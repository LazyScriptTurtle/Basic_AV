
function CreateCatalogs {

    $mainPath = 'C:\Program Files\BasicAV'
    $subDirectory = @("Scripts", "Quarantine", "Definitions", "Logs")
    $checker = Test-Path $mainPath -ErrorAction SilentlyContinue
    try {
        if ($checker) {
            Write-Host "Main Directory Exist "
        }
        else {
            New-Item -Path $mainPath -ItemType Directory *> $null
            foreach ($directory in $subDirectory) {
            
                if ($directory -ne "Quarantine") {
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

