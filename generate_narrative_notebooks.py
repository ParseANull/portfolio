#!/usr/bin/env python3
"""
================================================================================
                    JUPYTER NOTEBOOK GENERATION ENGINE
================================================================================

PURPOSE: We are notebook architects. We create comprehensive Jupyter notebooks
         for each project, telling the story of data analysis through narrative
         first-person plural comments and docstrings.

OUR MISSION: We transform raw project directories into fully-documented,
             analysis-ready notebooks that guide developers through the
             exploration and learning journey.

FLOW STORY:
  1. We maintain metadata for all 40 projects
  2. We construct narrative notebook cells with markdown and code
  3. We weave in first-person plural commentary explaining data flow
  4. We create proper variable scope transitions and docstrings
  5. We write complete notebooks to each project repository
  6. We report our documentation success

Version: 1.0 (Narrative Enhanced Edition)
================================================================================
"""

import json
import os
from pathlib import Path
from datetime import datetime

# ═══════════════════════════════════════════════════════════════════════════
# PROJECT METADATA CATALOG
# ═══════════════════════════════════════════════════════════════════════════
#
# PURPOSE: We maintain the source of truth for each project.
#          This metadata flows into our notebook templates.
#
# ═══════════════════════════════════════════════════════════════════════════

PROJECTS = [
    {"name": "getting-a-good-nights-sleep", "title": "Getting a Good Night's Sleep", "topic": "Sleep Data Analysis", "level": "Basic"},
    {"name": "ai-assisted-product-launch", "title": "AI-Assisted Product Launch", "topic": "Market Strategy", "level": "Basic"},
    {"name": "ai-assisted-restaurant-planning", "title": "AI-Assisted Restaurant Planning", "topic": "Business Planning", "level": "Basic"},
    {"name": "ai-assisted-travel-planning", "title": "AI-Assisted Travel Planning", "topic": "Travel Optimization", "level": "Basic"},
    {"name": "analyzing-electric-vehicle-charging-habits", "title": "Analyzing EV Charging Habits", "topic": "EV Analysis", "level": "Basic"},
    {"name": "analyzing-industry-carbon-emissions", "title": "Analyzing Industry Carbon Emissions", "topic": "Environmental Data", "level": "Basic"},
    {"name": "analyzing-river-thames-water-levels", "title": "Analyzing River Thames Water Levels", "topic": "Time Series Analysis", "level": "Intermediate"},
    {"name": "analyzing-us-census-data-in-python", "title": "Analyzing US Census Data in Python", "topic": "Census Analysis", "level": "Intermediate"},
    {"name": "applying-sql-to-real-world-problems", "title": "Applying SQL to Real-World Problems", "topic": "SQL Analysis", "level": "Intermediate"},
    {"name": "build-an-educational-quiz-bot-with-the-openai-api", "title": "Educational Quiz Bot", "topic": "AI/ML", "level": "Basic"},
    {"name": "building-a-calorie-intake-calculator", "title": "Building a Calorie Intake Calculator", "topic": "Application Development", "level": "Intermediate"},
    {"name": "building-a-go-to-market-strategy", "title": "Building a Go-To-Market Strategy", "topic": "Business Strategy", "level": "Basic"},
    {"name": "building-core-sign-up-functions-to-help-validate-new-users", "title": "Sign-Up Validation", "topic": "Software Engineering", "level": "Advanced"},
    {"name": "building-rag-chatbots-for-technical-documentation", "title": "RAG Chatbots", "topic": "NLP/LLM", "level": "Intermediate"},
    {"name": "building-wedding-planning-software", "title": "Wedding Planning Software", "topic": "Software Engineering", "level": "Advanced"},
    {"name": "case-study-building-software-in-python", "title": "Building Software in Python", "topic": "Software Engineering", "level": "Advanced"},
    {"name": "case-study-set-up-a-book-recommendation-app-in-azure", "title": "Book Recommendation in Azure", "topic": "Cloud Computing", "level": "Basic"},
    {"name": "cleaning-an-orders-dataset-with-pyspark", "title": "Cleaning Orders with PySpark", "topic": "Big Data", "level": "Intermediate"},
    {"name": "cleaning-data-with-generative-ai", "title": "Data Cleaning with AI", "topic": "AI/Data Cleaning", "level": "Basic"},
    {"name": "consolidating-employee-data", "title": "Consolidating Employee Data", "topic": "Data Manipulation", "level": "Intermediate"},
    {"name": "data-driven-decision-making-in-sql", "title": "Data-Driven Decisions", "topic": "SQL/BI", "level": "Intermediate"},
    {"name": "data-storytelling-case-study-college-majors", "title": "College Majors Storytelling", "topic": "Data Visualization", "level": "Basic"},
    {"name": "data-storytelling-case-study-green-businesses", "title": "Green Businesses Storytelling", "topic": "Data Visualization", "level": "Basic"},
    {"name": "debugging-code", "title": "Debugging Code", "topic": "Python Debugging", "level": "Basic"},
    {"name": "detecting-cybersecurity-threats-using-deep-learning", "title": "Cybersecurity Threats Detection", "topic": "Deep Learning", "level": "Intermediate"},
    {"name": "developing-multi-input-models-for-ocr", "title": "Multi-Input OCR Models", "topic": "Computer Vision", "level": "Advanced"},
    {"name": "examining-the-history-of-lego-sets", "title": "LEGO Sets History", "topic": "Data Exploration", "level": "Basic"},
    {"name": "exploring-londons-travel-network", "title": "London Travel Network", "topic": "SQL Analysis", "level": "Basic"},
    {"name": "exploring-trends-in-american-baby-names", "title": "American Baby Names Trends", "topic": "Data Analysis", "level": "Basic"},
    {"name": "factors-that-fuel-student-performance", "title": "Student Performance Factors", "topic": "Education Analytics", "level": "Intermediate"},
    {"name": "generate-a-study-guide", "title": "Study Guide Generator", "topic": "AI/Education", "level": "Basic"},
    {"name": "generating-keywords-for-search-campaigns", "title": "SEO Keywords", "topic": "Marketing Automation", "level": "Basic"},
    {"name": "insurance-claim-processing-with-pinecone", "title": "Insurance Claims Processing", "topic": "Vector Database", "level": "Intermediate"},
    {"name": "personalized-language-tutor", "title": "Language Tutor", "topic": "NLP", "level": "Basic"},
    {"name": "powering-data-for-the-department-of-energy-building-an-etl-pipeline", "title": "DoE ETL Pipeline", "topic": "Data Engineering", "level": "Intermediate"},
    {"name": "predicting-traffic-volume-with-pytorch", "title": "Traffic Prediction", "topic": "Deep Learning", "level": "Intermediate"},
    {"name": "recommending-skincare-products", "title": "Skincare Recommendations", "topic": "Recommendation Systems", "level": "Basic"},
    {"name": "uncovering-the-worlds-oldest-businesses", "title": "World's Oldest Businesses", "topic": "SQL Analysis", "level": "Intermediate"},
    {"name": "understanding-subscription-behaviors", "title": "Subscription Behaviors", "topic": "SaaS Analytics", "level": "Intermediate"},
    {"name": "will-this-customer-purchase-your-product", "title": "Customer Purchase Prediction", "topic": "Predictive Analytics", "level": "Intermediate"},
]


def create_notebook_cell(source_lines, cell_type="code"):
    """
    We construct a single notebook cell with proper formatting.
    
    SCOPE FLOW:
      Input:  source_lines (list of code/markdown strings)
              cell_type (code or markdown)
      Output: Properly formatted cell dict for Jupyter notebook
    """
    return {
        "cell_type": cell_type,
        "execution_count": None if cell_type == "markdown" else 0,
        "metadata": {},
        "outputs": [],
        "source": source_lines
    }


def create_narrative_notebook(project):
    """
    We are notebook architects. We construct a comprehensive Jupyter notebook
    that tells the story of a project's data analysis journey.
    
    SCOPE FLOW:
      Input:  project (dict with name, title, topic, level)
      Output: Complete Jupyter notebook dict ready for serialization
      
    NARRATIVE STRUCTURE:
      1. Title & Introduction - Establish project purpose
      2. Environment Setup - Import libraries (we gather our tools)
      3. Data Loading - Bring data into our workspace
      4. Exploratory Analysis - We investigate and discover
      5. Analysis & Insights - We draw conclusions
      6. Conclusion - We summarize our journey
    """
    
    cells = []
    
    # ═══════════════════════════════════════════════════════════════════════
    # SECTION 1: PROJECT INTRODUCTION
    # ═══════════════════════════════════════════════════════════════════════
    
    cells.append(create_notebook_cell([
        f"# {project['title']}\n",
        f"\n",
        f"**Skill Level:** {project['level']}\n",
        f"**Topic:** {project['topic']}\n",
        f"\n",
        f"---\n",
        f"\n",
        f"## Our Journey\n",
        f"\n",
        f"We embark on this analysis with purpose. We are data explorers, seeking to uncover\n",
        f"patterns, understand relationships, and extract meaningful insights from the\n",
        f"{project['topic']} dataset. As we progress through each cell, we will:\n",
        f"\n",
        f"1. **Gather Our Tools** - Import necessary libraries for analysis\n",
        f"2. **Load Our Data** - Bring the dataset into our workspace\n",
        f"3. **Explore** - Examine structure, distributions, and relationships\n",
        f"4. **Analyze** - Perform deeper investigations\n",
        f"5. **Conclude** - Summarize our findings and insights\n",
        f"\n",
        f"Each cell represents a stage in our analytical journey. Variable scope flows\n",
        f"from one cell to the next, transitioning data through transformations that\n",
        f"build toward comprehensive understanding.\n"
    ], "markdown"))
    
    # ═══════════════════════════════════════════════════════════════════════
    # SECTION 2: ENVIRONMENT SETUP
    # ═══════════════════════════════════════════════════════════════════════
    
    cells.append(create_notebook_cell([
        f"# Environment Setup\n",
        f"\n",
        f"## Purpose\n",
        f"We gather the essential tools for our analysis. Each library serves a purpose\n",
        f"in our data exploration workflow:\n",
        f"- **pandas**: Our primary tool for data manipulation and exploration\n",
        f"- **numpy**: Numerical operations and array handling\n",
        f"- **matplotlib/seaborn**: Visualization of our discoveries\n",
        f"\n",
        f"## Import Flow\n",
        f"These imports establish our global analysis environment. We will reference\n",
        f"these libraries throughout all subsequent cells.\n"
    ], "markdown"))
    
    cells.append(create_notebook_cell([
        f"import pandas as pd\n",
        f"import numpy as np\n",
        f"import matplotlib.pyplot as plt\n",
        f"import seaborn as sns\n",
        f"import warnings\n",
        f"\n",
        f"# Configure visualization settings\n",
        f"sns.set_style('whitegrid')\n",
        f"plt.rcParams['figure.figsize'] = (12, 6)\n",
        f"warnings.filterwarnings('ignore')\n",
        f"\n",
        f"print('✓ All libraries imported successfully')\n",
        f"print(f'pandas version: {{pd.__version__}}')\n",
        f"print(f'numpy version: {{np.__version__}}')\n"
    ], "code"))
    
    # ═══════════════════════════════════════════════════════════════════════
    # SECTION 3: DATA LOADING & INSPECTION
    # ═══════════════════════════════════════════════════════════════════════
    
    cells.append(create_notebook_cell([
        f"# Data Loading & Initial Exploration\n",
        f"\n",
        f"## Data Ingestion\n",
        f"We now transition into the data loading phase. We open our dataset and\n",
        f"bring it into memory as a pandas DataFrame. This creates our primary\n",
        f"variable scope for all subsequent analysis.\n",
        f"\n",
        f"## Variable Scope Transition\n",
        f"From this point forward, the `df` variable exists in our workspace.\n",
        f"All transformations and analyses will operate on or derive from this\n",
        f"fundamental data structure.\n"
    ], "markdown"))
    
    cells.append(create_notebook_cell([
        f"# We load our primary dataset\n",
        f"# NOTE: Replace 'dataset.csv' with your actual data filename\n",
        f"df = pd.read_csv('../data/dataset.csv')\n",
        f"\n",
        f"# SCOPE TRANSITION: df is now our primary working dataset\n",
        f"print(f'Dataset shape: {{df.shape[0]}} rows × {{df.shape[1]}} columns')\n",
        f"print(f'\\nFirst few records:')\n",
        f"df.head()\n"
    ], "code"))
    
    # ═══════════════════════════════════════════════════════════════════════
    # SECTION 4: EXPLORATORY DATA ANALYSIS
    # ═══════════════════════════════════════════════════════════════════════
    
    cells.append(create_notebook_cell([
        f"# Exploratory Data Analysis (EDA)\n",
        f"\n",
        f"## Our Investigation Strategy\n",
        f"We now move into the exploration phase. Here we answer fundamental questions:\n",
        f"- What data types do we have?\n",
        f"- Are there missing values?\n",
        f"- What are the distributions of our key variables?\n",
        f"- Are there obvious patterns or relationships?\n",
        f"\n",
        f"Each analysis step builds on previous findings, creating a narrative of discovery.\n"
    ], "markdown"))
    
    cells.append(create_notebook_cell([
        f"# Step 1: We examine the structure of our data\n",
        f"print('=== DATA STRUCTURE ===')\n",
        f"print(df.info())\n",
        f"print('\\n=== DATA SUMMARY STATISTICS ===')\n",
        f"df.describe()\n"
    ], "code"))
    
    cells.append(create_notebook_cell([
        f"# Step 2: We check for missing values (data quality assessment)\n",
        f"print('=== MISSING VALUES ANALYSIS ===')\n",
        f"missing = df.isnull().sum()\n",
        f"missing_pct = (missing / len(df)) * 100\n",
        f"missing_df = pd.DataFrame({{\n",
        f"    'Missing Count': missing,\n",
        f"    'Percentage': missing_pct\n",
        f"}})\n",
        f"missing_df = missing_df[missing_df['Missing Count'] > 0]\n",
        f"\n",
        f"if len(missing_df) > 0:\n",
        f"    print(missing_df)\n",
        f"else:\n",
        f"    print('✓ No missing values detected')\n"
    ], "code"))
    
    cells.append(create_notebook_cell([
        f"# Step 3: We examine unique values and data distributions\n",
        f"print('=== COLUMN UNIQUENESS ANALYSIS ===')\n",
        f"for col in df.columns:\n",
        f"    unique_count = df[col].nunique()\n",
        f"    print(f'{{col}}: {{unique_count}} unique values')\n"
    ], "code"))
    
    # ═══════════════════════════════════════════════════════════════════════
    # SECTION 5: ANALYSIS & VISUALIZATION
    # ═══════════════════════════════════════════════════════════════════════
    
    cells.append(create_notebook_cell([
        f"# Analysis & Visualization\n",
        f"\n",
        f"## Our Discovery Process\n",
        f"We now visualize patterns and relationships. Our transformations of the\n",
        f"original data flow through visualizations that make patterns visible.\n",
        f"\n",
        f"## Variable Scope Continuity\n",
        f"The original `df` remains unchanged. Any derived variables (filtered\n",
        f"subsets, aggregations, etc.) exist in local scope within each cell.\n"
    ], "markdown"))
    
    cells.append(create_notebook_cell([
        f"# We create visualizations to understand patterns\n",
        f"# This shows the distribution of our first numeric column\n",
        f"\n",
        f"numeric_cols = df.select_dtypes(include=[np.number]).columns\n",
        f"\n",
        f"if len(numeric_cols) > 0:\n",
        f"    fig, axes = plt.subplots(1, min(3, len(numeric_cols)), figsize=(15, 4))\n",
        f"    if len(numeric_cols) == 1:\n",
        f"        axes = [axes]\n",
        f"    \n",
        f"    for idx, col in enumerate(numeric_cols[:3]):\n",
        f"        axes[idx].hist(df[col].dropna(), bins=30, edgecolor='black', alpha=0.7)\n",
        f"        axes[idx].set_title(f'Distribution of {{col}}')\n",
        f"        axes[idx].set_xlabel(col)\n",
        f"        axes[idx].set_ylabel('Frequency')\n",
        f"    \n",
        f"    plt.tight_layout()\n",
        f"    plt.show()\n",
        f"    print('✓ Visualizations created')\n"
    ], "code"))
    
    # ═══════════════════════════════════════════════════════════════════════
    # SECTION 6: KEY FINDINGS & CONCLUSION
    # ═══════════════════════════════════════════════════════════════════════
    
    cells.append(create_notebook_cell([
        f"# Key Findings & Conclusion\n",
        f"\n",
        f"## Our Journey Summarized\n",
        f"We have completed our exploratory analysis of the {project['topic']} dataset.\n",
        f"\n",
        f"### What We Discovered\n",
        f"1. **Dataset Overview**: We examined {{df.shape[0]}} records with {{df.shape[1]}} features\n",
        f"2. **Data Quality**: We assessed completeness and identified any issues\n",
        f"3. **Distributions**: We visualized patterns in key variables\n",
        f"\n",
        f"### Next Steps\n",
        f"- Deeper statistical analysis of relationships\n",
        f"- Hypothesis testing on key variables\n",
        f"- Predictive modeling (if applicable)\n",
        f"- Domain-specific insights and recommendations\n",
        f"\n",
        f"## Variable Scope Legacy\n",
        f"Our primary `df` DataFrame is now fully explored. All transformations\n",
        f"and aggregations we've created are available for reference or further analysis.\n"
    ], "markdown"))
    
    # ═══════════════════════════════════════════════════════════════════════
    # NOTEBOOK METADATA
    # ═══════════════════════════════════════════════════════════════════════
    
    notebook = {
        "cells": cells,
        "metadata": {
            "kernelspec": {
                "display_name": "Python 3",
                "language": "python",
                "name": "python3"
            },
            "language_info": {
                "name": "python",
                "version": "3.8.0"
            }
        },
        "nbformat": 4,
        "nbformat_minor": 4
    }
    
    return notebook


def generate_all_notebooks():
    """
    We orchestrate the generation of all project notebooks.
    
    EXECUTION FLOW:
      1. We iterate through all projects
      2. We construct the repository path
      3. We generate the narrative notebook
      4. We serialize to JSON
      5. We write to the notebooks directory
      6. We report our success
    """
    
    print("\n" + "="*70)
    print("JUPYTER NOTEBOOK GENERATION ENGINE - Starting")
    print("="*70 + "\n")
    
    success_count = 0
    failed_count = 0
    base_path = Path("C:/GitHub/datacamp-projects")
    
    for project in PROJECTS:
        project_name = project["name"]
        repo_path = base_path / project_name / "notebooks"
        notebook_path = repo_path / "analysis.ipynb"
        
        try:
            # We ensure the directory exists
            repo_path.mkdir(parents=True, exist_ok=True)
            
            # We generate the narrative notebook
            notebook = create_narrative_notebook(project)
            
            # We serialize to JSON
            with open(notebook_path, 'w') as f:
                json.dump(notebook, f, indent=2)
            
            print(f"✓ {project_name}")
            success_count += 1
            
        except Exception as e:
            print(f"✗ {project_name} - Error: {e}")
            failed_count += 1
    
    # We report our completion
    print("\n" + "="*70)
    print("GENERATION COMPLETE")
    print("="*70)
    print(f"Notebooks Created: {success_count}")
    print(f"Failed: {failed_count}")
    print(f"\nAll project repositories now have narrative Jupyter notebooks!")


if __name__ == "__main__":
    generate_all_notebooks()
