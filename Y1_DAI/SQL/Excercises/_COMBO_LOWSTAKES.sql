--***********************
--Combo exercises week 3
--***********************


-------------
--Exercise 1
-------------


-- Select the projects that employees 999111111, 999222222 and 999555555
-- are working on for more than 6 hours.
-- Note the output (eg aliases). Sort your result by hours worked from lowest to highest.
-- Fetch only the first 3 rows of the result.

/*
+--------------------+---------+----------+---------+-----+----------+------------+
|project name        |EMP      |first_name|last_name|hours|birth_date|age_employee|
+--------------------+---------+----------+---------+-----+----------+------------+
|Salaryadministration|999111111|Douglas   |Bock     |8.5  |1965-09-01|57          |
|HumanResources      |999555555|Suzan     |Jochems  |14.8 |1981-06-20|41          |
|Debtors             |999555555|Suzan     |Jochems  |19.2 |1981-06-20|41          |
+--------------------+---------+----------+---------+-----+----------+------------+
*/

--Type your answer here:

SELECT p.project_name, e.employee_id, e.first_name, e.last_name, t.hours, e.birth_date, date_part('year',age(e.birth_date))
    FROM tasks t
    JOIN employees e ON e.employee_id = t.employee_id
    JOIN projects p ON p.project_id = t.project_id
    WHERE (e.employee_id = '999111111'OR e.employee_id = '999222222' OR e.employee_id = '999555555')
        AND t.hours >= 6
    ORDER BY t.hours
    FETCH NEXT 3 ROWS ONLY;


--***********************
--Combo exercises week 4
--***********************

------------
--Exercise 2
------------
--List the projects, for which the total hours worked is more than 30, and display
--  how many employees worked (ie. performed tasks) on this project
--  and the project name
--  and the name of the department that supports this project
--Sort by project name.
-- Make sure the you get exactly the output as shown below.
--   (e.g. 3 columns, aliases, constants and concatenations)

/*
+-----------+-------------------------------------+------------------------------------------+
|#employees |project                              |department                                |
+-----------+-------------------------------------+------------------------------------------+
|3 employees|perform tasks on Debtors             |which is supported by dept. Administration|
|3 employees|perform tasks on Inventory           |which is supported by dept. Administration|
|3 employees|perform tasks on Ordermanagement     |which is supported by dept. Production    |
|3 employees|perform tasks on Salaryadministration|which is supported by dept. Production    |
|2 employees|perform tasks on Warehouse           |which is supported by dept. Production    |
+-----------+-------------------------------------+------------------------------------------+
*/

SELECT COUNT(t.employee_id) || ' employees' as "#employees", 'perform tasks on ' || p.project_name as project,
        'which is supported by dept. ' || d.department_name as department
    FROM projects p
    JOIN tasks t ON t.project_id = p.project_id
    JOIN departments d ON d.department_id = p.department_id
    GROUP BY p.project_id, d.department_name
    HAVING SUM(t.hours) >= 30
    ORDER BY project;



-- Custom Combos

-- 1) List the family members of all employees that manage at least one employee.
-- | Manager ID | Manager Last Name | Family Member Name | Family Member Age ( just the years )|

SELECT DISTINCT e1.employee_id, e1.last_name, fm.name, date_part('year',age(fm.birth_date))
    FROM employees e1
    JOIN employees e2 ON e2.manager_id = e1.employee_id
    INNER JOIN family_members fm ON e1.employee_id = fm.employee_id;


SELECT mgr.manager_id,e.last_name,fm.name, date_part('Year',age(fm.birth_date))
FROM employees e
     LEFT JOIN employees mgr ON e.employee_id = mgr.manager_id
     INNER JOIN family_members fm on e.employee_id = fm.employee_id
    GROUP BY mgr.manager_id,fm.birth_date,fm.name,e.last_name
    HAVING count(mgr.manager_id) >= '1';

-- 2) Now list all of family members from (1) but give their age at the time
-- their respective manager started managing their respective departments

-- | Manager ID | Manager Last Name | Family Member Name | Family Member Age ( just the years) | Family Member Age when Manger Started Managing their Department

SELECT DISTINCT d.department_id, e1.employee_id, e1.last_name, fm.name, date_part('year',age(fm.birth_date)), date_part('year',age(d.mgr_start_date,fm.birth_date)) FROM employees e1
    JOIN employees e2 ON e2.manager_id = e1.employee_id
    INNER JOIN family_members fm ON e1.employee_id = fm.employee_id
    JOIN departments d ON e1.employee_id = d.manager_id
    ORDER BY e1.employee_id;


