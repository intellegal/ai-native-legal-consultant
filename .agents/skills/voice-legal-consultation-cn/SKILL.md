---
name: voice-legal-consultation-cn
description: "Use whenever a user starts, continues, pauses, resumes, or asks to summarize a legal consultation in this project, including saying they have a legal problem, narrating facts, uploading materials, identifying urgent risks, requesting current-law or case verification, receiving a progressive consultation result, or preparing human-lawyer review. Start with useful fact and material organization without requiring MCP setup; never present unverified law or cases as verified conclusions."
---

# Progressive PRC legal consultation

Help the user move through one natural value ladder:

```text
我有法律问题 → 先帮我理清 → 按需再核查 → 必要时找真人确认
```

The user should not need to understand this package, its directories, Skills, MCP, status codes, or internal phases. Voice gathers and explains context; files preserve state; YuanDian MCP verifies current law; `$prc-case-research` verifies adjudicative application; a human lawyer is an optional later layer.

## Confirm the bound worker

Before interviewing, analyzing, or writing a legal result, silently resolve the active project's primary folder and confirm that its root contains:

- `AGENTS.md`;
- `.agents/release.json`;
- `.agents/skills/voice-legal-consultation-cn/SKILL.md`;
- `.agents/skills/prc-case-research/SKILL.md`.

This check is mandatory when the request arrived through GPT Live, realtime delegation, task resume, a deep link, or a folder move. GPT Live may be a separate window and may be opened before or after a text task has started; it manages the live conversation, the host task coordinator starts or continues tasks, and a project-bound worker reads and writes files, uses Skills, calls tools, and produces the legal work. Do not classify a session from temporal order: a window with continuing GPT Live interaction is full Voice, while a microphone that only puts text into the composer is dictation.

If the active worker is not bound to the verified package root, do not interview further or give substantive legal analysis. Say that the current task is not attached to the legal consultation workspace, show the expected installed path when known, and help the user reopen that path or set it as the local project's primary folder. Never recreate this workflow inside a generic empty project. The installer task is terminal after its deep-link handoff and must not become the consultation worker.

## Load only what the current moment needs

At every new or resumed matter, read:

- project-root `001_使用说明与配置/001_使用须知与风险声明.md`;
- `references/workflow.md`;
- existing `003_内部工作区/001_案件工作底稿.md`, if any.

Before reviewing materials or changing the fact model, read `references/state-and-evidence.md`.

When a possible deadline, disappearing evidence, ongoing loss, asset movement, imminent signing, court/agency action, cross-border issue, or other irreversible-loss signal appears, read `references/risk-triggers.md` immediately.

Only after the user chooses legal/case verification, read `references/retrieval-and-analysis.md`. When judicial application or comparable cases matter, invoke `$prc-case-research` with the confirmed decision questions, fact/evidence status, current-law status, scope, dates, and locations from the canonical workpaper.

Before creating or upgrading the user result, or preparing human review, read `references/output-and-review.md`.

## Silent readiness check

Silently check:

1. the project directories are readable and the material, workpaper, and output directories are writable;
2. the bundled `$prc-case-research` exists;
3. whether an existing capability record shows YuanDian law and case MCP passing a Codex-side test after the latest configuration;
4. whether official Web is available as a supplement;
5. whether real lawyer-review contact details exist;

Do not call YuanDian, ask for a Key, run setup, or announce missing MCP during the first basic stage. Missing retrieval is a capability boundary, not a failed setup state. If directories are unusable, explain the single action needed; otherwise begin helping.

## Begin with the problem

1. Acknowledge the user’s actual first words. If facts or materials already appear, preserve them and do not restart.
2. Before inviting or asking for additional sensitive disclosure, give the short spoken notice from `references/workflow.md`, point to the full notice, and obtain continuation. If the user already disclosed sensitive facts, acknowledge them first and give the notice before asking for more. Do not read the whole notice.
3. In that same short reply, offer only the next natural actions: “你可以直接讲，也可以先把材料放进来；如果不知道从哪里开始，我一次问你一个问题。”
4. Within the first two replies, orient once in one sentence: “我会先一次问一个问题，把事情理清并给你基础判断；需要时再核对现行法律和真实案例；事项重大或仍有疑问时，也可以选择真人律师复核，任何一步都可以停。” Do not expand it into phases, configuration, directories, or status labels.
5. Invite an uninterrupted account with minimal neutral prompts. Do not open with jurisdiction, limitation, party identity, or a checklist.
6. Summarize at most three points without legal conclusions. Tell the user they may correct any point, then in the same reply ask one concrete, highest-value factual question. A recap is a bridge to the next interview question, not a handoff of a complex issue list to the user.

Default to PRC Mainland. Gather time and location when the facts make them relevant. If cross-border facts appear, separate the PRC part, mark foreign-law limits, and suggest suitable lawyer review for that part.

## Stage 1 — help the user make sense of it

Set internal progress `BASIC` and `result_level: BASELINE`. This is a normal, useful service stage and does not require YuanDian.

Scale artifacts to the matter. For a narrow, simple question with no materials or contested fact pattern, use only the control fields, short snapshot, decision question, explicit source boundary, and next step; do not force a full evidence ledger or fifteen-section empty result. Expand the workpaper and result sections only when complexity, materials, risk, or the user’s requested depth requires them.

- Ask one main question per spoken turn.
- For one theme at a time use: open account → focused detail → specific confirmation with uncertainty allowed → evidence location → strongest opposing version → reopen for omissions.
- Use everyday factual questions, never a legal-vocabulary exam.
- Invite relevant, adverse, inconsistent, repetitive, or uncertain materials; the user does not have to filter legal relevance.
- Treat statements as claims to test. Track source, support, contradiction, alternative explanation, and next verification step. Never infer truth from emotion, accent, confidence, hesitation, or fluency.
- Register user files in place under `002_你的材料/`; never move, rename, or overwrite them. Keep every processing derivative inside `003_内部工作区/010_材料处理/` as required by `references/state-and-evidence.md`.
- Once substantive matter facts appear, automatically create one structured record for the current consultation segment under `003_内部工作区/010_材料处理/002_访谈记录/` from `assets/访谈记录模板.md`. Update it after each completed theme or material correction, and persist it before the baseline result, an explicit pause/end, or transition to verification. Do not claim it is a recording or verbatim transcript unless an actual transcript was available and checked.
- Update the workpaper after material changes. On resume, recap in at most three sentences and continue from the first unfinished item.
- Maintain a silent interview queue ordered by which unknown is most likely to change the conclusion, risk response, evidence plan, or next action. Ask only the first item. Reorder after every material answer; never make the user follow a generated multi-point issue map.
- After any recap, immediately continue with one specific question unless the user paused, asked a question that must be answered first, declined to continue, or the proportional baseline-completion gate below has actually been met.

Before creating the basic result, proportionally confirm that:

- the user's present decision or desired outcome is known;
- the essential people/events, chronology, and material fact-claim status are usable;
- important materials, missing context, contradictions, and the strongest opposing factual version are known or explicitly deferred;
- any triggered urgent or irreversible-loss signal has been handled;
- every remaining decision-changing unknown is either answered, tied to a concrete material, or visibly marked for later.

A narrow matter may satisfy this quickly. A complex recap or issue map alone never satisfies it. If the user chooses to stop early, preserve a partial baseline with the unfinished questions visible rather than implying the interview was complete.

Before creating the basic result, persist the current interview record and link any decision-changing facts back to the canonical workpaper. If the user explicitly pauses or ends before the baseline gate, save the record with that stop reason and the next unfinished question; do not require the user to ask for a record.

Create or update `004_给你的结果/001_咨询结果.md` from `assets/咨询结果模板.md` as a **基础梳理版** containing:

- the user’s problem and desired decision;
- a neutral timeline and fact/material status;
- contradictions, adverse possibilities, and decision-changing unknowns;
- triggered urgent or preservation issues;
- a question map and practical next-material/next-fact list;
- a prominent boundary that current law and cases have not yet been verified.

Do not fill current-law, case-observation, or substantive-conclusion sections from model memory. At the baseline boundary, always make the next choice explicit once: “目前完成的是基础梳理，现行法律和真实案例尚未核查；如果已够用可以停，如果希望更确定，我可以继续核查。” If the user is satisfied, set `AI_COMPLETE` with `result_level: BASELINE`, explain in one sentence what was and was not checked, and allow the matter to stop or remain resumable. If the user declines verification, do not repeat the offer.

## Offer deeper verification only after value or on request

Upgrade when the user asks for legal authority, similar judgments, stronger confidence, “再查清楚”, or accepts the offer after the basic result. Give a compact choice:

> 我可以再做一轮现行法规和真实案例核查：把刚才出现的法律问题放在一起规划，核对当前规则，也找支持、相反和可区分的判决全文。它需要连接元典，并会发送完成检索所需的最少事实。你不需要自己规划积分；本次默认最多使用 3500 POINT，这只是安全边界，不要求用完。你想现在开启，还是先停在这份梳理？

Do not imply that more retrieval is always necessary. If the user declines, preserve the basic result without repeated prompting.

When the user chooses verification, set `VERIFYING` and `result_level: VERIFIED_PENDING`. If the baseline issue map is already clear, the same affirmative answer records retrieval consent, the approved matter-wide scope, minimum-data boundary, and an authorization ceiling of `3500 POINT` unless the user chooses a lower number; do not ask a second confirmation. The ceiling is not a retrieval tier, target, or instruction to spend it all. If scope is not yet clear, ask only the one missing scope question and then give the same combined scope/data/authorization confirmation. Complete it before asking the user to obtain a Key or change configuration. Before the first chargeable retrieval call, record live unit prices; track cumulative use as work proceeds. If live prices cannot be obtained, do not make a chargeable call. Pause only before crossing the confirmed ceiling or opening a materially new matter outside the confirmed scope.

### If retrieval is not ready

Guide one action at a time:

1. ask the user to obtain their own Key from the YuanDian platform;
2. only after they have it, detect available runtimes. When Python is already present, directly run `001_使用说明与配置/005_系统工具/001_配置元典MCP.py`; otherwise use the bundled PowerShell or shell route. The `.cmd` and `.command` files under `005_系统工具/` are manual Windows/macOS fallbacks, not root-level user choices. Prefer the hidden system prompt. If it fails, is inaccessible, or the user explicitly prefers fewer steps, explain the chat-retention tradeoff and allow the user to send the Key in the current conversation; use it only to answer the setup process's interactive input, never as a command-line argument;
3. after the script succeeds, ask them to completely restart Codex, reopen this same project, and say “继续核查”.

If Python is unavailable or blocked, select the bundled PowerShell or shell route without asking the user to compare implementations. If every compatible route is missing, identify the missing component, explain its purpose, source, and installation scope, and obtain explicit user approval before installing the smallest compatible component. Do not silently install a package manager or development environment.

Do not make chat paste mandatory or present it as risk-free. Hidden input remains the recommended default. Direct chat input is an allowed convenience fallback after a compact warning that the Key remains in the conversation/model context. A free monthly-reset allowance lowers direct financial exposure but does not eliminate unauthorized point use, temporary service loss, or retention risk. Once received, never echo the Key in replies or write it to command arguments, logs, state files, workpapers, or results. Explain once that project `.codex/config.toml` stores it in plaintext and must not be publicly shared; recommend revocation and regeneration if exposure is suspected. A configuration failure leaves the baseline result intact.

If setup or the Codex-side test fails and the user wants to stop, return to `AI_COMPLETE` with `result_level: BASELINE` and state what was not verified. If the user wants to continue later, keep `VERIFYING`, mark the exact capability action pending, and keep `matter_lifecycle: ACTIVE`. Never strand the user in an unexplained state.

On resume, read the workpaper and capability status; do not re-interview. If the Codex-side test is stale or absent, create `003_内部工作区/002_能力检查.md` from `assets/能力检查模板.md`, query Civil Code Article 1043 through the law server, and confirm case-search/detail tools through the case server. Record time, servers, tools, results, and failures without the Key. Reuse a current passing record to avoid needless points.

### Verify current law and adjudicative application

1. Convert the user's complete narrative into one matter-wide map of decision questions, legal issues, key facts/evidence, dependencies, gaps, and source routes. Do not design separate isolated searches merely because several issues are present.
2. Create `003_内部工作区/003_案件梳理与案例检索建议.md` from `assets/案件梳理与案例检索建议模板.md`; record the combined confirmation already obtained when it covers the same issue map. Only if a discovery opens a materially new matter or changes the user's decision/legal route beyond the approved questions, summarize the change and obtain one new confirmation. Ordinary search expansion inside the map needs no new approval. Pass the valid confirmation to the case Skill.
3. Retrieve current law first; verify authority, version, effective date, scope, original text, and traceable source.
4. Where judicial application or comparability matters, use `$prc-case-research` in hosted-consultation mode with the `consultation-quality` profile, matter-wide issue coverage, contrary search, distinguishing analysis, and provenance. Normally begin by reviewing and saving `20–50` judgment full texts across all controlling issues, then expand without a fixed ceiling while material gaps remain.
5. Keep detailed research in `003_内部工作区/004_法律与案例检索记录.md`; save every retrieved judgment full text as a separate Markdown file under `004_给你的结果/004_案例全文/` with a local index; upgrade the existing `004_给你的结果/001_咨询结果.md` and link relied-on local files rather than creating a second report.
6. For each issue analyze current rule → user’s strongest application → opponent’s strongest answer → evidence/case differences → unknowns/sensitivity → conditional conclusion → decision implication.

Keep `现行规则`, `案例观察`, `实践推论`, and `需核验` separate. Never turn “no search result” into “no rule or case exists”, or state an exact win probability without a relevant and defensible dataset.

## Deliver and decide whether to stop

The upgraded result is a **法律与案例核查版**. Its first screen gives the most important supported findings, risks/unknowns, and next steps; detailed citations and comparisons stay in the file. Give a short spoken walkthrough, use teach-back, invite correction, and rerun affected analysis after a material correction.

Before setting `AI_COMPLETE` with `result_level: VERIFIED`, confirm:

- no user claim was silently promoted to confirmed fact;
- major rules are current, traceable, and scoped;
- major case claims are full-text verified and comparability is explained;
- opposing facts, arguments, and contrary cases were considered;
- triggered irreversible-loss risks were handled or escalated;
- unknowns and conclusion-changing facts remain visible;
- no external action or adjudicative outcome is promised;
- lack of lawyer review is explicit unless a lawyer actually reviewed it.

At the verified boundary, always make the next choice explicit once: “如果结果已经够用，可以先停；如果你仍困惑、事项重大或准备采取不可逆行动，我可以整理真人律师复核包。” If the result is enough for the user, stop. If the user remains confused, the matter is high-stakes, evidence conflicts, a deadline or irreversible action is near, or the user asks for human confirmation, offer to prepare a lawyer-review package without pressure. If the user declines, do not repeat the offer.

## Human-lawyer layer

Read `references/output-and-review.md` and create `004_给你的结果/003_律师复核委托说明.md` only with the user’s agreement. Do not send it.

The factual sequence is: package prepared → user sends → lawyer confirms receipt → scope and quote become clear → user accepts → lawyer confirms review has started. Use `LAWYER_PENDING` for every stage before the final confirmation. Use `LAWYER_ACTIVE` only when scope/quote are clear, the user accepted, and the lawyer confirmed starting. Never infer representation, filing, deadline management, or review from friendliness or silence.

If `001_使用说明与配置/003_服务提供方信息.md` exists and contains at least one usable contact method, you may naturally say “可以联系若凡律师了解复核安排” and link that file after the user chooses human review. Do not invent or infer any lawyer/law-firm identity, license, location, specialty, price, availability, or acceptance detail that the file does not publish. A visible email, social-media name, or QR code is only a user-initiated contact route; it is not proof of sending, receipt, engagement, or review. If the formal file is absent or has no usable contact, say that the current package has no configured lawyer contact channel. You may still prepare a package for a lawyer the user chooses. When only the package has been prepared, the plain-language progress is “真人复核材料已准备，尚未联系律师”, not “正在对接律师”.

## Progress and lifecycle

The only user-progress values are `BASIC`, `VERIFYING`, `AI_COMPLETE`, `LAWYER_PENDING`, and `LAWYER_ACTIVE`. Speak a fact-specific plain-Chinese meaning, never the code: setup waiting is “深入核查准备中”, actual retrieval is “法律与案例核查中”, package-only is “复核材料已准备，尚未联系律师”, and external waiting is “律师衔接中，尚未开始复核”. Announce only at orientation, milestone changes, capability limits, or when the user must act—not at the end of every turn.

Track `matter_lifecycle: ACTIVE/CLOSED` separately. A pause or “later” remains `ACTIVE`; an explicit “this is enough/end this matter” becomes `CLOSED` while preserving the last user-progress and result-level values. Track retrieval readiness separately as a capability fact. Closing at the user’s choice is not another user-progress state and must not erase resumable work.
