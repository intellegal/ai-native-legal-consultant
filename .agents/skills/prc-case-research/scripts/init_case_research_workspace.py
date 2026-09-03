from __future__ import annotations

import argparse
import csv
from pathlib import Path

SKILL_VERSION = "2.6.1"

CASE_EXCERPT_TABLE = (
    "> 加粗为本报告标注；如原文已有强调，另行注明。\n\n"
    "| 裁判认定（概括） | 案号、法院及日期 | 关键事实/争点 | 裁判要旨摘录（原文） | 研究提示/适用差异 |\n"
    "|---|---|---|---|---|\n\n"
)

RETRIEVAL_COLUMNS = [
    "round_id",
    "path_or_purpose",
    "query_and_filters",
    "hit_total",
    "returned",
    "candidate_reviewed",
    "fulltext_reviewed",
    "new_unique_documents",
    "new_unique_disputes",
    "new_coverage_cells",
    "material_change",
    "next_step_or_stop_reason",
]

CASE_COLUMNS = [
    "wp_id",
    "case_no",
    "source_or_id",
    "local_fulltext",
    "fulltext_status",
    "dispute_family_id",
    "source_variant_of",
    "research_use",
    "controlling_issue",
    "court_reasoning",
    "result",
    "conclusion_ids",
    "exclusion_or_caveat",
    "snapshot",
]

CONCLUSION_COLUMNS = [
    "conclusion_id",
    "concise_claim",
    "supporting_cases",
    "limiting_or_different_reasoning_cases",
    "basis",
    "confidence",
    "unresolved_issue",
]

COVERAGE_COLUMNS = [
    "coverage_id",
    "decision_relevant_cell",
    "verified_case_keys",
    "strength_or_gap",
    "last_material_round",
    "status",
]

RECOVERY_COLUMNS = [
    "control_case_key",
    "recovery_mode",
    "query_and_filters",
    "recovered",
    "failure_mechanism",
    "resulting_change",
    "limitation",
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
    "dispute_family_id",
    "source_variant_of",
    "duplicate_status",
    "duplicate_basis",
    "facts_excerpt",
    "controlling_issue",
    "reasoning_excerpt",
    "result_excerpt",
    "chain_status",
    "caveat",
]

SEARCH_CACHE_COLUMNS = [
    "cache_version",
    "endpoint",
    "query_normalized",
    "filters_normalized",
    "scope_dates",
    "hit_total",
    "requested_top_k",
    "returned_count",
    "capture_status",
    "overflow_or_error",
    "retained_case_keys",
    "retrieved_at",
    "material_observation",
    "reuse_limit",
]


def write_text(path: Path, text: str) -> None:
    if not path.exists():
        path.parent.mkdir(parents=True, exist_ok=True)
        with path.open("x", encoding="utf-8", newline="") as stream:
            stream.write(text)


def write_csv(path: Path, columns: list[str]) -> None:
    if path.exists():
        return
    with path.open("w", newline="", encoding="utf-8-sig") as f:
        csv.writer(f).writerow(columns)


def main() -> None:
    parser = argparse.ArgumentParser(description="Create only missing case-research files; existing work is preserved.")
    parser.add_argument("output_dir")
    parser.add_argument("--topic", default="裁判文书研究")
    parser.add_argument("--mode", choices=("standalone", "consultation"), default="standalone")
    parser.add_argument("--case-excerpts", action="store_true", help="Excerpt scaffold in a new standalone report only")
    parser.add_argument("--fulltext-index", action="store_true", help="Optional separate original-text index")
    parser.add_argument("--archive-sources", action="store_true", help="Optional additional source-snapshot folder; required judgments are retained regardless")
    parser.add_argument("--structured-data", action="store_true")
    parser.add_argument("--local-cache", action="store_true")
    args = parser.parse_args()
    root = Path(args.output_dir).expanduser().resolve()
    assets = Path(__file__).resolve().parents[1] / "assets"
    if args.mode == "consultation":
        workpaper_dir = root / "003_内部工作区"
        record = workpaper_dir / "004_法律与案例检索记录.md"
        originals = root / "004_给你的结果" / "004_案例全文"
    else:
        workpaper_dir = root / "_研究底稿"
        record = workpaper_dir / "底稿.md"
        originals = root / "案例全文"
        excerpt = CASE_EXCERPT_TABLE if args.case_excerpts else ""
        write_text(root / "报告.md", f"# {args.topic}\n\n## 结论摘要\n\n## 核心分析\n\n## 关键案例及差异\n\n{excerpt}## 实践建议\n\n## 研究边界与待核验事项\n\n引用精读或作为依据的判决时，填写已保存全文的相对链接，并随报告提供对应文件。\n")
    workpaper_dir.mkdir(parents=True, exist_ok=True)
    write_text(record, (assets / "研究记录模板.md").read_text(encoding="utf-8").replace("{{topic}}", args.topic))
    if args.fulltext_index:
        write_text(originals / "000_案例全文索引.md", (assets / "案例全文索引模板.md").read_text(encoding="utf-8"))
    if args.archive_sources:
        (workpaper_dir / "sources").mkdir(exist_ok=True)
    if args.structured_data:
        data_dir = workpaper_dir / "data"
        data_dir.mkdir(exist_ok=True)
        for name, columns in (("检索轨迹", RETRIEVAL_COLUMNS), ("案例台账", CASE_COLUMNS), ("覆盖单元", COVERAGE_COLUMNS), ("漏检回收测试", RECOVERY_COLUMNS), ("结论溯源", CONCLUSION_COLUMNS)):
            write_csv(data_dir / f"{name}.csv", columns)
    if args.local_cache:
        cache_dir = workpaper_dir / "cache"
        cache_dir.mkdir(exist_ok=True)
        write_csv(cache_dir / "案例缓存.csv", CASE_CACHE_COLUMNS)
        write_csv(cache_dir / "检索缓存.csv", SEARCH_CACHE_COLUMNS)
    print(root)


if __name__ == "__main__":
    main()
