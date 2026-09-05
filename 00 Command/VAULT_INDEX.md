# VAULT_INDEX

> The authoritative map of the Forge vault. Any agent — Forge, Claude, ChatGPT, Codex, or a future agent — should read this file as part of startup so it can resume work without rediscovering the vault from scratch.

---

## AI Resume Protocol

Before doing any work in this vault, any agent must:

1. Read **00 Command** first. Do not read Doctrine, Agents, or any other folder before Command.
2. Follow the Startup / Read Order below.
3. Confirm the current mission, last completed build, and next locked build before taking any action.
4. If the agent cannot answer "what is the current mission / last completed build / next locked build / what decisions are locked" after reading Command, it must stop and re-read Command rather than proceed on assumption.
5. Do not create, rename, or restructure files outside of an explicitly assigned build.

This protocol is sourced from [[FORGE_BOOT.md]] Section 14 ("Boot Confirmation") and Section 7 ("Mandatory Startup Sequence").

---

## Startup / Read Order

Per [[FORGE_BOOT.md]] Section 7, the mandatory startup sequence is:

1. Read [[FORGE_BOOT.md]]
2. Read [[CURRENT_STATE.md]]
3. Read the latest entries in [[BUILD_LEDGER.md]]
4. Read `VAULT_INDEX.md` (this file)
5. Open the active mission
6. Confirm the next incomplete build
7. Execute that build
8. Update [[CURRENT_STATE.md]]
9. Append the result to [[BUILD_LEDGER.md]]

**Known discrepancy:** the Command file [[00 Command/FORGE.md|FORGE.md (Command)]] states its own, shorter startup sequence (Read FORGE → Read VAULT_INDEX → Read CURRENT_STATE → Open active mission → Execute), which orders VAULT_INDEX before CURRENT_STATE rather than after BUILD_LEDGER. Per [[KNOWLEDGE_HIERARCHY.md]], FORGE_BOOT.md ranks above other command files in authority, so the 9-step sequence above is treated as authoritative here. This discrepancy is flagged, not resolved — reconciling it would mean editing Doctrine or Command files beyond this build's scope.

---

## Vault Map — Top-Level Folders

| Folder | Actual Current Purpose | Status |
|---|---|---|
| `00 Command` | Operating core: identity, boot doctrine, live state, execution queue, build history, system audit checklist, and this index. | Populated (7 files after this build) |
| `01 Doctrine` | Standing rules governing how Forge and its agents operate — execution, decisions, communication, mission lifecycle, knowledge authority, risk, agent interaction, operating principles, and the Project Panama strategic mission. | Populated (9 files) |
| `02 Missions` | Intended to hold individual mission records (per [[MISSION_LIFECYCLE.md]] and the "Active Mission Register" referenced in [[FORGE_BOOT.md]]). | Empty — no mission files exist yet |
| `03 Agents` | Roster and individual profiles for every Forge agent — role, authority, responsibilities, success metrics, standard output format. | Populated (1 registry + 6 agent profiles) |
| `04 Knowledge` | Intended reference knowledge base (per [[KNOWLEDGE_HIERARCHY.md]] rank 8, "Obsidian Knowledge Base"). | Empty |
| `05 Resources` | Intended supporting reference material / assets. No doctrine currently defines its scope beyond the name. | Empty |
| `06 Projects` | Scoped infrastructure/build projects that sit outside the core Command build sequence. | Populated (1 file: the Phase 2 MCP infrastructure project) |
| `07 Operations` | Operational templates and SOP-adjacent material (see [[BP.md]] for the agent responsible for SOPs). | Populated — contains a `Templates` subfolder with one file |
| `08 Daily Notes` | Intended for day-to-day working notes (standard Obsidian daily-notes convention). | Empty |
| `09 Decisions` | Intended to hold the "Decision Register" referenced in [[CURRENT_STATE.md]] and governed by [[DECISION_FRAMEWORK.md]]. | Empty — no decision files exist yet |
| `10 Dashboard` | Executive dashboard view. | Populated (1 file: `Forge HQ`) |
| `99 Archive` | Intended destination for completed/cancelled missions and retired material, per [[MISSION_LIFECYCLE.md]]'s "Archived" state. | Empty |

Not part of the numbered vault structure but present at the vault root: `README.md` (vault overview), `.obsidian/` (Obsidian app config and installed plugins), `.git/` (version control).

---

## Command Layer — Critical Files and Roles

| File | Role |
|---|---|
| [[FORGE_BOOT.md]] | Mandatory startup doctrine for any agent operating in this vault: identity, mission, command doctrine, anti-drift rules, startup sequence, command structure, boot confirmation checklist. |
| [[CURRENT_STATE.md]] | Live operational state: current mission, current/last/next build, active-mission summary, waiting-on lists, locked decisions, current risks, session resume point. Updated at the end of every completed build session. |
| [[EXECUTION_QUEUE.md]] | The single source of active work. Forge executes only from this file; anything not listed here is not active work. |
| [[BUILD_LEDGER.md]] | Append-only historical record of every completed, deployed build. Never rewritten. |
| `VAULT_INDEX.md` | This file — the structural map of the vault. |
| [[00 Command/FORGE.md|FORGE.md (Command)]] | Short-form identity/mission/priorities snapshot with its own (non-authoritative — see discrepancy above) startup sequence. |
| [[SYSTEM_AUDIT.md]] | Audit checklist and objectives for validating vault integrity before expansion; not itself a live audit log. |

---

## Doctrine (01 Doctrine)

Nine files, each with a single defined responsibility. Not modified by this build — listed here for navigation only:

- [[AGENT_INTERACTION_PROTOCOL.md]] — command hierarchy, delegation, and reporting standards between agents.
- [[COMMUNICATION_STANDARD.md]] — response format, writing standard, escalation triggers.
- [[DECISION_FRAMEWORK.md]] — which decisions Forge makes independently vs. escalates to Sam.
- [[EXECUTION_STANDARD.md]] — minimum quality bar and definition of done for every build.
- [[KNOWLEDGE_HIERARCHY.md]] — order of authority across all information sources in the vault.
- [[MISSION_LIFECYCLE.md]] — mission states from Proposed through Archived.
- [[OPERATING_PRINCIPLES.md]] — the twelve non-negotiable operating principles.
- [[PROJECT_PANAMA.md]] — the long-term strategic mission every build must ladder up to.
- [[RISK_MANAGEMENT.md]] — risk categories, levels, and stop-work conditions.

---

## Agents (03 Agents)

- [[AGENT_REGISTRY.MD]] — master roster and command structure (Sam Colon → Forge → all other agents).
- [[03 Agents/FORGE.md|FORGE.md (Agent)]] — Chief of Staff profile (Active).
- [[WARBUCKS.md]] — Revenue Generation (Planned).
- [[BP.md]] — Business Operations (Planned).
- [[EXESEC.md]] — Executive Secretary (Planned).
- [[PETER PARKER.md]] — Research and Intelligence (Planned).
- [[GRIND.md]] — Execution and Accountability (status not listed in the registry itself, though the profile exists and is fully built).

**Naming note:** both `00 Command/FORGE.md.md` and `03 Agents/FORGE.md.md` resolve to the same Obsidian note title, `FORGE.md`. A bare `[[FORGE.md]]` wikilink is ambiguous between the two; this index disambiguates them by folder as shown above.

---

## Where to Look

**Missions** — `02 Missions/` is currently empty. Mission structure and states are defined in [[MISSION_LIFECYCLE.md]]; the "Active Mission Register" referenced in [[FORGE_BOOT.md]] has not been built as a file yet. Until then, the single active mission ("Forge Command v1") is tracked directly in [[CURRENT_STATE.md]].

**Decisions** — `09 Decisions/` is currently empty. Decision-making authority is governed by [[DECISION_FRAMEWORK.md]]; the "Decision Register" referenced in [[CURRENT_STATE.md]]'s Waiting on Forge list has not been built as a file yet. The small set of decisions already locked are recorded directly in [[CURRENT_STATE.md]]'s Locked Decisions section.

**Agents** — `03 Agents/` — see the Agents section above. [[AGENT_REGISTRY.MD]] is the roster; individual files are the profiles.

**Knowledge** — `04 Knowledge/` is currently empty. Its intended role (per [[KNOWLEDGE_HIERARCHY.md]] rank 8) is reference knowledge and supporting documentation, ranked below command files and doctrine but above raw conversation context.

**Resources** — `05 Resources/` is currently empty. No doctrine yet defines its scope beyond the folder name.

**Projects** — `06 Projects/` contains [[FORGE_INFRASTRUCTURE_PHASE_2.md]], a scoped infrastructure project (connecting Forge to the vault via MCP) tracked separately from the core Command build sequence.

**Operations** — `07 Operations/` contains a `Templates` subfolder with [[Mission Template]], a template file for creating new mission notes.

**Daily Notes** — `08 Daily Notes/` is currently empty.

**Dashboard** — `10 Dashboard/` contains [[Forge HQ]], the executive dashboard view referenced in [[FORGE_BOOT.md]]'s build sequence ("Executive Dashboard activation").

**Archive** — `99 Archive/` is currently empty. Per [[MISSION_LIFECYCLE.md]], completed or cancelled missions move here after logging in [[BUILD_LEDGER.md]].

---

## Notes

- This index reflects the vault as audited on 2026-08-11. It maps structure only — for live mission/build/risk state, always defer to [[CURRENT_STATE.md]], [[EXECUTION_QUEUE.md]], and [[BUILD_LEDGER.md]] rather than this file, per [[KNOWLEDGE_HIERARCHY.md]]'s one-source-of-truth rule.
- File extensions are left as-is throughout this index (most notes in this vault carry a doubled `.md.md` extension). This index does not rename or correct that; wikilinks above match the vault's actual current filenames.
- No files were invented for this map — every file and folder referenced above was confirmed to exist by direct inspection at build time.
