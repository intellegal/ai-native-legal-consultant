#!/bin/bash
set -u

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P) || exit 1
PROJECT_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/../.." && pwd -P) || exit 1
CONFIG_PATH="$PROJECT_ROOT/.codex/config.toml"
SETUP_DIR="$PROJECT_ROOT/001_使用说明与配置"
STATUS_PATH="$SETUP_DIR/006_元典MCP配置状态.md"
START_MARKER='# yuandian-legal-consultation:start'
END_MARKER='# yuandian-legal-consultation:end'
TEMP_DIR=$(mktemp -d "${TMPDIR:-/tmp}/yuandian-setup.XXXXXX") || exit 1
cleanup() {
  key=''
  rm -rf -- "$TEMP_DIR"
}
trap cleanup EXIT INT TERM

fail() {
  echo "配置失败：$1" >&2
  exit 1
}

read_key() {
  if [ -x /usr/bin/osascript ]; then
    key=$(/usr/bin/osascript -e 'text returned of (display dialog "请输入元典 API Key。输入内容不会显示。" default answer "" with hidden answer buttons {"取消", "继续"} default button "继续")') || exit 130
  elif [ -t 0 ]; then
    printf '请输入元典 API Key（输入不会显示）：'
    stty -echo
    IFS= read -r key
    stty echo
    printf '\n'
  else
    fail '当前环境无法显示安全输入。请回到项目让 Agent 在可见终端运行本工具。'
  fi
  case "$key" in
    [Bb][Ee][Aa][Rr][Ee][Rr]' '*) key=${key#* } ;;
  esac
  [ -n "$key" ] || fail 'API Key 为空。'
  case "$key" in
    *[[:space:]]*) fail 'API Key 中包含空白字符；请只填写 Key 本身。' ;;
  esac
}

strip_managed_block() {
  awk -v start="$START_MARKER" -v end="$END_MARKER" '
    $0 == start { inside = 1; next }
    $0 == end { inside = 0; next }
    !inside { print }
    END { if (inside) exit 2 }
  ' "$1"
}

write_config() {
  mkdir -p -- "$(dirname -- "$CONFIG_PATH")" || fail '无法创建项目 .codex 目录。'
  : > "$TEMP_DIR/current"
  if [ -f "$CONFIG_PATH" ]; then
    start_count=$(grep -cF "$START_MARKER" "$CONFIG_PATH" 2>/dev/null || true)
    end_count=$(grep -cF "$END_MARKER" "$CONFIG_PATH" 2>/dev/null || true)
    if [ "$start_count" -ne 0 ] || [ "$end_count" -ne 0 ]; then
      [ "$start_count" -eq 1 ] && [ "$end_count" -eq 1 ] || fail '现有配置中的元典管理标记不完整，已停止以避免破坏配置。'
      strip_managed_block "$CONFIG_PATH" > "$TEMP_DIR/current" || fail '无法安全读取现有配置。'
    else
      cp -- "$CONFIG_PATH" "$TEMP_DIR/current" || fail '无法读取现有配置。'
    fi
  fi
  if grep -qF '[mcp_servers.yuandian-law]' "$TEMP_DIR/current" || grep -qF '[mcp_servers.yuandian-case]' "$TEMP_DIR/current"; then
    fail '现有 config.toml 已手工定义元典 Server；请先处理冲突后重试。'
  fi
  escaped_key=$(printf '%s' "$key" | sed 's/\\/\\\\/g; s/"/\\"/g')
  {
    if [ -s "$TEMP_DIR/current" ]; then
      cat "$TEMP_DIR/current"
      printf '\n'
    fi
    printf '%s\n' "$START_MARKER"
    printf '%s\n' '# 由项目内跨平台配置工具管理；请勿提交此文件。'
    printf '\n[mcp_servers.yuandian-law]\n'
    printf '%s\n' 'url = "https://open.chineselaw.com/mcp/law/stream"' 'required = false' 'tool_timeout_sec = 60'
    printf '%s\n' '[mcp_servers.yuandian-law.http_headers]'
    printf 'Authorization = "Bearer %s"\n' "$escaped_key"
    printf '%s\n' 'Accept = "application/json, text/event-stream"'
    printf '\n[mcp_servers.yuandian-case]\n'
    printf '%s\n' 'url = "https://open.chineselaw.com/mcp/case/stream"' 'required = false' 'tool_timeout_sec = 60'
    printf '%s\n' '[mcp_servers.yuandian-case.http_headers]'
    printf 'Authorization = "Bearer %s"\n' "$escaped_key"
    printf '%s\n' 'Accept = "application/json, text/event-stream"'
    printf '\n%s\n' "$END_MARKER"
  } > "$TEMP_DIR/config.toml" || fail '无法生成项目配置。'
  mv -- "$TEMP_DIR/config.toml" "$CONFIG_PATH" || fail '无法写入项目配置。'
}

MCP_BODY=''
MCP_HEADERS=''
MCP_HTTP=''
mcp_post() {
  url=$1
  payload=$2
  session=${3:-}
  headers_file="$TEMP_DIR/headers"
  body_file="$TEMP_DIR/body"
  set -- -sS -D "$headers_file" -o "$body_file" -w '%{http_code}' -X POST "$url" \
    -H "Authorization: Bearer $key" \
    -H 'Accept: application/json, text/event-stream' \
    -H 'Content-Type: application/json' \
    -H 'User-Agent: ai-native-legal-consultant/1.0' \
    --data "$payload" --max-time 30
  [ -z "$session" ] || set -- "$@" -H "Mcp-Session-Id: $session"
  MCP_HTTP=$(curl "$@") || return 1
  MCP_BODY=$(cat "$body_file")
  MCP_HEADERS=$(cat "$headers_file")
  case "$MCP_HTTP" in 2??) return 0 ;; *) return 2 ;; esac
}

http_message() {
  case "$1" in
    401) printf '%s' 'HTTP 401：Key 无效或认证失败' ;;
    402) printf '%s' 'HTTP 402：积分不足' ;;
    429) printf '%s' 'HTTP 429：请求过于频繁' ;;
    *) printf 'HTTP %s：服务端拒绝请求' "$1" ;;
  esac
}

test_server() {
  server_name=$1
  server_url=$2
  initialize='{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"ai-native-legal-consultant-setup","version":"1.0"}}}'
  if ! mcp_post "$server_url" "$initialize" ''; then
    test_passed=0
    test_message=$(http_message "$MCP_HTTP")
    return
  fi
  if printf '%s' "$MCP_BODY" | grep -q '"error"[[:space:]]*:'; then
    test_passed=0
    test_message='initialize 返回错误。'
    return
  fi
  session=$(printf '%s\n' "$MCP_HEADERS" | grep -i '^Mcp-Session-Id:' | tail -n 1 | cut -d: -f2- | tr -d '\r' | sed 's/^[[:space:]]*//')
  mcp_post "$server_url" '{"jsonrpc":"2.0","method":"notifications/initialized","params":{}}' "$session" >/dev/null 2>&1 || true
  if ! mcp_post "$server_url" '{"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}' "$session"; then
    test_passed=0
    test_message=$(http_message "$MCP_HTTP")
    return
  fi
  compact=$(printf '%s' "$MCP_BODY" | tr -d '\r\n')
  if ! printf '%s' "$compact" | grep -Eq '"tools"[[:space:]]*:[[:space:]]*\[[[:space:]]*\{'; then
    test_passed=0
    test_message='连接成功，但 tools/list 未返回可用工具。'
    return
  fi
  tool_count=$(printf '%s' "$compact" | grep -o '"name"[[:space:]]*:' | wc -l | tr -d ' ')
  test_passed=1
  test_message="连接成功，发现至少 $tool_count 个工具。"
}

write_status() {
  timestamp=$(date '+%Y-%m-%dT%H:%M:%S%z')
  if [ "$law_passed" -eq 1 ] && [ "$case_passed" -eq 1 ]; then
    next_heading='## 仍需完成的 Codex 端测试'
    next_steps='1. 完全重启 Codex，再打开同一个项目。\n2. 直接说“继续核查”；Agent 会从已有工作底稿恢复。\n3. Agent 完成法规真实查询和案例工具发现，并写入 `003_内部工作区/002_能力检查.md`。'
  else
    next_heading='## 下一步'
    next_steps='脚本链路测试未全部通过。请按上表处理并重新运行；已有基础梳理不受影响。'
  fi
  {
    printf '# 元典 MCP 配置状态\n\n'
    printf '%s\n' "- 测试时间：$timestamp" '- Key 已通过交互式输入提供（本文件不记录 Key）' '- 配置范围：仅当前项目 `.codex/config.toml`'
    printf '\n| Server | 脚本链路测试 | 结果 |\n| --- | --- | --- |\n'
    printf '| yuandian-law | %s | %s |\n' "$([ "$law_passed" -eq 1 ] && printf '通过' || printf '失败')" "$law_message"
    printf '| yuandian-case | %s | %s |\n' "$([ "$case_passed" -eq 1 ] && printf '通过' || printf '失败')" "$case_message"
    printf '\n%s\n\n%b\n' "$next_heading" "$next_steps"
    printf '\n> 注意：`.codex/config.toml` 中以明文保存 Key。请勿公开提交或共享整个配置文件。\n'
  } > "$STATUS_PATH" || fail '无法写入配置状态文件。'
}

echo '此工具只用于您已选择的深入核查；已有基础梳理不会被清空。'
command -v curl >/dev/null 2>&1 || fail '未找到 curl。请让 Agent 解释用途并在取得同意后安装兼容组件。'
read_key
write_config
echo "已写入项目配置：$CONFIG_PATH"
echo '正在测试 yuandian-law ...'
test_server 'yuandian-law' 'https://open.chineselaw.com/mcp/law/stream'
law_passed=$test_passed; law_message=$test_message
echo "$law_message"
echo '正在测试 yuandian-case ...'
test_server 'yuandian-case' 'https://open.chineselaw.com/mcp/case/stream'
case_passed=$test_passed; case_message=$test_message
echo "$case_message"

write_status
echo "状态已写入：$STATUS_PATH"
if [ "$law_passed" -eq 1 ] && [ "$case_passed" -eq 1 ]; then
  echo '下一步：完全重启 Codex，重新打开同一项目并说“继续核查”。'
  exit 0
fi
echo '脚本测试未全部通过。已有基础梳理不会丢失。'
exit 2
