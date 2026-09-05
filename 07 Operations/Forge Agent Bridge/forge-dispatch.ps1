param(
  [Parameter(Mandatory=$true)]
  [string]$MissionPath,

  [string]$Vault = "C:\Users\Family\OneDrive\Forge\Forge"
)

$ErrorActionPreference = "Stop"

$Build  = Join-Path $Vault "07 Operations\Forge Agent Bridge"
$Inbox  = Join-Path $Build "inbox"
$Outbox = Join-Path $Build "outbox"
$Audit  = Join-Path $Build "audit"
New-Item -ItemType Directory -Force -Path $Inbox,$Outbox,$Audit | Out-Null

if (-not (Test-Path $MissionPath)) { throw "Mission file not found: $MissionPath" }

$mission = Get-Content $MissionPath -Raw | ConvertFrom-Json

$requiredMissionFields = @(
  "mission_id","work_package_id","assigned_agent","objective",
  "required_deliverable","authority_tier","completion_test","return_format","status"
)
foreach ($f in $requiredMissionFields) {
  if ($null -eq $mission.$f) { throw "Mission packet missing required field: $f" }
}

$agent = ([string]$mission.assigned_agent).ToUpperInvariant()

$agentMap = @{
  "SCOUT"    = @{ Folder="Scout";    Doctrine="SCOUT_DOCTRINE.md" }
  "PETER"    = @{ Folder="Peter";    Doctrine="PETER_DOCTRINE.md" }
  "GRIND"    = @{ Folder="GRIND";    Doctrine="GRIND_DOCTRINE.md" }
  "EXESEC"   = @{ Folder="ExeSec";   Doctrine="EXESEC_DOCTRINE.md" }
  "WARBUCKS" = @{ Folder="Warbucks"; Doctrine="WARBUCKS_DOCTRINE.md" }
  "BUILDER"  = @{ Folder="Builder";  Doctrine="BUILDER_DOCTRINE.md" }
}

if (-not $agentMap.ContainsKey($agent)) {
  throw "Unsupported assigned_agent '$agent'. Allowed: $($agentMap.Keys -join ', ')"
}

$agentFolder = Join-Path $Vault ("03 Agents\" + $agentMap[$agent].Folder)
$doctrinePath = Join-Path $agentFolder $agentMap[$agent].Doctrine

if (-not (Test-Path $doctrinePath)) { throw "$agent doctrine not found: $doctrinePath" }

$claude = Get-Command claude -ErrorAction SilentlyContinue
if (-not $claude) { throw "Claude Code CLI command 'claude' was not found on PATH." }

$slug = ([string]$mission.work_package_id).ToLowerInvariant()
$slug = $slug -replace '[^a-z0-9\-]+','-'
$slug = $slug.Trim('-')

$canonicalMissionPath = Join-Path $Inbox ("mission." + $slug + ".json")
if ((Resolve-Path $MissionPath).Path -ne $canonicalMissionPath) {
  Copy-Item $MissionPath $canonicalMissionPath -Force
}

$HandoffPath     = Join-Path $Outbox ("handoff." + $slug + ".json")
$DeliverablePath = Join-Path $Outbox ("deliverable." + $slug + ".md")
$AuditPath       = Join-Path $Audit ("audit." + $slug + ".json")
$RawPath         = Join-Path $Audit ("claude-raw." + $slug + ".json")

Remove-Item $HandoffPath,$DeliverablePath -Force -ErrorAction SilentlyContinue

$Prompt = @"
You are executing a Forge work package as $agent.

Read the mission packet at:
$canonicalMissionPath

Read your persistent operating doctrine at:
$doctrinePath

Follow the doctrine and execute only the assigned work package.
Do not use or access corporate BP/S.M. Lawrence proprietary data unless the mission explicitly contains sanitized approved input.

Write the substantive deliverable to:
$DeliverablePath

Then write a JSON handoff to:
$HandoffPath

The JSON handoff MUST contain these fields:
mission_id
work_package_id
agent
status
deliverable_path
evidence
assumptions
unresolved_risks
decision_required
recommended_next_action
completed_at

Rules:
- agent must be $agent
- status must be COMPLETE, FAILED, or BLOCKED
- do not claim files exist unless you actually wrote them
- do not exceed the mission authority tier
- do not recruit or assign other agents
"@

$started = (Get-Date).ToString("o")

Push-Location $Vault
try {
  $result = & claude -p $Prompt --permission-mode acceptEdits --output-format json 2>&1
  $exit = $LASTEXITCODE
}
finally {
  Pop-Location
}

$ended = (Get-Date).ToString("o")
$result | Out-File -FilePath $RawPath -Encoding utf8

$validationErrors = @()

if ($exit -ne 0) { $validationErrors += "Claude CLI exited with code $exit" }
if (-not (Test-Path $HandoffPath)) { $validationErrors += "Handoff file missing" }
if (-not (Test-Path $DeliverablePath)) { $validationErrors += "Deliverable file missing" }

if (Test-Path $HandoffPath) {
  try {
    $h = Get-Content $HandoffPath -Raw | ConvertFrom-Json
    $required = @(
      "mission_id","work_package_id","agent","status","deliverable_path",
      "evidence","assumptions","unresolved_risks","decision_required",
      "recommended_next_action","completed_at"
    )
    foreach ($f in $required) {
      if ($null -eq $h.$f) { $validationErrors += "Missing handoff field: $f" }
    }
    if (([string]$h.agent).ToUpperInvariant() -ne $agent) {
      $validationErrors += "Handoff agent '$($h.agent)' does not match assigned agent '$agent'"
    }
    if ($h.status -notin @("COMPLETE","FAILED","BLOCKED")) {
      $validationErrors += "Invalid handoff status '$($h.status)'"
    }
    if ($h.mission_id -ne $mission.mission_id) {
      $validationErrors += "Handoff mission_id does not match mission packet"
    }
    if ($h.work_package_id -ne $mission.work_package_id) {
      $validationErrors += "Handoff work_package_id does not match mission packet"
    }
  }
  catch {
    $validationErrors += "Handoff JSON parse failed: $($_.Exception.Message)"
  }
}

$auditRecord = [ordered]@{
  mission_id        = [string]$mission.mission_id
  work_package_id   = [string]$mission.work_package_id
  assigned_agent    = $agent
  started_at        = $started
  ended_at          = $ended
  claude_exit_code  = $exit
  doctrine_path     = "$doctrinePath"
  mission_packet    = "$canonicalMissionPath"
  deliverable       = "$DeliverablePath"
  handoff           = "$HandoffPath"
  raw_cli_output    = "$RawPath"
  validation        = $(if ($validationErrors.Count -eq 0) {"PASS"} else {"FAIL"})
  validation_errors = $validationErrors
}

$auditRecord | ConvertTo-Json -Depth 6 | Out-File -FilePath $AuditPath -Encoding utf8

Write-Host ""
Write-Host "FORGE UNIVERSAL DISPATCH: $($auditRecord.validation)"
Write-Host "Agent: $agent"
Write-Host "Mission: $($mission.mission_id)"
Write-Host "Work Package: $($mission.work_package_id)"
Write-Host "Audit: $AuditPath"

if ($validationErrors.Count -gt 0) {
  $validationErrors | ForEach-Object { Write-Host " - $_" }
  exit 1
}

Write-Host "Handoff: $HandoffPath"
Write-Host "Deliverable: $DeliverablePath"
