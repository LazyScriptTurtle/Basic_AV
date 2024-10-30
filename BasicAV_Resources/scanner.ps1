function scanner {
    param (
        # Input parameter for the main directory path to scan
        [string]$mainPath  
    )

    # Counter for the total number of files processed
    $totalFiles = 0  
    # List to store file details
    $fileList = New-Object System.Collections.Generic.List[Object]  
    
    try {
        # Retrieve files without wildcard patterns to avoid errors
        # Get all files in the directory recursively
        $files = Get-ChildItem -Path $mainPath -File -Recurse -ErrorAction Stop 
        $totalFilesCount = $files.Count  # Count the total number of files found

        foreach ($file in $files) {
            try {
                # Increment the file counter
                $totalFiles += 1  

                # Compute the MD5 hash of the file
                $hash = Get-FileHash $file.FullName -Algorithm MD5 -ErrorAction SilentlyContinue  
                
                $fileList.Add([PSCustomObject]@{
                    # File name
                    Name = $file.Name 
                    # Full path to the file
                    Path = $file.FullName  
                    # Hash value or "No Hash" if not computed
                    Hash = if ($hash) { $hash.Hash } else { "No Hash" }  
                })
                
                # Write-Progress -Activity "Scanning files" -Status "$totalFiles/$totalFilesCount files processed" -PercentComplete (($totalFiles / $totalFilesCount) * 100)  # Progress reporting (commented out)
            }
            catch {
                # Handle errors during file processing
                Write-Output "Error processing $($file.FullName): $($_.Exception.Message)"  
            }
        }

        # Output the total number of files scanned
        Write-Output "Scanned $totalFiles files in $mainPath."  
        # Return the list of scanned files
        return $fileList  
    }
    catch {
        # Handle errors when accessing the directory
        Write-Output "Error scanning directory $mainPath : $($_.Exception.Message)"  
        # Return an empty array on error
        return @()  
    }
}

# Define an array of main paths to scan
$mainPaths = @(
    'D:\Git\'  
)

# Initialize a list to store results from all scanned paths
$allResults = New-Object System.Collections.Generic.List[Object]  

foreach ($mainPath in $mainPaths) {
    # Call the scanner function for each main path
    $result = scanner -mainPath $mainPath  
    if ($result -is [System.Collections.IEnumerable] -and $result.Count -gt 0) {
        # Add the results to the combined results list
        $allResults.AddRange($result)  
        # Output confirmation of added results
        Write-Output "Added results for $mainPath."  
    } else {
        # Handle the case where no valid results were returned
        Write-Output "Error: scanner did not return a valid list of objects for path $mainPath"  
    }
}

if ($allResults.Count -gt 0) {
    # Save results to a JSON file
    $allResults | Select-Object -Property Name, Path, Hash | ConvertTo-Json | Out-File -FilePath Scan_results.json -Encoding UTF8  
    # Output confirmation of file save
    Write-Output "Results saved to Scan_results.json."  
} else {
    # Handle the case where there are no results to save
    Write-Output "No results to save. Check the paths and permissions."  
}
