#!/bin/bash
cd "$(dirname "$0")" || exit 1
echo "此工具仅在您选择‘再帮我核查’后使用；基础梳理不需要配置。"
echo "Key 将在系统安全输入框中填写，请勿把 Key 粘贴到公开聊天。"
echo
if command -v curl >/dev/null 2>&1; then
  /bin/bash "002_配置元典MCP.sh"
  status=$?
elif command -v python3 >/dev/null 2>&1; then
  python3 "001_配置元典MCP.py"
  status=$?
elif command -v python >/dev/null 2>&1; then
  python "001_配置元典MCP.py"
  status=$?
else
  echo "当前电脑未找到 curl 或 Python。请回到项目让 Agent 说明并协助处理。"
  status=1
fi
echo
if [ -t 0 ]; then
  read -r -p "按回车键关闭窗口。" _
fi
exit "$status"
