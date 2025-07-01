

-- CTEs: Common Table Expression
WITH CTE_Example (Gender, AVG_sal, MAX_Sal, MIN_Sal, COUNT_Sal) AS
(
SELECT gender, AVG(salary) avg_sal, MAX(salary) max_sal, MIN(salary) min_sal, COUNT(salary) count_sal
FROM employee_demographics dem
JOIN  employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
) -- this create a tempory table that is not in the memory just temporary

SELECT *
FROM CTE_Example
;

-- li CTE  è un alternativa alle subqueries.
SELECT avg(avg_sal)
FROM(
SELECT gender, AVG(salary) avg_sal, MAX(salary) max_sal, MIN(salary) min_sal, COUNT(salary) count_sal
FROM employee_demographics dem
JOIN  employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender) subquery_example;


WITH CTE_Example1 AS
(
SELECT employee_id, gender, birth_date
FROM employee_demographics
WHERE birth_date > '1985-01-01'
) ,
CTE_Example2 AS
(
SELECT employee_id, salary
FROM employee_salary
WHERE salary > 50000
)
SELECT *
FROM CTE_Example1 e1
JOIN CTE_Example2 e2
ON  e1.emplyee_id = e2.employee_id
;
