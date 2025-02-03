function Fast-Scan {
    
    $fastPath = @(
        "C:\Windows\System32",  
        "C:\Windows\SysWOW64",  
        "C:\Windows\Temp",  
        "C:\Windows\Prefetch",  
        "C:\Windows\Tasks",  
        "C:\Windows\System32\Tasks",  
        "C:\Windows\System32\drivers\etc",  
        "C:\Windows\System32\wbem",  
        "C:\Windows\System32\config\systemprofile\AppData\Local",  
        "C:\Windows\Installer",  
        "C:\Windows\Fonts",  
        "C:\Windows\debug",  
        "C:\Windows\Offline Web Pages",  
        "C:\Windows\IME",  
        "C:\Windows\Registration",  
        "C:\Windows\Resources",  
        "C:\Windows\WinSxS",  
        "C:\ProgramData",  
        "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup",  
        "C:\Program Files",  
        "C:\Program Files\Common Files",  
        "C:\Program Files (x86)",  
        "C:\Program Files (x86)\Common Files",  
        "C:\Users\%USERNAME%\AppData\Roaming",  
        "C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup",  
        "C:\Users\%USERNAME%\AppData\Local",  
        "C:\Users\%USERNAME%\AppData\Local\Temp",  
        "C:\Users\%USERNAME%\AppData\LocalLow",  
        "C:\Users\%USERNAME%\AppData\Local\Microsoft\Windows\Temporary Internet Files",  
        "C:\Users\%USERNAME%\AppData\Local\Microsoft\Windows\Explorer",  
        "C:\Users\%USERNAME%\AppData\Local\Microsoft\OneDrive",  
        "C:\Users\%USERNAME%\AppData\Local\Microsoft\WindowsApps",  
        "C:\Users\%USERNAME%\AppData\Local\Packages",  
        "C:\Users\%USERNAME%\AppData\Local\MicrosoftEdge",  
        "C:\Users\%USERNAME%\Desktop",  
        "C:\Users\%USERNAME%\Downloads",  
        "C:\Users\%USERNAME%\Documents",  
        "C:\Users\%USERNAME%\Videos",  
        "C:\Users\%USERNAME%\Pictures",  
        "C:\Users\%USERNAME%\Music",  
        "%TEMP%",  
        "%APPDATA%",  
        "%LOCALAPPDATA%",  
        "%WINDIR%",  
        "%PROGRAMFILES%",  
        "%PROGRAMFILES(x86)%",  
        "%USERPROFILE%\Start Menu\Programs\Startup",  
        "%USERPROFILE%\Local Settings\Temp"
    )

    foreach ($path in $fastPath) {
        $itemInPath = Get-ChildItem -Path $path -Recurse -ErrorAction SilentlyContinue
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
            Write-Progress -Activity "Scan $path / $item.Directory" -Status " Scanned $total for $totalItem" -PercentComplete (($total / $totalItem) * 100)
        }
        return $resultCollection
    }
}