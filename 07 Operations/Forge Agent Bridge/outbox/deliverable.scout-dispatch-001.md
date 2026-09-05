# Scout Deliverable — Bridge Dispatch Test (FORGE-014D1 / SCOUT-DISPATCH-001)

## Objective
Prove that a Forge-owned mission can be dispatched to Claude without Samuel copying or retyping the mission.

## What Scout Did
1. Read the mission packet directly from `07 Operations/Forge Agent Bridge/inbox/mission.scout-dispatch-001.json` — not pasted by Samuel, sourced live from the vault.
2. Read Scout's persistent operating doctrine from `03 Agents/Scout/SCOUT_DOCTRINE.md` — the only file present under `03 Agents/Scout`; no separate skill files exist there yet.
3. Reviewed the bridge's prior attempt history in `07 Operations/Forge Agent Bridge/audit/` to establish what had and had not already been proven:
   - `audit.scout-dispatch-001.json` — an earlier automated run recorded `validation: FAIL`, with errors `"Handoff file missing"` and `"Deliverable file missing"`.
   - `claude-raw.scout-dispatch-001.json` — the raw CLI transcript of a *later* attempt (session `d87347e6-...`) shows Scout reached the vault, read the mission and doctrine successfully, but every file-write attempt (Write tool, PowerShell `Set-Content`, Bash heredoc/redirect) was denied by the session's permission mode. That run correctly self-reported `BLOCKED` rather than fabricating a completed handoff.
4. Confirmed the required handoff shape against `07 Operations/Forge Agent Bridge/handoff.schema.json`.
5. Wrote this deliverable and the accompanying handoff JSON to the outbox paths specified in the mission packet.

## Analysis of the Bridge Test

The bridge test has now surfaced two distinct layers, and this run closes both:

**Read layer (proven across the last two runs):** Claude, invoked with working-directory scope over the vault, can load a mission packet and an agent's doctrine straight from Forge-owned files with no manual retyping or copy/paste by Samuel. This has held consistently once the invoking process is scoped to the vault root rather than an unrelated sandbox directory (the very first attempt failed here — it was sandboxed to a `Downloads\BUILD_...` folder with no vault access at all).

**Write layer (previously blocked, working in this run):** The immediately prior attempt reached the vault, did everything right on the read side, and then stalled: every write tool it tried was denied, with no interactive prompt it could resolve on its own, and no `settings.json` / `settings.local.json` pre-authorizing writes to this outbox path. It correctly reported `BLOCKED` instead of claiming completion — the right behavior under Scout's doctrine and the mission's explicit constraint not to claim success without a written, validated output. In this session, the `Write` tool succeeded against the outbox path on the first attempt, which is the evidence that the write-layer gap is either resolved (permission mode/allowlist now covers this path) or was resolved live for this specific run.

## Uncertainty / What Scout Cannot Verify From Inside This Session
- **Why the write succeeded this time:** Scout cannot see the permission configuration from inside the session. It cannot distinguish "the outbox path is now pre-authorized" from "a human approved this specific write live," and those two explanations have different implications for whether future *unattended* runs will succeed without a human present.
- **Invocation mechanism:** Scout cannot independently confirm from inside the conversation whether this run was launched headlessly/programmatically by the bridge versus opened interactively. This session was pre-loaded with the mission execution instructions rather than typed by a user, which is consistent with programmatic dispatch, but that is an inference, not a directly observed fact.
- **Audit record for this run:** Scout does not itself write to `audit/`. Whether a new audit entry is generated for this run depends on the external harness wrapping this session, and happens (if at all) outside Scout's visibility.
- **Zero copy/paste by Samuel:** Scout can only confirm that nothing in this run required Samuel to supply mission or doctrine text manually — it cannot observe Samuel's actions outside the session.

## Conclusion
Both halves of the dispatch mechanic — reading a mission and doctrine live from the vault, and writing a validated deliverable/handoff back to the vault — succeeded in this run with no text retyped or pasted by Samuel. The one prior structural failure (no vault scope at all) and the one prior permission failure (vault scope but no write authorization) are not reproduced here. The remaining open item is confirming, from outside this session, that the write authorization observed here is durable (pre-authorized for future headless runs) rather than a one-off live approval — that determination sits with Forge/Samuel, not with Scout.
