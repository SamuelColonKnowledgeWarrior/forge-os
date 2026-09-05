# DECISION_REGISTER

> The authoritative register of decisions locked under Forge Command. Governed by [[DECISION_FRAMEWORK.md]]. Built as Build 008 per [[BUILD_LEDGER.md]] and [[EXECUTION_QUEUE.md]].

---

## Register Rules

- A decision is entered here only when it is supported by existing vault evidence — an explicit statement in a Command file, Doctrine file, or the Build Ledger. Nothing below was inferred without a citable source.
- **Date locked**, **rationale**, and **authority** are recorded only where the vault states them explicitly. Where not stated, the field reads `Not recorded` rather than an invented value.
- Per [[DECISION_FRAMEWORK.md]], decisions fall into two authority classes: those Forge may make independently (reversible, low-risk — task sequencing, documentation structure, workflow improvements) and those that must escalate to Sam (change mission/strategy, spend money, create legal/ethical/reputational risk, are difficult to reverse, or conflict with locked doctrine). The Authority field below states who is recorded as having made each decision, not a judgment about which class it should have been.
- Status values used: **Locked** (in force, unmodified since recorded), **Superseded** (replaced by a later decision — see Supersession History), **Not recorded** (status itself not stated in source).
- [[EXECUTION_QUEUE.md]] and [[CURRENT_STATE.md]] remain authoritative for current execution and operating state respectively, per [[KNOWLEDGE_HIERARCHY.md]]; this register does not duplicate their live content, only the decisions themselves.

---

## Decisions

### DEC-001

| Field | Value |
|---|---|
| Decision | Obsidian Forge vault is the source of truth. |
| Date Locked | Not recorded |
| Authority | Not recorded |
| Rationale | Not recorded |
| Status | Locked |
| Affected Systems/Files | Entire vault; stated directly in [[FORGE_BOOT.md]] Section 6 ("Source of Truth") and echoed in [[README.md]] and [[OPERATING_PRINCIPLES.md]] Principle 5 ("One Source of Truth"). |
| Supersession History | None recorded. |
| Source | [[CURRENT_STATE.md]] Locked Decisions; [[FORGE_BOOT.md]] Section 6. |

### DEC-002

| Field | Value |
|---|---|
| Decision | Folder structure is frozen unless Sam explicitly approves a change. |
| Date Locked | Not recorded |
| Authority | Not recorded |
| Rationale | Not recorded |
| Status | Locked |
| Affected Systems/Files | Entire vault folder structure. Stated verbatim in [[FORGE_BOOT.md]] Section 6. |
| Supersession History | None recorded. |
| Source | [[CURRENT_STATE.md]] Locked Decisions; [[FORGE_BOOT.md]] Section 6. |

### DEC-003

| Field | Value |
|---|---|
| Decision | Every build ends with a tangible artifact. |
| Date Locked | Not recorded |
| Authority | Not recorded |
| Rationale | Not recorded |
| Status | Locked |
| Affected Systems/Files | All Command builds. Matches [[EXECUTION_STANDARD.md]] Core Principle 1 ("Artifact First") and [[OPERATING_PRINCIPLES.md]] Principle 4 ("Artifact Before Explanation"); also stated in [[FORGE_BOOT.md]] Sections 4 and 8. |
| Supersession History | None recorded. |
| Source | [[CURRENT_STATE.md]] Locked Decisions; [[EXECUTION_STANDARD.md]]; [[OPERATING_PRINCIPLES.md]]. |

### DEC-004

| Field | Value |
|---|---|
| Decision | Audit before Build. |
| Date Locked | Not recorded |
| Authority | Not recorded |
| Rationale | Not recorded |
| Status | Locked |
| Affected Systems/Files | All Command builds. Matches [[EXECUTION_STANDARD.md]] Core Principle 3 ("Audit Before Build") and [[OPERATING_PRINCIPLES.md]] Principle 2 ("Audit Before Build"); also [[FORGE_BOOT.md]] Section 4. |
| Supersession History | None recorded. |
| Source | [[CURRENT_STATE.md]] Locked Decisions; [[EXECUTION_STANDARD.md]]; [[OPERATING_PRINCIPLES.md]]. |

### DEC-005

| Field | Value |
|---|---|
| Decision | One deployment step at a time. |
| Date Locked | Not recorded |
| Authority | Not recorded |
| Rationale | Not recorded |
| Status | Locked |
| Affected Systems/Files | Human-AI deployment cadence, all builds requiring Sam's deployment action. Matches [[FORGE_BOOT.md]] Section 9 ("Human-AI Deployment Cadence... No skipping ahead."). |
| Supersession History | None recorded. |
| Source | [[CURRENT_STATE.md]] Locked Decisions; [[FORGE_BOOT.md]] Section 9. |

### DEC-006

| Field | Value |
|---|---|
| Decision | No duplicate architecture. |
| Date Locked | Not recorded |
| Authority | Not recorded |
| Rationale | Not recorded |
| Status | Locked |
| Affected Systems/Files | Vault-wide — folders, dashboards, templates, systems, missions. Matches [[FORGE_BOOT.md]] Section 5 (Anti-Drift Rules: "create duplicate folders, dashboards, templates, or systems"), [[MISSION_LIFECYCLE.md]] ("No duplicate active missions"), and [[AGENT_INTERACTION_PROTOCOL.md]] ("No duplicate work"). |
| Supersession History | None recorded. |
| Source | [[CURRENT_STATE.md]] Locked Decisions; [[FORGE_BOOT.md]] Section 5; [[MISSION_LIFECYCLE.md]]; [[AGENT_INTERACTION_PROTOCOL.md]]. |

### DEC-007

| Field | Value |
|---|---|
| Decision | Build 006 is locked as `VAULT_INDEX.md` (resolving a prior conflict between `BUILD_LEDGER.md`/`FORGE_BOOT.md`'s Command Build Sequence, which pointed to `VAULT_INDEX.md`, and `EXECUTION_QUEUE.md`, which had pointed to a "Forge Agent Profile" build). |
| Date Locked | 2026-08-11 |
| Authority | Sam/Forge (per the build session in which this was decided; the detailed resolution note has since been superseded in [[BUILD_LEDGER.md]]'s text by Build 006's completed entry, per Ledger Rules — the underlying decision is preserved here since it is not itself a historical ledger entry). |
| Rationale | `EXECUTION_QUEUE.md`'s omission of Mission/Decision Register work was not treated as authoritative for this determination; `FORGE_BOOT.md`'s Command Build Sequence governed instead. |
| Status | Locked (implemented — Build 006 was completed and deployed). |
| Affected Systems/Files | [[BUILD_LEDGER.md]], [[EXECUTION_QUEUE.md]], [[CURRENT_STATE.md]], [[VAULT_INDEX.md]]. |
| Supersession History | None — this decision resolved a previously unresolved question; it did not replace an existing locked decision. |
| Source | [[BUILD_LEDGER.md]] Build 006 entry (evidence of the artifact built); [[VAULT_INDEX.md]]'s own "Known discrepancy" note, which documents the same underlying conflict from a different angle. |

### DEC-008

| Field | Value |
|---|---|
| Decision | Build 007 is locked as `ACTIVE_MISSION_REGISTER.md` in `02 Missions/`, per `FORGE_BOOT.md`'s Command Build Sequence (item 5), rather than following `EXECUTION_QUEUE.md`'s Waiting on Forge list, which had omitted Mission Register and Decision Register entirely. |
| Date Locked | 2026-08-11 |
| Authority | Forge (stated explicitly in [[BUILD_LEDGER.md]]'s Build 007 entry: "Locked by Forge on 2026-08-11"). |
| Rationale | "FORGE_BOOT's established Command Build Sequence governs the intended construction order. EXECUTION_QUEUE omitted Mission Register and Decision Register and must be brought into alignment rather than used to bypass required Command infrastructure." |
| Status | Locked (implemented — Build 007 was completed and deployed). |
| Affected Systems/Files | [[BUILD_LEDGER.md]], [[EXECUTION_QUEUE.md]], [[CURRENT_STATE.md]], 02 Missions/ACTIVE_MISSION_REGISTER.md. |
| Supersession History | None — resolves the same open conflict class as DEC-007, for the next build in sequence. |
| Source | [[BUILD_LEDGER.md]] Build 007 entry, "Decision carried forward from prior Next Locked Build entry." |

---

## Not Yet Locked (for clarity — not entered as decisions above)

- The build that follows Build 008 (Decision Register) is **not yet locked**. Per [[FORGE_BOOT.md]]'s Command Build Sequence item 8, "Executive Dashboard activation" is the next undone item, but no decision has been recorded locking it as a build. See [[EXECUTION_QUEUE.md]]'s Next Locked Build field.
- "Audit Doctrine" and "Audit Missions" are open work items in [[EXECUTION_QUEUE.md]]'s Waiting on Forge list, not decisions — no decision has been locked about their scope, method, or timing.

---

## Findings / Gaps Discovered While Building This Register

- **Authority gap, DEC-001 through DEC-006:** none of the six original Locked Decisions in [[CURRENT_STATE.md]] states who locked them (Sam, Forge, or jointly) or when. Per this register's rule against inventing unrecorded fields, these are marked `Not recorded` rather than attributed by inference. This is a genuine gap in the vault's record, not a conflict between sources.
- **No conflict found** between [[DECISION_FRAMEWORK.md]] and how DEC-007/DEC-008 were actually decided — both were treated as changes with real construction-order consequences and were escalated through a Sam/Forge exchange rather than made unilaterally by Forge alone, consistent with [[DECISION_FRAMEWORK.md]]'s "conflicts with locked doctrine" and "difficult to reverse" escalation criteria.
- **Historical note preservation:** [[BUILD_LEDGER.md]]'s "Next Locked Build" section is, by design, a forward-looking pointer that gets overwritten each time a build closes out — it is not covered by the ledger's own append-only rule, which applies to completed build entries. That means the detailed rationale text for DEC-007 (Build 006's lock) was overwritten when Build 006 closed out and Build 007's stub replaced it. DEC-007 above reconstructs that decision from what remains citable ([[BUILD_LEDGER.md]]'s Build 006 entry and [[VAULT_INDEX.md]]'s discrepancy note) rather than from the original stub text, which no longer exists in the vault.

---

## Notes

- Built 2026-08-11 as Build 008, using only evidence in [[DECISION_FRAMEWORK.md]], [[CURRENT_STATE.md]]'s Locked Decisions, [[BUILD_LEDGER.md]], and [[EXECUTION_QUEUE.md]] at build time.
- No existing file was modified to produce this register.

## FORGE-20260905-092129 — Decision Required — 2026-09-05 09:34:17
- Agent: GRIND
- Work Package: GRIND-DISPATCH-FORGE-20260905-092129
- Status: OPEN
- Recommended Action: Supply the actual book brief/manuscript summary, prior sales/list data, author platform status, and current training/speaking/consulting offer details (or confirm none exist yet) so the positioning angle and funnel can be validated or corrected before asset production begins
- Source Handoff: C:\Users\Family\OneDrive\Forge\Forge\07 Operations\Forge Agent Bridge\outbox\handoff.grind-dispatch-forge-20260905-092129.json
- Authority: Forge/Sam per existing decision doctrine


## FORGE-20260905-093616 — Decision Required — 2026-09-05 09:37:03
- Agent: GRIND
- Work Package: GRIND-DISPATCH-FORGE-20260905-093616
- Status: OPEN
- Recommended Action: Forge to confirm/adjust the positioning line, then authorize GRIND to draft the media pitch, positioning-line options, and target outlet list (Tier 1 work) for this recommendation
- Source Handoff: C:\Users\Family\OneDrive\Forge\Forge\07 Operations\Forge Agent Bridge\outbox\handoff.grind-dispatch-forge-20260905-093616.json
- Authority: Forge/Sam per existing decision doctrine


## FORGE-20260905-091533 — Decision Required — 2026-09-05 09:51:15
- Agent: SCOUT
- Work Package: SCOUT-DISPATCH-FORGE-20260905-091533
- Status: OPEN
- Recommended Action: Forge/Samuel to: (1) authorize live web access for Scout to re-verify current pricing and feature sets on the shortlisted platforms (Thinkific, Podia, LearnWorlds, Kajabi) before any commitment; (2) supply budget ceiling, expected catalog size, and whether certificates/compliance tracking are required so the recommendation can be sharpened; (3) make the final platform selection and any spend/contract decision, which is outside Scout's Tier 1 authority.
- Source Handoff: C:\Users\Family\OneDrive\Forge\Forge\07 Operations\Forge Agent Bridge\outbox\handoff.scout-dispatch-forge-20260905-091533.json
- Authority: Forge/Sam per existing decision doctrine


## FORGE-QUEUE-TEST-001 — Decision Required — 2026-09-05 10:04:29
- Agent: PETER
- Work Package: PETER-DISPATCH-FORGE-QUEUE-TEST-001
- Status: OPEN
- Recommended Action: Forge to confirm whether this general recommendation satisfies BUILD 015A queue validation, or to supply sanitized book/platform source material for a follow-up tailored recommendation
- Source Handoff: C:\Users\Family\OneDrive\Forge\Forge\07 Operations\Forge Agent Bridge\outbox\handoff.peter-dispatch-forge-queue-test-001.json
- Authority: Forge/Sam per existing decision doctrine

