function Set-Scan {
    param (
        [string]$Path
    )

    # Tworzenie obiektu DirectoryInfo
    $directoryInfo = New-Object System.IO.DirectoryInfo($Path)
    $excludedPath = @("System Volume Information", "Documents and Settings")

    # List to store all files
    $allFiles = @()

    try {
        # Using Get-ChildItem to recursively fetch files
        $allFiles = Get-ChildItem -Path $Path -Recurse -File -ErrorAction SilentlyContinue | Where-Object {
            # Exclude directories based on their names
            $excludedPath -notcontains $_.Directory.Name
        }
    }
    catch {
        Write-Warning "An error occurred while scanning the directory: $_"
        return
    }

    $allFilesCount = $allFiles.Count
    $total = 0
    $startTime = Get-Date
    $allResults = @()

    foreach ($file in $allFiles) {
        $total++
        try {
            # Calculate hash for the file
            $hash = Get-FileHash -Path $file.FullName -Algorithm SHA256 -ErrorAction SilentlyContinue
            $result = [PSCustomObject]@{
                Name = $file.Name
                Path = $file.FullName
                Hash = if($hash.Hash){$hash.Hash}else {Continue}
            }
            $allResults += $result
        }
        catch {
            Write-Warning "Failed to access file: $($file.FullName). Error: $_"
            continue
        }

        # Progress
        $percentComplete = ($total / $allFilesCount) * 100

        # Time estimation
        $elapsedTime = (Get-Date) - $startTime
        $estimatedTotalTime = ($elapsedTime.TotalSeconds / $total) * $allFilesCount
        $remainingTime = $estimatedTotalTime - $elapsedTime.TotalSeconds

        # Time format
        $remainingTimeFormatted = [TimeSpan]::FromSeconds($remainingTime)

        # Show progress (update after every 10 files)
        if ($total % 10 -eq 0) {
            Write-Progress -Activity "File Scan" `
                            -Status " $total/$allFilesCount (Time to End: $($remainingTimeFormatted.Hours):$($remainingTimeFormatted.Minutes):$($remainingTimeFormatted.Seconds))" `
                            -PercentComplete $percentComplete
        }
    }

    # Final progress display (when done)
    Write-Progress -Activity "File Scan" -Status "Completed" -PercentComplete 100

    # Return the results
    $allResults
}
