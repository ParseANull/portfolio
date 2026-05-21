###############################################################################
# DataCamp Project Automation Script - Enhanced Version
# Purpose: Sync downloaded DataCamp projects to GitHub repositories
# Author: Portfolio Setup
# Version: 2.0
###############################################################################

param(
    [switch]$ShowHelp,
    [switch]$DryRun,
    [string]$ProjectFilter = "",
    [int]$MaxProjects = 0
)

if ($ShowHelp) {
    Write-Host @"
USAGE: .\sync_datacamp_projects.ps1 [OPTIONS]

OPTIONS:
    -DryRun              Show what would be done without making changes
    -ProjectFilter       Filter projects (e.g., 'getting-a-good' shows only matching projects)
    -MaxProjects N       Process only first N projects
    -ShowHelp           Display this help message

EXAMPLES:
    .\sync_datacamp_projects.ps1                           # Process all projects
    .\sync_datacamp_projects.ps1 -ProjectFilter "sleep"    # Process only matching projects
    .\sync_datacamp_projects.ps1 -DryRun -MaxProjects 5    # Test with 5 projects
"@
    exit
}

# ============================================================================
# CONFIGURATION
# ============================================================================

$BasePortfolioPath = $PSScriptRoot
$DownloadsFolder = Join-Path $env:USERPROFILE "Downloads"
$LogFile = Join-Path $BasePortfolioPath "sync_log_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"

# List of all 40 projects
$AllProjects = @(
    'getting-a-good-nights-sleep',
    'building-rag-chatbots-for-technical-documentation',
    'generating-keywords-for-search-campaigns',
    'building-core-sign-up-functions-to-help-validate-new-users',
    'developing-multi-input-models-for-ocr',
    'cleaning-an-orders-dataset-with-pyspark',
    'examining-the-history-of-lego-sets',
    'building-a-calorie-intake-calculator',
    'will-this-customer-purchase-your-product',
    'understanding-subscription-behaviors',
    'detecting-cybersecurity-threats-using-deep-learning',
    'predicting-traffic-volume-with-pytorch',
    'exploring-trends-in-american-baby-names',
    'personalized-language-tutor',
    'factors-that-fuel-student-performance',
    'debugging-code',
    'powering-data-for-the-department-of-energy-building-an-etl-pipeline',
    'insurance-claim-processing-with-pinecone',
    'build-an-educational-quiz-bot-with-the-openai-api',
    'building-wedding-planning-software',
    'consolidating-employee-data',
    'analyzing-industry-carbon-emissions',
    'analyzing-river-thames-water-levels',
    'exploring-londons-travel-network',
    'analyzing-electric-vehicle-charging-habits',
    'uncovering-the-worlds-oldest-businesses',
    'case-study-building-software-in-python',
    'analyzing-us-census-data-in-python',
    'data-driven-decision-making-in-sql',
    'applying-sql-to-real-world-problems',
    'case-study-set-up-a-book-recommendation-app-in-azure',
    'cleaning-data-with-generative-ai',
    'data-storytelling-case-study-college-majors',
    'data-storytelling-case-study-green-businesses',
    'generate-a-study-guide',
    'ai-assisted-travel-planning',
    'building-a-go-to-market-strategy',
    'ai-assisted-product-launch',
    'recommending-skincare-products',
    'ai-assisted-restaurant-planning'
)

# ============================================================================
# FUNCTIONS
# ============================================================================

function Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $logEntry = "[$timestamp] [$Level] $Message"
    
    Add-Content -Path $LogFile -Value $logEntry
    
    $color = switch ($Level) {
        "ERROR" { "Red" }
        "SUCCESS" { "Green" }
        "WARNING" { "Yellow" }
        "DEBUG" { "Gray" }
        default { "White" }
    }
    
    Write-Host $logEntry -ForegroundColor $color
}

function Test-GitRepo {
    param([string]$RepoPath)
    
    if (!(Test-Path (Join-Path $RepoPath ".git"))) {
        Log "Git repository not found at $RepoPath" "ERROR"
        return $false
    }
    return $true
}

function Get-ProjectRepository {
    param([string]$ProjectName)
    
    $repoPath = Join-Path $BasePortfolioPath $ProjectName
    if (!(Test-Path $repoPath)) {
        Log "Repository directory not found: $repoPath" "WARNING"
        return $null
    }
    return $repoPath
}

function Sync-ProjectFiles {
    param(
        [string]$ProjectName,
        [string]$RepoPath
    )
    
    $notebooksDir = Join-Path $RepoPath "notebooks"
    $dataDir = Join-Path $RepoPath "data"
    $scriptsDir = Join-Path $RepoPath "scripts"
    
    # Create directories if they don't exist
    @($notebooksDir, $dataDir, $scriptsDir) | ForEach-Object {
        if (!(Test-Path $_)) {
            New-Item -ItemType Directory -Path $_ | Out-Null
            Log "Created directory: $_" "DEBUG"
        }
    }
    
    # Find matching files in Downloads
    $notebookPattern = "*$ProjectName*.ipynb"
    $dataPattern = "*$ProjectName*.csv"
    
    $notebooks = Get-ChildItem -Path $DownloadsFolder -Filter $notebookPattern -ErrorAction SilentlyContinue
    $dataFiles = Get-ChildItem -Path $DownloadsFolder -Filter $dataPattern -ErrorAction SilentlyContinue
    
    $fileSyncCount = 0
    
    # Copy notebooks
    foreach ($notebook in $notebooks) {
        $destPath = Join-Path $notebooksDir "analysis.ipynb"
        if ($DryRun) {
            Log "Would copy: $($notebook.FullName) → $destPath" "DEBUG"
        } else {
            Copy-Item $notebook.FullName $destPath -Force
            Log "Copied notebook: $($notebook.Name)" "SUCCESS"
            $fileSyncCount++
        }
    }
    
    # Copy data files
    foreach ($dataFile in $dataFiles) {
        $destPath = Join-Path $dataDir $dataFile.Name
        if ($DryRun) {
            Log "Would copy: $($dataFile.FullName) → $destPath" "DEBUG"
        } else {
            Copy-Item $dataFile.FullName $destPath -Force
            Log "Copied data file: $($dataFile.Name)" "SUCCESS"
            $fileSyncCount++
        }
    }
    
    return @{
        FilesFound = ($notebooks.Count + $dataFiles.Count)
        FilesCopied = $fileSyncCount
        HasNotebook = $notebooks.Count -gt 0
        HasData = $dataFiles.Count -gt 0
    }
}

function Commit-ProjectChanges {
    param(
        [string]$ProjectName,
        [string]$RepoPath,
        [hashtable]$SyncResult
    )
    
    Push-Location $RepoPath
    try {
        $status = & git status --porcelain
        
        if ($status) {
            if ($DryRun) {
                Log "Would commit changes for: $ProjectName" "DEBUG"
            } else {
                & git add .
                & git commit -m "Add DataCamp project files: $ProjectName" -q
                & git push -q
                Log "Git commit and push completed for: $ProjectName" "SUCCESS"
            }
            return $true
        } else {
            Log "No changes to commit for: $ProjectName" "DEBUG"
            return $false
        }
    }
    catch {
        Log "Git error for $ProjectName : $_" "ERROR"
        return $false
    }
    finally {
        Pop-Location
    }
}

# ============================================================================
# MAIN EXECUTION
# ============================================================================

Log "========================================" "INFO"
Log "DataCamp Project Sync - Starting" "INFO"
Log "========================================" "INFO"
Log "Downloads folder: $DownloadsFolder" "DEBUG"
Log "Portfolio path: $BasePortfolioPath" "DEBUG"
if ($DryRun) { Log "DRY RUN MODE - No files will be modified" "WARNING" }

# Filter projects if specified
$Projects = $AllProjects
if ($ProjectFilter) {
    $Projects = $AllProjects | Where-Object { $_ -like "*$ProjectFilter*" }
    Log "Filtered to $($Projects.Count) projects matching: $ProjectFilter" "INFO"
}

if ($MaxProjects -gt 0) {
    $Projects = $Projects | Select-Object -First $MaxProjects
    Log "Limited to first $MaxProjects projects" "INFO"
}

Log "Processing $($Projects.Count) projects..." "INFO"

$stats = @{
    Total = $Projects.Count
    Processed = 0
    Success = 0
    Failed = 0
    FilesFound = 0
    FilesSynced = 0
}

# Process each project
foreach ($projectIndex, $project in ($Projects | ForEach-Object { $_ } | Foreach-Object { $i++ } { $_, $i })) {
    Log "`n[$projectIndex/$($Projects.Count)] Processing: $project" "INFO"
    
    $repoPath = Get-ProjectRepository $project
    if (!$repoPath) {
        $stats.Failed++
        continue
    }
    
    if (!(Test-GitRepo $repoPath)) {
        $stats.Failed++
        continue
    }
    
    $syncResult = Sync-ProjectFiles -ProjectName $project -RepoPath $repoPath
    $stats.FilesFound += $syncResult.FilesFound
    $stats.FilesSynced += $syncResult.FilesCopied
    
    if ($syncResult.FilesCopied -gt 0) {
        $committed = Commit-ProjectChanges -ProjectName $project -RepoPath $repoPath -SyncResult $syncResult
        if ($committed) {
            $stats.Success++
        } else {
            $stats.Failed++
        }
    } else {
        Log "No files found for: $project" "WARNING"
    }
    
    $stats.Processed++
}

# ============================================================================
# SUMMARY
# ============================================================================

Log "`n========================================" "INFO"
Log "SYNC SUMMARY" "INFO"
Log "========================================" "INFO"
Log "Total projects processed: $($stats.Processed)/$($stats.Total)" "INFO"
Log "Successfully synced: $($stats.Success)" "SUCCESS"
Log "Failed: $($stats.Failed)" $(if ($stats.Failed -gt 0) { "WARNING" } else { "SUCCESS" })
Log "Files found: $($stats.FilesFound)" "INFO"
Log "Files synced: $($stats.FilesSynced)" "INFO"
Log "Log file: $LogFile" "DEBUG"
Log "========================================" "INFO"

if ($DryRun) {
    Log "DRY RUN completed - no changes were made" "WARNING"
}
