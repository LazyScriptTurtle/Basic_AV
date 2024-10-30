
function CreateCatalogs {

    $mainPath = 'C:\Program Files\BasicAV'
    $subDirectory = @("Scripts", "Quarantine", "Definitions", "Logs", "Scan_Results")
    $checker = Test-Path $mainPath -ErrorAction SilentlyContinue
    try {
        if ($checker) {
            Write-Host "Main Directory Exist "
            $allDirectories = Get-ChildItem -Path $mainPath -Directory
            foreach($dir in $allDirectories)
            {
                Test-Path -Path $dir
            }
        }
        else {
            New-Item -Path $mainPath -ItemType Directory *> $null
            foreach ($directory in $subDirectory) {
            
                if ($directory -ne "Quarantine" -and $directory -ne "Scan_Results") {
                    $path = "$mainPath\$directory"
                    $pathChecker = Test-Path -Path $path -ErrorAction SilentlyContinue
                    #Write-Host "1 $path" # Debug
                    if ($pathChecker -eq $false) {
                        New-Item -Path $path -ItemType Directory -ErrorAction SilentlyContinue *> $null
                        Write-Host "$path Created"
                        # Write-Host "2 $path" #Debug
                    }
                    else {
                        Write-Host "Directory Exist or check Permissions"
                    }
                }
                elseif ($directory -eq "Quarantine" -and (Test-Path -Path "$mainPath\Scripts\")) {
                    $path = "$mainPath\Scripts\$directory"
                    New-Item -Path $path -ItemType Directory -ErrorAction SilentlyContinue *> $null
                    Write-Host "$path Created"
                }
                elseif ($directory -eq "Scan_Results" -and (Test-Path -Path "$mainPath\Definitions\")) {
                    $path = "$mainPath\Definitions\$directory"
                    New-Item -Path $path -ItemType Directory -ErrorAction SilentlyContinue *> $null
                    Write-Host "$path Created"
                }
                else {
                    Write-Host "Directory Exist or check Permissions"
                }
            }
        }  
    }
    catch {
        Write-Host "Error $_"
    }
}

CreateCatalogs