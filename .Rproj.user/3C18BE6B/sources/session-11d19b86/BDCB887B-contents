# AI-Powered Introductory Single-Cell Analysis (Seminar 2)

<!-- Add a brief, 1-2 sentence summary explaining what this repository or R project does. -->
This is a simple guideline for learners who attend the AI & Bioinformatics lectures for non-commercial purposes.

This repository contains the R code, data, and documentation for analyzing single-cell RNA-seq data in AI & Bioinformatics Seminar 2. The primary purpose is to automate the processing of single-cell RNA-seq data from cellranger and generate reproducible results using AI agent.

## Key Features
* **Automated Data Cleaning:** Scripts to clean and preprocess raw data files using base functions in R.
* **AT-Powered** State-of-the-art AI agent enable code-free analysis, benefit for beginner.
* **Dynamic Reports:** Automatically generates reports using AI agent.

## 📂 Project Structure
```text
├── data/               # Raw and processed data files (do not edit raw data)
├── scripts/            # Modular R scripts for data processing and analysis
├── reports/            # R Markdown (.Rmd) or Quarto (.qmd) files and generated HTML/PDF outputs
├── SingleCellOmics_with_AI.Rproj  # RStudio project file
└── README.md           # This file
```

## 🛠️ Requirements & Installation

### Prerequisites
You need **R** (version 4.4.0 or higher) and **RStudio** installed on your machine.

Download R from https://mirrors.sustech.edu.cn/CRAN/
Download Rstudio from https://docs.posit.co/ide/user/#rstudio-ide-oss-downloads

### R Dependencies
This project relies on several R packages. You can install all required packages by running the following command in your RStudio console:

```R
install.packages(c("ggplot", "igraph", "uwot", 'dplyr','remotes','Seurat'))
remotes::install_github("IMNMV/ClaudeR")
```

### Download Claude Code
This project relies on several R packages. You can install all required packages by running the following command in your RStudio console:

```bash
## Dependencies
# macOS
brew install node
brew install git
# window

# Download Claude Code
npm install -g @anthropic-ai/claude-code
# Edit settings.json to avoid regions restriction
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://api.deepseek.com/anthropic",
    "ANTHROPIC_AUTH_TOKEN": "sk-*******",
    "ANTHROPIC_MODEL": "deepseek-v4-flash",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "deepseek-v4-flash",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "deepseek-v4-flash",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "deepseek-v4-flash”,
    "CLAUDE_CODE_EFFORT_LEVEL": "max"
  }
}
# 
# Clone this repository to your local machine
git clone https://github.com/Zhihao-Huang/SingleCellOmics_with_AI.git
```


## How to Run the Project
1. Open the **`SingleCellOmics_with_AI.Rproj`** file to launch the project in RStudio.
2. Open `scripts/01.run_clustering.R` to import the raw datasets and preprocess data.
3. Alternatively, Open `scripts/01.run_Seurat.R` to import the raw datasets and preprocess data.
4. Open `scripts/02.visualized_by_AI.R` to plot the clustering results from 01 scripts by ClaudeR.

##  Expected Outputs
* **`result/final_report.html`**: The main dynamic document containing all figures, tables, and statistical interpretations.
* **`data/cleaned_data.csv`**: The tidy dataset ready for secondary analysis.


## In the next lecture we will learn how to use academic-research-skills in Claude Code
academic-research-skills is a comprehensive suite of Claude Code skills for academic research, covering the full pipeline from research to publication.
* **`Deep Research`**
* **`Academic Paper`**
* **`Academic paper reviewer`**
* **`Academic Pipeline`**


## 📝 Author
* **Huang Zhihao** - *Initial work* - [https://github.com/Zhihao-Huang](https://github.com)