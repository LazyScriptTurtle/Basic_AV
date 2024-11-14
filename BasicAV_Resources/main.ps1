
    # Import wymaganych modułów

    . .\Malware_Bazar_API.ps1
    . .\OfflineHashChecker.ps1
    . .\Scanner.ps1
function Run {
    param(
        [switch]$Fast
    )

    $disks = Get-Volume | Select-Object -ExpandProperty DriveLetter -Unique
    $disk = @()
    foreach ($d in $disks) {
        $allDiskPath = "$d`:\"
        $disk += @($allDiskPath)
    }

    if ($Fast) {
        $scanResult = Run-SimpleScanner -Path $null
    }
    else {
        foreach ($a in $disk) {
            $scanResult = Run-SimpleScanner -Path $a
        
        }
        return $scanResult
    }
}
    Run -Fast yes