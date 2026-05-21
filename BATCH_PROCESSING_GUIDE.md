# Complete Portfolio Setup & Batch Processing Guide

This comprehensive guide covers the complete workflow from download to GitHub publication.

## 📋 Complete Overview

```
Phase 1: Setup & Validation (This Week)
├── Verify portfolio infrastructure
├── Test automation scripts
└── Download first batch (5 projects)

Phase 2: Batch Downloads (Week 2-3)
├── Download projects in batches of 5-10
├── Run sync script daily
└── Verify GitHub updates

Phase 3: Completion & Polish (Week 4+)
├── Fill remaining 25-30 projects
├── Add project descriptions
└── Launch portfolio site officially
```

## 🚀 Quick Start (First Time Setup)

### Step 1: Validate Your Setup
```powershell
cd C:\GitHub\portfolio
.\validate_portfolio.ps1 -Verbose
```

This checks:
- ✅ All 40 project repositories exist
- ✅ Git is configured correctly
- ✅ Documentation files are in place
- ✅ GitHub Pages is set up

### Step 2: Test the Sync Script
```powershell
# Dry run (see what would happen, no changes)
.\sync_datacamp_projects.ps1 -DryRun -MaxProjects 3
```

### Step 3: Download First DataCamp Project
1. Go to: https://app.datacamp.com/learn/projects/2030
2. Click "Continue Project"
3. Save notebook: Press Ctrl+S
4. Save as: `getting-a-good-nights-sleep.ipynb` to Downloads
5. See: [EXPORT_FROM_DATALAB.md](EXPORT_FROM_DATALAB.md) for detailed methods

### Step 4: Run Sync Script for Real
```powershell
.\sync_datacamp_projects.ps1 -MaxProjects 1
```

### Step 5: Verify Success
```powershell
# Check if file was synced
cd C:\GitHub\getting-a-good-nights-sleep
git log --oneline -5
```

## 📊 Full Project Inventory (40 Projects)

### Group 1: Python - Data Science (12 projects)
- [x] Getting a Good Night's Sleep (ID: 2030)
- [ ] Analyzing Crime in Los Angeles
- [ ] Predicting Movie Rental Durations
- [ ] Investigating Netflix Movies
- [ ] Exploring Trends in American Baby Names
- [ ] Analyzing US Census Data in Python
- [ ] Factors That Fuel Student Performance
- [ ] Understanding Subscription Behaviors
- [ ] Examining the History of LEGO Sets
- [ ] Building a Calorie Intake Calculator
- [ ] Consolidating Employee Data
- [ ] Case Study: Building Software in Python

### Group 2: SQL & Databases (8 projects)
- [ ] Analyzing Unicorn Companies
- [ ] When Was the Golden Era of Video Games?
- [ ] Analyze International Debt Statistics
- [ ] Exploring London's Travel Network
- [ ] Data-Driven Decision-Making in SQL
- [ ] Applying SQL to Real-World Problems
- [ ] Powering Data for the Department of Energy (ETL Pipeline)
- [ ] Analyzing River Thames Water Levels

### Group 3: Machine Learning & Deep Learning (7 projects)
- [ ] Predicting Credit Card Approvals
- [ ] Detecting Cybersecurity Threats Using Deep Learning
- [ ] Predicting Traffic Volume with PyTorch
- [ ] Developing Multi-Input Models for OCR
- [ ] Building RAG Chatbots for Technical Documentation
- [ ] Clustering Antarctic Penguin Species
- [ ] Hypothesis Testing in Healthcare

### Group 4: Advanced Analytics (5 projects)
- [ ] Analyzing Electric Vehicle Charging Habits
- [ ] Analyzing Industry Carbon Emissions
- [ ] Data Storytelling: College Majors
- [ ] Data Storytelling: Green Businesses
- [ ] Uncovering the World's Oldest Businesses

### Group 5: Modern AI & LLMs (5 projects)
- [ ] Building RAG Chatbots
- [ ] Build Educational Quiz Bot with OpenAI API
- [ ] Generate Study Guide with AI
- [ ] AI-Assisted Travel Planning
- [ ] AI-Assisted Restaurant Planning

### Group 6: Business & Development (3 projects)
- [ ] Building Wedding Planning Software
- [ ] Building a Go-to-Market Strategy
- [ ] AI-Assisted Product Launch

## 📅 Batch Processing Schedule

### Week 1: Foundation & Testing
**Mon-Wed:** Setup & Validation
- Run `validate_portfolio.ps1`
- Test sync script with `-DryRun` flag
- Document any issues

**Thu-Fri:** First Batch (5 projects)
- Download: Getting a Good Night's Sleep, Building RAG Chatbots, Generating Keywords, Building Core Sign-Up, Developing Multi-Input Models
- Run sync script
- Verify GitHub updates

### Week 2: Python Batch
**Mon-Fri:** 10 Python projects
- Download 5-7 projects/day
- Run sync script daily
- Monitor GitHub repository updates

```powershell
# Daily workflow:
cd C:\GitHub\portfolio

# 1. Validate (once daily)
.\validate_portfolio.ps1

# 2. Download 5-7 projects (manually from DataCamp)

# 3. Sync downloaded files
.\sync_datacamp_projects.ps1 -MaxProjects 7

# 4. Check results
git log --oneline -10
```

### Week 3: SQL & Mixed Batches
**Mon-Wed:** SQL projects (8 total)
- Analyzing Unicorn Companies
- Video Games Dataset
- International Debt Statistics
- Etc.

**Thu-Fri:** Machine Learning projects (5 projects)

### Week 4: Completion & Polish
**Mon-Wed:** Remaining 15 projects
**Thu-Fri:** 
- Review all repositories
- Add project descriptions
- Update portfolio README
- Deploy updates

## 🎯 Daily Workflow

### Example: Monday Download Batch

```powershell
# Step 1: Start with validation
cd C:\GitHub\portfolio
.\validate_portfolio.ps1

# Step 2: Download 5 projects manually from DataCamp
# Open each in browser:
# - https://app.datacamp.com/learn/projects/1531 (Unicorn Companies)
# - https://app.datacamp.com/learn/projects/1633 (Word Frequency)
# - https://app.datacamp.com/learn/projects/1908 (Credit Card)
# - ... (save each as: project-name.ipynb)

# Step 3: Run sync with dry-run first
.\sync_datacamp_projects.ps1 -DryRun

# Step 4: If results look good, execute
.\sync_datacamp_projects.ps1 -MaxProjects 5

# Step 5: Review commits
Get-ChildItem -Path $env:USERPROFILE\Downloads -Filter "*.ipynb" | 
    Select-Object Name, @{N="Modified";E={$_.LastWriteTime}} | 
    Sort-Object Modified -Descending | 
    Select-Object -First 5
```

## 🔄 Automation Opportunities

### Option A: Windows Task Scheduler
```powershell
# Run sync script automatically each evening
$trigger = New-ScheduledTaskTrigger -Daily -At 6:00PM
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-File C:\GitHub\portfolio\sync_datacamp_projects.ps1"
Register-ScheduledTask -TaskName "DataCamp Sync" -Trigger $trigger -Action $action
```

### Option B: Manual Batch Processing
See the batch download helper in [EXPORT_FROM_DATALAB.md](EXPORT_FROM_DATALAB.md)

## 📝 Project Documentation Template

After each project syncs, update its README:

```powershell
# Template for each project's README.md
# (See PROJECT_TEMPLATE_README.md for full template)

- Project Name: [From DataCamp]
- Difficulty: [Basic/Intermediate/Advanced]
- Duration: [Time estimate]
- Key Skills: [List 3-5]
- Dataset: [Filename & description]
- Learning Outcomes: [3-5 bullet points]
```

## ✅ Success Criteria

### Phase 1 (Week 1):
- [x] Portfolio infrastructure validated
- [ ] First 5 projects downloaded
- [ ] First batch synced successfully
- [ ] GitHub repositories updated
- [ ] GitHub Pages displaying projects

### Phase 2 (Weeks 2-3):
- [ ] 25 projects downloaded and synced
- [ ] README.md files created for each
- [ ] Project descriptions added
- [ ] GitHub commit history shows steady progress

### Phase 3 (Week 4+):
- [ ] All 40 projects synced
- [ ] Portfolio site complete
- [ ] Project showcase ready
- [ ] Ready for sharing with employers/clients

## 🐛 Troubleshooting

### Sync script not finding files?
```powershell
# Verify files in Downloads with correct names
Get-ChildItem -Path $env:USERPROFILE\Downloads -Filter "*.ipynb" | 
    Select-Object Name

# Files should be named like:
# - getting-a-good-nights-sleep.ipynb
# - analyzing-unicorn-companies.ipynb
```

### Git not committing?
```powershell
# Check git status in a project repo
cd C:\GitHub\getting-a-good-nights-sleep
git status

# If nothing staged, manually add:
git add .
git commit -m "Add DataCamp project files"
git push
```

### Files in wrong folder?
```powershell
# Run in verbose mode to see file movements
.\sync_datacamp_projects.ps1 -DryRun -Verbose

# Check specific project folder structure
tree C:\GitHub\getting-a-good-nights-sleep
```

## 📚 Key Documentation Files

1. **README.md** - Main portfolio overview
2. **DATACAMP_DOWNLOAD_GUIDE.md** - How to download from DataCamp
3. **EXPORT_FROM_DATALAB.md** - Multiple export methods explained
4. **PROJECT_TEMPLATE_README.md** - Template for project READMEs
5. **STRUCTURE.md** - Folder organization explained
6. **This file** - Complete setup guide

## 🎓 Learning Resources

While downloading projects, review:
- DataCamp project description and requirements
- Jupyter notebook best practices
- GitHub commit message conventions
- Data science documentation standards

## 🚀 Post-Completion

After all 40 projects are synced:

1. **Portfolio Review:**
   - Visit: https://parseanull.github.io/portfolio/
   - Review project cards and links
   - Test GitHub repository links

2. **Enhancement Options:**
   - Add project difficulty badges
   - Create category filters
   - Add project statistics
   - Create project showcase video

3. **Sharing:**
   - LinkedIn: Link to portfolio
   - Resume: Portfolio URL
   - GitHub: Pin favorite projects
   - Interviews: Reference specific projects

## 📞 Quick Reference

**All commands from** `C:\GitHub\portfolio`:

```powershell
# Validate setup
.\validate_portfolio.ps1

# Test sync (dry run)
.\sync_datacamp_projects.ps1 -DryRun -MaxProjects 5

# Run sync
.\sync_datacamp_projects.ps1

# View sync logs
Get-Content sync_log_*.txt | Select-Object -Last 50

# Check Downloads folder
dir $env:USERPROFILE\Downloads *.ipynb | Select -First 10

# Check project repo
cd C:\GitHub\[project-name]
git log --oneline -10
```

---

**Estimated Total Time:** 3-4 weeks  
**Effort Level:** Low (mostly downloads, automation handles rest)  
**Benefit:** Complete portfolio with 40 projects showcasing diverse skills
