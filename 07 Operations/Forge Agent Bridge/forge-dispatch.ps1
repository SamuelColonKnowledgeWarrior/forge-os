param(
  [string]$Vault = "C:\Users\Family\OneDrive\Forge\Forge"
)
$ErrorActionPreference = "Stop"
$Build = Join-Path $Vault "07 Operations\Forge Agent Bridge"
$Inbox = Join-Path $Build "inbox"
$Outbox = Join-Path $Build "outbox"
$Audit = Join-Path $Build "audit"
New-Item -ItemType Directory -Force -Path $Inbox,$Outbox,$Audit | Out-Null

$PacketSource = Join-Path $PSScriptRoot "mission.scout-dispatch-001.json"
$SchemaSource = Join-Path $PSScriptRoot "handoff.schema.json"
Copy-Item $PacketSource (Join-Path $Inbox "mission.scout-dispatch-001.json") -Force
Copy-Item $SchemaSource (Join-Path $Build "handoff.schema.json") -Force

$ScoutCandidates = @(
  (Join-Path $Vault "scout"),
  (Join-Path $Vault "03 Agents\Scout"),
  (Join-Path $Vault "03 Agents\SCOUT")
)
$ScoutPath = $ScoutCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $ScoutPath) { throw "Scout doctrine folder not found in expected Forge Vault locations." }

$Claude = Get-Command claude -ErrorAction SilentlyContinue
if (-not $Claude) { throw "Claude Code CLI command 'claude' was not found on PATH." }

$MissionPath = Join-Path $Inbox "mission.scout-dispatch-001.json"
$HandoffPath = Join-Path $Outbox "handoff.scout-dispatch-001.json"
$DeliverablePath = Join-Path $Outbox "deliverable.scout-dispatch-001.md"
$AuditPath = Join-Path $Audit "audit.scout-dispatch-001.json"

$Prompt = @"
You are executing a Forge work package as SCOUT.
Read the mission packet at: $MissionPath
Read Scout's persistent operating doctrine and relevant skill files under: $ScoutPath
Do not use or access corporate BP/S.M. Lawrence data.
Execute only the mission packet.
Write the substantive deliverable to: $DeliverablePath
Then write a JSON handoff to: $HandoffPath
The JSON handoff MUST contain exactly these required semantic fields:
mission_id, work_package_id, agent, status, deliverable_path, evidence, assumptions, unresolved_risks, decision_required, recommended_next_action, completed_at.
agent must be SCOUT. status must be COMPLETE, FAILED, or BLOCKED.
Do not claim files exist unless you actually wrote them.
"@

$started = (Get-Date).ToString("o")
Push-Location $Vault
try {
  $result = & claude -p $Prompt --permission-mode acceptEdits --output-format json 2>&1
} finally {
  Pop-Location
}
$exit = $LASTEXITCODE
$ended = (Get-Date).ToString("o")

$rawPath = Join-Path $Audit "claude-raw.scout-dispatch-001.json"
$result | Out-File -FilePath $rawPath -Encoding utf8

$validationErrors = @()
if ($exit -ne 0) { $validationErrors += "Claude CLI exited with code $exit" }
if (-not (Test-Path $HandoffPath)) { $validationErrors += "Handoff file missing" }
if (-not (Test-Path $DeliverablePath)) { $validationErrors += "Deliverable file missing" }

if (Test-Path $HandoffPath) {
  try {
    $h = Get-Content $HandoffPath -Raw | ConvertFrom-Json
    $required = @("mission_id","work_package_id","agent","status","deliverable_path","evidence","assumptions","unresolved_risks","decision_required","recommended_next_action","completed_at")
    foreach ($f in $required) {
      if ($null -eq $h.$f) { $validationErrors += "Missing handoff field: $f" }
    }
    if ($h.agent -ne "SCOUT") { $validationErrors += "Agent is not SCOUT" }
    if ($h.status -notin @("COMPLETE","FAILED","BLOCKED")) { $validationErrors += "Invalid handoff status" }
  } catch { $validationErrors += "Handoff JSON parse failed: $($_.Exception.Message)" }
}

$auditRecord = [ordered]@{
  mission_id = "FORGE-014D1"
  work_package_id = "SCOUT-DISPATCH-001"
  started_at = $started
  ended_at = $ended
  claude_exit_code = $exit
  scout_doctrine_path = "$ScoutPath"
  mission_packet = "$MissionPath"
  deliverable = "$DeliverablePath"
  handoff = "$HandoffPath"
  raw_cli_output = "$rawPath"
  validation = $(if ($validationErrors.Count -eq 0) {"PASS"} else {"FAIL"})
  validation_errors = $validationErrors
}
$auditRecord | ConvertTo-Json -Depth 5 | Out-File -FilePath $AuditPath -Encoding utf8

Write-Host ""
Write-Host "FORGE 014D-1 LOCAL DISPATCH TEST: $($auditRecord.validation)"
Write-Host "Audit: $AuditPath"
if ($validationErrors.Count -gt 0) {
  $validationErrors | ForEach-Object { Write-Host " - $_" }
  exit 1
}
Write-Host "Handoff: $HandoffPath"
Write-Host "Deliverable: $DeliverablePath"



