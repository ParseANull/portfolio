# 🚀 Quick Start Guide - DataCamp Portfolio Automation

**Time to read:** 5 minutes  
**Time to complete first project:** 15-20 minutes

## What You'll Have
✅ Automated system to download and organize 40 DataCamp projects  
✅ Individual GitHub repositories for each project  
✅ Live portfolio website at https://parseanull.github.io/portfolio/  
✅ Professional data science showcase  

## 5-Minute Setup

### 1. Validate Everything Works (2 min)
```powershell
cd C:\GitHub\portfolio
.\validate_portfolio.ps1
```
**Should see:** ✅ checkmarks for 40 projects, documentation, GitHub Pages

### 2. Test the Automation (3 min)
```powershell
.\sync_datacamp_projects.ps1 -DryRun -MaxProjects 3
```
**Should see:** "DRY RUN MODE - No files will be modified" + summary stats

---

## Download Your First Project (10 minutes)

### Step 1: Open DataCamp (1 min)
```
1. Go to: https://app.datacamp.com/learn/projects/2030
2. Click: "Continue Project" button
3. Wait for DataLab workspace to load
```

### Step 2: Save the Notebook (3 min)
**Best Method (Ctrl+S):**
```
1. Press: Ctrl+S (or Cmd+S on Mac)
2. Browser will open "Save As" dialog
3. Save to: C:\Users\[YourUsername]\Downloads\
4. Filename: getting-a-good-nights-sleep.ipynb
```

**Alternative Method (DevTools):**
- Press F12 to open Developer Tools
- Go to "Application" tab
- Find notebook JSON in Local Storage
- Copy and save as `.ipynb` file

See [EXPORT_FROM_DATALAB.md](EXPORT_FROM_DATALAB.md) for 5 more methods

### Step 3: Get the Data (2 min)
```
1. Go back to project page: https://app.datacamp.com/learn/projects/2030
2. Look for Resources/Downloads section
3. Download: sleep_health_data.csv
4. Save to: C:\Users\[YourUsername]\Downloads\
5. Rename to: getting-a-good-nights-sleep.csv
```

### Step 4: Run the Sync Script (4 min)
```powershell
cd C:\GitHub\portfolio
.\sync_datacamp_projects.ps1
```

**What happens automatically:**
- ✅ Detects your files in Downloads
- ✅ Moves .ipynb to `getting-a-good-nights-sleep/notebooks/`
- ✅ Moves .csv to `getting-a-good-nights-sleep/data/`
- ✅ Commits to GitHub
- ✅ Pushes to your repository
- ✅ Updates GitHub Pages portfolio

### Step 5: Verify Success (1 min)
```powershell
# Check GitHub
cd C:\GitHub\getting-a-good-nights-sleep
git log --oneline -3

# Or visit:
# https://github.com/ParseANull/getting-a-good-nights-sleep
# https://parseanull.github.io/portfolio/
```

---

## 🎯 Your First Complete Workflow

**Total Time: ~15 minutes**

```powershell
# Terminal 1: Monitor
cd C:\GitHub\getting-a-good-nights-sleep
git log --follow --oneline

# Terminal 2: Run sync
cd C:\GitHub\portfolio
.\sync_datacamp_projects.ps1

# Browser: Verify
# 1. GitHub repo: https://github.com/ParseANull/getting-a-good-nights-sleep
# 2. Portfolio: https://parseanull.github.io/portfolio/
# 3. Commit: Check "Add DataCamp project files: ..."
```

---

## Next: Batch Downloads (Optional but Recommended)

### Daily 5-Project Batch (30 minutes/day)

```powershell
# Example Monday Batch
# 1. Download 5 projects manually from DataCamp (15-20 min)
# 2. Run sync script (5 min)

.\sync_datacamp_projects.ps1 -MaxProjects 5

# Monitor progress
.\validate_portfolio.ps1
```

**One project takes ~3-4 minutes to download:**
- 3 min: Navigate DataCamp, save notebook
- 1-2 min: Find and save dataset
- Auto: Everything else happens automatically

**5 projects/day = 8 days = All 40 projects done in 2 weeks**

---

## 📚 Documentation Index

| File | Purpose | When to Read |
|------|---------|--------------|
| **README.md** | Portfolio overview | First time |
| **QUICK_START.md** | This file | Right now |
| **EXPORT_FROM_DATALAB.md** | 6 ways to download | Before downloading |
| **BATCH_PROCESSING_GUIDE.md** | Multi-week plan | Planning batches |
| **DATACAMP_DOWNLOAD_GUIDE.md** | Project checklist | While downloading |
| **STRUCTURE.md** | Folder organization | Reference only |

---

## ⚡ Quick Commands Reference

```powershell
# Navigate to portfolio
cd C:\GitHub\portfolio

# Validate setup
.\validate_portfolio.ps1

# Test without making changes
.\sync_datacamp_projects.ps1 -DryRun

# Process first 5 projects
.\sync_datacamp_projects.ps1 -MaxProjects 5

# Process specific projects
.\sync_datacamp_projects.ps1 -ProjectFilter "sleep"

# Process all remaining projects
.\sync_datacamp_projects.ps1

# View logs
cat sync_log_*.txt | tail -50

# Check what's in Downloads
dir $env:USERPROFILE\Downloads *.ipynb | head -10
```

---

## ✅ Success Checklist

After your first project:

- [ ] `validate_portfolio.ps1` shows all ✅
- [ ] First project downloaded successfully
- [ ] Sync script ran without errors
- [ ] GitHub repository updated with files
- [ ] Can see project in portfolio at: https://parseanull.github.io/portfolio/
- [ ] Can visit project repository: https://github.com/ParseANull/[project-name]

---

## 🎓 What Each Script Does

### validate_portfolio.ps1
Checks your setup is complete:
- 40 project repos exist
- Git is configured
- Documentation is in place
- GitHub Pages set up

**Run:** Before starting  
**Time:** 1 minute

### sync_datacamp_projects.ps1
Automates file organization:
- Detects .ipynb and .csv files in Downloads
- Moves them to correct project folders
- Creates git commits
- Pushes to GitHub

**Run:** Daily after downloading projects  
**Time:** 1-5 minutes depending on projects

---

## 🐛 Common Issues & Fixes

### "Files not found" error?
```powershell
# Check that files are named correctly:
# ✅ getting-a-good-nights-sleep.ipynb
# ❌ Getting a Good Night's Sleep.ipynb (wrong - has spaces)
# ❌ project.ipynb (wrong - missing project name)

# Rename if needed:
cd Downloads
Rename-Item "old-name.ipynb" "getting-a-good-nights-sleep.ipynb"
```

### "Git not found" error?
```powershell
# Install/update Git
# Download from: https://git-scm.com/download/win
# Or: choco install git (if using Chocolatey)

# Verify it works
git --version
```

### "Permission denied" on sync?
```powershell
# Run PowerShell as Administrator
# Right-click PowerShell → Run as Administrator
# Then try again
```

### "Nothing to commit" message?
This is normal! It means:
- Files were already synced, or
- Files weren't found in Downloads

Check file names and try again.

---

## 📊 Expected Progress

| Week | Projects | Status |
|------|----------|--------|
| 1 | 5 | Setup + first batch |
| 2 | 15 | Halfway done |
| 3 | 30 | Most complete |
| 4+ | 40 | All projects synced |

---

## 🌟 After Everything is Synced

Your portfolio will have:

✅ **40 GitHub Repositories**
- Each with notebook, data, documentation
- Organized by skill and difficulty
- Publicly visible on GitHub

✅ **Live Portfolio Site**
- Professional project showcase
- GitHub Pages deployment
- All 40 projects linked

✅ **Professional Presentation**
- Share with employers
- Use in interviews
- Link on LinkedIn/resume

---

## 🚀 You're Ready! Start Here:

1. **Run validation:** `.\validate_portfolio.ps1`
2. **Read export methods:** [EXPORT_FROM_DATALAB.md](EXPORT_FROM_DATALAB.md)
3. **Download first project:** See "Download Your First Project" above
4. **Run sync script:** `.\sync_datacamp_projects.ps1`
5. **Check portfolio:** https://parseanull.github.io/portfolio/

---

**Questions?** See full documentation in [BATCH_PROCESSING_GUIDE.md](BATCH_PROCESSING_GUIDE.md)

**Next Step:** Download one project and test the whole workflow! ⏰ Takes ~15 minutes
