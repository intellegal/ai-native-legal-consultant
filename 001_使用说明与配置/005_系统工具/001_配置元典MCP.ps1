Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$ConfigPath = Join-Path $ProjectRoot '.codex\config.toml'
$SetupDir = Join-Path $ProjectRoot '001_使用说明与配置'
$StatusPath = Join-Path $SetupDir '006_元典MCP配置状态.md'
$StartMarker = '# yuandian-legal-consultation:start'
$EndMarker = '# yuandian-legal-consultation:end'
$Servers = [ordered]@{
    'yuandian-law' = 'https://open.chineselaw.com/mcp/law/stream'
    'yuandian-case' = 'https://open.chineselaw.com/mcp/case/stream'
}

function ConvertTo-TomlString([string]$Value) {
    return '"' + $Value.Replace('\', '\\').Replace('"', '\"') + '"'
}

function Read-YuanDianKey {
    Write-Host '请在隐藏输入中填写元典 API Key；输入不会显示在屏幕上。'
    $secure = Read-Host '元典 API Key' -AsSecureString
    $ptr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
    try {
        $value = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr).Trim()
    }
    finally {
        [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr)
    }
    if ([string]::IsNullOrWhiteSpace($value)) { throw 'API Key 为空。' }
    if ($value.StartsWith('Bearer ', [StringComparison]::OrdinalIgnoreCase)) {
        $value = $value.Substring(7).Trim()
    }
    if ($value -match '\s') { throw 'API Key 中包含空白字符；请只填写 Key 本身。' }
    return $value
}

function New-ManagedBlock([string]$Key) {
    $lines = [Collections.Generic.List[string]]::new()
    $lines.Add($StartMarker)
    $lines.Add('# 由项目内跨平台配置工具管理；请勿提交此文件。')
    foreach ($entry in $Servers.GetEnumerator()) {
        $lines.Add('')
        $lines.Add("[mcp_servers.$($entry.Key)]")
        $lines.Add('url = ' + (ConvertTo-TomlString $entry.Value))
        $lines.Add('required = false')
        $lines.Add('tool_timeout_sec = 60')
        $lines.Add("[mcp_servers.$($entry.Key).http_headers]")
        $lines.Add('Authorization = ' + (ConvertTo-TomlString ('Bearer ' + $Key)))
        $lines.Add('Accept = "application/json, text/event-stream"')
    }
    $lines.Add('')
    $lines.Add($EndMarker)
    $lines.Add('')
    return $lines -join "`n"
}

function Update-ProjectConfig([string]$Key) {
    $configDir = Split-Path -Parent $ConfigPath
    New-Item -ItemType Directory -Force -Path $configDir | Out-Null
    $current = if (Test-Path -LiteralPath $ConfigPath) {
        Get-Content -Raw -LiteralPath $ConfigPath -Encoding UTF8
    } else { '' }

    $startCount = ([regex]::Matches($current, [regex]::Escape($StartMarker))).Count
    $endCount = ([regex]::Matches($current, [regex]::Escape($EndMarker))).Count
    if ($startCount -ne 0 -or $endCount -ne 0) {
        if ($startCount -ne 1 -or $endCount -ne 1) {
            throw '现有配置中的元典管理标记不完整，已停止，避免破坏配置。'
        }
        $pattern = '(?s)' + [regex]::Escape($StartMarker) + '.*?' + [regex]::Escape($EndMarker)
        $current = [regex]::Replace($current, $pattern, '').Trim()
    }
    foreach ($name in $Servers.Keys) {
        if ($current.Contains("[mcp_servers.$name]")) {
            throw "现有 config.toml 已手工定义 $name；请先处理冲突后重试。"
        }
    }
    $updated = if ([string]::IsNullOrWhiteSpace($current)) {
        New-ManagedBlock $Key
    } else {
        $current.TrimEnd() + "`n`n" + (New-ManagedBlock $Key)
    }
    [IO.File]::WriteAllText($ConfigPath, $updated, [Text.UTF8Encoding]::new($false))
}

function ConvertFrom-McpResponse([string]$Content, [string]$ContentType) {
    if ([string]::IsNullOrWhiteSpace($Content)) { return $null }
    if ($ContentType -like '*text/event-stream*') {
        $payloads = @($Content -split "`r?`n" | Where-Object { $_ -like 'data:*' } | ForEach-Object {
            $_.Substring(5).Trim()
        } | Where-Object { $_ -and $_ -ne '[DONE]' })
        if ($payloads.Count -eq 0) { return $null }
        return $payloads[-1] | ConvertFrom-Json
    }
    return $Content | ConvertFrom-Json
}

function Invoke-McpRequest([string]$Url, [hashtable]$Payload, [string]$Key, [string]$SessionId = '') {
    $headers = @{
        Authorization = 'Bearer ' + $Key
        Accept = 'application/json, text/event-stream'
        'User-Agent' = 'ai-native-legal-consultant/1.0'
    }
    if ($SessionId) { $headers['Mcp-Session-Id'] = $SessionId }
    $params = @{
        Uri = $Url
        Method = 'Post'
        Headers = $headers
        ContentType = 'application/json'
        Body = ($Payload | ConvertTo-Json -Depth 12 -Compress)
        TimeoutSec = 30
        UseBasicParsing = $true
    }
    $response = Invoke-WebRequest @params
    $contentType = [string]$response.Headers['Content-Type']
    $session = [string]$response.Headers['Mcp-Session-Id']
    if (-not $session) { $session = $SessionId }
    return [pscustomobject]@{
        Body = ConvertFrom-McpResponse ([string]$response.Content) $contentType
        SessionId = $session
    }
}

function Test-McpServer([string]$Name, [string]$Url, [string]$Key) {
    try {
        $initialize = @{
            jsonrpc = '2.0'; id = 1; method = 'initialize'
            params = @{
                protocolVersion = '2025-06-18'; capabilities = @{}
                clientInfo = @{ name = 'ai-native-legal-consultant-setup'; version = '1.0' }
            }
        }
        $init = Invoke-McpRequest $Url $initialize $Key
        if ($init.Body -and $init.Body.error) {
            return [pscustomobject]@{ Passed = $false; Message = 'initialize 返回错误：' + $init.Body.error.message }
        }
        Invoke-McpRequest $Url @{ jsonrpc = '2.0'; method = 'notifications/initialized'; params = @{} } $Key $init.SessionId | Out-Null
        $listed = Invoke-McpRequest $Url @{ jsonrpc = '2.0'; id = 2; method = 'tools/list'; params = @{} } $Key $init.SessionId
        $tools = @($listed.Body.result.tools)
        if ($tools.Count -eq 0) {
            return [pscustomobject]@{ Passed = $false; Message = '连接成功，但 tools/list 未返回可用工具。' }
        }
        return [pscustomobject]@{ Passed = $true; Message = "连接成功，发现 $($tools.Count) 个工具。" }
    }
    catch {
        $statusCode = $null
        if ($_.Exception.Response -and $_.Exception.Response.StatusCode) {
            $statusCode = [int]$_.Exception.Response.StatusCode
        }
        $message = if ($statusCode -eq 401) { 'HTTP 401：Key 无效或认证失败' }
            elseif ($statusCode -eq 402) { 'HTTP 402：积分不足' }
            elseif ($statusCode -eq 429) { 'HTTP 429：请求过于频繁' }
            elseif ($statusCode) { "HTTP $statusCode：服务端拒绝请求" }
            else { $_.Exception.GetType().Name + '：' + $_.Exception.Message }
        return [pscustomobject]@{ Passed = $false; Message = $message }
    }
}

function Write-SetupStatus([Collections.IDictionary]$Results) {
    $now = [DateTimeOffset]::Now.ToString('yyyy-MM-ddTHH:mm:sszzz')
    $rows = foreach ($name in $Results.Keys) {
        $result = $Results[$name]
        '| ' + $name + ' | ' + $(if ($result.Passed) { '通过' } else { '失败' }) + ' | ' + $result.Message + ' |'
    }
    $allPassed = @($Results.Values | Where-Object { -not $_.Passed }).Count -eq 0
    if ($allPassed) {
        $nextHeading = '## 仍需完成的 Codex 端测试'
        $nextSteps = @(
            '1. 完全重启 Codex，再打开同一个项目。',
            '2. 直接说“继续核查”；Agent 会从已有工作底稿恢复。',
            '3. Agent 完成法规真实查询和案例工具发现，并把结果写入 `003_内部工作区/002_能力检查.md`。'
        )
    }
    else {
        $nextHeading = '## 下一步'
        $nextSteps = @('脚本链路测试未全部通过。请按上表处理并重新运行；已有基础梳理不受影响。')
    }
    $text = @(
        '# 元典 MCP 配置状态', '',
        "- 测试时间：$now", '- Key 已通过交互式输入提供（本文件不记录 Key）',
        '- 配置范围：仅当前项目 `.codex/config.toml`', '',
        '| Server | 脚本链路测试 | 结果 |', '| --- | --- | --- |'
    ) + $rows + @('', $nextHeading, '') + $nextSteps + @(
        '', '> 注意：`.codex/config.toml` 中以明文保存 Key。请勿公开提交或共享整个配置文件。', ''
    )
    [IO.File]::WriteAllText($StatusPath, ($text -join "`n"), [Text.UTF8Encoding]::new($false))
}

try {
    Write-Host '此工具只用于您已选择的深入核查；已有基础梳理不会被清空。'
    $key = Read-YuanDianKey
    Update-ProjectConfig $key
    Write-Host "已写入项目配置：$ConfigPath"
    $results = [ordered]@{}
    foreach ($entry in $Servers.GetEnumerator()) {
        Write-Host "正在测试 $($entry.Key) ..."
        $results[$entry.Key] = Test-McpServer $entry.Key $entry.Value $key
        Write-Host $results[$entry.Key].Message
    }
    Write-SetupStatus $results
    Write-Host "状态已写入：$StatusPath"
    $failed = @($results.Values | Where-Object { -not $_.Passed }).Count
    if ($failed -eq 0) {
        Write-Host '下一步：完全重启 Codex，重新打开同一项目并说“继续核查”。'
        exit 0
    }
    Write-Host '脚本测试未全部通过。已有基础梳理不会丢失。'
    exit 2
}
catch {
    Write-Error ('配置失败：' + $_.Exception.Message)
    exit 1
}
