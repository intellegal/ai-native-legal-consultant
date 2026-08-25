# YuanDian Retrieval, Coverage, and Cost Control

Use this reference when retrieving cases through YuanDian or when the user asks to control retrieval cost. In hosted legal consultation, decision value and defensible coverage take priority over minimizing points; cost control prevents waste and records limits rather than forcing the smallest possible search. Recheck official documentation when tool schemas or prices may have changed.

## Official Sources

- Documentation center: https://open.chineselaw.com/docs/
- Case semantic search: https://open.chineselaw.com/api-square/16/
- Ordinary-case keyword search: https://open.chineselaw.com/api-square/7/
- Authoritative-case keyword search: https://open.chineselaw.com/api-square/8/
- Case details: https://open.chineselaw.com/api-square/9/
- Machine-readable full documentation: https://open.chineselaw.com/llms-full.txt

The public YuanDian homepage prices below were checked on 2026-08-23. YuanDian pricing and schemas can change, so query `yuandian_get_api_doc` before every matter's first chargeable call; live MCP documentation overrides this table.

## Cost Model

| Interface | Tool | Published price |
|---|---|---:|
| Case semantic search | `yuandian_case_vector_search` | 10 POINT/call |
| Ordinary-case keyword search | `yuandian_rh_ptal_search` | 10 POINT/call |
| Authoritative-case keyword search | `yuandian_rh_qwal_search` | 10 POINT/call |
| Case details | `yuandian_rh_case_details` | 5 POINT/call |

Use live prices as accounting inputs, not as a way to define research depth. For `consultation-quality`, check prices and available balance before the first chargeable call, record live unit prices, and track cumulative use. Do not classify the matter or choose issue coverage from any fixed POINT tier. The controlling issue map determines the search plan. Unless the host records a lower user-selected boundary, one verified consultation may use up to `3500 POINT`; this is an authorization ceiling, not a target. If live prices are unavailable, do not make a chargeable call. Pause only before the next call would cross the confirmed ceiling or when a discovery opens a materially new matter outside the approved scope. If the actual balance is inadequate, disclose which unresolved paths could not be completed.

## Semantic Search

- `return_num` defaults to 45. The current documentation does not state a hard maximum. Live tests requesting 50 and 60 returned 50 and 60 unique results respectively, and each call deducted the same 15 points.
- Do not describe 50 as the semantic endpoint’s maximum. For consultation-quality reconnaissance, 45 to 60 is a useful broad capture range when local caching and compact field projection are available; it is not a hard minimum or maximum.
- When results can be cached outside the main context, prefer a broad first capture that avoids paying again merely to enlarge the same query. Inspect the cached results in smaller review batches.
- When the raw response will enter the main model context, use a smaller return size because a 50-result live response was about 60,000 characters and a 60-result response about 71,000 characters.
- `rewrite_flag` defaults to `true`. Keep it on for exploratory natural-language retrieval; turn it off when testing a controlled formulation and query drift would be harmful.
- Apply known `wenshu_filter` fields early: case category, cause, document type, court, court level, region, date, authoritative-only flag, and authoritative source.
- Results contain processed and organized case content with similarity scores, not verbatim original judgments. Use them for reconnaissance and backfill, not as the final textual basis for a major conclusion.
- The default search already covers ordinary and authoritative cases. Run a separate authoritative search only when source type, authority status, or authoritative-case recall materially matters.

## Keyword Search

- `top_k` defaults to 10 and is capped at 50. Published pricing is per call, not per returned result. In consultation-quality mode, use `top_k=30` to `50` for focused lanes that can be projected locally; reserve smaller calls for untested/noisy expressions or strict cost-sensitive work.
- `qw` searches full-text terms. `fxgc` searches the analysis/reasoning field for ordinary cases and is often more precise for express judicial holdings.
- `search_mode` is global `and` or `or`; spaces split terms. Nested Boolean logic, `NOT`, and proximity operators are not supported.
- Use structured filters before adding more lexical terms when the scope is already known.
- Inspect `total` and the returned sample. Refine a noisy query before increasing depth. In a consultation, also open other materially distinct rule/fact/evidence/defense/procedure lanes when they test different risks; do not make every lane wait for a single precision probe.
- Search results already provide ID,案号, title, court, date, content snippet, URL, and score. Save these immediately instead of retrieving details later just to recover metadata.
- Ordinary-case `content` is a highlighted hit, summary, or analysis fragment. Authoritative-case `content` prefers an abstract, holding, or case note. Neither is guaranteed to be full judgment text.

## Detail Retrieval

- Supply `type=ptal` or `type=qwal` when known to reduce ambiguity.
- Prefer ID when the search result provides a reliable ID.
- The documented semantics state that案号 is used when no ID is supplied. Passing both ID and案号 therefore does not perform an independent cross-check.
- Re-fetch by案号 alone only when the ID result conflicts, identity is uncertain, a duplicate is suspected, or a central conclusion justifies the extra call.
- The ordinary detail response includes segmented fields such as `cmss`, `ajjbqk`, `fxgc`, `pjjg`, and full `content`. Save the complete judgment `content` and provenance to the matter's local Markdown archive, then project only the fields needed for the current model review.
- Capture all reusable metadata, URL, complete returned judgment text, selected excerpts, result, and caveats in the first successful detail call. A snippet, abstract, case note, or semantic-search organization is not a judgment full text.

## Quality-First Call Decisions

Use the next call that is most likely to reduce a material uncertainty or close a required coverage lane:

- When useful terminology is already known, run focused ordinary/authoritative keyword lanes broadly enough to cover rule language, facts/evidence, and the opponent path; do not choose only the cheapest single formulation.
- Pull a detail when a promising case can supply real court vocabulary, distinguish court reasoning from party allegations, verify a major conclusion, or decide whether a new path is needed; use the live price rather than a remembered value.
- Use semantic search when vocabulary remains uncertain, keyword paths leave a material recall gap, or one broad semantic capture can replace several speculative searches; use the live price rather than a remembered value.
- In consultation-quality mode, a bounded set of parallel, materially distinct initial lanes is justified by the confirmed issue map; avoid only duplicative or factually irrelevant speculation.
- For keyword search, `top_k=50` costs the same points as `top_k=10`; use the larger capture when local caching/projection exists and the path is sufficiently targeted.
- When increasing `top_k` or `return_num` through another call, locally dedupe results already seen and account for the duplicated leading results.
- Use date-delta retrieval for follow-ups instead of rerunning stable historical ranges.

Do not let point efficiency eliminate a controlling issue, contrary path, full-text verification, authority check, or decision-changing evidence/procedure lane. A matter with several legal issues must be planned and assessed as a whole. When a real balance limit forces omission, record the omitted lane and its likely effect on confidence.

## Context Control

Do not print complete tool responses into the main context by default. Persist each verified judgment full text as its own Markdown file, then locally project:

- case identity and source;
- court, date, procedure, and URL;
- one compact factual excerpt if needed;
- one compact reasoning excerpt;
- the result or calculation;
- the classification and unresolved issue.

Avoid returning both full `content` and the same text from `fxgc`, long field-name inventories, or many overlapping keyword windows.
