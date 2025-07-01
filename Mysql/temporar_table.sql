-- Tempory table 
CREATE TEMPORARY TABLE temp_table -- leave inside the ram
(id_temp_table int primary key auto_increment,
first_name varchar(50),
last_name varchar(50),
favorite_movie varchar(100)
);

SELECT *
FROM temp_table;

INSERT INTO temp_table
VALUES(2,'Alex', 'Freberg','Lord of the Rings: The Two Towers');

delete from temp_table
where id_temp_table = 2;


drop table temp_table;
SELECT *
FROM temp_table;

select * from employee_demographics;

SELECT *
FROM employee_salary;

CREATE TEMPORARY TABLE salary_over_50k
SELECT *
FROM employee_salary
WHERE salary >= 50000;

select * from salary_over_50k






