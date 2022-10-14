-- 4.1 PDF [Analytical Functions, GROUP BY, HAVING]

-- 1.
    -- Explain the error:
        -- SELECT     *
        -- FROM     employees
        -- WHERE     AVG(salary)>30000;
        -- -> Cant put an analytical function in 'WHERE'

        --SELECT employee_id, SUM(hours)
        --FROM tasks
        -- //GROUP BY employee_id;
        -- -> Cant put attribute and analytical functions without grouping

-- 2. Execute the following query:
--  ** EMPLOYE_ID IS MISTYPED
    SELECT hours FROM tasks
    WHERE employee_id='999444444';
    -- Review the results table and now run the following queries:
    SELECT COUNT(hours)
    FROM tasks
    WHERE employee_id='999444444';

    SELECT SUM(hours)
    FROM tasks
    WHERE employee_id='999444444';
    -- Conclusion:
    -- They do what they are supposed to do

-- 3. What is the difference between the following queries?
    SELECT SUM(salary)
    FROM employees;

    SELECT COUNT(salary)
    FROM employees;
    -- SUM(salary) Adds it all
    -- COUNT(salary) Counts how many employees there are with salary != NULL

-- 4.Execute the following queries:
    SELECT COUNT(*)
    FROM tasks;

    SELECT COUNT(hours)
    FROM tasks;

    -- Why don't both queries give the same result?
    -- Because COUNT(*) includes null value whereas
    -- COUNT(hours) only counts NON-NULL values

-- 5. Give the number of projects already being worked on by employees.
    SELECT COUNT(DISTINCT project_id) as NOTHANKYOU FROM tasks;

-- 6. On average, how many hours employees worked on project 30?
    SELECT ROUND(AVG(hours)) number_of_hours FROM tasks
    WHERE project_id = 30
    GROUP BY project_id;

-- 7. How many employees have children?
    SELECT COUNT(DISTINCT employee_id) from family_members
    WHERE relationship = 'DAUGHTER' OR relationship = 'SON';

-- 8. What is the highest number of hours logged on project 20?
    SELECT MAX(hours) FROM tasks
    WHERE project_id = 20
    GROUP BY project_id;

-- 9. What is the date of birth of the youngest child of employee 999111111?
    SELECT MAX(birth_date) FROM family_members
    WHERE (relationship = 'DAUGHTER' OR relationship = 'SON') AND employee_id = '999111111';

-- 10. What is the average length of employees' last names?
    SELECT ROUND(AVG( LENGTH(last_name))) from employees;

-- 11. For each project, provide the number of staff working on that project.
    SELECT project_id, COUNT(employee_id) from tasks
    GROUP BY project_id
    ORDER BY project_id;

-- 12. Find out how many employees are working on each project and calculate the
--     average from those numbers. (Tip: numbers first, then averages)

    SELECT ROUND(AVG(q.employeeCount)) FROM
        ( SELECT project_id, COUNT(employee_id)  as employeeCount
             FROM tasks
             GROUP BY project_id) as q;

-- 13. For each department, provide the number of employees who are from
--     the province of Limburg (LI) .

    SELECT department_id, COUNT(employee_id) as "number of employees" FROM employees
    WHERE province = 'LI'
    GROUP BY department_id;

-- 14. For each manager, give the number of subordinates.
    SELECT manager_id, COUNT(employee_id) FROM employees
        WHERE manager_id != 'NULL'
        GROUP BY manager_id;

-- 15. How many projects does a department support per location.
    SELECT department_id, location, COUNT(project_id) FROM projects
        GROUP BY department_id, location;

-- 16. Represent how many sons and how many daughters an employee has.  Solve in 1 instruction.
    SELECT employee_id, relationship, COUNT(relationship) FROM family_members
        WHERE (relationship = 'DAUGHTER' OR relationship = 'SON')
        GROUP BY employee_id, relationship;

-- 17. For each department, give the number of female employees
--     who earn less than 33000 AND have a parking space.

    SELECT department_id, COUNT(employee_id) FROM employees
        WHERE gender = 'F' AND salary < 33000
        GROUP BY department_id;

    SELECT department_id, COUNT(employee_id) FROM employees
        WHERE gender = 'F' AND salary < 33000
        GROUP BY department_id;
        --HAVING department_id = 1;

-- 18. Which of the two solutions is the most performant?
    -- Solution 1:
    SELECT location, COUNT(project_id) number_of_projects
    FROM projects
    WHERE UPPER(location) IN ('EINDHOVEN','OEGSTGEEST')
    GROUP BY location;
    -- Solution 2:
    SELECT location, COUNT(project_id) number_of_projects
    FROM projects
    GROUP BY location
    HAVING UPPER(location) IN ('EINDHOVEN','OEGSTGEEST');
    --> Solution 1, HAVING is inefficient

-- 4.2 PDF (Outer Joins)
    -- DO THIS BEFORE EXCERCISES:
        DELETE FROM tasks
        WHERE employee_id='999666666';
    -- Add a new department 'Sales’ to the DEPARTMENTS table:
        INSERT INTO departments
        (department_id, department_name, manager_id, mgr_start_date)
        VALUES(2,'Sales','999555555',NOW());
    -------------------------------------------------------------------

    -- 1. List all employees with the projects they are working on.
    SELECT employees.last_name, employees.first_name, projects.project_id
        FROM employees LEFT OUTER JOIN projects
        ON employees.department_id = projects.department_id
        ORDER BY employees.last_name;

    -- 2. List the employees who did not participate at any project. We want
    --    to have in the results table first and last names of those employees.

    -- Complicated and very fun solution
    SELECT employees.last_name, employees.first_name
        FROM employees LEFT OUTER JOIN tasks
        ON employees.employee_id = tasks.employee_id
        GROUP BY employees.employee_id,2
        HAVING SUM(tasks.hours) IS NULL;

    -- BETA simple solution
    SELECT e.last_name, e.first_name
        FROM employees e LEFT JOIN tasks t
        ON e.employee_id = t.employee_id
        WHERE t.project_id IS NULL;

    -- 3. For each employee, provide the number of projects on
    -- which he/she participated. *Take a critical look at your results table!

    SELECT e.last_name, e.first_name, COUNT(t.project_id)
        FROM employees e LEFT JOIN tasks t
        ON e.employee_id = t.employee_id
        GROUP BY e.employee_id
        ORDER BY 1;

    -- 4. List all departments and the projects they support (if any).
    -- In the results table will be: department name, project name and project location

    SELECT d.department_name, p.project_name, p.location
        FROM departments d LEFT OUTER JOIN projects p
        ON d.department_id = p.department_id;

    -- 5.
    --  a. List all employees and the name of the department in which they work.
    --  Also give the names of their family members.

        SELECT e.employee_id, e.last_name, d.department_name, fm.name FROM employees e
            LEFT OUTER JOIN family_members fm ON e.employee_id = fm.employee_id
            LEFT OUTER JOIN departments d ON e.department_id = d.department_id
        ORDER BY e.last_name;

    -- b. Suppose each employee is always assigned a department.
    -- (assume for a moment that there is a NOT NULL constraint on department_id from employees).
    -- How then can we modify previous solution?
    --      -->

    -- 6. List all employees with the projects they are working on.
    -- We want in the results table last name, first name, project name
    -- and the number of hours that employee worked on that project. Note the order.

        SELECT e.last_name, e.first_name, p.project_name, t.hours FROM employees e
            LEFT OUTER JOIN tasks t ON e.employee_id = t.employee_id
            LEFT OUTER JOIN projects p ON  t.project_id = p.project_id
        ORDER BY p.project_name;

    -- 7. Give all employees who are not managers of another employee.
        SELECT e1.employee_id, e1.last_name FROM employees e1
            LEFT OUTER JOIN employees e2 ON e1.employee_id = e2.manager_id
            WHERE e2.manager_id IS NULL
            ORDER BY e1.employee_id;

    -- 8. Give all employees who are not managers of another employee
    -- or who do not have a manager.

        SELECT DISTINCT e2.last_name as "E1's Manager", e1.last_name as "E2's Manager" , e1.manager_id FROM employees e1
            LEFT OUTER JOIN employees e2 ON e1.employee_id = e2.manager_id
            WHERE e2.manager_id IS NULL OR e1.manager_id IS NULL
        ORDER BY e2.last_name DESC;












