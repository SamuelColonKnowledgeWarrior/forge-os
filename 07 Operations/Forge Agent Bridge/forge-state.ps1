param(
    [Parameter(Mandatory=$true)]
    [string]$AuditPath
)

$Vault="C:\Users\Family\OneDrive\Forge\Forge"
$MissionRegister=Join-Path $Vault "02 Missions\ACTIVE_MISSION_REGISTER.md"
$DecisionRegister=Join-Path $Vault "09 Decisions\DECISION_REGISTER.md"

if (-not (Test-Path $AuditPath)) { throw "Audit file not found: $AuditPath" }

$Audit=Get-Content $AuditPath -Raw | ConvertFrom-Json

if (-not (Test-Path $Audit.handoff)) { throw "Handoff file not found: $($Audit.handoff)" }

$Handoff=Get-Content $Audit.handoff -Raw | ConvertFrom-Json

$timestamp=Get-Date -Format "yyyy-MM-dd HH:mm:ss"

$missionEntry=@"

## $($Audit.mission_id) — $timestamp
- Agent: $($Audit.assigned_agent)
- Work Package: $($Audit.work_package_id)
- Status: $($Handoff.status)
- Deliverable: $($Audit.deliverable)
- Handoff: $($Audit.handoff)
- Audit: $AuditPath
- Decision Required: $($Handoff.decision_required)
- Recommended Next Action: $($Handoff.recommended_next_action)

"@

if (-not (Select-String -Path $MissionRegister -SimpleMatch $Audit.mission_id -Quiet)) {
    Add-Content -Path $MissionRegister -Value $missionEntry -Encoding UTF8
}

if (-not [string]::IsNullOrWhiteSpace([string]$Handoff.decision_required)) {
$decisionEntry=@"

## $($Audit.mission_id) — Decision Required — $timestamp
- Agent: $($Audit.assigned_agent)
- Work Package: $($Audit.work_package_id)
- Status: OPEN
- Recommended Action: $($Handoff.recommended_next_action)
- Source Handoff: $($Audit.handoff)
- Authority: Forge/Sam per existing decision doctrine

"@

if (-not (Select-String -Path $DecisionRegister -SimpleMatch $Audit.mission_id -Quiet)) {
    Add-Content -Path $DecisionRegister -Value $decisionEntry -Encoding UTF8
}
}

Write-Host ""
Write-Host "FORGE STATE PERSISTENCE: PASS"
Write-Host "Mission: $($Audit.mission_id)"
Write-Host "Mission Register: UPDATED"
Write-Host "Decision Required: $($Handoff.decision_required)"
if (-not [string]::IsNullOrWhiteSpace([string]$Handoff.decision_required)) {
    Write-Host "Decision Register: UPDATED"
}


