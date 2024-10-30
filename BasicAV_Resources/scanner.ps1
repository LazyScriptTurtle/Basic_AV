





function scanner_module {
    param (
        [string]$Path
    )
    $exludePaths = @("C:\Windows\")
    $allFiles = Get-ChildItem -Path $Path -File -Recurse -Force -ErrorAction SilentlyContinue
    $allFilesCount = $allFiles.Count
    $total = 0
    $results = @()
    $diskUtil = Get-Counter | Select-Object -ExpandProperty CounterSamples | Where-Object { $_.Path -like '*\% disk time*' } | Select-Object -ExpandProperty cookedValue

    if ($diskUtil -gt 50) {
        do {
            Start-Sleep -Milliseconds 500
            $diskUtil = Get-Counter | Select-Object -ExpandProperty CounterSamples | Where-Object { $_.Path -like '*\% disk time*' } | Select-Object -ExpandProperty cookedValue            
        } while ($diskUtil -gt 50)
        
    }
    else {

        foreach ($file in $allFiles) {
            if ($file -notcontains $exludePaths) {
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

                    Write-Progress -Activity "Scanning files" -Status "$total/$allFilescount files processed" -PercentComplete (($total / $allFilesCount) * 100) 
               
                }
            
            
                catch {
                    Write-Output "Error $($_.Exception.Message)"
                }
            }
            else {
                continue
            }
        }
    }


    return $results

}
$date = Get-Date -Format "dd-MM-yyyy_HH-mm-ss"
$mainScanResultsPath = 'C:\Program Files\BasicAV\Definitions\Scan_Results\Main_Scan.json'
$anotherScanResultPath = "C:\Program Files\BasicAV\Definitions\Scan_Results\Another_Scan_$date.json"
# $mainDisk = Get-Volume | Select-Object -ExpandProperty DriveLetter
try {
if (Test-Path -Path $mainScanResultsPath) {
    Write-Host "1"
    #foreach($disk in $mainDisk){
    $results = scanner_module -Path "D:\Winrar"
    #}
    $results | ConvertTo-Json | Out-File -FilePath $anotherScanResultPath -Encoding utf8
    Write-Host "2"
}
else {
    
   # foreach ($disk in $mainDisk) {
        $results = scanner_module -Path "D:\Winrar" #$disk":\"
        Write-Host "3"
   # }
   $results | ConvertTo-Json | Out-File -FilePath $mainScanResultsPath -Encoding utf8
   Write-Host "4"
}
}
catch {
    Write-Output "Error $($_.Exception.Message)"
}

