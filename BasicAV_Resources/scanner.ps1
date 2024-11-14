

function Run-SimpleScanner {
    param (
    [string]$Path
    )

    $paths = @( 
        "C:\Windows\System32",
        "C:\Windows\SysWOW64",
        "C:\Windows\Temp",
        "C:\Windows\Prefetch",
        "C:\Windows\Fonts",
        "C:\Windows\Tasks",
        "C:\Windows\Installer",
        "C:\Users\$env:USERNAME\AppData\Local",
        "C:\Users\$env:USERNAME\AppData\Local\Temp",
        "C:\Users\$env:USERNAME\AppData\Roaming",
        "C:\ProgramData",
        "C:\Program Files",
        "C:\Program Files\Common Files",
        "C:\Program Files (x86)",
        "C:\ProgramData\Microsoft\Windows Defender",
        "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup",
        "C:\Windows\SoftwareDistribution\Download",
        "C:\Windows\WinSxS",
        "C:\Windows\Logs",
        "C:\Windows\explorer.exe",
        "C:\Windows\regedit.exe",
        "C:\Windows\system.ini",
        "C:\Windows\win.ini",
        "C:\Users\$env:USERNAME\Desktop",
        "C:\Users\$env:USERNAME\Downloads",
        "C:\Users\$env:USERNAME\Documents",
        "C:\Windows\ServiceProfiles\LocalService",
        "C:\Windows\ServiceProfiles\NetworkService",
        "C:\Windows\SystemApps",
        "C:\Windows\IME",
        "C:\Users\Public",
        "C:\Users\Default",
        "C:\Recovery",
        "C:\Windows\Panther",
        "C:\Windows\debug",
        "C:\Windows\Globalization",
        "C:\Windows\rescache",
        "C:\Windows\PolicyDefinitions",
        "C:\inetpub",
        "C:\PerfLogs",
        "C:\Windows\LiveKernelReports",
        "C:\Windows\SystemResources",
        "C:\Windows\diagnostics",
        "C:\Windows\Vss",
        "C:\Windows\Speech_OneCore",
        "C:\Windows\ShellExperiences",
        "C:\Windows\Web",
        "C:\Windows\INF",
        "C:\Windows\System32\winevt\Logs",
        "C:\Users"
    )
    $result = New-Object System.Collections.Generic.List[Object]
    if ($null -eq $Path) {
        foreach ($p in $paths) {
            if (Test-Path -Path $p) {
                $allItems = Get-ChildItem -Path $p -file -Recurse -ErrorAction SilentlyContinue
                $allItemsCount = $allItems.Count
                $total = 0
                foreach ($item in $allItems) {
                    $total ++
                    $hash = Get-FileHash -Path $item.FullName -Algorithm SHA256 -ErrorAction SilentlyContinue
                    $result.Add([PSCustomObject]@{
                            Name = $item
                            Path = $item.FullName
                            Hash = if ($hash) { $hash.Hash }else {}
    
                        })
                    Write-Progress -Activity "Scanning $p" -Status " Scanned $total for $allItemsCount" -PercentComplete (($total / $allItemsCount) * 100)
                }

            }
            else {
                Continue
            }
        }
    }
    else {
        $allItems = Get-ChildItem -Path $Path -file -Recurse -ErrorAction SilentlyContinue
        $allItemsCount = $allItems.Count
        $total = 0
        foreach ($item in $allItems) {
            if (Test-Path -Path $item.FullName) {
                $total ++
                $hash = Get-FileHash -Path $item.FullName -Algorithm SHA256 -ErrorAction SilentlyContinue
                $result.Add([PSCustomObject]@{
                        Name = $item.Name
                        Path = $item.FullName
                        Hash = if ($hash) { $hash.Hash }else {}

                    })
                Write-Progress -Activity "Scanning: $Path" -Status " Scanned $total for $allItemsCount" -PercentComplete (($total / $allItemsCount) * 100)
            }
            else {
                Continue
            }

        }
    }
    return $result
}
Run-SimpleScanner