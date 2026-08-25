# State, materials, facts, and evidence

## Canonical state

Use `003_内部工作区/001_案件工作底稿.md` as the only canonical matter state. Conversation memory is not authoritative. Create it from `assets/案件工作底稿模板.md` if absent.

Update after every material change: corrected fact, new file, contradiction, risk trigger, research result, user decision, or service-state change.

## Material handling

Invite all potentially relevant items, not only favorable or user-classified “evidence.” User files enter `002_你的材料/` directly and remain there with their original content and filename; do not create intake/archive categories, move them after registration, or make the user classify them. Before interpretation, record original name, path, source, receive time, size, and SHA-256 under `003_内部工作区/010_材料处理/003_材料清单/`. Put OCR, transcription, redaction, conversion, normalized-name copies, and other derivatives under `003_内部工作区/010_材料处理/001_可检索副本/`; put structured interview records under `003_内部工作区/010_材料处理/002_访谈记录/`; keep every source-to-derivative mapping in the material list.

The top-level distinction is a user-facing invariant: `002_你的材料/` contains only user-provided originals, `003_内部工作区/` contains every consultation-generated internal or processing artifact, and `004_给你的结果/` contains only user-readable or handoff-ready outputs.

For normalized working copies use `NNN_YYYYMMDD_材料类型_主体或主题_状态.ext`; use `日期不明` when needed and a new sequence, `_v02`, or `_补充01` instead of overwriting. User files remain in place with their original filenames.

## Interview record

Create `NNN_YYYYMMDD_HHMM_访谈记录.md` from `assets/访谈记录模板.md` as soon as substantive matter facts have been obtained. This is automatic internal persistence, not an optional user deliverable.

- Maintain one record per consultation segment/session; do not create a new file for every turn.
- Update after each completed theme, material correction, or decision-changing disclosure so an interrupted session loses as little state as practical.
- Persist and mark the stop reason when the baseline interview is complete, the user explicitly pauses or ends, or the workflow transitions to verification or human-review preparation.
- Capture the user's goal, material statements and chronology, mentioned/provided materials, adverse version, corrections, uncertainties, remaining highest-value question, and files created or updated.
- Summarize faithfully. Do not invent unspoken details, turn paraphrase into quotation, or call the record a recording/verbatim transcript unless an actual transcript was available and checked.
- Keep the canonical fact/evidence state in the workpaper; link or cross-reference it instead of allowing the interview record to become a competing matter state.

Inventory before interpreting. Record file name, type, source, date, page/range, original/copy/screenshot/export status, completeness, readability, OCR/transcription uncertainty, and associated issues.

Ask for context where needed:

- full contract, attachments, amendments, signature and performance records;
- complete messages/emails with identity and surrounding content;
- every page of official documents and delivery/service details;
- original media, source, creation/collection method, metadata and continuity;
- payment record, payer/payee identity, note, and link to the underlying obligation.

Do not authenticate evidence from appearance alone. Distinguish what a document displays from whether it is genuine, lawful, complete, admissible, or persuasive.

## Proposition ledger

Each material proposition must contain:

- a single observable claim;
- source: user, opponent, document, third party, public record, or system inference;
- status: admitted, user claim, opponent claim, material shows, conflict, unknown, inference;
- support with file and page/location or oral source;
- contrary material, missing context, or alternative explanation;
- why any reliability assessment follows from independence, contemporaneity, completeness, or consistency—not demeanor;
- legal issue affected;
- next verification action.

Keep proposition/source status separate from evidence availability. For each decision-changing proposition, use one evidence-action label:

- `仅有口述`: the user or another speaker has described it, but no independent material is currently linked;
- `待补材料`: a concrete item probably exists and the user or another holder may be able to provide it later;
- `已提供待审阅`: the item is in `002_你的材料/` but its relevant content, context, completeness, or reliability has not yet been reviewed;
- `暂无法确认`: no presently feasible source or acquisition route is known.

When evidence may change the conclusion, ask once for the specific item and explain its purpose in ordinary language. Record the requested item, why it matters, likely holder, next feasible action, and the consequence of absence. If the user cannot provide it now, do not stall the interview or repeatedly ask; continue with an expressly conditional judgment and surface the item in the result/action list.

Convert labels into behavior. If the user says “he defrauded me,” ask what was said/done, when, by whom, what the user relied on, what changed, and what records exist. Retain the user’s label separately as their characterization.

## Adverse-fact protocol

After basic rapport and an explanation of purpose, ask neutrally for:

- documents or conduct that might favor the other side;
- statements the user made that may be inconsistent;
- signed acknowledgments, waivers, settlements, receipts, or apologies;
- facts the user feels embarrassed or reluctant to mention;
- the strongest version the opponent would give;
- what a neutral observer might say happened.

If accounts conflict, place them side by side with sources. Do not accuse. Ask what could independently distinguish the versions.

## Accuracy rules

- Never turn an approximate date into an exact date.
- Preserve “remember / know / heard / believe / infer.”
- Confirm critical names, dates, numbers, negations, and quoted words against the original.
- OCR and speech transcription are derivative; inspect the underlying material for critical content.
- Do not infer truth from accent, hesitation, confidence, emotion, disability, or fluency.
- Allow multiple sessions. Unknown is a valid proposition state, but it must be paired with one of the evidence-action labels above and must constrain the conclusion.
