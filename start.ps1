
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
# SIG # Begin signature block
# MIIFjQYJKoZIhvcNAQcCoIIFfjCCBXoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU5d60JUwPgrmiYICKKPIzc4wp
# axigggMnMIIDIzCCAgugAwIBAgIQejcWDk/lGK5MdcpcyZxgBjANBgkqhkiG9w0B
# AQUFADAbMRkwFwYDVQQDDBBMYXp5U2NyaXB0VHVydGxlMB4XDTI0MTAzMTA5MjQx
# M1oXDTM0MTAzMTA5MzQxM1owGzEZMBcGA1UEAwwQTGF6eVNjcmlwdFR1cnRsZTCC
# ASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAJz6d43WDjnR+UHWBVK990vf
# Up1YotDErRDEsL07VFlLf/P/iljrZDOesqRFadcK87fmrFBsHQge1bqQPYie/BRn
# CtmuqgUBRK5eIlhLYQBmjncuCHL/qcASzgrT9WmivEyJD5Yt3PeISJOOWWYOU8bj
# xCWbHeeTwvGXFTFYfD9+T1p3dPsJ+d1xkVxnQe7JECjE3IPbycLZhxnJxNH2DpVH
# GAeN8KGG+KcxuJtnzpwA2O3kQIbFZsl4fGZ9uOBPqFhu4g29jtLEk3b1byBkDOcA
# dkB4i5fHrVnSs6trsnG5H/5NrVYvj7tMdCeJnwzLB4w7yxCaR4UYRdq6MVKQ4v0C
# AwEAAaNjMGEwDgYDVR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoGCCsGAQUFBwMDMBsG
# A1UdEQQUMBKCEExhenlTY3JpcHRUdXJ0bGUwHQYDVR0OBBYEFABN6yQfpg4TB5Mw
# 5+vLgebC9tGvMA0GCSqGSIb3DQEBBQUAA4IBAQAePqOzciA9Bi5vBjEXxdmJkWHs
# A/PZuaD7esJh5c7MVW15QUKGIy7OsdD2pXpkhSsHNUO/n7If8VRyChSfzs/owwZY
# WvJyxWHtGUDi+zY6Tk4QvePO2vlA7UTprygQAozcsN/PWZ1oQWnoMWSmHB5iQkvF
# bj1abLLD++x8RJWjFbIw6s9vNEQcO/IlgPGWBct4gtPdPEYYfNM0igBDl6ZGz2yz
# OCmehnF/Hk28DlaW7OK4TRJTgXt40wEfWrZUWO6Z839HcdQ/C+P5dJ2Ts6PZ09B3
# Gl0qm2icfLP2vZtGJkg1Uh3k1RZ+X7ETSN+XFq8VCQtOOodKxPBLp7tNYQe0MYIB
# 0DCCAcwCAQEwLzAbMRkwFwYDVQQDDBBMYXp5U2NyaXB0VHVydGxlAhB6NxYOT+UY
# rkx1ylzJnGAGMAkGBSsOAwIaBQCgeDAYBgorBgEEAYI3AgEMMQowCKACgAChAoAA
# MBkGCSqGSIb3DQEJAzEMBgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgor
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBQZYs4USsJt8DV10CrSbPeOgrBrHDAN
# BgkqhkiG9w0BAQEFAASCAQCaoFq2LnL16sT6h9LHjRrdHgrPLAROKCc3eYyWDw3a
# loKCbNKR82K3/c3XJxqIT5kHTKiblXrgkoIh6FIltifit0ow1mWruXMwmLEelc7k
# oyDbcex4ZNTQIzVthdR1min+9Km3rcb59v/b4xLMggU1uAmQyaoRRazlzeMkPj7L
# w492FHox6HkWt7QIYEBDPqtUShDEZAEQCvRhyANyfiLHy41T6i4DhC7ZtFebOCkx
# TopqwDMHIb5qcNznuE8e2ThkXhCRCK8JRhLkCXSpD6Qab30qYlCsR9Y8id41+1bU
# bsiqz8G8g6AKYm60AB6MVPSFyxSACWNp8a8NWiAoNDb9
# SIG # End signature block
