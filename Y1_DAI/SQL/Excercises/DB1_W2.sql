-- Week 2 Excercises
UPDATE EMPLOYEES
SET location='maastricht'
WHERE employee_id='999555555';

-- ENTERPRISE:
-- 2.3.1
-- 1
SELECT * FROM projects;

-- 2
SELECT project_name, project_id FROM projects;

-- 3 **
    --a
    SELECT 'project', project_id, 'is managed by', department_id FROM projects;

    --b**
    SELECT 'project' AS " ", project_id, 'is managed by' AS " " , department_id FROM projects;

    --c
    SELECT 'project ' ||  project_id || ' is managed by' || department_id
    AS "projects with department" FROM projects;

-- 4
SELECT current_date - birth_date FROM FAMILY_MEMBERS;

-- 5
    -- a
    --SELECT employee_id,project_id,hours;                            | doesn't specify 'FROM'
    --SELECT * FROM TASK;                                             | misspelling table name
    --SELECT department_id, manager_id, start_date FROM DEPARTMENTS;  | mgr_start_date NOT start_date

    -- b
    -- SELECT last_name, salary department_id FROM EMPLOYEES;         | No ',' between second & third
    --                                                                | column.

--6
    --SELECT employee_id, location, postal_code, province FROM employees;
    SELECT DISTINCT INITCAP(LOWER(location)) from employees;
    -- LOWER() not necessary, but makes it future proof

--7
    SELECT department_id, location FROM EMPLOYEES;

--8
    --a
    SELECT current_date;

    --b
    SELECT 150*.85 Calculation;

    --c **
    SELECT 'SQL ' || 'Data retrieval' || ' Chapter 3-4 ' "Best Course";

--9
    SELECT employee_id,name,gender,relationship FROM family_members WHERE employee_id = '999111111'
    ORDER BY name;

--10
    SELECT * from departments where department_name = 'Administration';

--11
    -- SELECT employee_id, last_name, city | Because the employee has the city
    -- FROM EMPLOYEES                      | as 'maastricht' NOT 'Maastricht'
    -- WHERE city='Maastricht';            |

    SELECT employee_id, last_name, location
    FROM EMPLOYEES
    WHERE LOWER(location) = 'maastricht';

--12
--Employee number, project number, and number of hours worked
    SELECT employee_id, project_id, hours FROM tasks
        WHERE project_id = 10 AND hours >= 20 AND hours <= 35;

--13
    SELECT project_id,hours from tasks WHERE employee_id = '999222222' AND hours < 10;

--14 ** No second solution? Or same province can be another city
    SELECT employee_id,last_name,province FROM employees WHERE province = 'GR'
        OR province = 'NB';
--15
    SELECT department_id, first_name FROM employees
    WHERE (first_name = 'Suzan' OR first_name = 'Martina' OR first_name = 'Henk' OR first_name = 'Douglas')
    ORDER BY department_id DESC, first_name DESC;

--16
    SELECT last_name, department_id, salary FROM employees
    WHERE department_id = '7' AND salary < '40000' OR employee_id = '999666666';

--17
    SELECT last_name, department_id FROM employees
    WHERE NOT LOWER(location) = 'eindhoven' AND NOT LOWER(location) = 'maarssen';

--18
    --a
    SELECT DISTINCT * from tasks ORDER BY hours NULLS FIRST ;
    --b
    SELECT DISTINCT * from tasks ORDER BY hours DESC NULLS LAST ;

--19
    SELECT last_name,location,salary FROM employees
    WHERE salary > '30000' AND (LOWER(location) LIKE 'm%' OR LOWER(location) LIKE 'o%');

--20
    SELECT name FROM family_members WHERE birth_date IN ('1988-01-01','1988-12-31');










