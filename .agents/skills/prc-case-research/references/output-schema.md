# Report, Continuing Research Record and Local Judgments

## Default deliverables

Use one concise report, one continuing research record, and complete local judgment files for every closely read or report-cited case. The reader should be able to understand and verify the report without a database membership.

- Standalone: `报告.md`, `_研究底稿/底稿.md` (the continuing research record), and `案例全文/` for required texts. Reuse a user's existing equivalents instead of creating parallel records.
- Hosted consultation: use the paths in `../profiles/hosted-consultation.md`; the host result remains the sole user-facing analysis.
- The record's case ledger is the default index. Add a separate full-text index only when many files, sharing or an existing workflow make it useful. Keep existing indexes and links working.
- Do not routinely create a separate planning document, keyword matrix, calibration log, practice translation, quote archive, cache or CSV set. Use sections in the record. Add datasets/cache only for actual computation, empirical reproducibility or useful continuation beyond that record.

## Required original-text retention and citations

Save the complete original judgment body actually obtained, without paraphrase, for every closely read or judgment-cited case. Keep provenance: case number, title, source/type/ID, court, decision date, procedure, original URL, retrieval time, text completeness, identity/version caveat and review status. Store original online URLs here as secondary provenance, not as the report's only judgment citation.

Use a filesystem-safe stable name. Do not overwrite a different judgment or source variant. An optional helper `scripts/save_case_fulltext.py` stores supplied text and metadata but cannot certify that a source is complete or has been closely read. Validate the body and identity through the source workflow; acquisition, local saving, close reading and verification remain distinct.

Snippets, abstracts, editorial case notes and semantic reconstructions must not be filed as verified judgment full text. When a required original is unavailable, retain the source lead and explicit gap in the record; do not reconstruct it or cite it as a verified judgment. Use lawful original access or ask about a material source change under the user's source choice.

Cite the **local judgment file** from the report and record. Inside distributable Markdown, use relative links from each actual file location; include the judgment files when sending the report. For example, a standalone report links `./案例全文/<file>.md`, and its record links `../案例全文/<file>.md`. A hosted result links `./004_案例全文/<file>.md`; its record links `../004_给你的结果/004_案例全文/<file>.md`. Encode URL-reserved characters in link destinations, not in actual filenames. In chat, use verified absolute file links.

## Concise report

Lead with the answer and its controlling conditions. Include decisive cases, original reasoning, similarities/differences, the strongest material adverse path, relevant evidence/procedure/action implications, and the boundary of coverage. Keep current rules, case observations, practical inferences and unresolved verification separate. State the applicable-law version; verify current deadlines and official requirements independently.

Statistical claims need a defined unit and sampling design; case existence, a filled coverage cell, or ranked hit counts do not prove prevalence or a numeric win probability. Put important uncertainty beside the affected conclusion.

## Optional Original-Excerpt Presentation

Use this mode when original judicial wording helps explain a material characterization, reasoning difference, evidence rule, or limiting condition, or when the user asks for lawyer-style case presentation. Add an excerpt column to the relevant existing table rather than imposing a new table on every report. Select the key cases; do not reproduce every collected judgment or force a fixed paragraph or word count.

A compact Markdown layout is:

```markdown
| 裁判认定（概括） | 案号、法院及日期 | 关键事实/争点 | 裁判要旨摘录（原文） | 研究提示/适用差异 |
|---|---|---|---|---|
```

Adapt the columns to the task; add a sequence number or group by a full-text-verified reasoning pattern only when useful. Keep grouped cases' individual limitations visible. Treat visual examples as presentation references, not verified corpora or universal case categories; do not copy their substantive holdings, colors, or merged-cell layouts into all research.

### Select and Verify the Excerpt

- Extract the paragraph or connected paragraphs from the verified original judgment, usually the court's reasoning. Preserve the facts, antecedents, conditions, exceptions, burden language, negation, and remedy boundaries needed to understand the passage. Do not substitute an author's summary, database-generated holding, party allegation, or OCR from a screenshot for judicial original text.
- Preserve the wording and its sequence. Mark omitted text explicitly, for example with `〔中略〕`; separate non-contiguous passages rather than stitching them into one apparent paragraph. Do not omit language that materially weakens or qualifies the proposed conclusion. Put researcher explanations outside the quotation.
- Bold the exact sentence or clause that answers the research question using Markdown `**...**`. Include its operative qualification or negation. Highlight relevant adverse reasoning and limitations as carefully as favorable reasoning; do not bold an entire long excerpt or mere search-term hits.
- State once near the table: `加粗为本报告标注；如原文已有强调，另行注明。` Original-source emphasis, omissions, and any disclosed transcription corrections must remain distinguishable from editorial highlighting.
- Give each excerpt a retrievable source and locator: case number, court/date, local original-text file, and an actual page, paragraph, or section with opening words. Do not invent official paragraph numbers. Check the quoted passage and bold spans against that source before delivery.
- If the original cannot be verified, leave the excerpt unavailable with a clear `原文待核验` note or omit the column for that case. A labeled summary may appear outside the original-text column; never put reconstructed prose in quotation marks.
- Administrative replies, statistics-agency answers, statutes, and editorial case notes are different source types. Present them separately or label their excerpt as `答复原文`, `条文原文`, or `编者摘要`; never present them as a court's holding. Follow applicable quotation and reuse limits for the actual source.

### Keep the Table Readable

Use quotation marks for the original passage and put the locator or source link outside the quotation. Escape literal pipe characters in Markdown table cells; use `<br>` for necessary paragraph breaks without changing the underlying text. If a faithful excerpt makes the table unwieldy, use a short comparison table plus case-by-case blockquotes, with the same selective bolding and citations. Do not shorten a legally necessary qualification merely to fit a cell.

The initializer's `--case-excerpts` flag adds an empty excerpt-table scaffold only to a new report; it supplies no cases or quotations and does not overwrite an existing report. Keep verified excerpts and locators in existing case notes/cache when reuse is needed rather than adding a separate quote archive by default.

## One continuing research record

Use `assets/研究记录模板.md`, adapting the topic and actual paths. Keep:

1. The user decision, scope/source, fact/evidence status, issue dependencies and explicit user constraints.
2. A living query/coverage map: intent, source-specific expression/filters, material discoveries and missing issues. Use an explicit table for complex research; do not force a taxonomy on a narrow question.
3. Material rounds: engine total, requested/returned and actually reviewed counts, capture status, original texts acquired/saved/read, new judgments/disputes/coverage, query change, next move and purpose-based stop reason. Record failed calls separately from zero hits.
4. A case ledger with local links, original-text/review status, controlling issue, court reasoning, outcome, source mirrors, dispute/batch relationships, relevance and affected conclusions. Metadata deduplication is provisional; preserve original-text identity evidence when it affects the sample.
5. Known omitted-case blind/diagnostic recovery when available, with failure mechanism and residual limit.
6. Conclusion trace, pending current-law checks, operational interruptions and a concrete next-step bookmark for resumption or key-case follow-up.

Do not duplicate the report's prose. Case roles are retrieval shorthand, not a substitute for explaining the court's actual reasoning. Count database records, judgment documents, adjudicative stages and independent disputes separately where the distinction matters.

## Optional computation and reuse

The initializer's `--structured-data` creates tables for computation or machine-readable handoff; `--local-cache` creates compact reusable case/query records; `--fulltext-index` adds an index. They are off by default. `--case-excerpts` adds an optional excerpt scaffold only to a newly created standalone report. Existing files are never overwritten.

Cache stable verified text and metadata; refresh later treatment, unresolved identity or new date windows when needed. A broader scope, stale time range, Top-K truncation, overflow or failed earlier call cannot serve as complete current coverage. Source variants remain mapped even when one canonical judgment is retained.

Field names in `scripts/init_case_research_workspace.py` support these distinctions. Do not store credentials. Do not retain raw responses or duplicate prose merely because a tool can produce them. Required close-read/cited original judgments remain mandatory regardless of optional caches.
