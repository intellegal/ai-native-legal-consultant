from __future__ import annotations

import argparse
import csv
from pathlib import Path


RETRIEVAL_COLUMNS = [
    "round_id",
    "path_or_purpose",
    "query_and_filters",
    "reviewed",
    "valid",
    "material_change",
    "next_step_or_stop_reason",
]

CASE_COLUMNS = [
    "wp_id",
    "case_no",
    "source_or_id",
    "local_fulltext",
    "fulltext_status",
    "role",
    "controlling_point",
    "conclusion_ids",
    "exclusion_or_caveat",
    "snapshot",
]

CONCLUSION_COLUMNS = [
    "conclusion_id",
    "concise_claim",
    "supporting_cases",
    "contrary_or_limiting_cases",
    "basis",
    "confidence",
    "unresolved_issue",
]

CASE_CACHE_COLUMNS = [
    "cache_version",
    "source",
    "source_type",
    "source_id",
    "case_no",
    "case_no_normalized",
    "title",
    "court",
    "decision_date",
    "procedure",
    "document_type",
    "url",
    "retrieved_at",
    "fulltext_status",
    "facts_excerpt",
    "reasoning_excerpt",
    "result_excerpt",
    "controlling_point",
    "chain_status",
    "caveat",
]

SEARCH_CACHE_COLUMNS = [
    "cache_version",
    "endpoint",
    "query_normalized",
    "filters_normalized",
    "scope_dates",
    "result_total",
    "retained_case_keys",
    "retrieved_at",
    "material_observation",
    "reuse_limit",
]


def write_text(path: Path, text: str) -> None:
    if not path.exists():
        path.write_text(text, encoding="utf-8")


def write_csv(path: Path, columns: list[str]) -> None:
    if path.exists():
        return
    with path.open("w", newline="", encoding="utf-8-sig") as f:
        csv.writer(f).writerow(columns)


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Create a lean case-research workspace."
    )
    parser.add_argument("output_dir", help="Research workspace directory to create")
    parser.add_argument("--topic", default="裁判文书研究", help="Research topic title")
    parser.add_argument(
        "--archive-sources",
        action="store_true",
        help="Create a source snapshot directory when exact source retention is necessary",
    )
    parser.add_argument(
        "--structured-data",
        action="store_true",
        help="Create minimal CSV tables for computation or machine-readable handoff",
    )
    parser.add_argument(
        "--local-cache",
        action="store_true",
        help="Create compact reusable case and search caches for continuation or incremental retrieval",
    )
    args = parser.parse_args()

    root = Path(args.output_dir).expanduser().resolve()
    workpaper_dir = root / "_研究底稿"
    fulltext_dir = root / "案例全文"
    root.mkdir(parents=True, exist_ok=True)
    workpaper_dir.mkdir(exist_ok=True)
    fulltext_dir.mkdir(exist_ok=True)

    index_template = (
        Path(__file__).resolve().parent.parent
        / "assets"
        / "案例全文索引模板.md"
    ).read_text(encoding="utf-8")
    standalone_index = index_template.replace(
        "`../001_咨询结果.md`", "`../报告.md`"
    ).replace(
        "`004_给你的结果/004_案例全文/`", "`案例全文/`"
    )
    write_text(fulltext_dir / "000_案例全文索引.md", standalone_index)

    write_text(
        root / "报告.md",
        f"# {args.topic}\n\n"
        "## 结论摘要\n\n"
        "## 核心分析\n\n"
        "## 关键案例及差异\n\n"
        "- 本地全文索引：[案例全文索引](./案例全文/000_案例全文索引.md)\n\n"
        "## 实践建议\n\n"
        "## 研究边界与待核验事项\n",
    )

    write_text(
        workpaper_dir / "底稿.md",
        f"# {args.topic}：研究底稿\n\n"
        "> 本文件只记录结论追溯所需的信息，不复制报告正文。\n\n"
        "## 研究边界\n\n"
        "- 研究问题：\n"
        "- 检索范围：\n"
        "- 排除规则：\n"
        "- 本地材料角色：\n"
        "- 用户意图与关键假设：\n\n"
        "## 检索轨迹\n\n"
        "| 轮次 | 路径/目的 | 查询与筛选 | 审阅数 | 有效数 | 实质变化 | 下一步/停止原因 |\n"
        "|---|---|---|---:|---:|---|---|\n\n"
        "## 案例台账\n\n"
        "| 底稿编号 | 案号 | 来源/ID | 本地全文 | 全文状态 | 角色 | 控制性要点 | 结论编号 | 排除/限制 | 快照 |\n"
        "|---|---|---|---|---|---|---|---|---|---|\n\n"
        "## 结论溯源\n\n"
        "| 结论编号 | 简要结论 | 支持案例 | 相反/限制案例 | 依据类型 | 置信度 | 待核验事项 |\n"
        "|---|---|---|---|---|---|---|\n\n"
        "## 待核验事项\n\n",
    )

    if args.archive_sources:
        (workpaper_dir / "sources").mkdir(exist_ok=True)

    if args.structured_data:
        data_dir = workpaper_dir / "data"
        data_dir.mkdir(exist_ok=True)
        write_csv(data_dir / "检索轨迹.csv", RETRIEVAL_COLUMNS)
        write_csv(data_dir / "案例台账.csv", CASE_COLUMNS)
        write_csv(data_dir / "结论溯源.csv", CONCLUSION_COLUMNS)

    if args.local_cache:
        cache_dir = workpaper_dir / "cache"
        cache_dir.mkdir(exist_ok=True)
        write_csv(cache_dir / "案例缓存.csv", CASE_CACHE_COLUMNS)
        write_csv(cache_dir / "检索缓存.csv", SEARCH_CACHE_COLUMNS)

    print(root)


if __name__ == "__main__":
    main()
