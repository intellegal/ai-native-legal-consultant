# Yuandian Retrieval and Cost Optimization

Use this as the single operational reference for YuanDian. The provider strategy is in `../providers/yuandian.md`; quality acceptance and exhaustion handling belong to `research-method.md`. Recheck documentation when actual schema or price uncertainty matters; do not impose a routine pricing or approval gate.

## Official Sources

- Documentation center: https://open.chineselaw.com/docs/
- Case semantic search: https://open.chineselaw.com/api-square/16/
- Ordinary-case keyword search: https://open.chineselaw.com/api-square/7/
- Authoritative-case keyword search: https://open.chineselaw.com/api-square/8/
- Case details: https://open.chineselaw.com/api-square/9/
- Machine-readable full documentation: https://open.chineselaw.com/llms-full.txt

The prices below were verified on 2026-09-03 against the official API-detail JSON (`price` and `chargeType`) for IDs 16, 7, 8, and 9, and independently cross-checked with `yuandian_get_api_doc`; both sources agreed. This was a documentation/metadata check, not a chargeable case-retrieval or deduction test. The historical schema, defaults, and retrieval-behavior observations below were recorded on 2026-08-26 and were not revalidated by this price refresh. Static documentation pages may lag behind live metadata, consult `yuandian_get_api_doc` when live metadata is needed. This dated table is informational, not a mandatory pre-call gate or a spending allowance.

Official live pricing records: [semantic](https://open.chineselaw.com/api/apis/16), [ordinary keyword](https://open.chineselaw.com/api/apis/7), [authoritative keyword](https://open.chineselaw.com/api/apis/8), [details](https://open.chineselaw.com/api/apis/9).

## Cost Model

| Interface | Tool | Published price |
|---|---|---:|
| Case semantic search | `yuandian_case_vector_search` | 15 POINT/call |
| Ordinary-case keyword search | `yuandian_rh_ptal_search` | 5 POINT/call |
| Authoritative-case keyword search | `yuandian_rh_qwal_search` | 5 POINT/call |
| Case details | `yuandian_rh_case_details` | 10 POINT/call |

Prices are dated operational information, not permanent constants or research-intensity tiers. No default credit allowance or spending target applies. Respect a limit explicitly supplied by the user. On a credible insufficient-credit response, confirm the condition if unclear, save the work, stop further retrieval and ask the user how to proceed; do not run speculative chargeable retries. Do not assert exhaustion from an unrelated error.

## Semantic Search

- `return_num` defaults to 45. The current documentation does not state a hard maximum. Historical tests recorded on 2026-08-26 requested 50 and 60, returned 50 and 60 unique results respectively, and deducted the same 15 points per call. These retrieval/deduction tests were not rerun during the 2026-09-03 price check.
- Do not describe 50 as the semantic endpoint’s maximum. Choose each capture size from the task and actual transport capacity; the historical test values are not recommended defaults.
- When results can be cached outside the main context, a broad first capture can avoid paying again merely to enlarge the same query. Inspect the cached results in smaller review batches.
- When the raw response will enter the main model context, use a smaller return size because a 50-result live response was about 60,000 characters and a 60-result response about 71,000 characters.
- Official API documentation retrieved on 2026-09-03 describes `rewrite_flag` as default `false`, superseding the earlier recorded `true` assumption. Set it explicitly: enable for useful exploratory rewriting and disable for controlled formulations. Check the actual exposed tool schema if its behavior differs.
- Apply known `wenshu_filter` fields early: case category, cause, document type, court, court level, region, date, authoritative-only flag, and authoritative source.
- Results contain processed and organized case content with similarity scores, not verbatim original judgments. Use them for reconnaissance and backfill, not as the final textual basis for a major conclusion.
- The default search already covers ordinary and authoritative cases. Run a separate authoritative search only when source type, authority status, or authoritative-case recall materially matters.

## Keyword Syntax


For `rh_ptal_search` and `rh_qwal_search`:

- `qw`: full-text terms split by spaces.
- `fxgc`: analysis or reasoning terms split by spaces; available for ordinary cases.
- `search_mode`: global connector; only `and` and `or` are confirmed.
- `title`: terms split by spaces and all title terms must hit.
- `ay`, `jbdw`, `xzqh_p`, `wszl`, `source`, and date fields: structured filters; array values are OR within the field.
- `top_k`: default 10 and maximum 50 per call.

Do not pass nested Boolean expressions, `NOT`, or proximity operators such as `NEAR/5` into `qw`. For `A AND (B OR C)`, run `A B` and `A C` as separate `and` queries only after the first branch shows that the distinction is useful. For `A AND NOT X`, run `A` and filter or downrank candidates containing `X` after review.

Use `fxgc` first when the target is an express judicial holding. Use `qw` when the relevant language may appear in facts, evidence, party submissions, appraisal reports, or other portions of the judgment.


## Keyword Search

- `top_k` defaults to 10 and is capped at 50. Published pricing is per call, not per returned result.
- `top_k` is a capture-size request, not a relevance, diversity, or coverage guarantee. Record hit total, requested `top_k`, returned count, and capture status separately.
- `qw` searches full-text terms. `fxgc` searches the analysis/reasoning field for ordinary cases and is often more precise for express judicial holdings.
- `search_mode` is global `and` or `or`; spaces split terms. Nested Boolean logic, `NOT`, and proximity operators are not supported.
- Use structured filters before adding more lexical terms when the scope is already known.
- Inspect `total` and the returned sample. Refine a noisy query before increasing depth; expand a proven high-precision query when that is more useful than opening several speculative paths.
- Search results already provide ID,案号, title, court, date, content snippet, URL, and score. Save these immediately instead of retrieving details later just to recover metadata.
- Ordinary-case `content` is a highlighted hit, summary, or analysis fragment. Authoritative-case `content` prefers an abstract, holding, or case note. Neither is guaranteed to be full judgment text.

### MCP Response-Size Boundary

A small representative test on 2026-08-26 used six certificate-subsidy queries at `top_k=50`. Four calls failed with `开放平台接口响应过大，已超过 1048576 字节限制`, while two targeted calls succeeded and returned 20 and 10 results. Retesting four failed paths at `top_k=30` made three succeed; one still overflowed. This is an observed bridge/payload behavior, not a universal failure-rate estimate.

- On overflow, the tested tool returned an error and no usable partial result list. Do not treat the call as zero hits or as a truncated but usable capture.
- Payload size depends on the returned fields and text length, not only the requested count. A smaller `top_k` can still overflow, while a targeted `top_k=50` call can succeed.
- `top_k=50` is more point-efficient only when the response is likely to fit and the extra candidates are useful. For broad or text-heavy paths, start with a smaller probe, then partition by legally meaningful dimensions such as term family, date, region, cause, court level, document type, or reasoning field.
- If an overflow occurs, retry with a smaller capture or a meaningful partition and log `capture_status=overflow`. Do not silently convert the transport failure into a substantive search result.

## Detail Retrieval

- Supply `type=ptal` or `type=qwal` when known to reduce ambiguity.
- Prefer ID when the search result provides a reliable ID.
- The documented semantics state that案号 is used when no ID is supplied. Passing both ID and案号 therefore does not perform an independent cross-check.
- Re-fetch by案号 alone only when the ID result conflicts, identity is uncertain, a duplicate is suspected, or a central conclusion justifies the extra call.
- The ordinary detail response includes segmented fields such as `cmss`, `ajjbqk`, `fxgc`, `pjjg`, and full `content`. Preserve the complete original body locally for every closely read or cited judgment; project only the fields needed for review into the model context. A local projection cannot prevent an overflow that already occurred upstream in the MCP bridge.
- Capture all reusable metadata, URL, selected excerpts, result, and caveats in the first successful detail call.

## Adaptive Calls and Whole-Task Coverage

Use another keyword path, detail or semantic call when it can materially resolve a question, improve court vocabulary, test the opposing explanation or close a gap. Do not choose scope from the cheapest call or any fixed POINT tier. Source response sizes are per-call facts, not total research targets.

Choose a useful batch that can actually be returned. If a ranked response is incomplete, expand through productive expressions or meaningful issue/date/court partitions; repeated leading results are not new coverage. Do not infer a semantic maximum from the keyword endpoint. Reuse stable texts and metadata, and search only uncovered time deltas where appropriate.

Closely read and report-cited judgments must be saved in full under `output-schema.md`; candidates not selected for either use need not become permanent files. A returned keyword snippet or semantic case summary is not an original judgment.

## Context Control

Do not print complete tool responses into the main context by default. Locally project:

- case identity and source;
- court, date, procedure, and URL;
- one compact factual excerpt if needed;
- one compact reasoning excerpt;
- the result or calculation;
- the classification and unresolved issue.

Avoid returning both full `content` and the same text from `fxgc`, long field-name inventories, or many overlapping keyword windows.
