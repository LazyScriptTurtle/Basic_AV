function Full-Scan {

    # Add-Type -AssemblyName "System.Windows.Forms"

    $resultCollection = @()
    $driveList = Get-Volume | Select-Object -ExpandProperty DriveLetter
    foreach ($drive in $driveList) {
        #[System.Windows.Forms.MessageBox]::Show("Collecting item from $drive", "Informacja")
        $itemOnDrive = Get-ChildItem -Path "$drive`:\" -Recurse -ErrorAction SilentlyContinue
        $totalItem = $itemOnDrive.Count
        $total = 0
        foreach ($item in $itemOnDrive) {
            $total ++ 
            $hash = Get-FileHash -Algorithm SHA256 -Path $item.FullName -ErrorAction SilentlyContinue
            $resultCollection += ([PSCustomObject]@{
                    Hash          = if ($hash) { $hash.Hash }else { "B/D" }
                    Name          = $item.Name
                    Path          = $item.FullName
                    LastTimeWrite = $item.LastWriteTime
                    CreationTime  = $item.CreationTime
                })
            Write-Progress -Activity "Scan $drive / $item.Directory" -Status " Scanned $total for $totalItem" -PercentComplete (($total / $totalItem) * 100)
        }
        return $resultCollection
    }

}

