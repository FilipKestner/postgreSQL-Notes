
-- 3.1 PDF

-- 1a: Perform the following query. Critically examine the results table.
-- What do you notice?
    SELECT a. department_id
         ,department_name
         ,project_id
         ,project_name
         ,location
    FROM DEPARTMENTS a, PROJECTS ;
--  Every row in projects table is repeated 3 times

-- 1b: What is the cause of this and how do you fix it?
-- Rewrite the query and check the result table again.
    SELECT d.department_id, d.department_name, p.project_id, p.project_name, p.location
           FROM departments d
           JOIN projects p
           ON d.department_id = p.department_id;


-- 2: Make a list of all department managers with their employee number, name, salary
-- and the numbers of their assigned parking spaces.
    SELECT e.employee_id, e.first_name, e.last_name, e.salary, e.parking_spot
        FROM employees e
        JOIN departments d
        ON e.employee_id = d.manager_id;

-- 3: Management needs a list of the projects and the employees working on those projects.
-- The results table should include:
--      name of the project
--      location of the project
--      name of the employee
--      Department to which the employee is assigned

    SELECT p.project_name, p.location, e.first_name || ' ' || e.last_name as full_name, e.department_id
        FROM employees e
        JOIN projects p
        ON e.department_id = p.department_id;

-- 4: Now limit the results table of the previous query to projects
-- localized in Eindhoven or managed by department Administration.
    SELECT p.project_name, p.location, e.first_name || ' ' || e.last_name as full_name, e.department_id,
        p.department_id as qq

        FROM employees e
        JOIN projects p ON e.department_id = p.department_id
        WHERE UPPER(p.location) = 'EINDHOVEN' OR p.department_id = 3
        ORDER BY p.project_name;
-- 5: ~~

-- 6: List employees with their children.
--      Please note the sorting!!!
    SELECT e.first_name || ' ' || e.last_name as full_name, fm.name, fm.gender, fm.birth_date
        FROM employees e
        JOIN family_members fm
        ON e.employee_id = fm.employee_id
        ORDER BY full_name;

-- 7: ~~
-- ########################################################################################


-- 3.2 PDF

-- 1: Which male employees have a different residence from employee Jochems?
    SELECT e1.last_name, e1.location, e2.last_name, e2.location, e2.gender
        FROM employees e1
        JOIN employees e2
        ON e2.last_name != 'Jochems' AND e1.last_name = 'Jochems'
        WHERE e2.gender = 'M' AND INITCAP(LOWER(e2.location)) != 'Maastricht';



-- 2: List employees who have their birth date in the same month.
-- Note the order of the rows.

    INSERT INTO departments(department_id,department_name,manager_id,mgr_start_date)
    VALUES (11,'Testing Department', 999666666, '2011-01-01');

    SELECT e1.employee_id, e1.last_name, e1.birth_date, e2.birth_date
        FROM employees e1
        JOIN employees e2
        ON date_part('month',e2.birth_date) = date_part('month',e1.birth_date) -- Checks same birth month
        AND e1.employee_id != e2.employee_id -- Doesn't compare employee with himself
        ORDER BY date_part('month',e1.birth_date); -- Order by birth month of e1

-- 3: Which projects are supported by the same department as project 3?
--    Please provide all project data.

    SELECT p2.project_id, p2.project_name, p2.department_id, p2.location
        FROM projects p1
        JOIN projects p2
        ON p1.department_id = p2.department_id AND p1.project_id = 3
        WHERE p2.project_id != 3;

-- 4: An autojoin with a foreign key that points to a primary table is called recursive
-- because you can apply it multiple times. Show the workers for whom Bordoloi
-- is the boss of their boss.

    SELECT *
        FROM employees e1
        JOIN employees e2 ON e1.manager_id = e2.manager_id
        JOIN employees e3 ON e2.manager_id = e3.employee_id;


-- ########################################################################################

-- 3.3

-- 1: Give the ID of employees with children under the age of 18?
--    Always use a calculation method that takes leap years into account.

    SELECT DISTINCT employee_id
        FROM family_members
        WHERE date_part('year',age(birth_date)) < 18;

-- 2: Which employees from Eindhoven or Maarssen are older than 30?
    SELECT employee_id, last_name,location, to_char(age(current_date,birth_date), 'YYMMDD') as age
        FROM employees
        WHERE date_part('year',age(current_date, birth_date)) > 30
        AND (INITCAP(LOWER(location)) = 'Eindhoven' OR INITCAP(LOWER(location)) = 'Maarssen');


-- 3: Which employees have a partner with an age between 35y and 45y?
--    Give the ID of the employee and the age of that partner.

    SELECT employee_id, TO_CHAR(age(birth_date), 'FMYY "years" FMMM "months" FMDD "days"') as age1
        FROM family_members
        WHERE relationship = 'PARTNER'
        AND date_part('year',age(birth_date)) > 35
        AND date_part('year',age(birth_date)) < 45 ;


-- 4: For each employee, provide the date he/she will retire. Suppose the retirement age is
--    65 and one retires on his/her birthday.

    SELECT first_name, last_name, birth_date,
       TO_CHAR(birth_date + interval '65 years', 'FMDay FMDD FMMonth FMYYYY') as "Pension Date"
        FROM employees;

-- 5:
    SET lc_time = 'fr_FR';
    SELECT name,
       to_char(birth_date, 'TMday FMDD TMmonth FMYYYY') AS "born on"
        FROM FAMILY_MEMBERS
        ORDER BY birth_date DESC;








