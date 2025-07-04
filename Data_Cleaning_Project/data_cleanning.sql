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

-- cleanining a country column
UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'united States%';
 
SELECT country
FROM layoffs_staging2
WHERE country like 'united States%';

SELECT `date`, STR_TO_DATE(`date`,'%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`,'%m/%d/%Y');

SELECT `date`
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2 -- we modify the type of the date column from text to date type
MODIFY COLUMN `date` date;

-- deal with  null and blank value 

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL;

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';


SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

-- since there some blank value into industry column for AIrbnb company we are going to update this blank values a travel company
-- how can we deal with the null values or blank value ? we are going to fill these null columns or value with the value in the table which has the same company ( for industry)
-- example if we have two row with which both the company value Airbnb and for one the industry is blank and for another the industry is blank we are going to fill this blank we the value in the not null raw
-- how can we do this ? --> with join 
/*UPDATE layoffs_staging2 t1 
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry = ''
AND t2.industry IS NOT NULL;*/ -- this doesnt work

SELECT company, MAX(industry) as industry
from layoffs_staging2
WHERE industry IS NOT NULL AND industry != ''
GROUP BY company;

UPDATE layoffs_staging2 AS t1
JOIN(SELECT company, MAX(industry) as industry
from layoffs_staging2
WHERE industry IS NOT NULL AND industry != ''
GROUP BY company)AS t2 ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL OR t1.industry = '';

SELECT t1.company , t2.company, t1.industry, t2.industry 
FROM layoffs_staging2 t1 
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE  t1.industry = ''
AND t2.industry IS NOT NULL;


DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL ;

SELECT *
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;





