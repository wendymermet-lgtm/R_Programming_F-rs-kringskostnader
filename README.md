# R_Programming_F-rs-kringskostnader

Student : Wendy Mermet

## Projekt
Försäkringskostnader – analysera vilka faktorer som hänger ihop med kostnader i R


## Kom igång
  1. Klona repot från GitHub
  2. Öppna `R_Programming_F-rs-kringskostnader.Rproj` i RStudio
  3. Installera nödvändiga paket (se nedan)
  4. Lägg originalfilen `insurance_costs.csv` i projektet
  5. Kör `run_full_analysis.R` för att köra alla scripts i sekvens

## Paket
  1. Datamanipulation (tidyverse-kärnan)
    install.packages("tidyverse")
    install.packages("dplyr")
    install.packages("tidyr")

 2. Visualisering
    install.packages("ggplot2")
    install.packages("patchwork")
    install.packages("GGally")

 3. Modellering
    install.packages("tidymodels")
    install.packages("recipes")
    install.packages("ranger")

 4. Verktyg
    install.packages("fastDummies")

 5. Rapportering och appar
    install.packages("knitr")
    install.packages("shiny")

 6. Reproducerbarhet
    install.packages("renv")
    
    
## Filstruktur
    
project/R_Programming_Försäkringskostnader.Rproj    
├── data
│   └── insurance_costs.csv                       # Rådata
├── report
│   ├── df_insurance.csv                          # Dataset för shiny appen, kommer från scripts/03_data_preparation.R
│   ├── final_report.html
│   ├── final_report.qmd                          # Quarto-källfil för rapporten
│   ├── final_report_files
│   ├── images                                    # Auto-genererade grafer från /scripts/99_figures.R
│   │   ├── charges_distribution.png
│   │   ├── charges_per_plan_type.png
│   │   ├── linear_regression_residual_plot.png
│   │   ├── model_results_summary.png
│   │   ├── random_forest_residual_plot.png
│   │   └── top_10_drivers.png
│   └── README.md
├── run_full_analysis.R                         **# Kör hela analysen i sekvens**
└── scripts
    ├── 01_load_data.R                            # Laddar in data
    ├── 02_raw_data_check.R                       # Dataförståelse
    ├── 03_data_preparation.R                     # Datastädning och förbehandling
    ├── 04_analysis.R                             # Variabelanalys
    ├── 05_regression_analysis.R                  # Regressionsanalys
    ├── 06_regression_error_analysis.R            # Residualanalys    
    └── 99_figures.R                              # Genererar grafer till report/images
