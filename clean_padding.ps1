
try {
    $enc = [System.Text.Encoding]::GetEncoding(932)
}
catch {
    $enc = [System.Text.Encoding]::Default
}

$files = Get-ChildItem "c:\Users\hamada\medical\*.csv"

foreach ($f in $files) {
    Write-Host "Checking $($f.Name)..."
    try {
        $text = [System.IO.File]::ReadAllText($f.FullName, $enc)
        
        # Use string replacement for U+3000
        $padChar = [string][char]0x3000
        
        if ($text.Contains($padChar)) {
            Write-Host "  Found full-width spaces. Cleaning..."
            $text = $text.Replace($padChar, "")
            $modified = $true
        }
        else {
            Write-Host "  No full-width spaces found."
            $modified = $false
        }

        # Remove completely empty rows
        $lines = $text -split "\r?\n"
        $validLines = @()
        $emptyRemoved = 0

        foreach ($line in $lines) {
            # Remove lines that are just commas or empty
            if ($line -match "^[,]*$") {
                $emptyRemoved++
                continue
            }
            $validLines += $line
        }

        if ($emptyRemoved -gt 0) {
            Write-Host "  Removed $emptyRemoved additional empty rows."
            $modified = $true
        }

        if ($modified) {
            [System.IO.File]::WriteAllLines($f.FullName, $validLines, $enc)
            Write-Host "  Saved changes."
        }
        
    }
    catch {
        Write-Host "  Error: $_"
    }
    Write-Host "----------------"
}
