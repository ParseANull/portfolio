#!/usr/bin/env pwsh
# Test and validate portfolio setup

param(
    [switch]$Verbose,
    [switch]$FixIssues
)

function Test-Path-Safe {
    param([string]$Path)
    if (Test-Path $Path) {
        Write-Host "✅ " -ForegroundColor Green -NoNewline
        Write-Host "$Path exists"
        return $true
    } else {
        Write-Host "❌ " -ForegroundColor Red -NoNewline
        Write-Host "$Path NOT FOUND"
        return $false
    }
}

function Test-GitRepo {
    param([string]$Path)
    if (Test-Path (Join-Path $Path ".git")) {
        Write-Host "✅ " -ForegroundColor Green -NoNewline
        Write-Host "Git repo: $Path"
        return $true
    } else {
        Write-Host "❌ " -ForegroundColor Red -NoNewline
        Write-Host "Git repo NOT initialized: $Path"
        return $false
    }
}

Write-Host "======================================"
Write-Host "Portfolio Setup Validator"
Write-Host "======================================"
Write-Host ""

$issues = @()
$baseDir = "C:\GitHub\portfolio"

# Check base directory
Write-Host "1. Checking base portfolio directory..."
if (!(Test-Path-Safe $baseDir)) {
    $issues += "Portfolio base directory not found"
}

# Check scripts
Write-Host ""
Write-Host "2. Checking automation scripts..."
$scripts = @(
    "sync_datacamp_projects.ps1",
    "validate_portfolio.ps1"
)
foreach ($script in $scripts) {
    $scriptPath = Join-Path $baseDir $script
    if (Test-Path $scriptPath) {
        Write-Host "✅ $script"
    } else {
        Write-Host "⚠️  $script not found (optional)"
    }
}

# Check documentation
Write-Host ""
Write-Host "3. Checking documentation..."
$docs = @(
    "README.md",
    "DATACAMP_DOWNLOAD_GUIDE.md",
    "EXPORT_FROM_DATALAB.md",
    "PROJECT_TEMPLATE_README.md",
    "STRUCTURE.md"
)
foreach ($doc in $docs) {
    $docPath = Join-Path $baseDir $doc
    if (Test-Path-Safe $docPath) { } else { }
}

# Check project repositories
Write-Host ""
Write-Host "4. Checking project repositories..."
$repoCount = 0
$gitRepos = 0

Get-ChildItem -Path $baseDir -Directory | Where-Object { $_.Name -notlike ".*" } | ForEach-Object {
    $repoPath = $_.FullName
    if ($_ .Name -eq ".git" -or $_.Name -eq "docs") { return }
    
    $repoCount++
    if (Test-GitRepo $repoPath) {
        $gitRepos++
        if ($Verbose) {
            $files = (Get-ChildItem -Path $repoPath -Recurse -File | Measure-Object).Count
            Write-Host "   Contains $files files"
        }
    }
}

Write-Host ""
Write-Host "Summary: $gitRepos/$repoCount project repos initialized"

# Check GitHub Pages
Write-Host ""
Write-Host "5. Checking GitHub Pages..."
$docsDir = Join-Path $baseDir "docs"
if (Test-Path-Safe $docsDir) {
    $indexHtml = Join-Path $docsDir "index.html"
    $configYml = Join-Path $docsDir "_config.yml"
    
    if (Test-Path $indexHtml) {
        Write-Host "✅ index.html (portfolio landing page)"
    }
    if (Test-Path $configYml) {
        Write-Host "✅ _config.yml (Jekyll config)"
    }
}

# Check Downloads folder
Write-Host ""
Write-Host "6. Checking Downloads folder for DataCamp exports..."
$downloadsPath = Join-Path $env:USERPROFILE "Downloads"
$ipynbFiles = @(Get-ChildItem -Path $downloadsPath -Filter "*.ipynb" -ErrorAction SilentlyContinue | Measure-Object).Count
$csvFiles = @(Get-ChildItem -Path $downloadsPath -Filter "*.csv" -ErrorAction SilentlyContinue | Measure-Object).Count

Write-Host "Found: $ipynbFiles .ipynb files, $csvFiles .csv files"

if ($ipynbFiles -gt 0 -or $csvFiles -gt 0) {
    Write-Host "✅ DataCamp exports ready for syncing"
} else {
    Write-Host "⚠️  No DataCamp exports found yet"
}

# Check git configuration
Write-Host ""
Write-Host "7. Checking git configuration..."
$userName = git config --global user.name
$userEmail = git config --global user.email

if ($userName) {
    Write-Host "✅ Git user: $userName"
} else {
    Write-Host "❌ Git user not configured"
    $issues += "Git user not configured. Run: git config --global user.name 'Your Name'"
}

if ($userEmail) {
    Write-Host "✅ Git email: $userEmail"
} else {
    Write-Host "❌ Git email not configured"
    $issues += "Git email not configured. Run: git config --global user.email 'your.email@example.com'"
}

# Display results
Write-Host ""
Write-Host "======================================"
Write-Host "Validation Results"
Write-Host "======================================"

if ($issues.Count -eq 0) {
    Write-Host "✅ All checks passed! Your portfolio is ready." -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:"
    Write-Host "1. Download DataCamp projects (see DATACAMP_DOWNLOAD_GUIDE.md)"
    Write-Host "2. Place exports in: $downloadsPath"
    Write-Host "3. Run: .\sync_datacamp_projects.ps1 -DryRun"
    Write-Host "4. Review changes, then run: .\sync_datacamp_projects.ps1"
} else {
    Write-Host "⚠️  Found $($issues.Count) issue(s):" -ForegroundColor Yellow
    foreach ($issue in $issues) {
        Write-Host "  • $issue" -ForegroundColor Yellow
    }
    
    if ($FixIssues) {
        Write-Host ""
        Write-Host "Attempting to fix issues..."
        # Add fixes as needed
    }
}

Write-Host ""
Write-Host "For more information, see: $(Join-Path $baseDir 'README.md')"
