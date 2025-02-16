function File-Extensions {
    param(
        [string]$FolderPath
    )

    function Get-FileType {
        param (
            [string]$FilePath
        )


        $fileName = Split-Path $FilePath -Leaf
        if ($fileName -match '^[^.]+\.[^.]+\..+$') {
            Write-Warning "Suspicious File Extension: $fileName"
            try {
                New-BurntToastNotification -Text "!!! Suspicious File !!!", $fileName
            } catch {
                Write-Warning "Error"
            }
        }


        $stream = [System.IO.File]::OpenRead($FilePath)
        $reader = New-Object System.IO.BinaryReader($stream)


        $bytes = $reader.ReadBytes(8)
        $reader.Close()
        $stream.Close()


        $hex = ($bytes | ForEach-Object { $_.ToString("X2") }) -join ' '


        switch -Wildcard ($hex) {
            "25 50 44 46 *" { return "PDF" }               # PDF
            "FF D8 FF *"    { return "JPEG/JPG" }          # JPEG/JPG
            "89 50 4E 47 *" { return "PNG" }              # PNG
            "50 4B 03 04 *" { return "ZIP" }              # ZIP
            "4D 5A *"       { return "EXE" }              # EXE (Windows)
            "23 21 2F 62 69 6E 2F 62" { return "Script" }  # Shebang (#!/bin/bash)
            default {

                $extension = [System.IO.Path]::GetExtension($FilePath).ToLower()
                switch ($extension) {
                    ".ps1"  { return "PowerShell Script" }
                    ".txt"  { return "Text File" }
                    ".csv"  { return "CSV File" }
                    ".py"   { return "Python Script" }
                    ".pyc"  { return "Python Script"}
                    default { return "Unknown" }
                }
            }
        }
    }

    function Scan-Folder {
        param (
            [string]$FolderPath
        )


        $files = Get-ChildItem -Path $FolderPath -Recurse -File

        foreach ($file in $files) {
            $fileType = Get-FileType -FilePath $file.FullName
            Write-Output "$($file.FullName) - File Type: $fileType"
        }
    }


    Scan-Folder -FolderPath $FolderPath
}

