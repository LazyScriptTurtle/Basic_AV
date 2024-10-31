function scanner_module {
    param (
        [string]$Path,
        [int]$batch = 100
    )
    $excludePaths = @("C:\Windows\")
    $allFiles = Get-ChildItem -Path $Path -File -Recurse -Force -ErrorAction SilentlyContinue
    $allFilesCount = $allFiles.Count
    $total = 0
    $results = @()

    # Funkcja do sprawdzenia obciążenia dysku
    function Get-DiskUsage {
        return (Get-Counter '\PhysicalDisk(_Total)\% Disk Time').CounterSamples.CookedValue
    }

    # Skanowanie plików w seriach
    foreach ($file in $allFiles) {
        # Sprawdzenie, czy ścieżka jest wykluczona
        if (-not ($excludePaths | ForEach-Object { $file.FullName -like "*$_*" })) {
            try {
                # Monitorowanie wykorzystania dysku
                while ((Get-DiskUsage) -gt 40) {
                    Write-Output "Dysk obciążony powyżej 40%, wstrzymywanie na 500 ms"
                    Start-Sleep -Milliseconds 500  # Wstrzymywanie do czasu spadku obciążenia dysku
                }

                $total += 1
                $date = Get-Date -Format "dd/MM/yyyy_HH:mm:ss"
                $result = Get-FileHash -Path $file.FullName -Algorithm MD5 -ErrorAction SilentlyContinue
                $results += [PSCustomObject]@{
                    Name = $file.Name
                    Path = $file.FullName
                    Hash = if ($result) { $result.Hash } else { "Error" }
                    Date = $date
                }

                Write-Progress -Activity "Scanning files" -Status "$total/$allFilesCount files processed" -PercentComplete (($total / $allFilesCount) * 100)

                # Zapis wyników po każdej serii
                if (($total % $batch) -eq 0) {
                    $results | ConvertTo-Json | Out-File -FilePath "scan_results_batch_$($total/$batch).json" -Encoding UTF8
                    $results = @()  # Czyszczenie wyników po zapisaniu serii
                }
            }
            catch {
                Write-Output "Error: $($_.Exception.Message)"
            }
        }
    }

    # Zapis pozostałych wyników po zakończeniu wszystkich serii
    if ($results.Count -gt 0) {
        $results | ConvertTo-Json | Out-File -FilePath "scan_results_final.json" -Encoding UTF8
    }

    return $results
}

$date = Get-Date -Format "dd-MM-yyyy_HH-mm-ss"
$mainScanResultsPath = 'C:\Program Files\BasicAV\Definitions\Scan_Results\Main_Scan.json'
$anotherScanResultPath = "C:\Program Files\BasicAV\Definitions\Scan_Results\Another_Scan_$date.json"
$mainDisk = Get-Volume | Select-Object -ExpandProperty DriveLetter
try {
    if (Test-Path -Path $mainScanResultsPath) {
        foreach ($disk in $mainDisk) {
            $results = scanner_module -Path $disk":\" -Batch 100
        }
        $results | ConvertTo-Json | Out-File -FilePath $anotherScanResultPath -Encoding utf8
        # Write-Host "2"
    }
    else {
    
        foreach ($disk in $mainDisk) {
            $results = scanner_module -Path $disk":\" -Batch 100
            #    Write-Host "3"
        }
        $results | ConvertTo-Json | Out-File -FilePath $mainScanResultsPath -Encoding utf8
        # Write-Host "4"
    }
}
catch {
    Write-Output "Error $($_.Exception.Message)"
}