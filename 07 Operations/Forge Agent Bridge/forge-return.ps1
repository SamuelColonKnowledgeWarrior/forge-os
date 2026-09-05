param(
    [Parameter(Mandatory=$true)]
    [string]$AuditPath,

    [string]$Vault = "C:\Users\Family\OneDrive\Forge\Forge"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $AuditPath)) {
    throw "Forge audit record not found: $AuditPath"
}

$Audit = Get-Content $AuditPath -Raw | ConvertFrom-Json

if ($Audit.validation -ne "PASS") {
    throw "Mission has not passed Forge dispatch validation. Validation: $($Audit.validation)"
}

if (-not (Test-Path $Audit.handoff)) {
    throw "Validated handoff file not found: $($Audit.handoff)"
}

if (-not (Test-Path $Audit.deliverable)) {
    throw "Validated deliverable file not found: $($Audit.deliverable)"
}

$Handoff = Get-Content $Audit.handoff -Raw | ConvertFrom-Json
$Deliverable = Get-Content $Audit.deliverable -Raw

$Bridge = Join-Path $Vault "07 Operations\Forge Agent Bridge"
$Returns = Join-Path $Bridge "returns"
New-Item -ItemType Directory -Force -Path $Returns | Out-Null

$slug = ([string]$Audit.work_package_id).ToLowerInvariant()
$slug = $slug -replace '[^a-z0-9\-]+','-'
$slug = $slug.Trim('-')

$ReturnPath = Join-Path $Returns ("return." + $slug + ".md")

$decision = if ($Handoff.decision_required) { "YES" } else { "NO" }

$content = @"
# FORGE EXECUTIVE RETURN

## Mission Status
COMPLETE

## Mission
$($Audit.mission_id)

## Work Package
$($Audit.work_package_id)

## Specialist
$($Audit.assigned_agent)

## Executive Readout
The assigned specialist completed the work package and the Forge Universal Dispatcher validated the execution path.

## Decision Required
$decision

## Recommended Next Action
$($Handoff.recommended_next_action)

## Unresolved Risks
$(
    if ($Handoff.unresolved_risks -and $Handoff.unresolved_risks.Count -gt 0) {
        ($Handoff.unresolved_risks | ForEach-Object { "- $_" }) -join "`n"
    } else {
        "None reported."
    }
)

## Deliverable
$Deliverable

---

## Forge Control Record

Audit: $AuditPath

Handoff: $($Audit.handoff)

Original Deliverable: $($Audit.deliverable)

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
"@

Set-Content -Path $ReturnPath -Value $content -Encoding UTF8

Write-Host ""
Write-Host "FORGE EXECUTIVE RETURN: PASS"
Write-Host "Mission: $($Audit.mission_id)"
Write-Host "Agent: $($Audit.assigned_agent)"
Write-Host "Decision Required: $decision"
Write-Host "Return Packet: $ReturnPath"
Write-Host ""
Write-Host "Recommended Next Action:"
Write-Host "$($Handoff.recommended_next_action)"
