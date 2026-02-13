
try {
    $enc = [System.Text.Encoding]::GetEncoding(932)
}
catch {
    $enc = [System.Text.Encoding]::Default
}

$files = Get-ChildItem ".\20*.csv"
$data = @{}

foreach ($f in $files) {
    if ($f.Name -match "(\d{4})\.csv") {
        $year = $matches[1]
        Write-Host "Processing $year..."
        
        $lines = Get-Content $f.FullName -Encoding Default
        
        $yearData = @()
        
        for ($i = 1; $i -lt $lines.Count; $i++) {
            $line = $lines[$i]
            if ([string]::IsNullOrWhiteSpace($line)) { continue }
            
            try {
                $obj = $line | ConvertFrom-Csv -Header "Code", "Area", "TotalPop", "ElderlyPop", "Doctors", "Hospitals", "Beds", "BedsPsych", "BedsCare", "BedsGeneral"
                
                # Helper script block to clean numbers
                $cleanNum = { param($val) 
                    if ($val -eq "-" -or $null -eq $val) { return 0 }
                    $s = $val -replace ",", "" -replace '"', " "
                    # Check if numeric
                    if ($s -match "^-?[\d\.]+$") { return [double]$s }
                    return 0
                }

                $clean = @{
                    "id"          = $obj.Code
                    "area"        = $obj.Area
                    "totalPop"    = & $cleanNum $obj.TotalPop
                    "elderlyPop"  = & $cleanNum $obj.ElderlyPop
                    "doctors"     = & $cleanNum $obj.Doctors
                    "hospitals"   = & $cleanNum $obj.Hospitals
                    "beds"        = & $cleanNum $obj.Beds
                    "bedsPsych"   = & $cleanNum $obj.BedsPsych
                    "bedsCare"    = & $cleanNum $obj.BedsCare
                    "bedsGeneral" = & $cleanNum $obj.BedsGeneral
                }
                
                if ($clean.totalPop -gt 0) {
                    $clean["agingRate"] = ($clean.elderlyPop / $clean.totalPop) * 100
                }
                else {
                    $clean["agingRate"] = 0
                }

                $yearData += $clean
            }
            catch {
                Write-Host "  Skipping line $i in $year : $_"
            }
        }
        $data[$year] = $yearData
    }
}

$json = $data | ConvertTo-Json -Depth 4 -Compress
$jsContent = "const medicalData = $json;"
[System.IO.File]::WriteAllText(".\data.js", $jsContent, [System.Text.Encoding]::UTF8)

Write-Host "Generated data.js"
