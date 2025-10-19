# Simple script to load .env variables
# Usage: .\set-env.ps1 [optional-env-file-path]

param(
    [string]$EnvFile = ".env"
)

if (-not (Test-Path $EnvFile)) {
    Write-Error "Environment file '$EnvFile' not found!"
    exit 1
}

$count = 0
Get-Content $EnvFile | Where-Object { 
    $_.Trim() -ne '' -and -not $_.Trim().StartsWith('#') 
} | ForEach-Object { 
    if ($_.Contains('=')) {
        $key, $value = $_.Split('=', 2)
        $key = $key.Trim()
        $value = $value.Trim().Trim('"').Trim("'")
        [Environment]::SetEnvironmentVariable($key, $value, 'Process')
        Write-Host "✓ $key" -ForegroundColor Green
        $count++
    }
}

Write-Host ""
Write-Host "Loaded $count environment variables from $EnvFile" -ForegroundColor Cyan