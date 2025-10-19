# PowerShell script to load environment variables from .env file
# Usage: .\load-env.ps1

param(
    [string]$EnvFile = ".env"
)

Write-Host "Loading environment variables from $EnvFile..." -ForegroundColor Green

# Check if .env file exists
if (-not (Test-Path $EnvFile)) {
    Write-Error "Environment file '$EnvFile' not found!"
    exit 1
}

# Read and process each line in the .env file
Get-Content $EnvFile | ForEach-Object {
    $line = $_.Trim()
    
    # Skip empty lines and comments
    if ($line -eq "" -or $line.StartsWith("#")) {
        return
    }
    
    # Split on the first '=' character
    $splitIndex = $line.IndexOf("=")
    if ($splitIndex -gt 0) {
        $key = $line.Substring(0, $splitIndex).Trim()
        $value = $line.Substring($splitIndex + 1).Trim()
        
        # Remove quotes if present
        if ($value.StartsWith('"') -and $value.EndsWith('"')) {
            $value = $value.Substring(1, $value.Length - 2)
        }
        if ($value.StartsWith("'") -and $value.EndsWith("'")) {
            $value = $value.Substring(1, $value.Length - 2)
        }
        
        # Set the environment variable
        [Environment]::SetEnvironmentVariable($key, $value, "Process")
        Write-Host "Set $key" -ForegroundColor Yellow
    }
}

Write-Host "Environment variables loaded successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Loaded variables:" -ForegroundColor Cyan
Write-Host "- OPENAI_API_VERSION: $env:OPENAI_API_VERSION"
Write-Host "- AZURE_OPENAI_ENDPOINT: $env:AZURE_OPENAI_ENDPOINT"
Write-Host "- AZURE_OPENAI_API_KEY: $(if($env:AZURE_OPENAI_API_KEY) { '*' * $env:AZURE_OPENAI_API_KEY.Length } else { 'Not set' })"