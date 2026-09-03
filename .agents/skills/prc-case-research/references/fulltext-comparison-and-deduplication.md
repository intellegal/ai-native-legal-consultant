# Full-Text Comparison, Coverage, and Deduplication

Read this reference when the research compares judicial views, claims sample coverage, removes possible duplicates, follows a case chain, studies batch litigation, reconciles ordinary and authoritative database entries, or checks whether a known omitted case can be recovered.

## Reason-First Comparison

Do not decide that two cases express opposing judicial views from the result, query path, snippet, or a position label. Read the relevant original judgment text and compare:

1. the controlling legal or factual question actually before the court;
2. the material facts and contractual or institutional arrangement;
3. the evidence offered, accepted, rejected, or missing;
4. the procedural posture and whether the court reached the merits;
5. the court's own characterization, burden allocation, reasoning chain, and remedy;
6. any later appellate, retrial, or authoritative treatment that changes the meaning of the earlier text.

A genuine difference in judicial view exists only when the courts materially address the same controlling question and adopt different characterizations, reasoning, burden rules, or legal consequences. A claim rejected for missing proof, standing, limitation, pleading design, jurisdiction, or another non-merits reason does not by itself establish an opposing substantive view. Conversely, the same result may rest on materially different reasoning and should not be collapsed into one viewpoint.

Use candidate labels only as retrieval shorthand. In the report, explain the actual reasoning difference and its factual or evidentiary boundary.

## Full-Text Deduplication

Metadata and snippets may identify possible duplicates before detail retrieval, but do not merge or exclude a case from a reported sample solely on those signals. When duplication affects a conclusion, denominator, or retained case set, inspect the original texts and record the basis.

Distinguish these relationships:

- **Source mirror**: the same judgment is stored in ordinary, authoritative, departmental, or other database collections. Confirm identity from the case number, court, date, parties or anonymized party structure, facts, reasoning, and disposition. Keep one canonical judgment record and preserve all source mappings.
- **Litigation chain**: first-instance, appellate, retrial, or remand judgments arise from one underlying dispute. Keep each judicial decision when its reasoning matters, but cluster them under one dispute family and do not count them as independent disputes.
- **Batch family**: judgments share a template, employer, project, policy, or event but concern distinct workers, contracts, payments, or claims. Similar wording alone is not duplication. Keep independent disputes separate and record the batch relationship when it affects representativeness.
- **Possible duplicate**: texts are incomplete, identifiers conflict, or the relationship remains uncertain. Preserve both records, mark the uncertainty, and exclude the pair from any count that requires a resolved independent unit.

Before merging, compare enough full text to establish whether the underlying dispute, adjudicative stage, and judgment are the same. Text similarity is a lead, not proof. When database versions differ materially, retain the variants or source snapshots needed to explain the difference.

For empirical statements, declare the counting unit: database records, judgment documents, adjudicative stages, or independent disputes. Never count source mirrors twice. Do not silently treat several stages of one dispute as several independent observations.

## Dynamic Coverage Map

Use a compact coverage map only for complex, empirical, or omission-checking work where saturation must be auditable. Derive coverage cells from decision-relevant gaps in the current matter; do not impose a universal fact taxonomy.

One cell may combine whichever dimensions materially control the question, such as the disputed issue, fact pattern, evidence pattern, procedural posture, judicial reasoning, authority level, time segment, or remedy. Record:

`coverage_id | decision_relevant_cell | verified_case_keys | strength_or_gap | last_material_round | status`

Use the map to show what has been covered, what remains weak or missing, and whether a new round adds a genuinely new cell. Do not treat a filled cell as representative of prevalence unless the sampling design supports that claim.

## Marginal-Information Selection

After initial screening, prefer the next full text that is most likely to change the evidence map:

1. fills a missing coverage cell;
2. tests an unresolved characterization or reasoning conflict;
3. resolves a possible duplicate, source mirror, batch relationship, or case chain;
4. supplies a clearer merits holding or materially stronger authority;
5. checks a lower-ranked, semantic-only, or otherwise underrepresented path;
6. provides a repeated example only when repetition is needed for an empirical claim.

This is a priority order, not a quota. A high-ranked repetitive result is normally less useful than a lower-ranked case that resolves a material gap.

## Known-Case Recovery Control

When the user supplies a previously omitted case or the local corpus contains a known control case, test whether the current retrieval design can recover it before declaring saturation.

- Run a **blind recovery** with the neutral task vocabulary when evaluating ordinary discoverability.
- Run a **diagnostic recovery** with distinctive court wording or facts when locating the failure mechanism.
- Record whether the miss arose from vocabulary, ranking depth, structured filters, source coverage, transport failure, identity mismatch, or another cause.
- Use the result to repair the relevant path or disclose a source limitation.

Recovery of one known case is a regression control, not proof of general recall. An exact case-number lookup proves identity and availability only; it does not validate the broader search strategy.

## Saturation Check

Before stopping complex, empirical, or omission-checking work, confirm that new rounds no longer materially change the task-relevant coverage cells, judicial reasoning map, evidence or procedural distinctions, duplicate/dispute-family structure, useful vocabulary, authority picture, or practical conclusion. If known omitted cases exist, complete their recovery controls or disclose why recovery remains impossible.
