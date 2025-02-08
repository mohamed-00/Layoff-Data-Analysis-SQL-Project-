-- Select all columns and generate a row number for each unique record based on specific fields
SELECT *, ROW_NUMBER() OVER (
    PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,
    `date`, stage, country, funds_raised_millions
) AS row_num
FROM layoffs_staging;

-- Create a new table to store cleaned data with row numbers
CREATE TABLE `layoffs_staging2` (
    `company` TEXT,
    `location` TEXT,
    `industry` TEXT,
    `total_laid_off` INT DEFAULT NULL,
    `percentage_laid_off` TEXT,
    `date` TEXT,
    `stage` TEXT,
    `country` TEXT,
    `funds_raised_millions` INT DEFAULT NULL,
    `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Insert data into the new table with row numbers to identify duplicates
INSERT INTO layoffs_staging2
SELECT *, ROW_NUMBER() OVER (
    PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,
    `date`, stage, country, funds_raised_millions
) AS row_num
FROM layoffs_staging;

-- Select all records where the company name appears at least once in the dataset
SELECT *
FROM layoffs_staging2
WHERE company IN (
    SELECT company FROM layoffs_staging2 WHERE row_num >= 1
);

-- Remove duplicate rows, keeping only the first occurrence
DELETE FROM layoffs_staging2
WHERE row_num > 1;

-- Retrieve a list of unique company names with any trailing spaces removed
SELECT DISTINCT TRIM(company)
FROM layoffs_staging2;

-- Standardize company names by trimming any extra spaces
UPDATE layoffs_staging2
SET company = TRIM(company);

-- Count the number of layoffs per industry and sort them in descending order
SELECT DISTINCT industry, COUNT(*) AS industry_count
FROM layoffs_staging2
GROUP BY industry
ORDER BY industry_count DESC;
