-- Case Statements

SELECT first_name,
last_name,
age,
CASE
	WHEN age <= 30 THEN 'Young'
    WHEN age BETWEEN 31 and 50 THEN 'Old'
    WHEN age >= 50 THEN "On Death's Door"
END AS Age_Bracket
FROM employee_demographics;


SELECT first_name, last_name, salary,
CASE
	WHEN salary < 50000 THEN salary *(1.05)
    WHEN salary > 70000 THEN salary *(1.07)
END AS New_Salary,
CASE
	WHEN dept_id = 6 THEN salary * .10
END AS Bonus
FROM employee_salary as emp

