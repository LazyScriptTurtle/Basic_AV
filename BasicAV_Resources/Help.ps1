function Get-BasicAvHelp {
    Write-Host "Basic Antivirus - User Manual" -ForegroundColor Green
    Write-Host "Description:" -ForegroundColor DarkBlue
    Write-Host "Basic Antivirus (BasicAV) is a simple antivirus scanner written in PowerShell."
    Write-Host "It allows users to perform different types of scans to detect potentially harmful software."
    Write-Host ""
    Write-Host "|===================|"-ForegroundColor Green
    Write-Host "| Available Options |" -ForegroundColor Green
    Write-Host "|===================|"-ForegroundColor Green
    Write-Host "- Full Scan" -ForegroundColor DarkBlue
    Write-Host "Performs a deep scan of the entire system to detect threats."
    Write-Host "Results are saved in the Full_Scan_Result.json file."
    Write-Host ""

    Write-Host "- Custom Scan" -ForegroundColor DarkBlue
    Write-Host "Allows scanning of a specific folder or location specified by the user."
    Write-Host "The user must manually enter the path to scan."
    Write-Host ""

    Write-Host "- Fast Scan" -ForegroundColor DarkBlue
    Write-Host "Performs a quick scan of critical system locations to detect potential threats."
    Write-Host "Faster than a full scan but may not detect all threats."
    Write-Host ""

    Write-Host "- Malware Search" -ForegroundColor DarkBlue
    Write-Host "Searches for known malware signatures in the system."
    Write-Host "Uses predefined malware signatures or patterns for detection."
    Write-Host ""

    Write-Host "- Magic Numbers" -ForegroundColor DarkBlue
    Write-Host "Analyzes file headers and magic numbers to identify potentially harmful files."
    Write-Host "Useful for detecting suspicious or disguised files."
    Write-Host ""

    Write-Host "6-9. (Not yet implemented)" -ForegroundColor Yellow
    Write-Host ""

    Write-Host "- Help" -ForegroundColor DarkBlue
    Write-Host "Displays this help menu with descriptions of all available options."
    Write-Host ""

    Write-Host "Usage:"
    Write-Host "Run the script in PowerShell."
    Write-Host "Select an option by entering the corresponding number."
    Write-Host "Follow on-screen instructions for scans requiring user input."
}
