# Practical Analysis Guide

Use this guide when case research may inform real-world action, not only academic description. The goal is to translate裁判口径 into evidence, procedure, deadline/material, and action implications while keeping every claim auditable.

For a whole matter or multi-issue dispute, read `matter-decomposition.md` first, reusing the user's requested or host-confirmed scope and clarifying only material uncertainty. Use this guide to enrich those issues; do not use its categories as a preset issue universe.

## Intent Archetypes

Classify the user's likely intent before finalizing the search plan. If inferred, label it as an inference.

- `原告/申请人评估`: identify viable claims, burden of proof, evidence gaps, remedies, and procedural barriers.
- `被告/相对方抗辩`: identify defenses courts accept, evidence that weakens the claim, limitation/procedure objections, and settlement leverage.
- `证据收集`: identify evidence categories, admissible forms, preservation/notarization needs, and common defects.
- `谈判/调解`: identify likely range of outcomes, facts that shift leverage, and risks of litigating.
- `执行/异议/再审/上诉`: identify posture-specific thresholds, filing materials, review scope, and timing issues.
- `合规/交易/结构设计`: identify patterns courts respect or pierce, documentation practices, and avoidable risk facts.
- `学术/实证研究`: keep practical synthesis short and focus on method, coding, and sample limitations.

## Practice Map

Build only the task-relevant subset as an internal working analysis within the requested matter-level scope, or directly for an atomic query. Revise it after full-text review. Treat the schema below as optional reasoning support, not a required table, research card, or user-facing deliverable. Integrate useful findings into the report; do not create a separate practice-translation file by default.

`intent, issue_path, likely_claim_or_defense, facts_to_prove, burden_notes, evidence_types, evidence_form, evidence_defects, procedural_path, deadline_or_time_limit, required_filings, case_differences_to_track, source_basis, verification_status`

Use `verification_status` values:

- `case_observation`: found in full-text cases but not independently verified as a current rule.
- `current_rule_checked`: checked against a current statute, judicial interpretation, court rule, or official filing guidance.
- `inference`: practical conclusion inferred from cases; not a binding rule.
- `needs_verification`: plausible but not verified; use for time limits, filing materials, and procedure details if current authority was not checked.

## Evidence Map

For each issue path, extract evidence from cases in a structured way:

- evidence category: contract, bank flow, chat/message, invoice/receipt, equity register, industrial and commercial filing, real-estate register, insurance policy, appraisal, audit report, witness testimony, company records, enforcement materials, notarized evidence, electronic data, or other.
- evidence form: original, copy, screenshot, exported record, notarized record, official archive, platform record, bank statement, court investigation material, appraisal opinion, or audit report.
- proving purpose: source of funds, ownership, intent, control, transfer path, value, timing, notice, possession/use, company independence, sham transaction, or damages.
- court treatment: accepted, partly accepted, rejected, not reviewed, required separate litigation, or insufficient without corroboration.
- defect pattern: authenticity problem, relevance problem, legality problem, incomplete chain, unclear source, no original, hearsay, self-made document, after-the-fact document, inconsistent amount/date, or cannot identify counterparty.
- stronger substitute: official record, third-party record, original bank flow, notarized electronic data, appraisal/audit, court investigation order, or preservation.

## Procedure Map

Do not state procedural deadlines or filing requirements as rules unless current authority has been checked. If only cases mention them, label them as `case_observation` or `needs_verification`.

Track:

- posture: pre-litigation, first instance, second instance, retrial, enforcement, enforcement objection, third-party objection, preservation, appraisal, separate litigation, arbitration, administrative filing.
- venue/jurisdiction and cause-of-action implications when they affect success.
- claim/remedy design: confirmation, partition, return, compensation, invalidation, cancellation/registration change, damages, preservation, appraisal, audit, investigation order, or separate lawsuit.
- timing issues: limitation period, appeal period, retrial petition period, objection period, enforcement time limits, preservation timing, appraisal application timing, evidence submission deadline.
- required materials: complaint/application, identity/authorization, evidence list, copies, property clues, guarantee/security for preservation, appraisal application, investigation order application, enforcement materials, proof of service/address, fee materials.
- procedural barriers: wrong defendant, wrong cause, separate-litigation requirement, res judicata, limitation defense, lack of jurisdiction, non-final judgment, enforcement-only issue, appraisal impossible, valuation date dispute, or burden not met.

## Report Integration

Integrate only the material that changes the answer or the user's next step. Usually this means the relevant subset of: controlling case pattern, facts and burden of proof, evidence strengths or defects, procedural path, outcome differences, and action options. Put uncertainty beside the affected conclusion instead of adding a generic checklist.

Do not turn the report into generic legal advice or reproduce the working map as a separate file. Keep source provenance and unresolved verification in the single workpaper when one exists; keep substantive evidence, procedure, and action analysis in the report.

## Writing Rules

- Separate `案例观察`, `现行规则`, and `实践推论`.
- Include case numbers for case-derived conclusions.
- For deadlines and required filings, cite current authority when checked; otherwise write `需核验`.
- Avoid promising outcomes. Write in terms of evidence sufficiency, procedural risk, and likely points of dispute.
- If the user is not represented by counsel or facts are incomplete, frame output as research support rather than legal advice.
