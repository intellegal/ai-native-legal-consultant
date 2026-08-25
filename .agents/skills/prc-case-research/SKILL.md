---
name: prc-case-research
description: "Use for new or supplemental retrieval and full-text evaluation of PRC Mainland judicial cases, including consultation-level comparable and contrary cases, sample expansion, omission checking, and matter-level research planning. Trigger when a user asks to find cases or a host legal-consultation skill needs adjudicative application; do not trigger for closed-corpus summarization or foreign-law case research."
---

# PRC Case Research

Research how courts apply PRC Mainland law to materially comparable facts, evidence, procedures, and remedies. Preserve the original lawyer-research strengths of decision-first decomposition, two-sided retrieval, full-text verification, provenance, and auditable limits. Optimize the default consultation workflow for coverage and decision value rather than the fewest MCP calls.

## Choose the operating context

### Hosted legal consultation

Use this mode when `$voice-legal-consultation-cn` invokes the skill or the project contains `003_内部工作区/001_案件工作底稿.md`.

- Treat the host's confirmed facts, evidence status, current-law results, decision questions, and research boundary as the input. Do not restart the interview or re-ask facts already recorded.
- Default to the `consultation-quality` retrieval profile below unless the user expressly requests strict cost control or the MCP balance cannot support it. Plan research from the matter's controlling questions, not from point tiers or a target spend. Treat balance as capacity, not a retrieval design. If the host recorded no lower limit, one affirmative verification choice authorizes up to `3500 POINT` for the current consultation; this is a safety boundary, not a quota to consume.
- Keep detailed work in `003_内部工作区/004_法律与案例检索记录.md`, created from `assets/咨询案例检索记录模板.md` when absent.
- Save each retrieved judgment full text as its own Markdown file under `004_给你的结果/004_案例全文/`, create the index and case files from `assets/案例全文索引模板.md` and `assets/案例全文文件模板.md`, and link the local files from the case ledger and verified consultation result.
- Return case findings to the host for integration into the verified layer of `004_给你的结果/001_咨询结果.md`. Do not create a competing standalone `报告.md`.

### Standalone case research

Use the ordinary report-first workflow. For reproducible, empirical, continuing, or handoff work, read `references/output-schema.md` and use `scripts/init_case_research_workspace.py` when its workspace is useful.

### Cost-sensitive override

Use only when the user requests a low-cost search, the available balance is materially constrained, or the intended answer is a narrow lookup. Preserve full-text verification and contrary-search requirements; reduce secondary issue breadth first and disclose what was not searched. Do not silently downgrade quality.

## Load only the needed references

- For a whole matter or multiple dependent issues, read `references/matter-decomposition.md`.
- Before building or expanding search expressions, read `references/keyword-matrix.md`.
- When using YuanDian or evaluating point consumption, read `references/yuandian-optimization.md` and check live tool metadata when available.
- When findings will guide evidence, procedure, negotiation, or action, read `references/practical-analysis.md`.
- Before persisting a plan, workpaper, cache, or standalone report, read `references/output-schema.md`.

## Non-negotiable research rules

1. Separate `现行规则`, `案例观察`, `实践推论`, and `需核验`.
2. Treat legal relationships, claims, defenses, and user-favored outcomes as provisional hypotheses rather than search definitions.
3. Search materially plausible supporting, contrary, distinguishing, and gap paths.
4. Verify full text for every case supporting a major conclusion and for enough contrary or borderline cases to test whether the conclusion survives.
5. Compare controlling facts, disputed issue, evidence, procedural posture, applicable-law version, reasoning, remedy, and result. Topic or result similarity alone is insufficient.
6. Record case number, source ID/type, court, date, procedure, URL, retrieval time, full-text status, and material limitations.
7. Never convert an empty result into a claim that no rule, case, or judicial approach exists.
8. Never write API keys, authorization headers, or other credentials into any artifact or output.

## Hosted-consultation input and handoff

Before retrieval, obtain or derive the following from the host workpaper:

- the user decision and desired/unacceptable outcomes;
- each controlling research question and why it can change that decision;
- confirmed facts, party claims, contradictions, missing facts, and evidence locations;
- current-law rule/version already verified or still pending;
- relevant dates, location, court/procedure signals, and cross-border limits;
- user-confirmed research scope and any excluded issue;
- the matter-wide research authorization, any user-set lower point boundary, and any real balance constraint.

If the matter has not been decomposed, produce `003_内部工作区/003_案件梳理与案例检索建议.md` and return it to the host. The host gives a short spoken scope summary and obtains one confirmation for all identified issues. Do not independently add another conversational checkpoint. New synonyms, filters, full-text pulls, contrary paths, and gap-filling moves inside the confirmed scope do not require renewed approval.

Return a concise handoff containing:

- major case observations and which decision question each affects;
- full-text-verified supporting, contrary, and distinguishing cases;
- the controlling similarities and differences from the user's matter;
- evidence or fact gaps revealed by the cases;
- the coverage lanes completed, omitted, or still uncertain;
- current-rule checks still required;
- the local full-text files used by each major observation;
- any real balance constraint, tool failure, or source limitation that reduced coverage.

## Matter-level planning gate

Use matter-level planning when the user supplies a whole dispute, multiple parties/transactions, several claims or defenses, or a comprehensive omission-check request. Skip it for a narrow case lookup or a user-defined empirical question.

For matter-level work:

1. Derive one matter-wide issue map from the user's narrative, decision, claims, defenses, evidence, procedure, remedies, and unresolved dependencies. Include all material legal questions disclosed by the narrative rather than treating each query as a separate research task.
2. Route current-law questions to authoritative legal sources, factual gaps to evidence or clarification, current local operating questions to official sources, and only adjudicative-application questions to case research.
3. Produce one concise `案件梳理与案例检索建议.md` explaining the boundary, provisional paths, material questions, source routing, priority, and exclusions.
4. Obtain one user confirmation or an explicit waiver before external retrieval. In hosted consultation, the voice host owns this confirmation.
5. Reopen scope only when a discovery materially changes the decision, legal route, or research boundary and cannot reasonably fit inside an approved question. Ordinary new expressions, additional cases, contrary paths, or a larger full-text set inside the approved matter do not require another checkpoint.

## Consultation-quality retrieval profile

Research intensity follows the number, dependency, materiality, and uncertainty of the matter's controlling questions. Do not classify a matter as “targeted” or “deep” by expected POINT consumption, and do not reduce issue coverage merely to fit an internally preferred spend. Before the first chargeable call, check live unit prices and record them; track cumulative use as work proceeds. If live prices are unavailable, do not make a chargeable call. Never cross the host-confirmed authorization boundary; if none was supplied, use `3500 POINT` for the current consultation. Return to the host only before crossing that boundary or opening a materially new matter outside the confirmed scope. Do not continue merely to use remaining points.

### 1. Build one matter-wide issue and coverage map

Represent every material legal issue disclosed by the user's narrative in one plan. Show dependencies between issues, identify which questions can change the user's decision, route non-case questions to the proper source, and then form materially different case-research lanes for each controlling adjudicative issue across:

- statutory/doctrinal expressions and historical names;
- transaction, conduct, relationship, and event facts;
- evidence type, burden, authenticity, completeness, and defect language;
- the opponent's characterization, defense, denial, exception, or competing cause;
- procedural posture, remedy, and merits-avoidance paths;
- supporting, contrary, and distinguishing result/reasoning expressions;
- authoritative/typical/reference cases and ordinary judgments;
- semantic backfill for vocabulary or recall gaps.

Open several justified lanes at the outset instead of designing the work as one search at a time. Allocate attention by decision impact, unresolved uncertainty, and dependency on other issues—not evenly and not by a POINT allowance. Retire an immaterial branch only with a recorded reason; add newly discovered material issues to the same map when they fit the confirmed matter.

### 2. Capture generous search batches

- For focused YuanDian keyword lanes, normally request `top_k=30` to `50` when results can be projected and deduplicated locally; a smaller probe remains appropriate for an untested or obviously noisy expression.
- For semantic reconnaissance/backfill, a broad capture is appropriate when the response can be cached or projected outside the main context.
- Run authoritative-case retrieval when authority status or reference value matters; do not assume ordinary and authoritative databases are interchangeable.
- Use targeted official-web discovery to find current official typical/reference cases, court publications, adjudication guidance, and terminology that a database query may miss. Verify identity and text before relying on it.

### 3. Read enough full text to test the theory

- Pull details for every candidate that could materially support, contradict, distinguish, or overturn a major conclusion.
- For both a validation-oriented check and a broader verification, normally begin with a matter-wide review target of `20–50` judgment full texts across the controlling issues. This is a quality starting range, not a mechanical minimum, quota, or ceiling. Review fewer only when the available comparable pool, tool access, or a user-selected lower authorization boundary genuinely prevents the range and disclose that limitation; expand beyond 50 whenever unresolved issues, contrary paths, regional/time segments, new court vocabulary, or conclusion-changing differences require it.
- Distribute the full-text set across the issue map and meaningful fact/evidence/procedure variants; do not let one easy issue consume the set while another controlling issue remains untested, and do not stop after the first favorable case.
- Pull borderline or apparently adverse cases when they can reveal exclusion rules, burden allocation, remedy limits, or better search vocabulary.
- Dedupe by normalized case number, then source ID, title, court, and date before detail retrieval.

For every full-text detail retrieved:

- save one Markdown file under `004_给你的结果/004_案例全文/` in hosted consultation, or `案例全文/` in standalone work;
- use a filesystem-safe name such as `NNN_案号_法院_裁判日期.md`, falling back to the stable source ID when no case number is available;
- record title, case number, source/type/ID, court, decision date, procedure, URL, retrieval time, text status, and any identity/version caveat before the body;
- preserve the complete returned judgment text without paraphrasing it; when the provider returns only an abstract, snippet, or processed semantic text, label it accordingly and do not count or file it as a verified judgment full text;
- add the file to `000_案例全文索引.md` and link it from every workpaper/report row that relies on it.

Use relative Markdown links that work from the actual file location: `./004_案例全文/<file>.md` from `004_给你的结果/001_咨询结果.md`, `./<file>.md` from the index, and `../004_给你的结果/004_案例全文/<file>.md` from `003_内部工作区/004_法律与案例检索记录.md`.

### 4. Expand adaptively after the broad pass

Use the returned texts to tighten noise, add court expressions, reverse a characterization, fill an uncovered lane, extend a recent/authority segment, or close a repetitive path. Keep the matrix live; do not mechanically run every conceivable combination.

### 5. Complete a coverage gate

Before stopping a controlling issue, confirm or expressly disclose the absence of:

- a supporting application path;
- an opponent/contrary path;
- material factual, evidentiary, and procedural distinctions;
- an authority-level and recent-time check where relevant;
- semantic or alternate-expression backfill, or a reason it was unnecessary;
- full-text verification for every case used in a major conclusion;
- a current-law check for any rule, period, filing requirement, or procedure stated as current.

Stop when additional rounds no longer change the conclusion, practical map, or disclosed uncertainty—not merely because the first usable case was found.

## Data sources and source handling

- Check local verified cases, workpapers, caches, and source snapshots before reacquisition, but do not let reuse narrow the current issue unfairly.
- Use legal case MCP tools for structured retrieval. YuanDian is a supported provider, not the skill identity.
- Treat semantic-search results and keyword snippets as discovery material. Use detail/original text for major conclusions.
- General web pages, articles, and search snippets can reveal expressions or omissions but cannot independently establish a major case observation. Prefer official court and authoritative database pages.
- Capture source metadata and URLs when first returned. Do not spend a later detail call merely to recover metadata already available.
- Persist the complete verified judgment to the local Markdown archive, but project only decision-relevant fields into the main conversation context. Local retention and context compression are complementary.

## Research record and analysis

For every retained case record:

`案号 | 来源/ID | 本地全文 | 案名 | 法院 | 日期 | 程序 | 全文状态 | 角色 | 控制性事实 | 证据及处理 | 争点 | 裁判理由 | 结果/救济 | 本案相同点 | 本案差异 | 影响的结论 | 限制`

For every major conclusion, write:

`现行规则 → 用户最强适用 → 对方最强回应 → 支持/相反/区分案例 → 证据和程序差异 → 未知与敏感变量 → 条件性结论 → 决策含义`

Do not give an exact win probability without a relevant, described, defensible dataset. Use basis-linked language such as `支持较强`, `有条件支持`, `两种解释均有现实基础`, `目前不足以判断`, or `超出覆盖`, and state what could change it.

## Completion check

Before claiming that case research is complete, confirm:

- the confirmed scope was actually searched;
- controlling issues received the consultation-quality profile unless a downgrade is disclosed;
- major case claims rely on verified full text rather than summaries/snippets;
- the matter-wide issue map drove the work, the normal `20–50` full-text starting range was met or a concrete limitation was disclosed, and expansion continued where coverage remained unresolved;
- each reviewed judgment full text has a local Markdown file and each major report citation links to that file;
- supporting, contrary, distinguishing, authority, and omission lanes were addressed as relevant;
- comparisons explain outcome-changing similarities and differences;
- current rules and case observations remain separate;
- tool failures, balance limits, missing text, under-sampled paths, and unresolved conflicts are visible;
- hosted findings were written to the canonical consultation workpaper and returned to the voice host without creating a second report.
