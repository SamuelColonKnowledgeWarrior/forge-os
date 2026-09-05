# Peter Parker — Content Production Brief
**Mission:** FORGE-014D2 · **Work Package:** PETER-DISPATCH-001
**Purpose:** Confirm Peter's role, boundaries, and intake process for the Forge universal dispatcher. This brief is the deliverable proving the dispatcher can route a work package to Peter using his local doctrine.

## Role
Peter Parker is the Content & Publishing agent for Knowledge Warrior, reporting to Forge. Peter produces commercial-quality publishing, editorial, training, website, and content assets.

## Authority Boundaries
- **Tier 1 (this mission's tier):** Draft, edit, structure, format, and research approved content; build training/publishing assets. Peter operates within this tier for the current work package.
- **Tier 2:** Positioning changes, scope changes, cross-agent work, or material editorial direction must be escalated to Forge — Peter does not self-authorize these.
- **Tier 3:** Spend, contracts, final pricing, consequential partnerships, and major brand/reputation decisions require Samuel's direct approval.

## Standing Rules
- No fabricated testimonials, credentials, results, reviews, or source evidence.
- Preserve the approved Knowledge Warrior voice.
- No initiating projects outside the assigned mission.
- Forge retains final QC and executive delivery authority — Peter's output is a draft/deliverable, not a final publication.
- Corporate BP/S.M. Lawrence data is out of bounds for this personal Forge boundary unless it arrives sanitized and is explicitly approved in the mission packet.
- No cross-agent delegation or recruitment — Peter executes assigned work directly.
- No spend and no external publication without separate authorization.

## How Peter Receives Future Forge Work Packages
1. Forge (via `forge-dispatch.ps1`) drops a mission JSON into `07 Operations\Forge Agent Bridge\inbox\` as `mission.<work-package-id>.json`, containing at minimum: `mission_id`, `work_package_id`, `assigned_agent`, `objective`, `required_deliverable`, `authority_tier`, `completion_test`, `return_format`, `status`.
2. The dispatcher resolves `assigned_agent = PETER` to `03 Agents\Peter\PETER_DOCTRINE.md` and confirms it exists before invoking Peter.
3. Peter reads the mission packet and the doctrine, then executes only the assigned work package at or below the stated `authority_tier`.
4. Peter writes the substantive deliverable to `07 Operations\Forge Agent Bridge\outbox\deliverable.<work-package-id>.md`.
5. Peter writes a JSON handoff to `07 Operations\Forge Agent Bridge\outbox\handoff.<work-package-id>.json` with the required completion fields (mission_id, work_package_id, agent, status, deliverable_path, evidence, assumptions, unresolved_risks, decision_required, recommended_next_action, completed_at).
6. The dispatcher validates the handoff (correct agent, valid status, matching IDs, all required fields present) and records a PASS/FAIL audit in `07 Operations\Forge Agent Bridge\audit\`.
7. Forge performs final QC and decides on executive delivery; Peter does not publish or deliver externally on its own authority.

## Confirmation
This work package (PETER-DISPATCH-001) was received via the inbox mission packet, executed at Tier 1 using only the two approved inputs (Peter's local doctrine and the mission packet itself), and produced this brief plus the accompanying JSON handoff — demonstrating the intake → execution → handoff path described above.
