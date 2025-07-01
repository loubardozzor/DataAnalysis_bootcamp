-- Window Functions


-- compute the average salary for the entire table and put the avarage in every place in the avg column
SELECT dem.first_name, dem.last_name,gender, AVG(salary)
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY dem.first_name, dem.last_name,gender;


SELECT dem.first_name, dem.last_name,gender, AVG(salary) OVER(PARTITION BY gender, dem.first_name, dem.last_name)
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
    
  
  -- this query will create two partion over the data because we have two possible value of gender attribute e or each value  it will calculate the Sum and assign and every line with the same value gender will have the same value of sum
	-- final sum
SELECT dem.first_name, dem.last_name,gender, salary,
SUM(salary) OVER(PARTITION BY gender ) AS Rolling_Total
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
    
 
 
 -- cumulated sum
SELECT dem.first_name, dem.last_name,gender, salary,
SUM(salary) OVER(PARTITION BY gender order by dem.employee_id ) AS Rolling_Total
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
    
    
SELECT dem.employee_id,dem.first_name, dem.last_name,gender, salary,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) AS row_num
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
    
    
    
SELECT dem.employee_id,dem.first_name, dem.last_name,gender, salary,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) AS rank_number,
RANK() OVER(PARTITION BY gender ORDER BY salary DESC) rank_num,
DENSE_RANK() OVER(PARTITION BY gender ORDER BY salary DESC) as dens_rank
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
    
    
    

SELECT gender, birth_date, age,
	SUM(age) over(partition by gender order by birth_date) as totale_cum
FROM employee_demographics;
    


select first_name, last_name, occupation, salary,
avg(salary) over( partition by occupation) as sal_per_occupation
from employee_salary sal;

SELECT dem.gender, dem.first_name, dem.last_name,
avg(salary) over(partition by gender)
FROM employee_demographics dem JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
    
SELECT sal.first_name, sal.last_name,sal.salary, dep.department_name,
avg(sal.salary) over ( partition by dep.department_name) as salary_per_department
FROM
employee_salary sal JOIN parks_departments dep
ON sal.dept_id = dep.department_id
;
    

SELECT dep.department_name, avg(sal.salary)
FROM
employee_salary sal JOIN parks_departments dep
ON sal.dept_id = dep.department_id
group by dep.department_name



    