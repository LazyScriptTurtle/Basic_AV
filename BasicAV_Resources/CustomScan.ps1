function Custom-Scan {

    param (
        [Parameter(Mandatory=$true)]
        [String]$customPathToScan
    )
 
    try {
        if ($customPathToScan) {
            $resultCollection = @()
            $itemInPath = Get-ChildItem -Path $customPathToScan -Recurse -ErrorAction SilentlyContinue
            $totalItem = $itemInPath.Count
            $total = 0
            foreach ($item in $itemInPath) {
                $total ++ 
                $hash = Get-FileHash -Algorithm SHA256 -Path $item.FullName -ErrorAction SilentlyContinue
                $resultCollection += ([PSCustomObject]@{
                        Hash          = if ($hash) { $hash.Hash }else { "B/D" }
                        Name          = $item.Name
                        Path          = $item.FullName
                        LastTimeWrite = $item.LastWriteTime
                        CreationTime  = $item.CreationTime
                    })
                Write-Progress -Activity "Scan $item / $item.Directory" -Status " Scanned $total for $totalItem" -PercentComplete (($total / $totalItem) * 100)
            }
            return $resultCollection
        }
        else {
            Write-Host "Wrong Path"
        }
    }
    catch {
        Write-Host "Error $_"
    }
}
