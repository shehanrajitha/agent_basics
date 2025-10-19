# agent_basics

## Environment Setup

This project uses Azure OpenAI services and requires environment variables to be configured.

### Prerequisites

- Azure OpenAI resource created in Azure portal
- PowerShell (for Windows users)
- Python 3.7+ (if using Python)

### Environment Variables Configuration

1. **Configure your environment variables:**
   
   Update the `.env` file with your actual Azure OpenAI credentials:
   ```bash
   # The API version you want to use: set this to `2023-12-01-preview` for the released version.
   OPENAI_API_VERSION=2023-12-01-preview
   
   # The base URL for your Azure OpenAI resource. You can find this in the Azure portal under your Azure OpenAI resource.
   AZURE_OPENAI_ENDPOINT=https://your-resource-name.openai.azure.com
   
   # The API key for your Azure OpenAI resource. You can find this in the Azure portal under your Azure OpenAI resource.
   AZURE_OPENAI_API_KEY=<your Azure OpenAI API key>
   ```

   **Important:** Replace the following placeholders:
   - `your-resource-name` with your actual Azure OpenAI resource name
   - `<your Azure OpenAI API key>` with your actual API key from Azure portal

### Loading Environment Variables

#### Option 1: PowerShell (Windows - Recommended)

**Method 1: Using the detailed script**
```powershell
# Set execution policy if needed (run as administrator)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Load environment variables
.\load-env.ps1
```

**Method 2: Using the simple script**
```powershell
.\set-env.ps1
```

**Verify variables are loaded:**
```powershell
echo $env:OPENAI_API_VERSION
echo $env:AZURE_OPENAI_ENDPOINT
echo $env:AZURE_OPENAI_API_KEY
```

#### Option 2: Python (Cross-platform)

If you're using Python, install python-dotenv:
```bash
pip install python-dotenv
```

Then load variables in your Python code:
```python
from dotenv import load_dotenv
import os

# Load environment variables from .env file
load_dotenv()

# Access the variables
api_version = os.getenv('OPENAI_API_VERSION')
endpoint = os.getenv('AZURE_OPENAI_ENDPOINT')
api_key = os.getenv('AZURE_OPENAI_API_KEY')
```

#### Option 3: Manual PowerShell Commands

You can also set variables manually in your PowerShell session:
```powershell
$env:OPENAI_API_VERSION="2023-12-01-preview"
$env:AZURE_OPENAI_ENDPOINT="https://your-resource-name.openai.azure.com"
$env:AZURE_OPENAI_API_KEY="your-api-key-here"
```

### Security Notes

- The `.env` file is included in `.gitignore` to prevent accidental commits of sensitive information
- Never commit API keys or other sensitive credentials to version control
- Environment variables set using PowerShell scripts are only available in the current session

### Troubleshooting

**PowerShell Execution Policy Error:**
If you get an execution policy error, run PowerShell as administrator and execute:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Variables Not Loading:**
- Ensure the `.env` file is in the same directory as the PowerShell scripts
- Check that there are no extra spaces around the `=` signs in the `.env` file
- Verify the `.env` file is saved with UTF-8 encoding

**Finding Your Azure OpenAI Credentials:**
1. Go to [Azure Portal](https://portal.azure.com)
2. Navigate to your Azure OpenAI resource
3. Go to "Keys and Endpoint" section
4. Copy the endpoint URL and one of the API keys
