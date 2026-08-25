#!/usr/bin/env python3
"""Enable optional YuanDian law/case verification for this Codex project."""

from __future__ import annotations

import datetime as dt
import getpass
import json
import pathlib
import ssl
import sys
import urllib.error
import urllib.request

PROJECT_ROOT = pathlib.Path(__file__).resolve().parents[2]
CONFIG_PATH = PROJECT_ROOT / ".codex" / "config.toml"
SETUP_DIR = PROJECT_ROOT / "001_使用说明与配置"
STATUS_PATH = SETUP_DIR / "006_元典MCP配置状态.md"
START_MARKER = "# yuandian-legal-consultation:start"
END_MARKER = "# yuandian-legal-consultation:end"
SERVERS = {
    "yuandian-law": "https://open.chineselaw.com/mcp/law/stream",
    "yuandian-case": "https://open.chineselaw.com/mcp/case/stream",
}


def toml_string(value: str) -> str:
    return '"' + value.replace("\\", "\\\\").replace('"', '\\"') + '"'


def read_key() -> str:
    print("请粘贴元典 API Key；输入不会显示在屏幕上。")
    key = getpass.getpass("元典 API Key: ").strip()
    if not key:
        raise ValueError("API Key 为空。")
    if key.lower().startswith("bearer "):
        key = key[7:].strip()
    if any(ch.isspace() for ch in key):
        raise ValueError("API Key 中包含空白字符；请只填写 Key 本身。")
    return key


def managed_block(key: str) -> str:
    lines = [START_MARKER, "# 由 001_使用说明与配置/005_系统工具/001_配置元典MCP.py 管理；请勿提交此文件。"]
    for name, url in SERVERS.items():
        lines += [
            "",
            f"[mcp_servers.{name}]",
            f"url = {toml_string(url)}",
            "required = false",
            "tool_timeout_sec = 60",
            f"[mcp_servers.{name}.http_headers]",
            f"Authorization = {toml_string('Bearer ' + key)}",
            'Accept = "application/json, text/event-stream"',
        ]
    lines += ["", END_MARKER, ""]
    return "\n".join(lines)


def update_config(key: str) -> None:
    CONFIG_PATH.parent.mkdir(parents=True, exist_ok=True)
    current = CONFIG_PATH.read_text(encoding="utf-8") if CONFIG_PATH.exists() else ""
    if START_MARKER in current or END_MARKER in current:
        if current.count(START_MARKER) != 1 or current.count(END_MARKER) != 1:
            raise RuntimeError("现有配置中的元典管理标记不完整，已停止，避免破坏配置。")
        before, rest = current.split(START_MARKER, 1)
        _, after = rest.split(END_MARKER, 1)
        current = before.rstrip() + ("\n\n" if before.strip() else "") + after.lstrip()
    else:
        conflicts = [name for name in SERVERS if f"[mcp_servers.{name}]" in current]
        if conflicts:
            raise RuntimeError("现有 config.toml 已手工定义 " + ", ".join(conflicts) + "；请先移除冲突表。")
    updated = current.rstrip() + ("\n\n" if current.strip() else "") + managed_block(key)
    CONFIG_PATH.write_text(updated, encoding="utf-8")


def parse_mcp_body(raw: bytes, content_type: str):
    value = raw.decode("utf-8", errors="replace").strip()
    if not value:
        return None
    if "text/event-stream" in content_type:
        payloads = []
        for line in value.splitlines():
            if line.startswith("data:"):
                item = line[5:].strip()
                if item and item != "[DONE]":
                    payloads.append(json.loads(item))
        return payloads[-1] if payloads else None
    return json.loads(value)


def mcp_post(url: str, key: str, payload: dict, session_id: str | None = None):
    headers = {
        "Authorization": "Bearer " + key,
        "Accept": "application/json, text/event-stream",
        "Content-Type": "application/json",
        "User-Agent": "ai-native-legal-consultant/1.1.0",
    }
    if session_id:
        headers["Mcp-Session-Id"] = session_id
    request = urllib.request.Request(
        url,
        data=json.dumps(payload, ensure_ascii=False).encode("utf-8"),
        headers=headers,
        method="POST",
    )
    with urllib.request.urlopen(request, timeout=30, context=ssl.create_default_context()) as response:
        body = parse_mcp_body(response.read(), response.headers.get("Content-Type", ""))
        return body, response.headers.get("Mcp-Session-Id") or session_id


def test_server(name: str, url: str, key: str) -> tuple[bool, str]:
    initialize = {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
            "protocolVersion": "2025-06-18",
            "capabilities": {},
            "clientInfo": {"name": "ai-native-legal-consultant-setup", "version": "1.1.0"},
        },
    }
    try:
        reply, session_id = mcp_post(url, key, initialize)
        if isinstance(reply, dict) and reply.get("error"):
            return False, "initialize 返回错误：" + str(reply["error"].get("message", reply["error"]))
        mcp_post(
            url,
            key,
            {"jsonrpc": "2.0", "method": "notifications/initialized", "params": {}},
            session_id,
        )
        listed, _ = mcp_post(
            url,
            key,
            {"jsonrpc": "2.0", "id": 2, "method": "tools/list", "params": {}},
            session_id,
        )
        tools = ((listed or {}).get("result") or {}).get("tools") if isinstance(listed, dict) else None
        if not isinstance(tools, list) or not tools:
            return False, "连接成功，但 tools/list 未返回可用工具。"
        return True, f"连接成功，发现 {len(tools)} 个工具。"
    except urllib.error.HTTPError as exc:
        meanings = {401: "Key 无效或认证失败", 402: "积分不足", 429: "请求过于频繁"}
        return False, f"HTTP {exc.code}：{meanings.get(exc.code, '服务端拒绝请求')}"
    except Exception as exc:
        return False, f"{type(exc).__name__}：{exc}"


def write_status(results: dict[str, tuple[bool, str]]) -> None:
    now = dt.datetime.now().astimezone().isoformat(timespec="seconds")
    rows = [f"| {name} | {'通过' if ok else '失败'} | {message} |" for name, (ok, message) in results.items()]
    all_passed = all(ok for ok, _ in results.values())
    if all_passed:
        next_heading = "## 仍需完成的 Codex 端测试"
        next_steps = [
            "1. 完全重启 Codex，再打开同一个项目。",
            "2. 直接说“继续核查”；Agent 会从已有工作底稿恢复，不需要重新讲述。",
            "3. Agent 检索《民法典》第一千零四十三条并返回原文与来源。",
            "4. Agent 调用案例 Server 列出可用案例检索工具；不必为连通性测试消耗案例检索积分。",
            "5. Agent 将结果写入 `003_内部工作区/002_能力检查.md`。两项均通过后才把法律与案例写成已核验结论。",
        ]
    else:
        next_heading = "## 下一步"
        next_steps = [
            "脚本链路测试未全部通过。请先按上表失败原因处理并重新运行本工具；不要把本次结果理解为配置成功。",
            "已有基础梳理不受影响，可以稍后再继续核查。",
        ]
    text = "\n".join([
        "# 元典 MCP 配置状态",
        "",
        f"- 测试时间：{now}",
        "- Key 已通过交互式输入提供（本文件不记录 Key）",
        "- 配置范围：仅当前项目 `.codex/config.toml`",
        "",
        "| Server | 脚本链路测试 | 结果 |",
        "| --- | --- | --- |",
        *rows,
        "",
        next_heading,
        "",
        *next_steps,
        "",
        "> 注意：`.codex/config.toml` 中以明文保存 Key，以换取最短配置路径。请勿公开提交或共享整个配置文件。",
        "",
    ])
    STATUS_PATH.write_text(text, encoding="utf-8")


def main() -> int:
    try:
        print("此工具只用于您已选择的深入核查；已有基础梳理不会被清空。")
        key = read_key()
        update_config(key)
        print(f"已写入项目配置：{CONFIG_PATH}")
        results = {}
        for name, url in SERVERS.items():
            print(f"正在测试 {name} ...")
            results[name] = test_server(name, url, key)
            print(results[name][1])
        write_status(results)
        print(f"状态已写入：{STATUS_PATH}")
        passed = all(ok for ok, _ in results.values())
        if passed:
            print("下一步：完全重启 Codex，重新打开同一项目并说“继续核查”。")
        else:
            print("脚本测试未全部通过。请先按状态文件中的失败原因处理并重新运行；已有基础梳理不会丢失。")
        return 0 if passed else 2
    except KeyboardInterrupt:
        print("\n已取消。")
        return 130
    except Exception as exc:
        print(f"配置失败：{exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
