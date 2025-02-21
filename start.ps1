Write-Host "Importing Functions ..." -ForegroundColor Blue

$scriptPaths = @(
    ".\BasicAV_Resources\FullScan.ps1",
    ".\BasicAV_Resources\FastScan.ps1",
    ".\BasicAV_Resources\CustomScan.ps1",
    ".\BasicAV_Resources\MagicNumbers.ps1",
    ".\BasicAV_Resources\MalwareSearch.ps1",
    ".\BasicAV_Resources\Help.ps1"
)


$importSuccess = $true

foreach ($script in $scriptPaths) {
    sleep -Milliseconds 500
    if (Test-Path $script) {
        try {
            . $script
            $scriptName = Split-Path $script -Leaf
            Write-Host " Imported: $scriptName" -ForegroundColor Green
        } catch {
            Write-Host " ERROR: Failed to import $scriptName" -ForegroundColor Red
            $importSuccess = $false
        }
    } else {
        Write-Host " ERROR: File not found - $scriptName" -ForegroundColor Red
        $importSuccess = $false
    }
}

if ($importSuccess) {
    Write-Host "All functions imported successfully!" -ForegroundColor Green
} else {
    Write-Host "Some functions failed to import. Please check the errors above." -ForegroundColor Red
}

Start-Sleep -Seconds 3
Clear-Host

do {
Clear-Host
Write-Host '  //===============================\\ '
Write-Host ' //  '-NoNewline
Write-Host '        Basic Antivirus' -ForegroundColor Green -NoNewline
Write-Host '        \\'
Write-Host '//===================================\\'
Write-Host '|| 1. Full Scan      | 6.  X         ||' 
Write-Host '||                   |               ||'
Write-Host '|| 2. Custom Scan    | 7.  X         ||' 
Write-Host '||                   |               ||'
Write-Host '|| 3. Fast Scan      | 8.  X         ||' 
Write-Host '||                   |               ||'
Write-Host '|| 4. Malware Search | 9.  X         ||' 
Write-Host '||                   |               ||'
Write-Host '|| 5. Magic Numbers  | 10. Help      ||' 
Write-Host '||                   |               ||'
Write-Host '\\===================================//'
$choice = Read-Host ' Choose your option: '

switch ($choice) {
    1 {
        $date = Get-Date -Format "dd_MM_yyyy-HH_mm_ss"
        if (Test-Path ".\Full_Scan_Result.json") {
            Rename-Item ".\Full_Scan_Result.json" -NewName "Full_Scan_Result_old_$date.json"
            Write-Host "Old Full_Scan_Result.json renamed to Full_Scan_Result_old_$date.json" -ForegroundColor Yellow
        }
        $fullScanResults = Full-Scan
        $fullScanResults | ConvertTo-Json -Depth 10 | Out-File -FilePath .\Full_Scan_Result.json -Encoding utf8
        
        $resolvePath = Resolve-Path .\Full_Scan_Result.json
        Write-Host "Full Scan Results : $resolvePath" -ForegroundColor Green
    }
    
    2 {
        $path = Read-Host "Specify path"
        Custom-Scan -customPathToScan $path
    }
    
    3 {
        Fast-Scan
    }
    
    4 {
        Malware-Search
    }
    
    10 {
        Get-BasicAvHelp
        Write-Host " "
        Write-Host "Press Enter to return to the main menu..." -ForegroundColor Red
        Read-Host
        Clear-Host
    }

    Default {
        Write-Host "Invalid selection, please try again." -ForegroundColor Red
    }
}
 } while ($true)
