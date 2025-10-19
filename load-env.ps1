# PowerShell script to load environment variables from .env file
# Usage: .\load-env.ps1 [optional-env-file-path]

param(
    [string]$EnvFile = ".env",
    [switch]$ShowValues = $false,
    [switch]$Quiet = $false
)

if (-not $Quiet) {
    Write-Host "Loading environment variables from $EnvFile..." -ForegroundColor Green
}

# Check if .env file exists
if (-not (Test-Path $EnvFile)) {
    Write-Error "Environment file '$EnvFile' not found!"
    exit 1
}

# Array to store loaded variable names
$loadedVars = @()

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
        $loadedVars += $key
        
        if (-not $Quiet) {
            Write-Host "✓ Set $key" -ForegroundColor Yellow
        }
    }
}

if (-not $Quiet) {
    Write-Host ""
    Write-Host "Environment variables loaded successfully!" -ForegroundColor Green
    Write-Host "Total variables loaded: $($loadedVars.Count)" -ForegroundColor Cyan
    Write-Host ""
    
    if ($loadedVars.Count -gt 0) {
        Write-Host "Loaded variables:" -ForegroundColor Cyan
        foreach ($varName in $loadedVars) {
            $value = [Environment]::GetEnvironmentVariable($varName, "Process")
            
            # Mask sensitive variables (API keys, passwords, secrets, tokens)
            if ($varName -match "(API_KEY|PASSWORD|SECRET|TOKEN|KEY)" -and -not $ShowValues) {
                $maskedValue = if ($value) { "●" * [Math]::Min($value.Length, 20) } else { "Not set" }
                Write-Host "  - ${varName}: $maskedValue" -ForegroundColor Gray
            } else {
                $displayValue = if ($value) { $value } else { "Not set" }
                Write-Host "  - ${varName}: $displayValue" -ForegroundColor White
            }
        }
        
        if ($loadedVars | Where-Object { $_ -match "(API_KEY|PASSWORD|SECRET|TOKEN|KEY)" }) {
            Write-Host ""
            Write-Host "Note: Sensitive values are masked. Use -ShowValues to display actual values." -ForegroundColor DarkYellow
        }
    }
}