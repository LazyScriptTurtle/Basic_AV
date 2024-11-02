# Function to create the necessary directories for BasicAV
function CreateCatalogs {
    # Define the main path where the directories will be created
    $mainPath = Join-Path $env:ProgramFiles "BasicAV"
    
    # Define the primary subdirectories to create
    $subDirectories = @("Scripts", "Definitions", "Logs")
    
    try {
        # Check if the main directory exists; if not, create it
        if (-Not (Test-Path -Path $mainPath)) {
            New-Item -Path $mainPath -ItemType Directory -ErrorAction Stop
            Write-Host "Main directory $mainPath has been created."
        } else {
            Write-Host "Main directory $mainPath already exists."
        }

        # Create the primary subdirectories
        foreach ($directory in $subDirectories) {
            $path = Join-Path $mainPath $directory
            
            if (-Not (Test-Path -Path $path)) {
                New-Item -Path $path -ItemType Directory -ErrorAction Stop
                Write-Host "Directory $path has been created."
            } else {
                Write-Host "Directory $path already exists."
            }
        }

        # Create the 'Quarantine' subdirectory within 'Scripts'
        $quarantinePath = Join-Path $mainPath "Scripts\Quarantine"
        if (-Not (Test-Path -Path $quarantinePath)) {
            New-Item -Path $quarantinePath -ItemType Directory -ErrorAction Stop
            Write-Host "Directory $quarantinePath has been created."
        } else {
            Write-Host "Directory $quarantinePath already exists."
        }

        # Create the 'Scan_Results' directory within 'Definitions'
        $scanResultsPath = Join-Path $mainPath "Definitions\Scan_Results"
        if (-Not (Test-Path -Path $scanResultsPath)) {
            New-Item -Path $scanResultsPath -ItemType Directory -ErrorAction Stop
            Write-Host "Directory $scanResultsPath has been created."
        } else {
            Write-Host "Directory $scanResultsPath already exists."
        }

        # Create the 'Results' and 'Main' directories within 'Scan_Results'
        $resultsSubDirectories = @("Results", "Main")
        foreach ($subDir in $resultsSubDirectories) {
            $subPath = Join-Path $scanResultsPath $subDir
            if (-Not (Test-Path -Path $subPath)) {
                New-Item -Path $subPath -ItemType Directory -ErrorAction Stop
                Write-Host "Directory $subPath has been created."
            } else {
                Write-Host "Directory $subPath already exists."
            }
        }

    } catch {
        # Output an error message if something goes wrong
        Write-Host "An error occurred: $_"
    }
}
CreateCatalogs
# SIG # Begin signature block
# MIIFjQYJKoZIhvcNAQcCoIIFfjCCBXoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUXBwN5KLmLiLATCLku8/mnWLj
# 0JygggMnMIIDIzCCAgugAwIBAgIQejcWDk/lGK5MdcpcyZxgBjANBgkqhkiG9w0B
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
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBT/YE6osSLqHmqwzXw06ItdxSfd4DAN
# BgkqhkiG9w0BAQEFAASCAQANITDqUfcvDZ++yNWN5SGhFI68XN849WpsYPehnk/q
# 7B5/zJotAefObRo1W7yUyLKz6t520xsOD2zb2r/avIU4CZScT4HDzPPopluWZQaY
# p8W7gFUY8y3AO3+YgpNPCh4qXI6JJW2futwFUeUgS20VYvJZXlUcv/6rJLz9qNNF
# 14EGlFpcxpgXZSg3Gui9hIJ3VGl6HCaWnhc/eysu539LslBTZ8vcWM5Cyf9xqjlL
# cnQvHeY8IpN4uQ5QFvtWafZ5aan+eyAKVKjAJivfbQWMmEnRHgdsZmc0EKdlDvV+
# CT0vmPECHDYO7swVGuSuXD8iIfexGR0PM1ZH/XY40RkE
# SIG # End signature block
