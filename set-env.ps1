# Simple one-liner to load .env variables
# Usage: .\set-env.ps1

Get-Content .env | Where-Object { $_ -notmatch '^#' -and $_ -ne '' } | ForEach-Object { $key, $value = $_.Split('=', 2); [Environment]::SetEnvironmentVariable($key.Trim(), $value.Trim(), 'Process'); Write-Host "Set $($key.Trim())" -ForegroundColor Green }