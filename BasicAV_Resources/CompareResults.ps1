function Compare-Results {
    param (
        [string]$FirstPath,
        [string]$SecondPath,
        [string]$mainScanResultsPath
    )
    
    # Read the contents of the first JSON file
    $firstJsonContent = Get-Content -Path $FirstPath | ConvertFrom-Json
    # Read the contents of the second JSON file
    $secondJsonContent = Get-Content -Path $SecondPath | ConvertFrom-Json
    # Initialize an array to store results
    $allResults = @()

    # Find items that are in the first JSON but not in the second
    foreach ($item in $firstJsonContent) {
        $match = $secondJsonContent | Where-Object { 
            ($_.Path -eq $item.Path) -or (($_.Name -eq $item.Name) -and ($_.Hash -eq $item.Hash)) 
        }
        if (-not $match) {
            $allResults += $item
        }
    }

    # Find items that are in the second JSON but not in the first
    foreach ($item in $secondJsonContent) {
        $match = $firstJsonContent | Where-Object { 
            ($_.Path -eq $item.Path) -or (($_.Name -eq $item.Name) -and ($_.Hash -eq $item.Hash)) 
        }
        if (-not $match) {
            $allResults += $item
        }
    }

    # Return the results as output
    return $allResults
}
