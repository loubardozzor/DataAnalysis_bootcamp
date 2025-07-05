
-- Exploration Data Analysis

SELECT *
FROM layoffs_staging2;

SELECT Max(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off=1;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT `date`, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY `date`
ORDER BY 1 DESC;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 1 DESC;


SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;


WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) as total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC

)
SELECT `MONTH`, SUM(total_off) OVER(ORDER BY  `MONTH`)
FROM Rolling_Total;



/* We are trying to find the company who has the most laid_off per year */
WITH Company_Year(company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
) -- Campanya_Year_Rank
SELECT *,
DENSE_RANK() OVER (PARTITION BY years   ORDER BY total_laid_off DESC ) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL;

/* we will get for all the four years the companies who have the most laid_off*/


WITH Company_Year(company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS(
SELECT *,
DENSE_RANK() OVER (PARTITION BY years   ORDER BY total_laid_off DESC ) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5
;

    SELECT COLUMN_NAME 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'layoffs_staging2' 
	AND TABLE_CATALOG = 'world_layoffs'; 

/*We are given a CSV file named "layoffs.csv" with the following columns:
 company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions
 We are to generate a list of the top 10 countries with the highest total number of layoffs. 
 However, note that the data has some entries where `total_laid_off` is NULL. We should skip those.*/
 
 SELECT country, SUM(total_laid_off) as sum
 from layoffs_staging2
 where total_laid_off IS NOT NULL
 group by country
 ORDER BY sum DESC;

 
 select count(*)
 from layoffs_staging2;

select company, sum(total_laid_off) as sum
from layoffs_staging2
where total_laid_off is not null
group by company 
order by  sum desc
limit 10;

select company, (total_laid_off) as sum
from layoffs_staging2
where total_laid_off is not null
order by  sum desc
limit 10;

  -- Find the total layoffs per month, ordered by the month. (Hint: You can use 
  -- the `date` column. Assume the date format is 'MM/DD/YYYY'.)

select month(`date`) as month_, sum(total_laid_off) as sum
from layoffs_staging2
where total_laid_off is not null
group by month(`date`)
order by 1;    

-- Count the number of records where the `total_laid_off` is NULL.

SELECT COUNT(*)
FROM layoffs_staging2
WHERE total_laid_off is null;

SELECT avg(total_laid_off)
FROM layoffs_staging2
WHERE stage like 'Post-IPO';


-- For each country and industry, calculate the total layoffs. 
-- Order the results by country and then by total layoffs descending.

SELECT country, industry, count(total_laid_off) as total
FROM layoffs_staging2
GROUP BY country, industry
order BY country, total;

-- Find industries where the total number of layoffs across all companies in that 
-- industry is greater than 10,000. Show the industry and total layoffs


SELECT industry, sum(total_laid_off) as total
FROM layoffs_staging2
where industry is not null
group by industry
having total > 10000
ORDER BY total desc;

WITH ranked_layoffs AS(
SELECT *, ROW_NUMBER() OVER(PARTITION BY country ORDER BY total_laid_off DESC) as rank_in_country
FROM layoffs_staging2
WHERE total_laid_off IS NOT NULL
AND country IS NOT NULL
)
SELECT *
FROM ranked_layoffs
WHERE rank_in_country = 1;


-- with the subquery

SELECT *
FROM layoffs_staging2
where (country, total_laid_off) in
(
	SELECT country, max(total_laid_off)
	FROM layoffs_staging2
	WHERE country is not null
    and total_laid_off is not null 
	group by country)


