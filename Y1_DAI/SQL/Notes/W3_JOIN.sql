-- Week 3 SQL Notes

 -- Different Types of 'JOIN' Statement
    -- CROSS Join       -> Matches EACH ROW from TABLE_A to TABLE_B.
    --                     Can potentially create HUGE tables. ** If the
    --                     input tables have x,y columns the output will ALSO
    --                     have x,y columns respectively.
    SELECT * FROM employees CROSS JOIN departments;
    -- | SELECT ... FROM table_A CROSS JOIN table_B;

    -- ----------------------------------------------------------------------------------------------------------------

    -- INNER Join       -> Creates a new result by COMBINING COLUMNS VALUES
    --                     OF table_A & table_B BASED UPON JOIN-PREDICATE.
    --                     Basically finds all row pairs that match some given
    --                     condition and builds the resulting table from those pairs.
    -- ** 'INNER' JOIN IS SAME AS JUST 'JOIN' -> INNER IS DEFAULT
    SELECT employees.employee_id, location, salary FROM employees
        INNER JOIN family_members
        ON employees.employee_id = family_members.employee_id;
    -- | SELECT table_A.SOME_ATTRIBUTE1, SOME_ATTRIBUTE2 ... FROM table_A
    -- |    INNER JOIN table_B
    -- |    ON table_A.SOME_ATTRIBUTE1 = table_B.SOME_ATTRIBUTE1

    -- ----------------------------------------------------------------------------------------------------------------

    -- LEFT OUTER Join  -> An extension of 'INNER JOIN' this first
    --                     performs an INNER JOIN (basically finding
    --                     all row pairs that mean some specified condition)
    --                     THEN for EACH ROW IN table_A that some_condition == false
    --                     with ALL table_B rows then a column is added with value NULL
    --                     so that EVERY ROW IN table_A IS PRESENT
    --
    --SELECT employees.employee_id, first_name, projects.project_id, employees.department_id FROM employees
    --    LEFT OUTER JOIN projects
    --    ON employees.department_id = projects.department_id;

    -- BETTER EXAMPLE OF 'LEFT OUTER JOIN'
    INSERT INTO departments(department_id,department_name,manager_id,mgr_start_date)
        VALUES (11,'Testing Department', 999666666, '2011-01-01');

    SELECT departments.department_id, department_name, employees.employee_id FROM departments
        LEFT OUTER JOIN employees
        ON departments.department_id = employees.department_id;
        -- -> Employee_id for department 11 is null as it DNE

    DELETE FROM departments WHERE department_id = 11;

    -- ----------------------------------------------------------------------------------------------------------------

    -- RIGHT OUTER Join -> Same as left join: First an inner join is performed
    --                     and then instead of adding null values for table_B
    --                     columns it instead ADDS NULL VALUES IN table_A
    --                     COLUMNS. So there will ALWAYS BE A VALUE IN table_B
    INSERT INTO departments(department_id,department_name,manager_id,mgr_start_date)
        VALUES (11,'Testing Department', 999666666, '2011-01-01');

    SELECT employees.employee_id, departments.department_id, employees.manager_id, departments.manager_id FROM employees
        RIGHT OUTER JOIN departments
        ON employees.department_id = departments.department_id;

    DELETE FROM departments WHERE department_id = 11;
    -- ==> Every row in department (table_B) columns have values whereas the null is now in employees (table_A)
    -- ** SO BASICALLY LEFT IS FOR NULL VALUES IN THE ON TABLE WHEREAS
    -- RIGHT IS FOR NULL VALUES IN THE FROM TABLE

    -- ----------------------------------------------------------------------------------------------------------------

    -- FULL OUTER Join  -> Basically a combination of RIGHT and LEFT OUTER JOIN where null values
    --                     are added for any value that is not met/satisfied.

    -- ** YOU MUST RUN EVERY COMMAND LISTED BELOW INDIVIDUALLY HERE TO SEE THE EXAMPLE INCLUDING
    -- THE DELETE FUNCTIONS TO NOT FUCK UP THE DATABASE FOR THE EXCERCISES!

    INSERT INTO departments(department_id,department_name,manager_id,mgr_start_date)
        VALUES (11,'Testing Department', 999666666, '2011-01-01');

    INSERT INTO employees(employee_id, first_name,last_name)
        VALUES (123456,'TOMMY','TESTING');

    SELECT employees.employee_id, departments.department_id, departments.department_name, employees.manager_id,
        departments.manager_id, employees.location, departments.mgr_start_date
        FROM departments
        FULL OUTER JOIN employees
        ON departments.department_id = employees.department_id;

    DELETE FROM departments WHERE department_id = 11;
    DELETE FROM employees WHERE last_name = 'TESTING';

-- ----------------------------------------------------------------------------------------------------------------

    -- NATURAL Join     -> Creates a join based on columns with the same name between
    --                     two tables. ** A NATURAL Join can also be a 'LEFT' 'RIGHT'
    --                     or 'INNER' join as follows:
    --                          | NATURAL LEFT JOIN
    --                          | NATURAL RIGHT JOIN
    --                          | NATURAL INNER JOIN

    -- Here it matches using the manager_id table
    SELECT department_id, department_name, employees.manager_id, departments.manager_id
    FROM employees NATURAL JOIN departments;

    -- In the previous command it wasn't showing every single employee
    -- so we converted it to a 'NATURAL LEFT' join. Now it joins
    -- based on department_id columns I guess?
    SELECT department_id, department_name, employee_id, employees.manager_id, departments.manager_id FROM employees
    NATURAL LEFT JOIN departments;

    -- ** BASICALLY NATURAL joins remove the need for a condition but its automatic and used very rarely.
    -- Understand how it finds the commonalities between tables IMPLICITLY and specific use cases for it.
    -- BUT AVOID USING IT AT ALL COSTS! IT MIGHT GIVE UNEXPECTED RESULTS!
    --      GOOD -> Combining a table of products and product_categories where ***ONLY ONE COLUMNS IN COMMON***
    --      BAD  -> Joining two columns with MULTIPLE COLUMNS IN COMMON!!!! BAD BAD BAD

-- #####################################################################################################################

-- Join Using DIFFERENT CONDITIONALS:
    -- This is basically using all the joins but INSTEAD OF:
    --      | ON table_A.attribute = table_B.attribute
    -- we are going to mix it up and use something like this:
    --      | ON table_A.attribute = table_B.attribute
    --      | AND table_A.age >= RETIREMENT_AGE
    SELECT current_date;


    -- Although it looks a little complex this query simply gets all family members that are
    -- UNDER THE AGE OF 18 [ (current_date - family_members.birth_date) <= 6700 ]
    SELECT employees.employee_id, first_name, last_name, family_members.relationship, family_members.birth_date,
           (current_date - family_members.birth_date) as "Age in Days", age(family_members.birth_date)FROM employees
        JOIN family_members
        ON family_members.employee_id = employees.employee_id
        AND (current_date - family_members.birth_date) <= 6700;


    SELECT e.employee_id, e.first_name, e.last_name, fm.relationship, fm.birth_date
        FROM employees e
        JOIN family_members fm ON e.employee_id = fm.employee_id
        WHERE date_part('year',age(fm.birth_date)) < 18;

    -- ** You can use conditionals to narrow your search. Can use the conditionals learned in W1 here
    -- in the same way as you would when you select normally from a table. Essentially the table is
    -- taken, AND THEN THE CONDITIONAL TAKES THEM OUT. (not literally but think of it that way)

-- #####################################################################################################################

-- Auto Join (Joining a Table with Itself) || (Recursive/Self Joins)
    -- This is used to represent recursive relationships in diagrams. It basically JOINS a table with ITSELF
    -- in order to display a particular relationship.

    -- This basically tells us exactly who reports to who. I know it may seem like a
    -- harder way of just checking manager_id, but by doing it this way we can also
    -- see exactly which employee (e2.employee_id) IS MANAGING who (e1.employee_id)
    SELECT e1.employee_id, e1.manager_id, e2.employee_id
        FROM employees e1 INNER JOIN employees e2
        ON e2.employee_id = e1.manager_id;

    -- This is the same as the table above just shows it in a much easier to read way
    SELECT e1.first_name || ' ' || e1.last_name as Employee, 'is managed by' as " ", e2.first_name || ' ' || e2.last_name as Manager
        FROM employees e1 INNER JOIN employees e2
        ON e2.employee_id = e1.manager_id;

    -- This retrieves all employees that work in the SAME DEPARTMENT AS THE EMPLOYEE
    -- WITH LAST NAME BOCK!
    SELECT e1.first_name || ' ' || e1.last_name as Name, e1.department_id
        FROM employees e1 JOIN employees e2
        ON e1.department_id = e2.department_id WHERE UPPER(e2.last_name) = 'BOCK';

    -- *******************************************************************
    -- *   COMPLICATED EXAMPLE! DO NOT RUN ANY CODE BELOW OR YOU MIGHT   *
    -- *          HAVE TO REBUILD THE EMPLOYEES DATABASE!!!              *
    -- *******************************************************************

    -- ** What if there are multiple employees with last_name = 'Bock'  ?
    INSERT INTO employees(employee_id,first_name,last_name, department_id)
    VALUES (123456,'Tester','Bock', 7);
    -- -> Then because it compares to two different values the table
    -- contains two copies of each person in department 7 AND
    -- it also includes BOTH 'Bock's

    -- ** What if multiple 'Bock' in DIFFERENT DEPARTMENTS
    INSERT INTO employees(employee_id,first_name,last_name, department_id)
    VALUES (123456,'Tester','Bock', 3);
    -- -> Then it checks both department_id = 3 AND department_id = 7. In
    -- this case we would need to specify exactly WHICH BOCK we were talking about.

    SELECT e1.first_name || ' ' || e1.last_name as Name, e1.department_id
        FROM employees e1 JOIN employees e2
        ON e1.department_id = e2.department_id WHERE UPPER(e2.last_name) = 'BOCK';


    DELETE FROM employees WHERE employee_id = '123456';

    SELECT * FROM EMPLOYEES ORDER BY employee_id;

    -- ** So this is a great way to find/interact with relationships WITHIN THE SAME TABLE. Also keep in mind that
    -- we can use ALL TYPES OF JOIN while auto-joining.

-- #####################################################################################################################

-- Formatting

-- ** REFER TO THIS LINK FOR DOCUMENTATION
-- https://www.postgresql.org/docs/13/functions-formatting.html
-- ==============================================================

-- ** Making a new file with all the formatting rules because the slides
-- are dog wank and don't teach you anything about how formatting works
-- in SQL.

