param(
    [Parameter(Mandatory=$true)]
    [string]$Objective,

    [string]$Deliverable = "Complete the mission objective and return a professional, usable deliverable.",

    [string]$Context = "Knowledge Warrior / Personal Forge operation."
)

$ErrorActionPreference = "Stop"

$Vault  = "C:\Users\Family\OneDrive\Forge\Forge"
$Bridge = Join-Path $Vault "07 Operations\Forge Agent Bridge"
$Inbox  = Join-Path $Bridge "inbox"
$Router = Join-Path $Bridge "forge-router.ps1"

if (-not (Test-Path $Router)) {
    throw "Forge Router not found: $Router"
}

New-Item -ItemType Directory -Force -Path $Inbox | Out-Null

$Timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$MissionID = "FORGE-$Timestamp"

$Mission = [ordered]@{
    mission_id  = $MissionID
    objective   = $Objective
    deliverable = $Deliverable
    context     = $Context
    source      = "FORGE_MISSION_INTAKE"
    created_at  = (Get-Date).ToString("o")
}

$MissionPath = Join-Path $Inbox ("mission.intake-" + $MissionID.ToLower() + ".json")

$Mission | ConvertTo-Json -Depth 10 | Set-Content -Encoding UTF8 $MissionPath

Write-Host ""
Write-Host "FORGE MISSION INTAKE"
Write-Host "Mission: $MissionID"
Write-Host "Objective: $Objective"
Write-Host "Packet: $MissionPath"
Write-Host "Status: CREATED"
Write-Host ""

powershell -ExecutionPolicy Bypass -File $Router -MissionPath $MissionPath

$ExitCode = $LASTEXITCODE

Write-Host ""
if ($ExitCode -eq 0) {
    Write-Host "FORGE MISSION INTAKE: PASS"
    Write-Host "Mission: $MissionID"
    Write-Host "Status: EXECUTION COMPLETE"
}
else {
    Write-Host "FORGE MISSION INTAKE: FAIL"
    Write-Host "Mission: $MissionID"
    Write-Host "Exit Code: $ExitCode"
}

if ($ExitCode -eq 0) {
    $AuditFile = Get-ChildItem (Join-Path $PSScriptRoot "audit") -Filter ("audit.*" + $MissionID + ".json") |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1

    if ($AuditFile) {
        powershell -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot "forge-return.ps1") -AuditPath $AuditFile.FullName
        powershell -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot "forge-state.ps1") -AuditPath $AuditFile.FullName
    }
}

exit $ExitCode

