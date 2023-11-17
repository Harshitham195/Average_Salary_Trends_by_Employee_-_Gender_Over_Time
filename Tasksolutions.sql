
#Task 1 
#Create a visualization that provides a breakdown between the male and female employees working in the company each year, starting from 1990. 
use employees_mod;
SELECT 
    emp_no, from_date, to_date
FROM
    t_dept_emp;
    
SELECT DISTINCT
    emp_no, from_date, to_date
FROM
    t_dept_emp;

SELECT 
    YEAR(d.from_date) AS calender_year,
    e.gender,
    COUNT(e.emp_no) AS num_of_employees
FROM
    t_employees e
        JOIN
    t_dept_emp d ON e.emp_no = d.emp_no
GROUP BY calender_year , e.gender
HAVING calender_year >= '1990';

SELECT 
    d.dept_name,
    ee.gender,
    dm.emp_no,
    dm.from_date,
    dm.to_date,
    e.calendar_year,
    CASE
        WHEN
            YEAR(dm.to_date) >= e.calendar_year
                AND YEAR(dm.from_date) <= e.calendar_year
        THEN
            1
        ELSE 0
    END AS active
FROM
    (SELECT 
        YEAR(hire_date) AS calendar_year
    FROM
        t_employees
    GROUP BY calendar_year) e
        CROSS JOIN
    t_dept_manager dm
        JOIN
    t_departments d ON dm.dept_no = d.dept_no
        JOIN
    t_employees ee ON dm.emp_no = ee.emp_no
ORDER BY dm.emp_no , calendar_year;

SELECT 
    e.gender,
    d.dept_name,
    ROUND(AVG(s.salary), 2) AS salary,
    YEAR(s.from_date) AS calender_year
FROM
    t_employees e
        JOIN
    t_salaries s ON e.emp_no = s.emp_no
        JOIN
    t_dept_emp de ON de.emp_no = e.emp_no
        JOIN
    t_departments d ON d.dept_no = de.dept_no
GROUP BY e.gender , d.dept_no , calender_year
HAVING calender_year >= '1990'
ORDER BY d.dept_no;

#Task 4
#Create an SQL stored procedure that will allow you to obtain the average male and female salary per department within a certain salary range. Let this range be defined by two values the user can insert when calling the procedure.
#Finally, visualize the obtained result-set in Tableau as a double bar chart. 

delimiter $$
create procedure filter_salary (in p_min_salary float, in p_max_salary float)
begin
select avg(s.salary) as avg_salary ,e.gender, d.dept_name from
t_employees e
        JOIN
    t_salaries s ON e.emp_no = s.emp_no
		join
        t_dept_emp de on de.emp_no = e.emp_no
        join
        t_departments d on d.dept_no = de.dept_no
        where s.salary between p_min_salary and p_max_salary
        group by e.gender,d.dept_name;
end $$
delimiter ;

 call filter_salary (50000,90000);