$ErrorActionPreference = "Stop"

$auditRoot = "99_Attachments\Audit"
New-Item -ItemType Directory -Force -Path $auditRoot | Out-Null

$stamp = Get-Date -Format "yyyyMMdd_HHmm"
$reportPath = "$auditRoot\Broken_Links_$stamp.md"

$mdFiles = Get-ChildItem -Recurse -Filter "*.md" | Where-Object {
    $_.FullName -notmatch "\\.obsidian\\"
}

$noteNames = @{}

foreach ($file in $mdFiles) {
    $noteNames[$file.BaseName.ToLower()] = $true
}

$broken = @()

foreach ($file in $mdFiles) {
    $raw = Get-Content -Raw -Encoding UTF8 $file.FullName
    $matches = [regex]::Matches($raw, "\[\[([^\]|#]+)")

    foreach ($m in $matches) {
        $link = $m.Groups[1].Value.Trim()
        $key = $link.ToLower()

        if (-not $noteNames.ContainsKey($key)) {
            $broken += [pscustomobject]@{
                Source = $file.FullName
                Link = $link
            }
        }
    }
}

$lines = @()
$lines += "# Broken Link Audit - $stamp"
$lines += ""
$lines += "Total broken links: $($broken.Count)"
$lines += ""

if ($broken.Count -gt 0) {
    $groups = $broken | Group-Object Link | Sort-Object Count -Descending

    foreach ($g in $groups) {
        $lines += "---"
        $lines += ""
        $lines += "[[$($g.Name)]]"
        $lines += ""
        $lines += "Count: $($g.Count)"
        $lines += ""
        foreach ($item in $g.Group | Select-Object -First 10) {
            $relative = $item.Source.Replace((Get-Location).Path + "\", "")
            $lines += "- Source: $relative"
        }
        $lines += ""
    }
}

$lines += ""
$lines += "Related Concepts"
$lines += "[[Knowledge Management]]"
$lines += "[[Traceability]]"

$lines -join "`r`n" | Set-Content -Encoding UTF8 $reportPath

Write-Host "Broken link audit created:"
Write-Host " - $reportPath"
