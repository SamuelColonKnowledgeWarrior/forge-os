# MISSION LIFECYCLE

## Purpose

Standardize how missions are created, executed, paused, resumed, completed, and archived.

## States

1. Proposed
    

- Idea captured.
    
- Not active.
    

2. Active
    

- Added to EXECUTION_QUEUE.
    
- Assigned an owner.
    
- Has a defined objective and success criteria.
    

3. Blocked
    

- Waiting on an external dependency or decision.
    
- Blocker recorded in CURRENT_STATE.
    

4. Paused
    

- Intentionally deferred.
    
- Resume conditions documented.
    

5. Completed
    

- Deliverables accepted.
    
- BUILD_LEDGER updated.
    
- Outcomes recorded.
    

6. Archived
    

- Moved to archive after completion or cancellation.
    
- Retained for historical reference.
    

## Mission Rules

- One owner per mission.
    
- One primary objective.
    
- No duplicate active missions.
    
- Every active mission appears in EXECUTION_QUEUE.
    
- Every completed mission is logged in BUILD_LEDGER.
    

## Completion Checklist

- Objective achieved
    
- Deliverables deployed
    
- Continuity files updated
    
- Next mission identified
    

## Motto

Start with purpose. Finish with proof.