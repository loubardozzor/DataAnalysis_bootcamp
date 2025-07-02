-- Data Cleaning


SELECT *
FROM layoffs;

-- 1.Remove Duplicates
-- 2. Standardize the data
-- 3. Null Values or blank values
-- 4. Remove Any Columns

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT * 
FROM layoffs;

SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`)AS row_num
FROM layoffs_staging;

WITH duplicate_cte AS(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`)AS row_num
FROM layoffs_staging
)
select * 
from duplicate_cte 
where row_num >=2
;
-- since while partitioning by the 5 first  columns we fine some row that are duplicate in that columns but not in the intire set of columns we are going to do the parition over all columns

WITH duplicate_cte AS(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`,stage, country, 
funds_raised_millions)AS row_num
FROM layoffs_staging2
)
select * 
from duplicate_cte 
where row_num >=2;

-- after finding the duplicated raw we are going to delete these duplicated







