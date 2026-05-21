# DataCamp Projects Download & Sync Guide

## Overview
This guide helps you download all 40 DataCamp projects and automatically organize them into your GitHub portfolio repositories.

## Quick Reference - Project IDs & Names

| Project Name | Project ID | Language |
|---|---|---|
| Getting a Good Night's Sleep | 2030 | Python |
| Analyzing Unicorn Companies | 1531 | SQL |
| Cleaning Bank Marketing Campaign Data | 1613 | Python |
| Word Frequency in Moby Dick | 1633 | Python |
| When Was the Golden Era of Video Games? | 2485 | SQL |
| Predicting Credit Card Approvals | 1908 | Python |
| Building Financial Reports | 1857 | Python |

## Download Process

### Option A: Manual Download from DataCamp
1. Visit project: `https://app.datacamp.com/learn/projects/[PROJECT_ID]`
2. Click **"Continue Project"** to open DataLab
3. In DataLab, use keyboard shortcut **`Ctrl+S`** (Windows) or **`Cmd+S`** (Mac) to save
4. Or use **Browser's Developer Tools** (F12) → Storage/IndexedDB to export notebook data
5. Save file to: `C:\Users\[YourUsername]\Downloads\[project-name].ipynb`

### Option B: Fastest Method - Browser DevTools
1. Open project in DataLab
2. Press **F12** to open Developer Tools
3. Go to **Application** → **IndexedDB** → Search for notebook content
4. Copy notebook JSON and convert to `.ipynb` format
5. Save to Downloads folder

### Option C: Alternative - Export via API
DataCamp DataLab projects are typically saved as JSON in browser storage. Use this PowerShell snippet to extract:

```powershell
# Extract notebook from browser storage and convert to .ipynb
# (Requires manual browser Developer Tools access)
```

## File Organization

Once downloaded, files should be placed in Downloads folder with this naming pattern:
```
C:\Users\[YourUsername]\Downloads\
├── getting-a-good-nights-sleep-notebook.ipynb
├── getting-a-good-nights-sleep-data.csv
├── analyzing-unicorn-companies-notebook.ipynb
└── ...
```

## Automation Script

After files are in Downloads, run:
```powershell
cd C:\GitHub\portfolio
.\sync_datacamp_projects.ps1
```

The script will:
- Detect `.ipynb` and `.csv` files
- Move them to correct project folders
- Create `README.md` for each project
- Commit and push to GitHub automatically

## Project Directory Structure After Sync

Each project repository should have this structure:
```
C:\GitHub\[project-name]\
├── .github/
│   └── workflows/
│       └── tests.yml
├── notebooks/
│   └── analysis.ipynb              ← Downloaded from DataCamp
├── data/
│   └── project-data.csv            ← Downloaded from DataCamp
├── scripts/
│   └── preprocessing.py
├── output/
│   └── results.csv
├── .gitignore
├── README.md                        ← Auto-generated
└── requirements.txt
```

## Batch Download Workflow

### Recommended Schedule:
**Batch 1 (Python projects):** 5-7 projects/day
**Batch 2 (SQL projects):** 3-5 projects/day  
**Batch 3 (Advanced projects):** 2-3 projects/day
**Total time:** ~2-3 weeks for all 40 projects

### Batch Download Steps:
1. Open 3-5 projects in DataCamp
2. Save each using Ctrl+S or DevTools method
3. Place all files in Downloads folder
4. Run automation script once per day
5. Review GitHub commits and merged files

## Troubleshooting

### Problem: Notebook won't export
**Solution:** Use browser console to extract notebook:
```javascript
// In browser console (F12):
// Look for project data in Application > IndexedDB > notebooks
// Copy the JSON structure and save as .ipynb
```

### Problem: CSV files missing
**Solution:** Download manually from project Resources tab:
1. Go to project Resources section
2. Click dataset download link
3. Save to Downloads folder

### Problem: Script not finding files
**Solution:** Verify file naming:
- Use hyphens for spaces: `my-project.ipynb` ✓
- Use lowercase names ✓  
- Place directly in Downloads folder (not subfolder) ✓

## Complete Project List (All 40)

### Python Projects (20+)
- Getting a Good Night's Sleep
- Cleaning Bank Marketing Campaign Data
- Word Frequency in Moby Dick
- Predicting Credit Card Approvals
- Building Financial Reports
- Analyzing Crime in Los Angeles
- Performing a Code Review
- Predicting Movie Rental Durations
- Investigating Netflix Movies
- And 11 more...

### SQL Projects (8+)
- Analyzing Unicorn Companies
- When Was the Golden Era of Video Games?
- Analyze International Debt Statistics
- Exploring London's Travel Network
- And 4 more...

### Advanced/ML Projects (10+)
- Hypothesis Testing in Healthcare
- Clustering Antarctic Penguin Species
- Building a Retail Data Pipeline
- Assessing Customer Churn Using Machine Learning
- And 6 more...

## GitHub Integration

After sync, each project automatically:
- ✅ Commits to individual repository
- ✅ Pushes to GitHub
- ✅ Updates portfolio index
- ✅ Publishes to GitHub Pages

Monitor commits at: `https://github.com/ParseANull/[project-name]/commits`

## Next Steps

1. **This week:** Download first 5 projects and test sync script
2. **Next week:** Download 10 more projects in batches
3. **Following weeks:** Complete remaining 25 projects at comfortable pace
4. **Final step:** Review portfolio site and add project descriptions
