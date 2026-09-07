param(
    [switch]$RunOnce
)

$Bridge = $PSScriptRoot
$Triggers = Join-Path $Bridge "triggers"
$Inbox = Join-Path $Bridge "inbox"
$Ledger = Join-Path $Bridge "trigger-fire-ledger.json"

if (-not (Test-Path $Triggers)) {
    New-Item -ItemType Directory -Path $Triggers -Force | Out-Null
}

$Fired = @{}

if (Test-Path $Ledger) {
    $Raw = Get-Content $Ledger -Raw
    if (-not [string]::IsNullOrWhiteSpace($Raw)) {
        $Data = $Raw | ConvertFrom-Json
        foreach ($Property in $Data.PSObject.Properties) {
            $Fired[$Property.Name] = [string]$Property.Value
        }
    }
}

Write-Host "FORGE TRIGGER ENGINE: ACTIVE"
Write-Host "Trigger Definitions: $Triggers"
Write-Host ""

$Definitions = @(
    Get-ChildItem $Triggers -Filter "*.json" -File -ErrorAction SilentlyContinue
)

foreach ($File in $Definitions) {

    try {
        $Trigger = Get-Content $File.FullName -Raw | ConvertFrom-Json
    }
    catch {
        Write-Host "TRIGGER INVALID: $($File.Name)"
        continue
    }

    if (-not $Trigger.enabled) { continue }

    $ConditionMet = $false
    $EventKey = $null

    switch ($Trigger.type) {

        "FILE_EXISTS" {
            if (Test-Path $Trigger.path) {
                $Item = Get-Item $Trigger.path
                $ConditionMet = $true
                $EventKey = "$($Trigger.trigger_id)|$($Item.FullName)|$($Item.LastWriteTimeUtc.Ticks)"
            }
        }

        "FILE_CREATED" {
            $Matches = @(
                Get-ChildItem $Trigger.path -Filter $Trigger.filter -File -ErrorAction SilentlyContinue
            )

            foreach ($Match in $Matches) {
                $Key = "$($Trigger.trigger_id)|$($Match.FullName)|$($Match.CreationTimeUtc.Ticks)"

                if (-not $Fired.ContainsKey($Key)) {
                    $ConditionMet = $true
                    $EventKey = $Key
                    break
                }
            }
        }
    }

    if ($ConditionMet -and -not $Fired.ContainsKey($EventKey)) {

        $Stamp = Get-Date -Format "yyyyMMdd-HHmmss"
        $MissionID = "FORGE-TRIGGER-$($Trigger.trigger_id)-$Stamp"

        $Mission = [ordered]@{
            mission_id = $MissionID
            objective = $Trigger.objective
            deliverable = $Trigger.deliverable
            context = $Trigger.context
            authority_tier = $Trigger.authority_tier
            completion_test = $Trigger.completion_test
            return_format = $Trigger.return_format
            status = "INTAKE"
        }

        $MissionPath = Join-Path $Inbox ("mission.intake-" + $MissionID.ToLower() + ".json")

        $Mission |
            ConvertTo-Json -Depth 5 |
            Set-Content $MissionPath -Encoding UTF8

        $Fired[$EventKey] = (Get-Date).ToString("o")

        $LedgerObject = [ordered]@{}
        foreach ($Key in ($Fired.Keys | Sort-Object)) {
            $LedgerObject[$Key] = $Fired[$Key]
        }

        $LedgerObject |
            ConvertTo-Json -Depth 5 |
            Set-Content $Ledger -Encoding UTF8

        Write-Host "TRIGGER FIRED: $($Trigger.trigger_id)"
        Write-Host "Mission Created: $MissionID"
    }
}

if ($RunOnce) {
    Write-Host ""
    Write-Host "FORGE TRIGGER RUN: COMPLETE"
    exit 0
}
