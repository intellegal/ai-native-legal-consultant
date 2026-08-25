# Current-law, case, web, and analysis protocol

## Capability gate

This protocol starts only after the user chooses the deeper verification layer. Earlier public-Web examples and provisional judgments remain useful inputs, not mistakes to erase. A working legal MCP is required to present current law or a substantive legal opinion as database-verified. “Connected” is not enough: test that it returns traceable current text, authority, effective date/version, and scope.

Without a passing MCP, the evidence-aware baseline and any traceable public-source preliminary analysis remain a valid deliverable. Keep `result_level: BASELINE`, label database law/case status “尚未核查”, preserve the user’s work, and guide at most one setup action at a time. Describe the missing capability plainly instead of calling the whole setup incomplete.

## Route by question

- Current normative rule → legal MCP, then official text where material.
- User facts/evidence → files, user clarification, lawful public records.
- Judicial application/comparability → `$prc-case-research` in hosted-consultation mode.
- Current local process/forms → current official court/agency website.
- Court/government publications, public judgments, and reliable reporting → usable preliminary context when source type, link, time, proposition, and limits are visible; they may support a provisional direction but not a claim of comprehensive/current database verification.
- Commentary and search snippets → discovery only, never the sole basis for a major legal conclusion.

## Decision-first decomposition

Before searching, write:

1. the decision the user faces;
2. every material legal and non-legal question disclosed by the complete narrative and the dependencies between them;
3. the key facts/evidence and gaps for each question;
4. which source route answers each gap;
5. expected deliverables and coverage limits.

Create `003_内部工作区/003_案件梳理与案例检索建议.md`. If the opt-in choice expressly covered the already identified issue map, record it as the single matter-level approval and pass it to `$prc-case-research`; do not ask again. If the boundary was not clear, give one compact summary combining whole-matter scope, minimum-data boundary, and the default `3500 POINT` authorization boundary, then obtain one confirmation. Explain that the number is not a retrieval tier or spending target. Only a materially new matter outside the approved map or a call that would cross the authorization boundary requires renewed confirmation.

The first user-facing upgrade invitation must not recite this internal scope, data, and point structure. The user's affirmative choice to verify the already identified matter records the default matter-wide/minimum-data/`3500 POINT` boundary internally. Expand it to the user only when scope is unclear, the user asks or chooses a lower ceiling, a materially new matter appears, or the next call would cross the ceiling.

## Current-law retrieval

For every major rule record: title, issuing authority, hierarchy, promulgation/effective date, amendments/repeal, geographic/subject scope, exact provision, source URL, MCP/provider, and query time. Separate requirements, exceptions/defenses, procedure, and consequences.

Re-check time-sensitive law before finalization. Do not use an old court risk notice for a current period or deadline without current-law verification.

## Case research

Use `$prc-case-research` faithfully:

- pass the confirmed decision questions, fact/evidence ledger, current-law status, relevant dates/locations, and approved boundary from the canonical workpaper;
- default to `consultation-quality` and plan from the whole-matter issue map, never from point tiers or isolated single-search tasks;
- allocate lanes across every controlling issue by decision impact, dependency, and uncertainty; cover legal terms, conduct/facts, evidence, defenses, procedure/remedy, supporting/contrary reasoning, synonyms, historical names, authority status, and semantic backfill;
- normally capture `top_k=30` to `50` on focused keyword lanes when results can be projected and deduplicated locally; use smaller probes only for untested/noisy expressions or an explicit cost-sensitive mode;
- search supporting, contrary, and gap paths;
- normally review and save `20–50` judgment full texts across the matter's supporting, adverse, borderline, and distinguishing variants; treat this as a starting range rather than a quota or ceiling, and expand while material gaps remain; every case supporting a major conclusion must be full-text verified;
- save every retrieved judgment full text as a separate Markdown file under `004_给你的结果/004_案例全文/`, maintain `000_案例全文索引.md`, and link relied-on files from the workpaper and user result; snippets, abstracts, case notes, and semantic processing do not count as full text;
- record provenance, case number, court, date, procedure/finality, applicable-law version, facts, evidence, issue, reasoning, result, similarities, and differences;
- compare basic facts, disputed issue, governing rule, and evidence/procedure—not result alone;
- distinguish guiding cases, People’s Court Case Database reference cases, typical/gazette cases, and ordinary judgments;
- use targeted official-Web discovery for official reference/typical cases, court publications, recent terminology, and omission checking, then verify identity and text;
- write detailed research to `003_内部工作区/004_法律与案例检索记录.md` and return a concise handoff for the user report;
- stop on whole-matter coverage and saturation, not the first usable case, an arbitrary quantity, or unused POINT allowance.

Treat public cases used during the interview as seed leads. Verify their identity, full text when available, applicable-law version, comparability, later treatment, and contrary patterns before promoting them from `公开信息参考` to `案例观察`. If a public example cannot be verified or proves materially different, keep the original link visible and explain the downgrade rather than silently removing it.

Never state that no case exists merely because a search returned none. State platform, query, time, filters, and coverage.

## Four output labels

- `现行规则`: current authoritative norm.
- `案例观察`: what verified cases show about application.
- `实践推论`: reasoned inference from sources and matter context.
- `需核验`: unresolved source, version, fact, or coverage issue.

Do not merge these labels.

## Two-sided analysis

For each issue write:

1. current rule;
2. user’s strongest application and evidence;
3. opponent’s strongest facts, defenses, procedural/evidentiary attacks;
4. similar and contrary cases and the differences that matter;
5. unknowns and sensitivity variables;
6. conditional conclusion;
7. decision implication and possible low-cost next step.

Use confidence language tied to the basis: `支持较强`, `有条件支持`, `两种解释均有现实基础`, `目前不足以判断`, or `超出覆盖`. Always explain why and what could change it. Do not invent a numeric win rate.

## Final research QA

- no model-memory-only major rule;
- no stale or mismatched legal version;
- no case-summary-only major citation;
- every retrieved judgment full text has a local Markdown file, and every major case row links to it;
- the 20–50 starting range was met or a concrete source/tool limitation was disclosed, with unresolved controlling issues expanded as needed;
- no “case equals binding statute” claim;
- contrary search completed;
- local procedure not generalized nationally;
- facts, law, case observation, inference, and unknowns remain distinct;
- failed tools and unresolved conflicts are visible.
