param(
    [switch]$RunOnce
)

$Bridge = $PSScriptRoot
$Schedules = Join-Path $Bridge "schedules"
$Inbox = Join-Path $Bridge "inbox"
$FireLedger = Join-Path $Bridge "schedule-fire-ledger.json"

if (-not (Test-Path $Schedules)) {
    New-Item -ItemType Directory -Path $Schedules -Force | Out-Null
}

Write-Host "FORGE SCHEDULER: ACTIVE"
Write-Host "Schedule Definitions: $Schedules"
Write-Host ""

$Now = Get-Date

$Fired = @{}
if (Test-Path $FireLedger) {
    $RawLedger = Get-Content $FireLedger -Raw
    if (-not [string]::IsNullOrWhiteSpace($RawLedger)) {
        $LedgerData = $RawLedger | ConvertFrom-Json
        foreach ($Property in $LedgerData.PSObject.Properties) {
            $Fired[$Property.Name] = [string]$Property.Value
        }
    }
}

$Definitions = @(
    Get-ChildItem $Schedules -Filter "*.json" -File -ErrorAction SilentlyContinue
)

foreach ($File in $Definitions) {

    try {
        $Schedule = Get-Content $File.FullName -Raw | ConvertFrom-Json
    }
    catch {
        Write-Host "SCHEDULE INVALID: $($File.Name)"
        continue
    }

    if (-not $Schedule.enabled) { continue }

    $Due = $false

    switch ($Schedule.frequency) {

        "DAILY" {
            $Target = [datetime]::ParseExact(
                $Schedule.time,
                "HH:mm",
                $null
            )

            if ($Now.Hour -eq $Target.Hour -and $Now.Minute -eq $Target.Minute) {
                $Due = $true
            }
        }

        "WEEKLY" {
            $Target = [datetime]::ParseExact(
                $Schedule.time,
                "HH:mm",
                $null
            )

            if (
                $Now.DayOfWeek.ToString().ToUpper() -eq $Schedule.day.ToUpper() -and
                $Now.Hour -eq $Target.Hour -and
                $Now.Minute -eq $Target.Minute
            ) {
                $Due = $true
            }
        }

        "MONTHLY" {
            $Target = [datetime]::ParseExact(
                $Schedule.time,
                "HH:mm",
                $null
            )

            if (
                $Now.Day -eq [int]$Schedule.day -and
                $Now.Hour -eq $Target.Hour -and
                $Now.Minute -eq $Target.Minute
            ) {
                $Due = $true
            }
        }
    }

    if ($Due) {

        $FireKey = "$($Schedule.schedule_id)|$($Now.ToString('yyyyMMdd-HHmm'))"

        if ($Fired.ContainsKey($FireKey)) {
            Write-Host "SCHEDULE ALREADY FIRED: $($Schedule.schedule_id)"
            continue
        }

        $Stamp = Get-Date -Format "yyyyMMdd-HHmmss"
        $MissionID = "FORGE-SCHED-$($Schedule.schedule_id)-$Stamp"

        $Mission = [ordered]@{
            mission_id = $MissionID
            objective = $Schedule.objective
            deliverable = $Schedule.deliverable
            context = $Schedule.context
            authority_tier = $Schedule.authority_tier
            completion_test = $Schedule.completion_test
            return_format = $Schedule.return_format
            status = "INTAKE"
        }

        $MissionPath = Join-Path $Inbox ("mission.intake-" + $MissionID.ToLower() + ".json")

        if (-not (Test-Path $MissionPath)) {
            $Mission |
                ConvertTo-Json -Depth 5 |
                Set-Content $MissionPath -Encoding UTF8

            Write-Host "SCHEDULE FIRED: $($Schedule.schedule_id)"
            Write-Host "Mission Created: $MissionID"

            $Fired[$FireKey] = (Get-Date).ToString("o")
            $LedgerObject = [ordered]@{}
            foreach ($Key in ($Fired.Keys | Sort-Object)) {
                $LedgerObject[$Key] = $Fired[$Key]
            }
            $LedgerObject |
                ConvertTo-Json -Depth 5 |
                Set-Content $FireLedger -Encoding UTF8
        }
    }
}

if ($RunOnce) {
    Write-Host ""
    Write-Host "FORGE SCHEDULER RUN: COMPLETE"
    exit 0
}

