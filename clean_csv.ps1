
$files = Get-ChildItem ".\*.csv"

foreach ($file in $files) {
    Write-Host "Processing $($file.Name)..."
    
    # Create a backup
    Copy-Item $file.FullName "$($file.FullName).bak" -Force

    # Read all lines with Default encoding (usually correct for identifying SJIS/local chars)
    $lines = Get-Content $file.FullName -Encoding Default
    
    $cleanedLines = @()
    $emptyRowCount = 0
    $trimmedCount = 0
    
    foreach ($line in $lines) {
        # Check if line is completely empty or just commas
        if ($line -match "^[,]*$") {
            $emptyRowCount++
            continue
        }
        
        # Remove full-width spaces and trim
        # Note: String.Replace covers internal padding too if we want, but user said "empty fields".
        # Safe strategy: Replace full-width space with standard space, then trim?
        # Or just remove full-width space if it is padding.
        # Given '南渡島　　　　', replacing '　' with '' is safe for this dataset.
        $newLine = $line -replace "　", ""
        
        # Also clean up double commas if they resulted from empty fields? No, specific request "Remove empty rows".
        # The prompt "Remove empty fields" might mean "make ,, into ,". But CSV struct depends on commas.
        # We'll just strip the padding.
        
        if ($newLine -ne $line) {
            $trimmedCount++
        }
        $cleanedLines += $newLine
    }
    
    # Write back to file
    $cleanedLines | Set-Content $file.FullName -Encoding Default
    
    Write-Host "  Removed $emptyRowCount empty rows."
    Write-Host "  Trimmed padding in $trimmedCount rows."
    Write-Host "----------------------------------------"
}
