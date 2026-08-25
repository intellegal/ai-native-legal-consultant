@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo 此工具仅在您选择“再帮我核查”后使用；基础梳理不需要配置。
echo Key 将在隐藏输入中填写，请勿把 Key 粘贴到公开聊天。
echo.
where pwsh >nul 2>nul
if not errorlevel 1 goto use_pwsh
where powershell.exe >nul 2>nul
if not errorlevel 1 goto use_windows_powershell
where py >nul 2>nul
if not errorlevel 1 goto use_py
where python >nul 2>nul
if not errorlevel 1 goto use_python
echo 当前电脑未找到可用的 PowerShell 或 Python。
echo 请回到本项目对 Agent 说：“请帮我开启法规与案例核查”。
echo Agent 应先解释缺少的组件及用途，并在取得您的同意后再安装。
goto end
:use_pwsh
pwsh -NoProfile -File "001_配置元典MCP.ps1"
goto end
:use_windows_powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "001_配置元典MCP.ps1"
goto end
:use_py
py -3 "001_配置元典MCP.py"
goto end
:use_python
python "001_配置元典MCP.py"
:end
echo.
pause
