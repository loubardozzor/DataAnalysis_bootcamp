

SELECT *
FROM Parks_and_Recreation.employee_demographics
WHERE first_name= 'Leslie'
;

SELECT *
FROM employee_demographics
WHERE birth_date > '1985-01-01'
;

-- AND OR NOT ---Logical operators --

SELECT *
FROM employee_demographics
WHERE (first_name = 'Leslie' AND age = 44) OR age > 55 
;

-- LIKE statement
-- % and _
SELECT *
FROM employee_demographics
WHERE birth_date LIKE '1989%'
;