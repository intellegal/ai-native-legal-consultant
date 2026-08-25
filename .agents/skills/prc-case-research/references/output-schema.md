# Lean Output, Workpaper, and Cache Schema

Use a report-first structure. The user should not need to review internal process files to understand the answer.

## Contents

- Default Deliverables
- Matter-Level Planning Document
- Report
- Workpaper
- Compact Local Cache
- Retention Conditions
- Duplication Rule
- Optional Structured Data

## Default Deliverables

- Hosted legal consultation: `003_内部工作区/003_案件梳理与案例检索建议.md` before retrieval, `003_内部工作区/004_法律与案例检索记录.md` during research, and one Markdown file per retrieved judgment full text under `004_给你的结果/004_案例全文/`; return findings and local links to the host for the verified layer of `004_给你的结果/001_咨询结果.md`. Do not create standalone `报告.md` or a second user-facing case report.
- Quick lookup: direct answer or one concise report; no persistent workpaper or cache by default.
- Matter-level planning: `案件梳理与案例检索建议.md` as the only visible pre-retrieval deliverable; wait for confirmation before external case calls unless the user explicitly waives the gate.
- Ordinary research: `报告.md`; add `_研究底稿/底稿.md` only when later verification, continuation, or handoff is likely.
- Empirical or reproducible research: `报告.md` plus `_研究底稿/底稿.md`.
- Add a compact local cache when repeated use or costly reacquisition is reasonably likely.
- In case-research work, save every retrieved judgment full text locally as Markdown by default. Add other source snapshots or structured data only when a retention condition below applies.

## Matter-Level Planning Document

Use this document only when the request must be decomposed before retrieval. Keep it concise and easy to revise. Use short prose sections for the research goal and boundary, relevant facts and uncertainties, provisional legal routes, proposed research questions, questions routed away from case research, proposed order and scope, and the user's confirmation.

For each proposed research question, state only the neutral question, why it matters, and the recommended source. Do not expose internal field schemas, research cards, full keyword matrices, or speculative query trees. Preserve the confirmed document as the initial scope record; update it only when the user changes scope or a later discovery requires material expansion.

Do not create a full workspace merely to draft this document. In hosted consultation, keep it inside `003_内部工作区/` and let the voice host own confirmation. After confirmation, create the report, workpaper, cache, or structured data only when the normal retention conditions justify them.

## Hosted Consultation Record

Create `003_内部工作区/004_法律与案例检索记录.md` from `assets/咨询案例检索记录模板.md` when absent. It is the canonical case-research record for the matter and should contain:

- confirmed boundary, the matter-wide issue map, current-law status, authorization boundary, and any real balance limit;
- coverage status for support, contrary, fact/evidence, procedure/remedy, authority/recent, semantic/alternate expressions, and full text;
- one row per material retrieval round rather than every API call;
- retained supporting, contrary, distinguishing, background, and excluded cases with full-text status and local Markdown path;
- conclusion trace and decision-changing limitations;
- tool, balance, source, or coverage constraints.

The host's `004_给你的结果/001_咨询结果.md` remains the only user-facing analysis. `004_给你的结果/004_案例全文/` is a source archive for verification, not a competing report. Do not duplicate long analysis across the consultation record, result, and source files.

## Local Judgment Full-Text Archive

For hosted consultation, create `004_给你的结果/004_案例全文/000_案例全文索引.md` and save every successfully retrieved judgment full text beside it. For standalone research, use `案例全文/` unless the user supplied another output structure.

Each judgment file must contain a compact metadata block followed by the complete returned judgment text:

`本地编号 | 案名 | 案号 | 来源/类型/ID | 法院 | 裁判日期 | 程序 | 原始链接 | 获取时间 | 文本状态 | 身份或版本限制`

Use a filesystem-safe name such as `NNN_案号_法院_裁判日期.md`; replace invalid filename characters and fall back to a stable source ID when necessary. The index records the issue role, conclusion IDs, and relative local link. The case ledger and user-facing report must link to the local file whenever a case supports, contradicts, or materially distinguishes a conclusion.

Only a detail/original-text response containing the judgment body counts toward the normal matter-level `20–50` full-text starting range. Search snippets, abstracts, case notes, and processed semantic text may remain discovery records but must not be mislabeled as judgment full text. The range is not a ceiling: expand while unresolved controlling issues or new material differences remain. If the comparable pool, tool access, or a user-selected lower authorization boundary prevents 20, record that concrete reason rather than silently lowering the target.

Use `./004_案例全文/<file>.md` for links from `004_给你的结果/001_咨询结果.md`, `./<file>.md` from `000_案例全文索引.md`, and `../004_给你的结果/004_案例全文/<file>.md` from `003_内部工作区/004_法律与案例检索记录.md`.

## Report

Select only sections that help answer the request:

- conclusion summary;
- core legal and factual analysis;
- key cases and outcome differences;
- evidence, procedure, deadline/material, and action implications when relevant;
- research boundary and material uncertainty.

Keep detailed query history, rejected candidates, and calibration mechanics out of the report unless they materially qualify a conclusion.

## Workpaper

Use one compact Markdown file with these sections.

### Research Boundary

Record the question, scope, exclusions, local-material role, user intent, and important assumptions.

### Retrieval Trail

Use one row per material round, not one row per API call:

`round_id | path_or_purpose | query_and_filters | reviewed | valid | material_change | next_step_or_stop_reason`

Fold extracted expressions, noise patterns, and query revisions into `material_change`. Omit routine calls that did not affect coverage or judgment.

### Case Ledger

Use one row per retained case:

`wp_id | case_no | source_or_id | local_fulltext | fulltext_status | role | controlling_point | conclusion_ids | exclusion_or_caveat | snapshot`

Recommended `role` values: `support`, `contrary`, `distinguish`, `background`, `excluded`.

Recommended `fulltext_status` values: `verified`, `summary_only`, `metadata_only`, `id_mismatch_refetched`, `needs_review`.

Keep detailed notes only for cases that support, contradict, or materially distinguish a conclusion. Compress routine exclusions by recurring reason where individual traceability is unnecessary.

### Conclusion Trace

Use one row per major report conclusion:

`conclusion_id | concise_claim | supporting_cases | contrary_or_limiting_cases | basis | confidence | unresolved_issue`

Use `basis` values: `案例观察`, `现行规则`, `实践推论`, `需核验`.

### Pending Verification

List unresolved source conflicts, under-sampled paths, current-law checks, and questions that could change a conclusion.

## Compact Local Cache

Use a cache only when continuation, recurring research, incremental time-window updates, or expensive reacquisition is likely. Keep it internal unless the user requests it.

### Case Cache

Prefer one record per source case:

`cache_version | source | source_type | source_id | case_no | case_no_normalized | title | court | decision_date | procedure | document_type | url | retrieved_at | fulltext_status | facts_excerpt | reasoning_excerpt | result_excerpt | controlling_point | chain_status | caveat`

Store metadata and the fields needed to avoid another retrieval. Keep excerpts compact. The local judgment archive above is mandatory for every judgment full text retrieved; this compact cache remains optional.

### Search Cache

Prefer one record per materially reusable search:

`cache_version | endpoint | query_normalized | filters_normalized | scope_dates | result_total | retained_case_keys | retrieved_at | material_observation | reuse_limit`

Use the query, structured filters, source type, time range, and retrieval date as the cache identity. Do not reuse a cached search when the current scope is broader, the underlying time window has advanced, or the earlier result was incomplete.

### Reuse Rules

- Check normalized案号 and source ID before a detail call.
- Reuse stable judgment text and saved metadata.
- Refresh later appellate or retrial status when it matters.
- For a new date range, retrieve only the uncovered date delta and merge it with the cache.
- Preserve a separate source record when ordinary and authoritative databases contain materially different texts for the same case.
- Never store credentials or authentication headers.

## Retention Conditions

Retain an additional artifact only when at least one condition applies:

- repeated retrieval, continuation, or incremental update is likely;
- computation, statistics, bulk coding, or automated deduplication requires structured data;
- the user explicitly requests a dataset, case list, original texts, or reproducible package;
- another person or agent will continue the work and needs machine-readable handoff;
- the source is unstable, inaccessible, or difficult to reacquire;
- an ID/案号 mismatch or source inconsistency requires preserving evidence;
- a central conclusion depends on the exact text and the case number alone is insufficient for stable review.

Otherwise keep raw responses, temporary matrices, and intermediate lists transient.

## Duplication Rule

- Report: conclusions, reasoning, key authority, practical implications, and limits.
- Workpaper: provenance, material retrieval changes, case status, exclusions, and conclusion trace.
- Cache: reusable normalized records and compact excerpts.
- Source archive: exact returned judgment text plus provenance metadata only.

Do not copy report prose into the workpaper, duplicate the same excerpt across cache fields, or reproduce full judgments in the report.

## Optional Structured Data

Create structured files only when a retention condition applies. Prefer a minimal set:

- `检索轨迹.csv`: the retrieval-trail fields above;
- `案例台账.csv`: the case-ledger fields above;
- `结论溯源.csv`: the conclusion-trace fields above;
- `cache/案例缓存.csv`: compact reusable case records;
- `cache/检索缓存.csv`: materially reusable query records.

Do not recreate a multi-file workspace unless the user explicitly requires separate datasets for processing, computation, or handoff.
