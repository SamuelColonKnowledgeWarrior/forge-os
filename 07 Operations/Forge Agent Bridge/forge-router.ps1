param(
    [Parameter(Mandatory=$true)]
    [string]$MissionPath
)

$ErrorActionPreference = "Stop"

$Vault = "C:\Users\Family\OneDrive\Forge\Forge"
$Bridge = Join-Path $Vault "07 Operations\Forge Agent Bridge"
$Dispatcher = Join-Path $Bridge "forge-dispatch.ps1"

if (-not (Test-Path $MissionPath)) {
    throw "Forge mission packet not found: $MissionPath"
}

$Mission = Get-Content $MissionPath -Raw | ConvertFrom-Json

if (-not $Mission.objective) {
    throw "Forge mission missing objective."
}

$text = @(
    $Mission.objective
    $Mission.deliverable
    $Mission.context
) -join " "

$text = $text.ToLower()

$Agent = if ($text -match "research|verify|compare|intelligence|source|investigate") {
    "SCOUT"
}
elseif ($text -match "market|marketing|campaign|audience|promotion|relaunch|brand") {
    "GRIND"
}
elseif ($text -match "revenue|commercial|monetiz|pricing|offer|profit|income|sell") {
    "WARBUCKS"
}
elseif ($text -match "publish|publishing|book|course|training|editorial|content|website copy") {
    "PETER"
}
elseif ($text -match "meeting|minutes|follow-up|action item|decision register|commitment|executive admin") {
    "EXESEC"
}
elseif ($text -match "system|automation|workflow|integration|script|code|ui|deploy|technical") {
    "BUILDER"
}
else {
    "FORGE"
}

Write-Host ""
Write-Host "FORGE ROUTER"
Write-Host "Mission: $($Mission.mission_id)"
Write-Host "Selected Agent: $Agent"

if ($Agent -eq "FORGE") {
    Write-Host "Status: FORGE REVIEW REQUIRED"
    Write-Host "Reason: Mission does not meet a safe specialist-routing threshold."
    exit 2
}

$Mission | Add-Member -NotePropertyName assigned_agent -NotePropertyValue $Agent -Force

if (-not $Mission.required_deliverable) {
    $value = if ($Mission.deliverable) { $Mission.deliverable } else { "Complete the assigned mission objective and return a professional deliverable." }
    $Mission | Add-Member -NotePropertyName required_deliverable -NotePropertyValue $value -Force
}

if (-not $Mission.authority_tier) {
    $Mission | Add-Member -NotePropertyName authority_tier -NotePropertyValue 1 -Force
}

if (-not $Mission.completion_test) {
    $Mission | Add-Member -NotePropertyName completion_test -NotePropertyValue @(
        "Assigned specialist doctrine loaded."
        "Mission objective completed."
        "Deliverable written."
        "Structured handoff written."
        "Mission and work package IDs preserved."
        "Audit validates PASS."
    ) -Force
}

if (-not $Mission.return_format) {
    $Mission | Add-Member -NotePropertyName return_format -NotePropertyValue "Markdown deliverable plus JSON handoff" -Force
}

if (-not $Mission.status) {
    $Mission | Add-Member -NotePropertyName status -NotePropertyValue "READY_FOR_DISPATCH" -Force
}

if (-not $Mission.work_package_id) {
    $Mission | Add-Member -NotePropertyName work_package_id -NotePropertyValue "$Agent-DISPATCH-$($Mission.mission_id)" -Force
}

$RoutedPath = Join-Path (Join-Path $Bridge "inbox") ("mission." + $Agent.ToLower() + "-routed-" + $Mission.mission_id.ToLower() + ".json")

$Mission | ConvertTo-Json -Depth 10 | Set-Content -Encoding UTF8 $RoutedPath

Write-Host "Status: ROUTED"
Write-Host "Packet: $RoutedPath"
Write-Host ""

powershell -ExecutionPolicy Bypass -File $Dispatcher -MissionPath $RoutedPath
exit $LASTEXITCODE

