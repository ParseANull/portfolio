# DataCamp DataLab Export Guide

This guide explains how to export notebooks and datasets from DataCamp DataLab in multiple ways.

## Method 1: Browser Developer Tools (Fastest)

### Step-by-step:

1. **Open the project** in DataCamp DataLab
   - Go to: `https://app.datacamp.com/learn/projects/[PROJECT_ID]`
   - Click "Continue Project"
   
2. **Open DevTools** by pressing `F12`

3. **Extract Notebook Data:**
   - Go to the **"Application"** tab (or **"Storage"** in Firefox)
   - Expand **"Local Storage"** (or **"Session Storage"**)
   - Look for entries with `datacamp.com` domain
   - Find the notebook content (usually a large JSON string)
   - Copy the entire notebook object

4. **Save as .ipynb file:**
   - Create a new file in text editor
   - Paste the JSON data
   - Save as `[project-name].ipynb`
   - Place in Downloads folder

## Method 2: Browser Download (Simple)

### Using Chrome/Edge:

1. **In DataLab**, right-click on the notebook editor
2. Select **"Save Page As"** → `Ctrl+S`
3. Choose location: `C:\Users\[YourUsername]\Downloads\`
4. Save as: `[project-name].ipynb`

### Note:
- This may save the entire webpage as HTML
- Extract the `.ipynb` portion afterward if needed

## Method 3: Keyboard Shortcut (If Available)

1. **In DataLab workspace**, press `Ctrl+S`
2. Browser will try to save current page
3. Save to Downloads folder
4. Rename if needed to match project name

## Method 4: DataCamp Export Feature (If Available)

1. **In DataLab**, look for a menu option:
   - Click **"File"** menu (if visible)
   - Look for **"Download"**, **"Export"**, or **"Save"** option
   - Click to download notebook

2. **For Data Files:**
   - Look for **"Resources"** section in project page
   - Download CSV/data files directly
   - Save to Downloads folder

## Method 5: API/Command Line (Advanced)

### Using cURL (if DataCamp API is accessible):

```bash
# Example: Download specific project
curl -H "Authorization: Bearer [YOUR_TOKEN]" \
     https://api.datacamp.com/projects/[PROJECT_ID]/notebook \
     -o project-notebook.ipynb

# Download dataset
curl -H "Authorization: Bearer [YOUR_TOKEN]" \
     https://api.datacamp.com/projects/[PROJECT_ID]/data \
     -o project-data.csv
```

**Requirements:**
- DataCamp API token (from account settings)
- cURL installed (usually default on Windows 10+)

## Method 6: File Naming Convention for Automation

For the PowerShell sync script to work automatically, name your files:

### Correct Naming (✅):
```
getting-a-good-nights-sleep.ipynb
getting-a-good-nights-sleep.csv
analyzing-unicorn-companies.ipynb
analyzing-unicorn-companies.csv
```

### Incorrect Naming (❌):
```
Getting a Good Night's Sleep.ipynb    ← Use hyphens, not spaces
Project2030.ipynb                      ← Use full project name
analysis.ipynb                         ← Must include project identifier
```

## Step-by-Step Workflow for Batch Downloads

### Example: Download 5 Projects in One Session

1. **Open first project in new tab:**
   - Tab 1: `https://app.datacamp.com/learn/projects/2030`
   - Click "Continue Project"

2. **While loading, open next project:**
   - Tab 2: `https://app.datacamp.com/learn/projects/1531`
   - Click "Continue Project"

3. **Continue for all 5 projects**
   - Have tabs loading simultaneously

4. **Download from each tab:**
   - Tab 1 → Ctrl+S → Name: `project1.ipynb`
   - Tab 2 → Ctrl+S → Name: `project2.ipynb`
   - Tab 3 → Ctrl+S → Name: `project3.ipynb`
   - Tab 4 → Ctrl+S → Name: `project4.ipynb`
   - Tab 5 → Ctrl+S → Name: `project5.ipynb`

5. **Batch rename to proper format:**
   - Use PowerShell script or Windows bulk rename:
   ```powershell
   cd Downloads
   Rename-Item "project1 (1).ipynb" "getting-a-good-nights-sleep.ipynb"
   Rename-Item "project2 (1).ipynb" "analyzing-unicorn-companies.ipynb"
   # ... etc for all projects
   ```

6. **Run sync script:**
   ```powershell
   cd C:\GitHub\portfolio
   .\sync_datacamp_projects.ps1
   ```

## Troubleshooting Export Issues

### Problem: Only HTML file downloads, not .ipynb

**Solution:**
- HTML file contains the notebook in JSON format
- Open HTML in text editor
- Search for `"cells"` field (start of notebook JSON)
- Extract JSON starting from `{` to final `}`
- Save as `.ipynb` file

### Problem: DevTools doesn't show notebook data

**Solution:**
1. Try Firefox instead (sometimes better Local Storage visibility)
2. Check **IndexedDB** in Application tab
3. Look for `datacamp` database
4. Search for notebook collections
5. Export data from there

### Problem: Downloaded file won't open in Jupyter

**Solution:**
- Ensure file extension is `.ipynb`
- Verify it's valid JSON: `python -m json.tool notebook.ipynb`
- If invalid, try Method 2 (HTML extraction) again

### Problem: CSV file not accessible in DataLab

**Solution:**
1. Go back to project description page
2. Look for **"Resources"** section
3. Download CSV directly from there
4. If not available, create minimal sample CSV with column headers

## Automated Batch Download Helper

Save this as `batch_download.ps1`:

```powershell
# Interactive batch downloader
$projects = @(
    "getting-a-good-nights-sleep",
    "analyzing-unicorn-companies",
    # ... add more
)

$baseUrl = "https://app.datacamp.com/learn/projects/"

foreach ($project in $projects) {
    # Get project ID from mapping (you'd need to add this)
    $projectId = 2030  # Example
    $url = "$baseUrl$project"
    
    Write-Host "Opening: $project"
    Write-Host "URL: $url"
    Write-Host "Action: Manually save notebook as: $project.ipynb"
    Write-Host ""
    
    # Uncomment to auto-open in browser:
    # Start-Process $url
    
    Read-Host "Press Enter when you've saved the file..."
}
```

## Complete Download Checklist

- [ ] All 40 project IDs identified
- [ ] Project name to ID mapping created
- [ ] Download folder cleaned (remove old files)
- [ ] Batch 1 (5 projects) downloaded and named correctly
- [ ] PowerShell sync script tested with dry-run: `.\sync_datacamp_projects.ps1 -DryRun`
- [ ] Sync script executed successfully
- [ ] GitHub repositories updated with files
- [ ] Portfolio site updated with commit information
- [ ] Remaining batches scheduled

## Next: Running the Automation Script

After files are downloaded and in Downloads folder:

```powershell
# Navigate to portfolio directory
cd C:\GitHub\portfolio

# Dry run first (see what would happen)
.\sync_datacamp_projects.ps1 -DryRun -MaxProjects 5

# Execute for real (if dry run looks good)
.\sync_datacamp_projects.ps1 -MaxProjects 5

# Process all remaining projects
.\sync_datacamp_projects.ps1
```

## Summary

**Fastest Method:**
- Method 1 (DevTools) + PowerShell script = ~5 minutes per project

**Easiest Method:**
- Method 2 (Ctrl+S) + Batch rename + PowerShell script = ~7 minutes per project

**Most Reliable:**
- Method 5 (API) + Automation = Hands-off after setup

Choose based on your preference and DataCamp account type.
