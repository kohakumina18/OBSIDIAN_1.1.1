$ErrorActionPreference = "Stop"

$backupRoot = "99_Attachments\Backups"
New-Item -ItemType Directory -Force -Path $backupRoot | Out-Null

$vaultName = Split-Path (Get-Location).Path -Leaf
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$zipPath = "$backupRoot\${vaultName}_backup_$stamp.zip"

$tempRoot = Join-Path $env:TEMP "${vaultName}_backup_$stamp"

if (Test-Path $tempRoot) {
    Remove-Item -Recurse -Force $tempRoot
}

New-Item -ItemType Directory -Force -Path $tempRoot | Out-Null

Get-ChildItem -Force | Where-Object {
    $_.Name -notin @(".obsidian", ".git")
} | ForEach-Object {
    Copy-Item $_.FullName -Destination $tempRoot -Recurse -Force
}

Compress-Archive -Path "$tempRoot\*" -DestinationPath $zipPath -Force

Remove-Item -Recurse -Force $tempRoot

Write-Host "Vault backup created:"
Write-Host " - $zipPath"
