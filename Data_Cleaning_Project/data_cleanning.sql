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

-- 1. remove duplicate
-- let try to identify duplicate : 
select *, count(*)
from layoffs
group by company, location, industry, total_laid_off, percentage_laid_off, `date`,stage, country, 
funds_raised_millions
having count(*)>1;


-- since we have some duplicated raw we are going to delelte these duplicated 
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
FROM layoffs_staging
)
select * 
from duplicate_cte 
where row_num >=2;

-- after finding the duplicated raw we are going to delete these duplicated



DROP TABLE layoffs_staging2;


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

ALTER TABLE layoffs_staging2
ADD COLUMN row_num int ;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`,stage, country, 
funds_raised_millions)AS row_num
FROM layoffs_staging;

delete 
from layoffs_staging2
where row_num>=2;



-- 2. Standardizing data
SELECT company, TRIM(company) /* to remove white space at the begining of the company*/
FROM layoffs_staging2;



select * from layoffs_staging2;
UPDATE layoffs_staging2
SET company = TRIM(company)
;


SELECT  DISTINCT(industry)
FROM layoffs_staging2
ORDER BY 1;


SELECT * 
from layoffs_staging2
where  industry like 'Crypto%';


UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry like 'Crypto%';

-- 

with industry_cte as(
select industry
from layoffs_staging
)


update layoffs_staging2 
set industry = industry_cte.industry;












