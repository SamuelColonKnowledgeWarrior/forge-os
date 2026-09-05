param(
    [int]$PollSeconds = 10
)

$Bridge = $PSScriptRoot
$Inbox = Join-Path $Bridge "inbox"
$ProcessedFile = Join-Path $Bridge "queue-processed.json"

function Get-ProcessedMissions {
    $List = New-Object 'System.Collections.Generic.List[string]'

    if (Test-Path $ProcessedFile) {
        $Raw = Get-Content $ProcessedFile -Raw

        if (-not [string]::IsNullOrWhiteSpace($Raw)) {
            $Items = ConvertFrom-Json $Raw

            foreach ($Item in @($Items)) {
                if ($Item -is [string] -and -not [string]::IsNullOrWhiteSpace($Item)) {
                    [void]$List.Add($Item)
                }
            }
        }
    }

    return $List
}

function Save-ProcessedMissions {
    param([System.Collections.Generic.List[string]]$List)

    $Clean = @($List | Sort-Object -Unique)

    if ($Clean.Count -eq 0) {
        Set-Content $ProcessedFile "[]" -Encoding UTF8
    }
    else {
        ConvertTo-Json -InputObject $Clean |
            Set-Content $ProcessedFile -Encoding UTF8
    }
}

if (-not (Test-Path $ProcessedFile)) {
    $Baseline = New-Object 'System.Collections.Generic.List[string]'

    Get-ChildItem $Inbox -Filter "mission.intake-*.json" -File |
        ForEach-Object { [void]$Baseline.Add($_.Name) }

    Save-ProcessedMissions $Baseline

    Write-Host "FORGE QUEUE WATCHER: BASELINE CREATED"
    Write-Host "Historical intake missions protected: $($Baseline.Count)"
    Write-Host "No historical missions executed."
}

Write-Host ""
Write-Host "FORGE QUEUE WATCHER: ACTIVE"
Write-Host "Watching: $Inbox"
Write-Host "Poll interval: $PollSeconds seconds"
Write-Host "Press Ctrl+C to stop."
Write-Host ""

while ($true) {

    $Processed = New-Object 'System.Collections.Generic.List[string]'
    foreach ($Item in @(Get-ProcessedMissions)) {
        [void]$Processed.Add([string]$Item)
    }

    $Pending = @(
        Get-ChildItem $Inbox -Filter "mission.intake-*.json" -File |
        Where-Object { $_.Name -notin @($Processed) } |
        Sort-Object CreationTime
    )

    foreach ($MissionFile in $Pending) {

        Write-Host "QUEUE DETECTED: $($MissionFile.Name)"

        $Mission = Get-Content $MissionFile.FullName -Raw | ConvertFrom-Json

        powershell -ExecutionPolicy Bypass -File (Join-Path $Bridge "forge-router.ps1") `
            -MissionPath $MissionFile.FullName

        if ($LASTEXITCODE -eq 0) {

            $AuditFile = Get-ChildItem (Join-Path $Bridge "audit") `
                -Filter ("audit.*" + $Mission.mission_id + ".json") |
                Sort-Object LastWriteTime -Descending |
                Select-Object -First 1

            if ($AuditFile) {
                powershell -ExecutionPolicy Bypass -File (Join-Path $Bridge "forge-return.ps1") `
                    -AuditPath $AuditFile.FullName

                powershell -ExecutionPolicy Bypass -File (Join-Path $Bridge "forge-state.ps1") `
                    -AuditPath $AuditFile.FullName
            }

            if ($MissionFile.Name -notin @($Processed)) {
                [void]$Processed.Add($MissionFile.Name)
            }

            Save-ProcessedMissions $Processed

            Write-Host "FORGE QUEUE MISSION: COMPLETE"
        }
        else {
            Write-Host "FORGE QUEUE MISSION: FAILED - retained for retry"
        }

        Write-Host ""
    }

    Start-Sleep -Seconds $PollSeconds
}

