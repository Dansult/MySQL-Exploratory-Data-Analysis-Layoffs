# MySQL Exploratory Data Analysis: Company Layoffs Dataset

![SQL Analysis](https://img.shields.io/badge/SQL-Data%20Analysis-blue)
![MySQL](https://img.shields.io/badge/MySQL-8.0-orange)
![Business Intelligence](https://img.shields.io/badge/BI-Insights-green)

## Project Overview
This project demonstrates a comprehensive exploratory data analysis of company layoffs using MySQL. Building upon cleaned data, this analysis uncovers patterns, trends, and insights that provide valuable business intelligence about workforce reductions across industries, companies, and time periods.

## Business Problem
Organizations and job seekers need actionable insights about layoff trends to:
- Identify industries most affected by workforce reductions
- Track layoff patterns over time to detect cyclical trends
- Compare companies' layoff behaviors across different funding stages
- Understand the geographic distribution of major workforce changes
- Identify which companies have the highest layoff rates relative to their size

This analysis transforms raw layoff data into strategic business intelligence that can guide investment decisions, career planning, and industry forecasting.

## Technologies Used
- MySQL 8.0
- SQL analytical techniques including:
  - Aggregate functions (SUM, AVG, MAX)
  - Window functions for cumulative calculations
  - Common Table Expressions (CTEs) for multi-step analysis
  - DENSE_RANK() for competitive ranking
  - Time-based aggregations and trend analysis
  - Subqueries and complex JOINs

## Analysis Techniques

### 1. Identifying Extremes
Located maximum layoff events and highest percentage cuts:
```sql
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;
```

### 2. Company-Level Aggregations
Analyzed total layoffs by company to identify organizations with greatest workforce impacts:
```sql
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;
```

### 3. Industry Impact Analysis
Compared layoff volumes across different industries to reveal sector-specific trends:
```sql
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;
```

### 4. Geographic Distribution
Examined country-level data to understand global distribution of layoff events:
```sql
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;
```

### 5. Temporal Trend Analysis
Created rolling totals to track cumulative layoffs over time:
```sql
WITH Rolling_Total AS
(
  SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
  FROM layoffs_staging2
  WHERE SUBSTRING(`date`,1,7) IS NOT NULL
  GROUP BY `MONTH`
  ORDER BY 1 ASC
)
SELECT `MONTH`, total_off,
  SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;
```

### 6. Advanced Ranking Analysis
Used window functions to identify top companies by year for layoff volumes:
```sql
WITH Company_Year (company, years, total_laid_off) AS
(
  SELECT company, YEAR(`date`), SUM(total_laid_off)
  FROM layoffs_staging2
  GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(
  SELECT *, 
  DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
  FROM Company_Year
  WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5;
```

## Key Insights

The analysis reveals several actionable insights:
- **Temporal patterns**: Clear identification of peak layoff periods
- **Industry vulnerability**: Ranking of industries by total workforce reduction
- **Geographic concentrations**: Countries most affected by tech sector layoffs
- **Company-specific trends**: Organizations with consistent layoff patterns across years
- **Funding stage correlation**: Relationship between company maturity and layoff behavior
- **Scale comparison**: Relative impact of layoffs across different company sizes

## Business Applications

This analysis enables various strategic applications:
- Market research for workforce planning
- Investment strategy development for venture capital
- Risk assessment for job seekers evaluating companies
- Competitive intelligence for industry analysts
- Trend forecasting for economic researchers
- Business cycle understanding for strategic planning

## Skills Demonstrated

This project showcases the following analytical capabilities:
- Data exploration and insight extraction
- Complex SQL query construction
- Window function expertise
- Time-series analysis techniques
- Comparative and ranking analytics
- Business intelligence development
- Translating technical findings into business value

---

*This project is part of my portfolio demonstrating SQL analytics skills for business intelligence applications.*
