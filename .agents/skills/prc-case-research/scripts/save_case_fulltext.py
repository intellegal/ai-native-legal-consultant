"""Save supplied original judgment text; this helper does not retrieve or verify it."""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import re


def save_fulltext(payload: dict, output_dir: Path) -> Path:
    if payload.get("text_kind") != "judgment_fulltext":
        raise ValueError("text_kind must be judgment_fulltext; summaries are not originals")
    required = ("title", "case_no", "source", "source_id", "retrieved_at", "body")
    for field in required:
        if not isinstance(payload.get(field), str) or not payload[field].strip():
            raise ValueError(f"Missing nonempty string: {field}")
    body = payload["body"]
    digest = hashlib.sha256(body.encode("utf-8")).hexdigest()
    identity = "\0".join(payload[k] for k in ("case_no", "source", "source_id"))
    source_key = hashlib.sha256(identity.encode("utf-8")).hexdigest()[:12]
    label = re.sub(r'[<>:"/\\|?*\x00-\x1f]', "_", payload["case_no"]).strip(" .")[:60]
    # A fixed prefix also handles Windows reserved names such as CON and NUL.
    filename = f"案例_{label or '未编号'}_{source_key}_{digest[:12]}.md"
    metadata = {key: value for key, value in payload.items() if key != "body"}
    metadata.setdefault("completeness", "待核验")
    metadata.setdefault("review_status", "待核验；保存不等于精读")
    metadata["body_sha256"] = digest
    header = json.dumps(metadata, ensure_ascii=False, indent=2)
    # JSON is metadata; the body after the heading remains unchanged.
    rendered = f"# 案例全文\n\n```json\n{header}\n```\n\n## 原始裁判文书全文\n\n" + body
    root = output_dir.expanduser().resolve()
    root.mkdir(parents=True, exist_ok=True)
    target = root / filename
    if target.is_symlink() or target.resolve().parent != root:
        raise ValueError("Unsafe output path")
    if target.exists():
        if target.read_bytes() != rendered.encode("utf-8"):
            raise FileExistsError(f"Existing file differs; preserve it and review metadata: {target}")
    else:
        with target.open("x", encoding="utf-8", newline="") as stream:
            stream.write(rendered)
    return target


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("input_json", type=Path, help="UTF-8 JSON: text_kind, title, case_no, source, source_id, retrieved_at, body; add court/date/procedure/url/completeness when available")
    parser.add_argument("output_dir", type=Path)
    args = parser.parse_args()
    payload = json.loads(args.input_json.read_text(encoding="utf-8-sig"))
    print(save_fulltext(payload, args.output_dir))


if __name__ == "__main__":
    main()
