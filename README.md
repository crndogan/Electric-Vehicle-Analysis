# Electric-Vehicle-Analysis
Electric Vehicle Population Data Analysis in R

## Overview
This project analyzes the **Electric Vehicle Population Data** published by the Washington State Department of Licensing.  

The goal is to explore trends in electric vehicle adoption, vehicle age distribution, EV types, and relationships between price and range.


## Methods
Key steps in the analysis:
1. **Data Cleaning & Transformation**
   - Renamed columns for clarity
   - Created new fields (EV age, price range, CAFV eligibility, brand field, range quality)
   - Converted categorical variables to factors  

2. **Exploratory Data Analysis**
   - Top EV makes by count (bar chart)
   - Vehicle age distribution (histogram)
   - Average EV range vs. base price (scatter plot)
   - Distribution of EV types (pie chart)
   - Top 10 makes by average range (line chart)

3. **Exported Data**
   - Clean dataset → `Ev_Data.csv`
   - EV counts by state → `Df1_EvState.csv`
   - EV type distribution → `Df2_EvType.csv`
   - Average price vs. range → `Df3_EvPrice.csv`

---

## Example Visualizations
- 📊 Bar chart: Top 5 vehicle makes by count  
- 📈 Histogram: Distribution of EV ages  
- ⚡ Scatter plot: Average range vs. average price  
- 🥧 Pie chart: Distribution of EV types  
- 📉 Line chart: Top 10 makes by average electric range  

(*see `/outputs/` or report docx for sample charts*)

---

## How to Run
1. Clone this repo:
   ```bash
   git clone https://github.com/yourusername/Electric-Vehicle-Analysis.git
   cd Electric-Vehicle-Analysis
