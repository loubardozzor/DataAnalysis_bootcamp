-- Having vs where

SELECT gender, AVG(age)
FROM employee_demographics
WHERE AVG(age) > 40
GROUP BY gender;
-- this didn't work because we are trying to filter before grouping. while filtering AVG(age) doesn't exit because it will exist after the group by and select yet  do this instead
 
SELECT gender, AVG(age)
FROM employee_demographics
GROUP BY gender
HAVING AVG(age) > 40
;

SELECT occupation, AVG(salary)
FROM employee_salary
WHERE occupation LIKE  '%manager%'
GROUP BY occupation
HAVING AVG(salary) > 75000
;
-- HAVING work in the group data after the obviously the WHERE work on the initial data  order of the execution from -> where --> groupby --> select --> having

