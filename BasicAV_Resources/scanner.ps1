





function scanner_module {
    param (
        [string]$Path,
        [int]$Batch,
        [string]$ExcludedPath
    )
    $excludePaths = @("C:\Windows\")
    $excludePaths += $ExludedPath
    $allFiles = Get-ChildItem -Path $Path -Exclude $excludePaths* -File -Recurse -Force -ErrorAction SilentlyContinue
    $allFilesCount = $allFiles.Count
    $total = 0
    $results = @()
    #$diskUtil = Get-Counter | Select-Object -ExpandProperty CounterSamples | Where-Object { $_.Path -like '*\% disk time*' } | Select-Object -ExpandProperty cookedValue


    # if ($diskUtil -gt 50) {
    #     do {
    #         Start-Sleep -Milliseconds 500
    #         $diskUtil = Get-Counter | Select-Object -ExpandProperty CounterSamples | Where-Object { $_.Path -like '*\% disk time*' } | Select-Object -ExpandProperty cookedValue            
    #     } while ($diskUtil -gt 50)
        
    # }
    # else {

        foreach ($file in $allFiles) {
           # if (<#($file.FullName -notcontains $ExcludedPath) -and #> ($file.FullName -notcontains $excludePaths)) {
                try {
            

                    $total += 1
                    $date = Get-Date -Format "dd/MM/yyyy_HH:mm:ss"
                    $result = Get-FileHash -Path $file.FullName -Algorithm MD5 -ErrorAction SilentlyContinue
                    $results += [PSCustomObject]@{
                        Name = $file.Name
                        Path = $file.FullName
                        Hash = if ($result) { $result.Hash } else { Write-Output "Error" }
                        Date = $date
                    }

                    Write-Progress -Activity "Scanning files" -Status "$total/$allFilesCount files processed" -PercentComplete (($total / $allFilesCount) * 100) 
            
            
                }
                catch {
                    Write-Output "Error $($_.Exception.Message)"
                }
            #}
            # else {
            #     continue
            # }
        }
# }


    return $results

}
$date = Get-Date -Format "dd-MM-yyyy_HH-mm-ss"
$mainScanResultsPath = 'C:\Program Files\BasicAV\Definitions\Scan_Results\Main_Scan.json'
$anotherScanResultPath = "C:\Program Files\BasicAV\Definitions\Scan_Results\Another_Scan_$date.json"
$mainDisk = Get-Volume | Select-Object -ExpandProperty DriveLetter
$allResults = @()
try {
    if (Test-Path -Path $mainScanResultsPath) {
        foreach ($disk in $mainDisk) {
            $results = scanner_module -Path $disk":\"
            $allResults += $results
        }
        $results | ConvertTo-Json | Out-File -FilePath $anotherScanResultPath -Encoding utf8
        # Write-Host "2"
    }
    else {
    
        foreach ($disk in $mainDisk) {
            $results = scanner_module -Path $disk":\" 
            $allResults += $results
            #    Write-Host "3"
        }
        $allResults | ConvertTo-Json | Out-File -FilePath $mainScanResultsPath -Encoding utf8
        # Write-Host "4"
    }
}
catch {
    Write-Output "Error $($_.Exception.Message)"
}

