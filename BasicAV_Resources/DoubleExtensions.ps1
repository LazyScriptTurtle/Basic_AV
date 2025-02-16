function Double-Extensions {
    param (
        [string]$filePath
    )
    $allFiles = Get-ChildItem -Path $filePath -ErrorAction SilentlyContinue
    foreach ($file in $allFiles.FullName) {
        $fileName = Split-Path $file -Leaf
        if ($fileName -match '^[^.]+\.[^.]+\..+$') {
            New-BurntToastNotification -Text "!!! Suspicious File !!!", $file.Name, $file
            return $true
        }
    }
    return $false
}

