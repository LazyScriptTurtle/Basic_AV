function Malware-Search {
    param (
    [Parameter(Mandatory=$true)]
    [string]$hashBase,
    [Parameter(Mandatory=$true)]
    [string]$filePath
    )
    
        if (!(Test-Path $hashBase) -or !(Test-Path $filePath)) {
            Write-Error "Can't find File $hashBase"
            return
        }
        $hashSet = @{}

        Get-Content -Path $hashBase | ForEach-Object { $hashSet[$_] = $true }
        $scanResults = Get-Content -Path $filePath | ConvertFrom-Json
    

        foreach ($hash in $scanResults) {
            $newHash = $hash.Hash
            if ($hashSet.ContainsKey($newHash)) {
                New-BurntToastNotification -Text "!!! Virus detected !!!", $hash.Name, $hash.Path
            }
        }
    }
