# Forge Infrastructure Phase 2

## Objective

Connect Forge directly to the Obsidian vault using Model Context Protocol (MCP).

## Outcome

Forge can read and update the vault instead of rebuilding context from conversation history.

## Deliverables

- Install an Obsidian MCP server
    
- Connect ChatGPT to the vault
    
- Verify read access
    
- Verify write access
    
- Update CURRENT_STATE through MCP
    
- Update BUILD_LEDGER through MCP
    

## Success Criteria

- CURRENT_STATE becomes the live operating state
    
- EXECUTION_QUEUE is maintained directly
    
- BUILD_LEDGER updates without copy/paste
    
- Forge resumes work from the vault
    

## Notes

Do not redesign the vault.  
Do not create new doctrine during this phase.  
Focus only on infrastructure.

## Status

Ready to begin.