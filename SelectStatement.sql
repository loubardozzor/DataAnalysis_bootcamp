select * 
from Parks_and_Recreation.employee_demographics;

select first_name, 
last_name, 
birth_date,
age,
(age + 10)*10 + 10
from Parks_and_Recreation.employee_demographics;
# PEMDAS


SELECT distinct first_name, gender
from Parks_and_Recreation.employee_demographics;