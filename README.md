# AI-Powered Introductory Single-Cell Analysis (Seminar 2)

This repository contains the R code, data, and documentation for analyzing single-cell RNA-seq data using automated AI agents for AI & Bioinformatics Seminar 2.

Date: 2026.06.29

This is a simple guideline for learners who attend the AI & Bioinformatics lectures for non-commercial purposes.

## Key Features
* **Automated Data Cleaning:** Scripts to clean and preprocess raw data files using base functions in R.
* **AI-Powered:** State-of-the-art AI agents enable code-free analysis, benefiting beginners.
* **Dynamic Reports:** Automatically generates reports using an AI agent.

## 📂 Project Structure
```text
├── data/               # Raw and processed data files (do not edit raw data)
├── scripts/            # Modular R scripts for data processing and analysis
├── reports/            # R Markdown (.Rmd) or Quarto (.qmd) files and generated HTML/PDF outputs
├── result/             # Saved R objects and analytical outputs
├── SingleCellOmics_with_AI.Rproj  # RStudio project file
└── README.md           # This file
```

## 🛠️ Requirements & Installation

### Prerequisites
You need **R** (version 4.4.0 or higher) and **RStudio** installed on your machine.

Download R from https://mirrors.sustech.edu.cn/CRAN/

Download RStudio from https://docs.posit.co/ide/user/#rstudio-ide-oss-downloads

### R Dependencies
This project relies on several R packages. You can install all required packages by running the following command in your RStudio console:

```R
install.packages(c("ggplot2", "igraph", "uwot", "dplyr", "remotes", "Seurat"))
remotes::install_github("IMNMV/ClaudeR")
```

### Download & Configure Claude Code
Follow these steps to set up the global command-line AI assistant:

```bash
## Dependencies
# macOS
brew install node
brew install git

# Windows
# Install Node.js and Git using your preferred package manager or installer

# Download Claude Code
npm install -g @anthropic-ai/claude-code

# Edit settings.json to avoid regional restrictions
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://api.deepseek.com/anthropic",
    "ANTHROPIC_AUTH_TOKEN": "sk-*******",
    "ANTHROPIC_MODEL": "deepseek-v4-flash",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "deepseek-v4-flash",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "deepseek-v4-flash",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "deepseek-v4-flash",
    "CLAUDE_CODE_EFFORT_LEVEL": "max"
  }
}

# Clone this repository to your local machine
git clone https://github.com/Zhihao-Huang/SingleCellOmics_with_AI.git
```

## How to Run the Project
1. Open the **`SingleCellOmics_with_AI.Rproj`** file to launch the project in RStudio.
2. Open `scripts/01.run_clustering.R` to import raw datasets and preprocess data using base R functions.
3. Alternatively, open `scripts/01.run_Seurat.R` to process data using the Seurat pipeline.
4. Open `scripts/02.visualized_by_AI.R` to plot the clustering results from the step 1 scripts using ClaudeR.

## Expected Outputs
* **`result/Seurat_obj.rds`**: The main document containing the results of `01.run_Seurat.R`.
* **`result/base_obj.rds`**: The main document containing the results of `01.run_clustering.R`.

## In the next lecture we will learn how to use academic-research-skills in Claude Code
`academic-research-skills` is a comprehensive suite of Claude Code skills for academic research, covering the full pipeline from research to publication.
* **`Deep Research`**
* **`Academic Paper`**
* **`Academic paper reviewer`**
* **`Academic Pipeline`**

## The details of this lecture will be also available on WeChat Official Account: * **`单细胞组学`**

## 📝 Author
* **Huang Zhihao** - *Initial work* - [https://github.com/Zhihao-Huang](https://github.com/Zhihao-Huang)
