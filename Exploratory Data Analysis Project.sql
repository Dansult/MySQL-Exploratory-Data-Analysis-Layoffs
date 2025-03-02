--- Exploratory Data Analysis


select *
from layoffs_staging2;

select MAX(total_laid_off), MAX(percentage_laid_off)
from layoffs_staging2;

select *
from layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

select company, SUM(total_laid_off)
from layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

select MIN(`date`), MAX(`date`)
from layoffs_staging2;

select industry, SUM(total_laid_off)
from layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;


select country, SUM(total_laid_off)
from layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

select *
from layoffs_staging2;

select stage, SUM(total_laid_off)
from layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

select company, AVG(percentage_laid_off)
from layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

#Rolling total of layoffs

select SUBSTRING(`date`, 1,7) AS `MONTH`, SUM(total_laid_off)
from layoffs_staging2
WHERE SUBSTRING(`date`, 1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

select *
from layoffs_staging2;



WITH Rolling_Total AS
(
select SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
from layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off
,SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

# Show which company laid off people in which year?
select company, YEAR(`date`), SUM(total_laid_off)
from layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY company ASC;

select company, YEAR(`date`), SUM(total_laid_off)
from layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 2 DESC;

select company, YEAR(`date`), SUM(total_laid_off)
from layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;


WITH Company_Year AS
(
select company, YEAR(`date`), SUM(total_laid_off)
from layoffs_staging2
GROUP BY company, YEAR(`date`)
)
SELECT *
FROM Company_Year;

# Show top 5 companies that laid the most people off, ordered by Year and Rank
WITH Company_Year (company, years, total_laid_off) AS
(
select company, YEAR(`date`), SUM(total_laid_off)
from layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(SELECT *, 
DENSE_RANK() OVER (partition by years order by total_laid_off desc) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5;