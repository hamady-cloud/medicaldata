
$files = Get-ChildItem ".\*.csv"
foreach ($file in $files) {
    Write-Host "Analyzing $($file.Name)..."
    $lines = Get-Content $file.FullName
    $totalLines = $lines.Count
    $hyphenCount = 0
    $emptyFieldCount = 0
    $wideSpaceCount = 0
    
    foreach ($line in $lines) {
        if ($line -match ",-,") { $hyphenCount++ }
        if ($line -match ",,") { $emptyFieldCount++ }
        if ($line -match "　") { $wideSpaceCount++ }
    }
    
    Write-Host "  Total Lines: $totalLines"
    Write-Host "  Lines with hyphen (-): $hyphenCount"
    Write-Host "  Lines with empty field (,,): $emptyFieldCount"
    Write-Host "  Lines with wide space (　): $wideSpaceCount"
    Write-Host "----------------------------------------"
}
