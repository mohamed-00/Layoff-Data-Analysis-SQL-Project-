-- Retrieve all records from the layoffs staging table
SELECT *
FROM layoffs_staging2;

-- Get the maximum number of layoffs and highest percentage of layoffs
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- Get the total number of layoffs per country, sorted in descending order
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- Get the total number of layoffs per industry, sorted in descending order
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- Get the earliest and latest recorded dates in the dataset
SELECT MAX(`date`), MIN(`date`)
FROM layoffs_staging2;

-- Get the total number of layoffs per country for the year 2022
SELECT country, YEAR(`date`) AS year_date, SUM(total_laid_off)
FROM layoffs_staging2
WHERE YEAR(`date`) = 2022
GROUP BY country, year_date
ORDER BY 3 DESC;

-- Get the total number of layoffs per month, sorted in descending order
SELECT SUBSTRING(`date`,1,7) AS date_, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY date_
ORDER BY 2 DESC;

-- Get the maximum layoffs and highest layoff percentage per company and industry, sorted in descending order
SELECT country, company, industry, MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2
GROUP BY country, company, industry
ORDER BY 4 DESC;

-- Calculate rolling total of layoffs by month
WITH Rolling_total AS (
    SELECT
        SUBSTRING(`date`,1,7) AS Month_date,
        SUM(total_laid_off) AS total_off
    FROM layoffs_staging2
    WHERE SUBSTRING(`date`,1,7) IS NOT NULL
    GROUP BY Month_date
)
SELECT Month_date, total_off
FROM Rolling_total
ORDER BY Month_date;
