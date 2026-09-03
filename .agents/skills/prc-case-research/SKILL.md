---
name: prc-case-research
description: Use when the task requires retrieving, searching, collecting, supplementing, expanding, or omission-checking裁判文书/legal cases, when a case-law empirical report needs a case sample built or extended, or when a whole matter or multi-issue dispute must be organized into decision-relevant case-research questions before retrieval. Trigger even if the user provides local cases when the request asks for补充检索, 拓展研究, 查漏, 细分场景样本, or案件级检索规划. Do not trigger solely because the user provides case texts and only asks for ordinary reading, summarization, classification, or analysis without retrieval or sample-expansion need.
metadata:
  version: "2.6.1"
---

# Case Research

Research new cases, supplementary coverage, omissions or an empirical case sample. Local cases may be a closed corpus, seeds, reusable evidence or controls according to the request; closed-corpus summarization alone does not require external retrieval.

## Read for this task

1. Read [the shared research method](references/research-method.md). It governs progressive learning, evidence, quality acceptance and resource interruptions.
2. This public edition supports **YuanDian MCP only** for case-database retrieval and judgment-detail acquisition. Read [YuanDian strategy](providers/yuandian.md). If the configured YuanDian tools are unavailable, preserve current work and report the missing connection. If the user requests an unsupported database, explain this edition's capability boundary; do not invoke, install or fall back to another database/browser stack. Apply the shared method only within this edition's supported capabilities. The host's separately defined public-Web intake and official-source verification remain available as context; they do not constitute another configured case database.
3. Read [query intent and iteration](references/keyword-matrix.md) when designing or revising expressions, and [matter decomposition](references/matter-decomposition.md) for multi-issue matters.
4. Read [full-text comparison and identity](references/fulltext-comparison-and-deduplication.md) when comparing views, resolving duplication, auditing coverage or recovering known omissions; read [practical analysis](references/practical-analysis.md) when evidence, procedure or actions matter.
5. Read [output and retention](references/output-schema.md) before creating the report, research record or judgment files. Use [hosted consultation](profiles/hosted-consultation.md) only when a consultation host/task actually applies; otherwise use standalone output paths.

## Working contract

Learn and revise vocabulary through retrieved cases throughout the project. Select first-round breadth and later paths from the question and observed evidence; there is no fixed small-probe sequence or case-count target. Continue while feasible retrieval can materially improve an insufficient answer. A per-call API limit or a browser pacing observation never caps the whole research task.

Quality is established by coverage of the user's questions and material alternatives, original reasoning, resolved identity relationships and traceable limitations. Preserve full judgments for closely read or cited cases and cite their local files so the result can be shared with readers lacking database access. Missing originals remain explicit gaps, not verified judgment citations.

Keep one concise report, one continuing research record and required local judgment files. Separate indexes, structured datasets and caches are optional. Do not create a new approval checkpoint for routine supplementary retrieval inside the user's request. No preset POINT allowance or mandatory pricing checkpoint is part of this skill; respect explicit user limits and actual access boundaries. When credits are confirmed exhausted/insufficient, save current work, stop retrieval, explain the condition and ask the user what to do next.

## Helpers and maintenance

`scripts/init_case_research_workspace.py` creates missing report/record files without overwriting work; choose `--mode consultation` only for the host context. `scripts/save_case_fulltext.py` stores supplied original judgment text with provenance; saving is not verification. Use `--help` for the chosen helper.

This package is generated from the maintained case-research sources. See [.distribution.json](.distribution.json) for source paths and hashes; maintain the source rather than editing generated methods. Do not load all providers in ordinary case research.
