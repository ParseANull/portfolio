###############################################################################
#
# README GENERATION ENGINE
#
# PURPOSE: We are custodians of documentation. We take raw project metadata
#          and weave it into professional README.md files that tell the story
#          of each project - its purpose, difficulty, and requirements.
#
# OUR MISSION: We ensure every repository is self-documenting, providing
#              developers with immediate clarity about each project.
#
# FLOW STORY:
#   1. We maintain a catalog of all 40 projects with metadata
#   2. We construct a README template that tells a project's story
#   3. We visit each repository directory
#   4. We create a professional README.md file tailored to each project
#   5. We report our success to the operator
#
# Version: 1.0 (Narrative Enhanced Edition)
#
###############################################################################

<#
.SYNOPSIS
Generate professional README.md files for all project repositories.

.DESCRIPTION
We are documentation architects. For each of your 40 project repositories,
we create a README.md that serves as the project's front door - introducing
visitors to the project's purpose, difficulty level, and how to get started.

.OUTPUT
40 professional README.md files, one in each project repository, all with
consistent formatting, skill level badges, and clear instructions.
#>

# ═══════════════════════════════════════════════════════════════════════════
# PROJECT METADATA CATALOG
# ═══════════════════════════════════════════════════════════════════════════
#
# PURPOSE: We maintain the source of truth for each project
#          This metadata flows into our README templates
#
# DATA STRUCTURE:
#   - name: directory/repository identifier
#   - title: human-readable project name
#   - level: skill difficulty (Basic/Intermediate/Advanced)
#   - desc: what the project is about
#   - topics: key technologies and concepts
#   - prereqs: what a developer needs to know beforehand
#
# ═══════════════════════════════════════════════════════════════════════════

# We curate complete metadata for all 40 projects
# Each object represents a project's identity and purpose
$projects = @(
    @{ name = "ai-assisted-product-launch"; title = "AI-Assisted Product Launch"; level = "Basic"; desc = "Analyze market dynamics and craft a strategic entry plan for an EV manufacturer"; topics = "AI, Strategic Planning"; prereqs = "Business understanding" },
    @{ name = "ai-assisted-restaurant-planning"; title = "AI-Assisted Restaurant Planning"; level = "Basic"; desc = "Interact with a customized GPT and plan restaurant operations"; topics = "AI, Prompting, Business Planning"; prereqs = "ChatGPT familiarity" },
    @{ name = "ai-assisted-travel-planning"; title = "AI-Assisted Travel Planning"; level = "Basic"; desc = "Master travel planning with AI and craft prompts"; topics = "AI, Prompting, Travel"; prereqs = "ChatGPT familiarity" },
    @{ name = "analyzing-electric-vehicle-charging-habits"; title = "Analyzing EV Charging Habits"; level = "Basic"; desc = "Analyze EV charging behavior data"; topics = "Data Manipulation, EDA"; prereqs = "pandas" },
    @{ name = "analyzing-industry-carbon-emissions"; title = "Analyzing Industry Carbon Emissions"; level = "Basic"; desc = "Analyze which industries contribute to carbon emissions"; topics = "SQL, Data Analysis"; prereqs = "SQL fundamentals" },
    @{ name = "analyzing-river-thames-water-levels"; title = "Analyzing River Thames Water Levels"; level = "Intermediate"; desc = "Apply data manipulation to time series data"; topics = "Time Series, pandas"; prereqs = "Data Manipulation" },
    @{ name = "analyzing-us-census-data-in-python"; title = "Analyzing US Census Data in Python"; level = "Intermediate"; desc = "Use Census API for demographic data"; topics = "APIs, Python"; prereqs = "Intermediate Python" },
    @{ name = "applying-sql-to-real-world-problems"; title = "Applying SQL to Real-World Problems"; level = "Intermediate"; desc = "Create tables and write maintainable SQL"; topics = "SQL, Database"; prereqs = "SQL" },
    @{ name = "build-an-educational-quiz-bot-with-the-openai-api"; title = "Educational Quiz Bot"; level = "Basic"; desc = "Build a quiz bot using OpenAI API"; topics = "OpenAI API, LLM"; prereqs = "OpenAI API" },
    @{ name = "building-a-calorie-intake-calculator"; title = "Calorie Intake Calculator"; level = "Intermediate"; desc = "Build a dietary tracking application"; topics = "Python, App Dev"; prereqs = "Intermediate Python" },
    @{ name = "building-a-go-to-market-strategy"; title = "Go-To-Market Strategy"; level = "Basic"; desc = "Create GTM strategy with AI"; topics = "AI, Business"; prereqs = "ChatGPT" },
    @{ name = "building-core-sign-up-functions-to-help-validate-new-users"; title = "Sign-Up Validation"; level = "Advanced"; desc = "Build user validation functions"; topics = "Python, OOP"; prereqs = "Advanced Python" },
    @{ name = "building-rag-chatbots-for-technical-documentation"; title = "RAG Chatbots"; level = "Intermediate"; desc = "Implement RAG with LangChain"; topics = "RAG, LLM, NLP"; prereqs = "LangChain" },
    @{ name = "building-wedding-planning-software"; title = "Wedding Planning Software"; level = "Advanced"; desc = "Develop wedding management system"; topics = "Python, OOP, Database"; prereqs = "Advanced Python" },
    @{ name = "case-study-building-software-in-python"; title = "Building Software in Python"; level = "Advanced"; desc = "Build real-world applications with Python"; topics = "Python, OOP"; prereqs = "Advanced Python" },
    @{ name = "case-study-set-up-a-book-recommendation-app-in-azure"; title = "Book Recommendation in Azure"; level = "Basic"; desc = "Set up book recommendation app in Azure"; topics = "Azure, Cloud"; prereqs = "Azure basics" },
    @{ name = "cleaning-an-orders-dataset-with-pyspark"; title = "Cleaning Orders with PySpark"; level = "Intermediate"; desc = "Clean large-scale data with PySpark"; topics = "PySpark, Big Data"; prereqs = "PySpark" },
    @{ name = "cleaning-data-with-generative-ai"; title = "Data Cleaning with AI"; level = "Basic"; desc = "Use AI for data cleaning"; topics = "AI, Data Cleaning"; prereqs = "ChatGPT" },
    @{ name = "consolidating-employee-data"; title = "Consolidating Employee Data"; level = "Intermediate"; desc = "Merge employee data from sources"; topics = "pandas, ETL"; prereqs = "pandas" },
    @{ name = "data-driven-decision-making-in-sql"; title = "Data-Driven Decisions in SQL"; level = "Intermediate"; desc = "Analyze SQL and report insights"; topics = "SQL, BI"; prereqs = "SQL" },
    @{ name = "data-storytelling-case-study-college-majors"; title = "Data Storytelling: College Majors"; level = "Basic"; desc = "Learn data storytelling techniques"; topics = "Visualization, Communication"; prereqs = "Data viz" },
    @{ name = "data-storytelling-case-study-green-businesses"; title = "Data Storytelling: Green Business"; level = "Basic"; desc = "Practice data storytelling"; topics = "Visualization, Sustainability"; prereqs = "Data viz" },
    @{ name = "debugging-code"; title = "Debugging Code"; level = "Basic"; desc = "Sharpen debugging skills"; topics = "Python, Debugging"; prereqs = "Basic Python" },
    @{ name = "detecting-cybersecurity-threats-using-deep-learning"; title = "Cybersecurity Threat Detection"; level = "Intermediate"; desc = "Detect threats using deep learning"; topics = "Deep Learning, Security"; prereqs = "Deep Learning" },
    @{ name = "developing-multi-input-models-for-ocr"; title = "Multi-Input OCR Models"; level = "Advanced"; desc = "Build advanced OCR systems"; topics = "Deep Learning, Computer Vision"; prereqs = "Advanced DL" },
    @{ name = "examining-the-history-of-lego-sets"; title = "LEGO Sets History"; level = "Basic"; desc = "Explore LEGO trends"; topics = "Data Exploration, Python"; prereqs = "Basic Python" },
    @{ name = "exploring-londons-travel-network"; title = "London Travel Network"; level = "Basic"; desc = "Analyze TfL journey data"; topics = "SQL, Data Engineering"; prereqs = "SQL" },
    @{ name = "exploring-trends-in-american-baby-names"; title = "American Baby Names Trends"; level = "Basic"; desc = "Explore 101 years of name data"; topics = "Data Analysis, Python"; prereqs = "pandas" },
    @{ name = "factors-that-fuel-student-performance"; title = "Student Performance Factors"; level = "Intermediate"; desc = "Analyze student performance data"; topics = "SQL, Analytics"; prereqs = "SQL" },
    @{ name = "generate-a-study-guide"; title = "Generate Study Guide"; level = "Basic"; desc = "Create personalized study guides"; topics = "AI, ChatGPT"; prereqs = "ChatGPT" },
    @{ name = "generating-keywords-for-search-campaigns"; title = "Generate SEO Keywords"; level = "Basic"; desc = "Auto-generate marketing keywords"; topics = "Marketing, Python"; prereqs = "Basic Python" },
    @{ name = "getting-a-good-nights-sleep"; title = "Good Night's Sleep Analysis"; level = "Basic"; desc = "Analyze sleep quality factors"; topics = "EDA, pandas"; prereqs = "pandas" },
    @{ name = "insurance-claim-processing-with-pinecone"; title = "Insurance Claims Processing"; level = "Intermediate"; desc = "Process claims with Pinecone"; topics = "Vector DB, LLM"; prereqs = "Pinecone, OpenAI" },
    @{ name = "personalized-language-tutor"; title = "Language Tutor"; level = "Basic"; desc = "Build language tutor with OpenAI"; topics = "OpenAI, NLP"; prereqs = "OpenAI API" },
    @{ name = "powering-data-for-the-department-of-energy-building-an-etl-pipeline"; title = "DoE ETL Pipeline"; level = "Intermediate"; desc = "Build ETL pipeline"; topics = "ETL, Data Engineering"; prereqs = "SQL, Python" },
    @{ name = "predicting-traffic-volume-with-pytorch"; title = "Traffic Prediction"; level = "Intermediate"; desc = "Predict traffic with PyTorch"; topics = "PyTorch, Forecasting"; prereqs = "PyTorch" },
    @{ name = "recommending-skincare-products"; title = "Skincare Recommendations"; level = "Basic"; desc = "Build recommendation chatbot"; topics = "AI, ChatGPT"; prereqs = "ChatGPT" },
    @{ name = "uncovering-the-worlds-oldest-businesses"; title = "World's Oldest Businesses"; level = "Intermediate"; desc = "Discover oldest businesses"; topics = "SQL, Analytics"; prereqs = "SQL" },
    @{ name = "understanding-subscription-behaviors"; title = "Subscription Behaviors"; level = "Intermediate"; desc = "Analyze SaaS subscription data"; topics = "Data Analysis, Python"; prereqs = "pandas" },
    @{ name = "will-this-customer-purchase-your-product"; title = "Customer Purchase Prediction"; level = "Intermediate"; desc = "Predict customer purchases"; topics = "Statistics, Analytics"; prereqs = "Statistics" }
)

# ═══════════════════════════════════════════════════════════════════════════
# DOCUMENTATION FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════

<#
.FUNCTION New-ProjectReadme
.DESCRIPTION
We are markdown architects. We take project metadata and weave it into
a professional README that serves as the project's face to the world.

SCOPE FLOW:
  Input Parameters:
    - $Name: repository identifier (used for GitHub links)
    - $Title: project title (human-readable)
    - $Level: skill difficulty (Basic/Intermediate/Advanced)
    - $Desc: project description (what problem does it solve?)
    - $Topics: technologies and concepts covered
    - $Prereqs: prerequisites for understanding the project
  
  LOCAL SCOPE:
    - We construct the skill badge HTML based on difficulty level
    - We assemble markdown sections with consistent structure
    - We format the content for professional presentation
  
  OUTPUT:
    - A complete README.md string ready to be written to file
  
  STORY TOLD:
    Each README answers these questions:
    - What is this project about?
    - How hard is it?
    - What will I learn?
    - How do I get started?
    - Where is it on GitHub?
#>
function New-ProjectReadme {
    param(
        [string]$Name,      # Repository name for GitHub links
        [string]$Title,     # Project title
        [string]$Level,     # Skill level
        [string]$Desc,      # What is this project about?
        [string]$Topics,    # What will I learn?
        [string]$Prereqs    # What do I need to know first?
    )
    
    # BADGE CONSTRUCTION: We choose a visual badge based on difficulty
    # This provides instant context about the challenge level
    $badge = if ($Level -eq "Basic") { 
        "![Badge](https://img.shields.io/badge/Skill-Basic-green)" 
    } elseif ($Level -eq "Intermediate") { 
        "![Badge](https://img.shields.io/badge/Skill-Intermediate-yellow)" 
    } else { 
        "![Badge](https://img.shields.io/badge/Skill-Advanced-red)" 
    }
    
    # MARKDOWN ASSEMBLY: We construct the README in sections
    # Each section tells part of the project's story
    
    # TITLE SECTION: The project's first impression
    $content = "# $Title`n`n"
    
    # DIFFICULTY BADGE: Instant visual indicator
    $content += "$badge`n`n"
    
    # OVERVIEW SECTION: Why does this project exist?
    $content += "## Project Overview`n`n"
    $content += "$Desc`n`n"
    
    # METADATA SECTION: The essentials for a developer
    $content += "## Details`n`n"
    $content += "- **Skill Level:** $Level`n"
    $content += "- **Topics:** $Topics`n"
    $content += "- **Prerequisites:** $Prereqs`n`n"
    
    # STRUCTURE SECTION: How are the files organized?
    $content += "## Project Structure`n`n"
    $content += "``````n"
    $content += ".`n"
    $content += "|-- notebooks/      # Jupyter notebooks with analysis`n"
    $content += "|-- data/           # CSV datasets and data files`n"
    $content += "|-- scripts/        # Python utility scripts`n"
    $content += "|-- output/         # Generated results and visualizations`n"
    $content += "|-- README.md       # This file`n"
    $content += "|-- requirements.txt # Python dependencies`n"
    $content += "``````n`n"
    
    # GETTING STARTED SECTION: How do I begin?
    $content += "## Getting Started`n`n"
    $content += "1. Install dependencies: \`pip install -r requirements.txt\``n"
    $content += "2. Open the notebook in \`notebooks/\``n"
    $content += "3. Follow the instructions and execute cells in sequence`n`n"
    
    # KEY SKILLS SECTION: What will I learn?
    $content += "## Key Skills Covered`n`n"
    $content += "- " + ($Topics -replace ", ", "`n- ") + "`n`n"
    
    # TECHNOLOGIES SECTION: What tools are used?
    $content += "## Technologies Used`n`n"
    $content += "- Python 3.8+`n"
    $content += "- Jupyter Notebook`n"
    $content += "- pandas, NumPy, Matplotlib, Seaborn`n`n"
    
    # FOOTER SECTION: Where to find this project
    $content += "---`n`n"
    $content += "**Repository:** https://github.com/ParseANull/$Name`n"
    $content += "**Skill Level:** $Level`n"
    
    # RETURN: We deliver the complete README markdown
    return $content
}

# ═══════════════════════════════════════════════════════════════════════════
# MAIN EXECUTION FLOW
# ═══════════════════════════════════════════════════════════════════════════
#
# PURPOSE: We iterate through all projects and create READMEs
#          This is where we make our documentation vision real
#
# ═══════════════════════════════════════════════════════════════════════════

Write-Host "`n╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║    README GENERATION ENGINE - Starting Documentation Pass     ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Green

# COUNTERS: We track our documentation success
$success = 0        # How many READMEs we created
$failed = 0         # How many we failed to create

Write-Host "`nWe will now create professional README.md files...`n" -ForegroundColor Cyan

# ITERATION PHASE: We process each project
foreach ($proj in $projects) {
    # CONTEXT: Which project are we working on?
    $projectDir = "$proj.name"
    $projectPath = "C:\GitHub\datacamp-projects\$($proj.name)"
    
    # EXISTENCE CHECK: Does the repository directory exist?
    if (Test-Path $projectPath) {
        try {
            # README GENERATION: We construct the documentation for this project
            # We flow project metadata through our template engine
            $readme = New-ProjectReadme `
                -Name $proj.name `
                -Title $proj.title `
                -Level $proj.level `
                -Desc $proj.desc `
                -Topics $proj.topics `
                -Prereqs $proj.prereqs
            
            # FILE PERSISTENCE: We write the README to the repository
            $readmePath = "$projectPath\README.md"
            Set-Content -Path $readmePath -Value $readme -Force
            
            # SUCCESS REPORTING: We celebrate this creation
            Write-Host "✓ $($proj.name)" -ForegroundColor Green
            $success++
        }
        catch {
            # ERROR REPORTING: Something went wrong
            Write-Host "✗ $($proj.name) - Error: $_" -ForegroundColor Red
            $failed++
        }
    }
    else {
        # MISSING REPO: The repository doesn't exist (shouldn't happen)
        Write-Host "✗ $($proj.name) - Repository directory not found" -ForegroundColor Yellow
        $failed++
    }
}

# ═══════════════════════════════════════════════════════════════════════════
# COMPLETION SUMMARY
# ═══════════════════════════════════════════════════════════════════════════

Write-Host "`n╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║             DOCUMENTATION GENERATION COMPLETE                 ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan

Write-Host "READMEs Created: $success" -ForegroundColor Green
Write-Host "Failed: $failed" -ForegroundColor $(if ($failed -gt 0) { "Yellow" } else { "Green" })

Write-Host "`nAll project repositories now have professional README.md files!`n" -ForegroundColor Cyan
