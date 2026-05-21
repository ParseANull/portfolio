###############################################################################
# 
# PROJECT PORTFOLIO SYNCHRONIZATION ENGINE
# 
# PURPOSE: We orchestrate the movement of project files from our Downloads
#          folder into organized GitHub repositories. We serve as the connective
#          tissue between raw project artifacts and version-controlled portfolios.
#
# OUR MISSION: We transform scattered project files into a cohesive, committed
#              code collection ready for professional showcase.
#
# FLOW STORY: 
#   1. We listen for command parameters to guide our execution
#   2. We discover all project directories in our portfolio
#   3. We scan the Downloads folder for matching project files
#   4. We organize files into proper directory structures (notebooks/, data/, scripts/)
#   5. We commit changes to git with meaningful messages
#   6. We push to remote GitHub repositories
#   7. We log our journey with timestamps and status
#
# Version: 2.0 (Narrative Enhanced Edition)
#
###############################################################################

<#
.SYNOPSIS
Synchronizes downloaded project files to GitHub repositories with full audit trail.

.DESCRIPTION
We are a portfolio synchronization engine. We take your downloaded project files
from your local machine and organize them into proper Git-tracked repositories.
Each file we process transitions through multiple stages: discovery, validation,
organization, commitment, and publication.

.PARAMETER ShowHelp
Display our operational instructions and exit safely.

.PARAMETER DryRun
We operate in preview mode - showing you what WE WOULD do without making
any actual changes. Perfect for validation before real execution.

.PARAMETER ProjectFilter
We narrow our scope to projects matching a pattern. For example, 'sleep' will
make us process only projects with 'sleep' in their name.

.PARAMETER MaxProjects
We limit our processing to this number of projects. Useful for testing our
workflow on a subset before full execution.

.EXAMPLE
.\sync_datacamp_projects.ps1 -DryRun -MaxProjects 3
We preview our work on 3 projects without making changes.
#>

param(
    [switch]$ShowHelp,
    [switch]$DryRun,
    [string]$ProjectFilter = "",
    [int]$MaxProjects = 0
)

if ($ShowHelp) {
    Write-Host @"
╔════════════════════════════════════════════════════════════════════════════╗
║                 PORTFOLIO SYNCHRONIZATION ENGINE v2.0                      ║
║                                                                            ║
║ We are your portfolio automation companion. Here's how you guide us:       ║
╚════════════════════════════════════════════════════════════════════════════╝

USAGE: .\sync_datacamp_projects.ps1 [OPTIONS]

OPTIONS:
    -DryRun              We preview what we would do without making changes
    -ProjectFilter       We focus on projects matching this pattern
                         (e.g., 'getting-a-good' finds 'getting-a-good-nights-sleep')
    -MaxProjects N       We process only the first N projects (for testing)
    -ShowHelp            We display this help message

EXAMPLES (Our Common Workflows):
    .\sync_datacamp_projects.ps1
                         → We process all projects in normal mode

    .\sync_datacamp_projects.ps1 -ProjectFilter "sleep"
                         → We focus only on the sleep-related project

    .\sync_datacamp_projects.ps1 -DryRun -MaxProjects 5
                         → We preview our workflow on 5 projects (no changes)

    .\sync_datacamp_projects.ps1 -DryRun
                         → We show you everything we WOULD do to all projects

WHAT WE DO:
  ✓ We discover project files in your Downloads folder
  ✓ We organize them into structured directories (notebooks, data, scripts)
  ✓ We validate Git repositories and track changes
  ✓ We create meaningful commit messages
  ✓ We push everything to GitHub
  ✓ We maintain a detailed log of all operations
"@
    exit
}

# ═══════════════════════════════════════════════════════════════════════════
# CONFIGURATION SCOPE
# ═══════════════════════════════════════════════════════════════════════════
# 
# PURPOSE: We establish our operational environment - the paths, the folders,
#          and the complete catalog of projects we are responsible for.
#
# VARIABLE TRANSITIONS:
#   - Global scope variables establish our working directories
#   - AllProjects array defines our complete portfolio universe
#   - We cache these to avoid repeated directory discovery
#
# ═══════════════════════════════════════════════════════════════════════════

# OPERATIONAL DIRECTORIES
# We maintain these paths throughout our entire execution lifecycle
$BasePortfolioPath = "C:\GitHub\datacamp-projects"    # Our project repository root
$DownloadsFolder = Join-Path $env:USERPROFILE "Downloads"  # Where we discover raw files
$LogFile = Join-Path $BasePortfolioPath "sync_log_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"  # Our execution journal

# PROJECT CATALOG
# We are custodians of these 40 projects. This list is our source of truth.
# Each name here represents a directory we will visit and files we will organize.
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

# ═══════════════════════════════════════════════════════════════════════════
# FUNCTION LIBRARY
# ═══════════════════════════════════════════════════════════════════════════
#
# PURPOSE: We define reusable operations that orchestrate our workflow.
#          Each function is a specialized task that we can invoke repeatedly.
#
# DESIGN PHILOSOPHY: 
#   - Functions accept input parameters in local scope
#   - They perform focused operations
#   - They return results that flow to the next stage
#   - They maintain detailed logs of their actions
#
# ═══════════════════════════════════════════════════════════════════════════

<#
.FUNCTION Log
.DESCRIPTION
We maintain our operational journal. Every action, every success, every concern
is recorded with a timestamp. This function is our voice to the world and to
ourselves - providing visibility into our execution journey.

SCOPE FLOW:
  Input:    $Message (what happened), $Level (severity classification)
  Internal: $timestamp (current moment), $logEntry (formatted record)
  Output:   Entry written to log file AND displayed on console
  Side FX:  Console color indicates severity (Red=ERROR, Green=SUCCESS, etc)
#>
function Log {
    param(
        [string]$Message,      # What we're recording
        [string]$Level = "INFO" # How important this is (ERROR/SUCCESS/WARNING/DEBUG)
    )
    
    # TIMESTAMP TRANSITION: We capture the exact moment of this event
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    
    # RECORD CONSTRUCTION: We format the entry for both log file and console
    $logEntry = "[$timestamp] [$Level] $Message"
    
    # LOG PERSISTENCE: We append to our journal file
    Add-Content -Path $LogFile -Value $logEntry
    
    # VISUAL FEEDBACK: We choose colors based on the event severity
    # This helps us see patterns at a glance
    $color = switch ($Level) {
        "ERROR"   { "Red" }      # Problems that stop our work
        "SUCCESS" { "Green" }    # Completed operations to celebrate
        "WARNING" { "Yellow" }   # Cautions we should note
        "DEBUG"   { "Gray" }     # Detailed diagnostics for troubleshooting
        default   { "White" }    # Standard information
    }
    
    # CONSOLE OUTPUT: We share our news with the operator
    Write-Host $logEntry -ForegroundColor $color
}

<#
.FUNCTION Test-GitRepo
.DESCRIPTION
We verify that a directory is truly a Git repository before we attempt
to work with it. This prevents us from trying to commit to non-Git directories.

SCOPE FLOW:
  Input:    $RepoPath (directory to inspect)
  Internal: Checks for .git subdirectory
  Output:   Boolean - $true if valid repo, $false if not
  Purpose:  Gate function - we won't proceed without a valid Git repo
#>
function Test-GitRepo {
    param([string]$RepoPath)
    
    # VALIDATION CHECK: The hallmark of a Git repository is the .git directory
    $gitPath = Join-Path $RepoPath ".git"
    
    if (!(Test-Path $gitPath)) {
        # GIT MISSING: We log this failure for debugging
        Log "Git repository not found at $RepoPath - missing .git directory" "ERROR"
        return $false
    }
    
    # GIT FOUND: This is safe territory for us to operate
    return $true
}

<#
.FUNCTION Get-ProjectRepository
.DESCRIPTION
We locate a project's repository directory. This is where all the project's
organized files will live. If the directory doesn't exist, we report it
so corrective action can be taken.

SCOPE FLOW:
  Input:    $ProjectName (the project we're seeking)
  Local:    $repoPath (constructed path to look for)
  Output:   String path if found, $null if not found
  Side FX:  Logs warnings if directory is missing
#>
function Get-ProjectRepository {
    param([string]$ProjectName)
    
    # PATH CONSTRUCTION: We build the expected path for this project
    # by joining the base portfolio path with the project name
    $repoPath = Join-Path $BasePortfolioPath $ProjectName
    
    # EXISTENCE CHECK: We verify the repository directory exists
    if (!(Test-Path $repoPath)) {
        # MISSING REPO: We cannot work without this directory
        Log "Repository directory not found: $repoPath - project may not be initialized" "WARNING"
        return $null
    }
    
    # SUCCESS: We return the valid path for further operations
    return $repoPath
}

<#
.FUNCTION Sync-ProjectFiles
.DESCRIPTION
We are the file orchestrator. We discover project files in the Downloads folder,
organize them into the proper subdirectories (notebooks/, data/, scripts/),
and prepare them for Git tracking.

SCOPE FLOW:
  Input Parameters:
    - $ProjectName: identifier for this project
    - $RepoPath: where to place the organized files
  
  LOCAL SCOPE:
    - Create subdirectories: notebooksDir, dataDir, scriptsDir
    - Search patterns: notebookPattern (*ipynb), dataPattern (*.csv)
    - Arrays: $notebooks (discovered notebook files), $dataFiles (discovered data files)
    - Counter: $fileSyncCount (how many files we actually copy)
  
  OUTPUT:
    - Hashtable with: FilesFound, FilesCopied, HasNotebook, HasData
  
  DATA TRANSITION:
    Source: Files scattered in Downloads folder
    Process: Match, filter, copy to organized structure
    Result: Structured repository ready for commitment
#>
function Sync-ProjectFiles {
    param(
        [string]$ProjectName,  # Which project we're organizing
        [string]$RepoPath      # Where to put the organized files
    )
    
    # DIRECTORY BLUEPRINT: We define where files belong within the project
    $notebooksDir = Join-Path $RepoPath "notebooks"  # Jupyter analysis notebooks
    $dataDir = Join-Path $RepoPath "data"            # CSV datasets and data files
    $scriptsDir = Join-Path $RepoPath "scripts"      # Python utility scripts
    
    # DIRECTORY INITIALIZATION: We create the folder structure if missing
    # These three directories are our filing system
    @($notebooksDir, $dataDir, $scriptsDir) | ForEach-Object {
        if (!(Test-Path $_)) {
            New-Item -ItemType Directory -Path $_ -Force | Out-Null
            Log "Created directory structure: $_" "DEBUG"
        }
    }
    
    # FILE DISCOVERY PATTERNS: We search for files matching our project
    # We use wildcards to find files that contain the project name
    $notebookPattern = "*$ProjectName*.ipynb"  # Jupyter notebooks pattern
    $dataPattern = "*$ProjectName*.csv"        # Data files pattern
    
    # FILE DISCOVERY PHASE: We scan the Downloads folder for matching files
    # This is where raw project artifacts wait to be organized
    $notebooks = Get-ChildItem -Path $DownloadsFolder -Filter $notebookPattern -ErrorAction SilentlyContinue
    $dataFiles = Get-ChildItem -Path $DownloadsFolder -Filter $dataPattern -ErrorAction SilentlyContinue
    
    # COUNTERS: We track our file operations
    $fileSyncCount = 0
    
    # PHASE 1: NOTEBOOK MIGRATION
    # We move Jupyter notebooks to the notebooks directory
    # These represent the analysis work for the project
    foreach ($notebook in $notebooks) {
        # DESTINATION TRANSITION: We normalize the notebook name
        $destPath = Join-Path $notebooksDir "analysis.ipynb"
        
        if ($DryRun) {
            # PREVIEW MODE: We show what we would do
            Log "Would copy notebook: $($notebook.FullName) → $destPath" "DEBUG"
        } else {
            # EXECUTION MODE: We actually copy the file
            Copy-Item $notebook.FullName $destPath -Force
            Log "Synced notebook: $($notebook.Name)" "SUCCESS"
            $fileSyncCount++
        }
    }
    
    # PHASE 2: DATA FILE MIGRATION
    # We move CSV data files to the data directory
    # These are the datasets that the notebooks analyze
    foreach ($dataFile in $dataFiles) {
        # DESTINATION TRANSITION: We preserve the original filename for the data
        $destPath = Join-Path $dataDir $dataFile.Name
        
        if ($DryRun) {
            # PREVIEW MODE: We show what we would do
            Log "Would copy data file: $($dataFile.FullName) → $destPath" "DEBUG"
        } else {
            # EXECUTION MODE: We actually copy the file
            Copy-Item $dataFile.FullName $destPath -Force
            Log "Synced data file: $($dataFile.Name)" "SUCCESS"
            $fileSyncCount++
        }
    }
    
    # RESULT PACKAGING: We return a summary of what we found and processed
    # This information flows to the next stage (Git commitment)
    return @{
        FilesFound = ($notebooks.Count + $dataFiles.Count)  # Total discovered
        FilesCopied = $fileSyncCount                         # Total processed
        HasNotebook = $notebooks.Count -gt 0                # Was analysis present?
        HasData = $dataFiles.Count -gt 0                    # Was data present?
    }
}

<#
.FUNCTION Commit-ProjectChanges
.DESCRIPTION
We are the Git custodian. We take the organized files that Sync-ProjectFiles
prepared and commit them to Git with a meaningful message. Then we push
to the remote GitHub repository.

SCOPE FLOW:
  Input Parameters:
    - $ProjectName: project identifier
    - $RepoPath: where the project Git repo lives
    - $SyncResult: summary of what we synced
  
  LOCAL SCOPE:
    - We change directory (Push-Location) to the repo
    - We check git status
    - We execute git add, commit, and push commands
    - We catch errors and report them
    - We restore original directory (Pop-Location)
  
  OUTPUT:
    - Boolean: $true if changes were committed, $false if none or error
  
  SIDE EFFECTS:
    - Files are staged to Git index
    - Commits created on local branch
    - Changes pushed to GitHub remote
#>
function Commit-ProjectChanges {
    param(
        [string]$ProjectName,      # Which project's changes we're committing
        [string]$RepoPath,         # Where the Git repo is located
        [hashtable]$SyncResult     # What we just synced (context for commit)
    )
    
    # DIRECTORY TRANSITION: We navigate into the repository directory
    # This changes our execution context for all subsequent Git commands
    Push-Location $RepoPath
    try {
        # GIT STATUS CHECK: We see if there are changes to commit
        # --porcelain returns machine-readable format (empty if no changes)
        $status = & git status --porcelain
        
        # CHANGE DETECTION: If status has output, there are changes
        if ($status) {
            if ($DryRun) {
                # PREVIEW MODE: We show what we would commit without doing it
                Log "Would commit changes to Git for: $ProjectName" "DEBUG"
                Log "  Files to be staged: $($SyncResult.FilesCopied) items" "DEBUG"
            } else {
                # EXECUTION MODE: We perform the actual Git operations
                
                # STAGE PHASE: We add all modified and new files to the Git index
                & git add .
                Log "Staged files for commit" "DEBUG"
                
                # COMMIT PHASE: We create a permanent record of these changes
                # The commit message explains what we did and why
                $commitMsg = "Add project files: $ProjectName - synced $($SyncResult.FilesCopied) files"
                & git commit -m $commitMsg -q
                Log "Committed to local repository: $ProjectName" "SUCCESS"
                
                # PUSH PHASE: We send our committed changes to GitHub
                # This makes them available to the world and backed up remotely
                & git push -q
                Log "Pushed to remote repository: $ProjectName" "SUCCESS"
            }
            
            # RETURN SUCCESS: We committed (or would have committed)
            return $true
        } else {
            # NO CHANGES: The Git status was clean, nothing to commit
            Log "No new changes to commit for: $ProjectName (already current)" "DEBUG"
            return $false
        }
    }
    catch {
        # ERROR HANDLING: Something went wrong with Git operations
        Log "Git operation failed for $ProjectName : $($_.Exception.Message)" "ERROR"
        return $false
    }
    finally {
        # DIRECTORY RESTORATION: We return to our previous directory
        # This maintains our directory stack integrity for future operations
        Pop-Location
    }
}

# ═══════════════════════════════════════════════════════════════════════════
# MAIN EXECUTION FLOW
# ═══════════════════════════════════════════════════════════════════════════
#
# PURPOSE: We orchestrate the complete synchronization workflow from start
#          to finish. This is where all our functions work in concert.
#
# EXECUTION PHASES:
#   1. INITIALIZATION: We prepare our environment and parameters
#   2. FILTERING: We apply user constraints (filter, max projects)
#   3. ITERATION: We process each project through the sync pipeline
#   4. SUMMARY: We report our accomplishments
#
# ═══════════════════════════════════════════════════════════════════════════

# INITIALIZATION PHASE
# We greet the operator and establish context
Log "╔════════════════════════════════════════════════════════════════════╗" "INFO"
Log "║   PORTFOLIO SYNCHRONIZATION ENGINE - Execution Started             ║" "INFO"
Log "╚════════════════════════════════════════════════════════════════════╝" "INFO"
Log "Downloads folder: $DownloadsFolder" "DEBUG"
Log "Portfolio path: $BasePortfolioPath" "DEBUG"

# EXECUTION MODE NOTIFICATION: We announce if we're in safe mode
if ($DryRun) { 
    Log "⚠ DRY RUN MODE ACTIVE - We will preview operations without making changes" "WARNING" 
}

# FILTERING PHASE
# We apply user constraints to narrow our scope if requested

# We start with the complete project list
$Projects = $AllProjects
$originalCount = $Projects.Count

# USER FILTER: If the operator specified a pattern, we narrow our scope
if ($ProjectFilter) {
    $Projects = $AllProjects | Where-Object { $_ -like "*$ProjectFilter*" }
    Log "✓ Filtered from $originalCount to $($Projects.Count) projects matching: '$ProjectFilter'" "INFO"
}

# USER LIMIT: If the operator specified a max count, we further restrict
if ($MaxProjects -gt 0 -and $MaxProjects -lt $Projects.Count) {
    $Projects = @($Projects | Select-Object -First $MaxProjects)
    Log "✓ Limited to first $MaxProjects projects for testing/preview" "INFO"
}

# WORKFLOW CONTEXT: We announce what we're about to process
Log "Starting synchronization for $($Projects.Count) projects..." "INFO"

# STATISTICS ACCUMULATOR
# We track our progress through the workflow
$stats = @{
    Total       = $Projects.Count       # How many projects we have
    Processed   = 0                     # How many we've touched
    Success     = 0                     # How many succeeded
    Failed      = 0                     # How many failed
    FilesFound  = 0                     # Total files discovered
    FilesSynced = 0                     # Total files organized
}

# ITERATION PHASE
# We process each project through our pipeline
# This is where the real work happens - file discovery, organization, and commitment

for ($projectIndex = 0; $projectIndex -lt $Projects.Count; $projectIndex++) {
    # LOOP CONTEXT: We establish which project we're working on
    $project = $Projects[$projectIndex]
    $currentNum = $projectIndex + 1
    
    Log "`n" "INFO"
    Log "[$currentNum/$($Projects.Count)] ═══════════════════════════════════" "INFO"
    Log "Processing: $project" "INFO"
    
    # STAGE 1: REPOSITORY DISCOVERY
    # We locate the project's repository directory
    $repoPath = Get-ProjectRepository $project
    if (!$repoPath) {
        # FAILURE: Repository not found - skip this project
        Log "Repository not found - skipping" "WARNING"
        $stats.Failed++
        continue
    }
    
    # STAGE 2: GIT VALIDATION
    # We verify this is a legitimate Git repository
    if (!(Test-GitRepo $repoPath)) {
        # FAILURE: Not a Git repo - skip this project
        Log "Invalid Git repository - skipping" "WARNING"
        $stats.Failed++
        continue
    }
    
    # STAGE 3: FILE SYNCHRONIZATION
    # We discover files and organize them into the repo structure
    Log "Scanning Downloads folder for project files..." "DEBUG"
    $syncResult = Sync-ProjectFiles -ProjectName $project -RepoPath $repoPath
    
    # ACCUMULATE STATISTICS
    $stats.FilesFound += $syncResult.FilesFound
    $stats.FilesSynced += $syncResult.FilesCopied
    
    # STAGE 4: GIT COMMITMENT
    # If we synced any files, we commit them to Git
    if ($syncResult.FilesCopied -gt 0) {
        Log "Files organized - preparing Git commit..." "DEBUG"
        
        $committed = Commit-ProjectChanges -ProjectName $project -RepoPath $repoPath -SyncResult $syncResult
        
        if ($committed) {
            # SUCCESS: Files committed and pushed
            $stats.Success++
        } else {
            # FAILURE: Commit/push didn't happen
            $stats.Failed++
        }
    } else {
        # NO FILES FOUND: This project has no files to sync
        Log "No matching files found in Downloads for this project" "WARNING"
    }
    
    # PROGRESS UPDATE: We mark this project as processed
    $stats.Processed++
}

# ═══════════════════════════════════════════════════════════════════════════
# COMPLETION SUMMARY
# ═══════════════════════════════════════════════════════════════════════════
#
# PURPOSE: We report our final statistics to the operator
#          This gives visibility into what we accomplished
#
# ═══════════════════════════════════════════════════════════════════════════

Log "`n" "INFO"
Log "╔════════════════════════════════════════════════════════════════════╗" "INFO"
Log "║                    SYNCHRONIZATION COMPLETE                        ║" "INFO"
Log "╚════════════════════════════════════════════════════════════════════╝" "INFO"

# FINAL STATISTICS
Log "" "INFO"
Log "OPERATIONS SUMMARY:" "INFO"
Log "  Projects Total:      $($stats.Total)" "INFO"
Log "  Projects Processed:  $($stats.Processed)" "INFO"
Log "  Successful Syncs:    $($stats.Success)" "SUCCESS"
Log "  Failed Syncs:        $($stats.Failed)" $(if ($stats.Failed -gt 0) { "WARNING" } else { "SUCCESS" })
Log "" "INFO"
Log "FILE STATISTICS:" "INFO"
Log "  Files Discovered:    $($stats.FilesFound)" "INFO"
Log "  Files Synchronized:  $($stats.FilesSynced)" "SUCCESS"
Log "" "INFO"
Log "Log file saved to: $LogFile" "DEBUG"
Log "════════════════════════════════════════════════════════════════════" "INFO"

# EXECUTION MODE NOTIFICATION: We remind about safe mode if active
if ($DryRun) {
    Log "" "WARNING"
    Log "⚠  DRY RUN COMPLETED - No actual changes were made to your system" "WARNING"
    Log "    To execute for real, run without the -DryRun parameter" "WARNING"
}
