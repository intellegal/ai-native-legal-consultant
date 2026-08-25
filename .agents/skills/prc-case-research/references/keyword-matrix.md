# Coverage-First Keyword Matrix and Calibration

Build a materially broad starting matrix, then revise it with language found in matching judgments. Treat the matrix as an internal reasoning structure, not a user-facing deliverable or an instruction to run every conceivable combination.

## Consultation-Quality Start

For hosted legal consultation, optimize the first pass for coverage rather than minimum calls. For each controlling issue, normally open several materially different lanes spanning the rule/doctrine, transaction or conduct facts, evidence and burden language, opposing characterization or defense, procedure/remedy, supporting and contrary reasoning, and alternate or historical expressions. Include an authoritative-case lane and semantic backfill when they can change the answer. Give secondary issues less breadth when they cannot change the user's decision.

For a narrow standalone lookup or an explicit cost-sensitive request, a smaller probe may be enough. In every mode, frame the initial hypothesis neutrally. Treat a user-favored disposition as one position to test rather than the definition of relevance.

Do not wait for one tiny probe to reveal the entire vocabulary. Build the first matrix from the confirmed facts, current-law elements, evidence issues, opposing account, known legal expressions, and bounded synonyms. Then read snippets and selected full texts before revising or multiplying lanes.

Extract separately:

- the court’s factual characterization;
- the court’s reasoning and result expressions;
- party allegations or defenses;
- appraisal, evidence, and procedural language;
- contrary formulations used to reject the target characterization.

Do not treat every extracted word as a new search path. Add or revise a path only when it can improve precision, expand a material synonym set, test a contrary position, fill a real coverage gap, or expose a decision-changing distinction.

## Yuandian Syntax

For `rh_ptal_search` and `rh_qwal_search`:

- `qw`: full-text terms split by spaces.
- `fxgc`: analysis or reasoning terms split by spaces; available for ordinary cases.
- `search_mode`: global connector; only `and` and `or` are confirmed.
- `title`: terms split by spaces and all title terms must hit.
- `ay`, `jbdw`, `xzqh_p`, `wszl`, `source`, and date fields: structured filters; array values are OR within the field.
- `top_k`: default 10 and maximum 50 per call.

Do not pass nested Boolean expressions, `NOT`, or proximity operators such as `NEAR/5` into `qw`. For `A AND (B OR C)`, run `A B` and `A C` as separate `and` queries only after the first branch shows that the distinction is useful. For `A AND NOT X`, run `A` and filter or downrank candidates containing `X` after review.

Use `fxgc` first when the target is an express judicial holding. Use `qw` when the relevant language may appear in facts, evidence, party submissions, appraisal reports, or other portions of the judgment.

## Dynamic Calibration Loop

After the broad initial pass, use this loop for each material round:

1. Run a small probe and inspect both `total` and the returned cases.
2. Read snippets first. Pull details generously for promising, adverse, ambiguous, borderline, or vocabulary-rich cases when full text can test a conclusion or improve the matrix.
3. Assess the round using task-specific judgment rather than a fixed score or universal hit-rate threshold.
4. Select one next move:
   - **Tighten**: add a discriminating court expression or structured filter when noise has a repeatable cause.
   - **Expand expressions**: add synonyms or alternate formulations found in useful judgments.
   - **Reverse**: search for the competing characterization, rejected evidence, opposite burden allocation, or different remedy.
   - **Fill a gap**: open a path for a missing fact, evidence type, procedure, authority level, time segment, or result.
   - **Expand a proven path**: increase result depth when precision is good and additional cases can change the answer.
   - **Stop**: close the path when another round is unlikely to add a new expression, case type, or conclusion.
5. Dedupe before detail calls and reuse locally verified cases.
6. If a persistent workpaper exists, record one compact retrieval-trail row only when the round changes coverage, query logic, exclusions, or the stopping judgment.

## Result-Size Decision

Yuandian charges keyword searches per call rather than per returned result, while larger results consume more review and context. Balance both:

- in `consultation-quality` mode, normally capture `top_k=30` to `50` for focused keyword lanes when results can be projected and deduplicated locally;
- keep an untested or obviously noisy expression smaller until its signal is understood;
- refine an imprecise path before merely increasing `top_k`;
- expand a proven path and open other materially distinct lanes when each answers a different coverage question;
- when rerunning a query at greater depth, reuse and dedupe the results already reviewed;
- split results by a legally meaningful issue, date, court, region, document type, or authority source only when the split answers a research question.

## Coverage and Stop

Do not use a fixed number of keyword paths, results, or full texts as a hard quota or ceiling. The ranges above are operational defaults for a single consultation, not empirical sufficiency claims.

Continue when new expressions still change the search, a competing position remains untested, an important authority/time/fact/evidence/procedure segment is missing, or the claimed empirical confidence requires broader coverage.

Stop when useful additions are repetitive, noise is understood, all material positions are represented, and further retrieval no longer changes the conclusion or practical map. For empirical projects, explain actual sample adequacy and under-sampled areas instead of relying on a universal minimum.
