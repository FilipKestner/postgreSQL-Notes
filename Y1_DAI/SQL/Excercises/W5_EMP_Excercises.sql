-- 5.1 PDF [SET Operators & Conditional Functions]

-- 1. Return all birth dates (sorted) from employees and family members.

    SELECT TO_CHAR(birth_date,'YYYY/MM/DD') as year FROM employees
    UNION
    SELECT TO_CHAR(birth_date,'YYYY/MM/DD') as year FROM family_members
    ORDER BY year;

-- 2. Provide all birth dates (not sorted) from the tables employees and family members.
    SELECT birth_date FROM family_members
    UNION
    SELECT birth_date FROM employees;

-- 3. Give all employees who do not have family members.
    SELECT employee_id FROM employees
    EXCEPT
    SELECT employee_id FROM family_members;

-- 4. Provide all employees who are not department managers:
    SELECT employee_id FROM employees
    EXCEPT
    SELECT manager_id FROM departments;

-- 5.2 Excercise on Text Functions

-- 1. Provide the full name of each employee (including infix) ! Please provide a solution that:
--      a. Only using the COALESCE function
        SELECT COALESCE(first_name, infix, last_name) || COALESCE(infix, last_name) || last_name FROM employees;

--      b. only used the CONCAT function
        SELECT CONCAT(first_name,' ', infix,' ', last_name) FROM employees;

--      c. Only using the CONCAT_WS function
        SELECT CONCAT_WS(' ',first_name, infix, last_name) FROM employees;


-- 2. Get the address of all employees to whom you apply the following:
--      a. Convert all characters to lowercase
        SELECT LOWER(street) FROM employees;

--      b. Remove the initial 'z' from the address
        SELECT TRIM(LEADING 'z' FROM LOWER(street)) FROM employees;

--      c. Show 30 characters each, if the address is shorter then complete the string with '*' characters
        SELECT RPAD(TRIM(LEADING 'z' FROM LOWER(street)), 30,'*') FROM employees;

-- 3. Which employees have the letter 'o' in their names and first names? Use a text function.

    SELECT first_name, last_name FROM employees
    WHERE POSITION('o' IN LOWER(first_name)) != 0
        AND POSITION('o' IN LOWER(last_name)) != 0;

-- 4. Give all employees who have 2 O's in a row in their last name and no other O's.
    SELECT last_name FROM employees
    WHERE POSITION('oo' IN LOWER(last_name)) != 0;

-- 5. In employee addresses, replace all letters 'e' with an 'o' except the first 'e'.
    SELECT SUBSTR(street,1,POSITION('e' IN street)) || REPLACE(SUBSTR(street,POSITION('e' IN street)+1), 'e','o') FROM employees;


-- 6. Form an email address for each employee(not to be added in the table but
--    show in the results table. Form: 3 first characters of the first name + "." + 3
--    first characters of last name + "@" + department name + ". be". The whole must be in lower case.
--    Do not use the || sign.

    SELECT CONCAT(
        SUBSTR(LOWER(first_name),1,3),
        '.',
        SUBSTR(LOWER(last_name),1,3),
        '@',
        d.department_name,
        '.be'
               ) FROM employees e
    INNER JOIN departments d on e.department_id = d.department_id;

-- Conditional Functions and Expressions:

-- 1. For each child of an employee, display whether his/her age category
--    is child (<18y) or adult (>=18y). Make use of CASE.
    SELECT employee_id, name, relationship,
           CASE
               WHEN age(birth_date) < INTERVAL '18 years' THEN 'Child'
               ELSE 'Adult'
           END
    FROM family_members
    WHERE relationship =  'SON' OR relationship = 'DAUGHTER';

-- 2. Provide the full names of all employees. Make sure there are not
--    too many or too few blanks. To see this clearly, after composing
--    the name, replace each blank with a slash '/'

    SELECT REPLACE(CONCAT_WS('/',first_name, infix, last_name),' ', '/') FROM employees;

-- 3. a. Show for all employees the first name of their partner. If an employee does not
--    have a partner show the text ‘Single’ instead of his/her first name.

    SELECT e.employee_id, e.first_name, e.birth_date,
           CASE
               WHEN fm.relationship = 'PARTNER' THEN fm.name
               ELSE 'SINGLE'
            END,
        fm.relationship
    FROM employees e
    FULL OUTER JOIN family_members fm ON e.employee_id = fm.employee_id
    GROUP BY e.employee_id, fm.relationship, relationship;


--  b. Now also show the date of birth of the partner and the first name of
--  the oldest of the two (i.e. the partner with the smallest date of birth). Expected result
    SELECT e.employee_id, e.first_name, e.birth_date,
           CASE
               WHEN fm.relationship = 'PARTNER' THEN fm.name
               ELSE 'SINGLE'
               END as partner,
            fm.birth_date,
            CASE
                WHEN fm.relationship IS NULL THEN e.first_name
                WHEN AGE(e.birth_date) > AGE(fm.birth_date) THEN e.first_name
                ELSE fm.name
            END
    FROM employees e
    FULL OUTER JOIN family_members fm on e.employee_id = fm.employee_id
    WHERE fm.relationship IS NULL OR fm.relationship = 'PARTNER'
    ORDER BY e.first_name;

-- 4. Combining different types of functions:
--
-- a. How many seconds have passed today already?
    -- Clock
    -- The day is 58541 seconds old.
    SELECT 'The day is ' || TRUNC(
            extract(second from current_timestamp)
                + (extract(hour from current_timestamp)*60*60)
                + (extract(minute from current_timestamp)*60))
               || ' seconds old.';


-- b. Based on the system time, calculate how many minutes before this class ends.
    -- Clock
    -- The class ends in 92 minutes.

    SELECT (CURRENT_DATE + INTERVAL '20 hours') - CURRENT_TIMESTAMP(0);

    SELECT 'The class ends in '
               || (EXTRACT(hour from ( (CURRENT_DATE + INTERVAL '20 hours') - CURRENT_TIMESTAMP(0))*60)
                    + EXTRACT(minutes from ( (CURRENT_DATE + INTERVAL '20 hours') - CURRENT_TIMESTAMP(0))))
            || ' minutes';

--  c. Now calculate the same, but show the result in both hours & minutes?
    -- Clock
    -- The class ends in 1 hour and 32 minutes.
    SELECT 'The class ends in '
               || (EXTRACT(hour from ( (CURRENT_DATE + INTERVAL '20 hours') - CURRENT_TIMESTAMP(0))) ||
            + EXTRACT(minutes from ( (CURRENT_DATE + INTERVAL '20 hours') - CURRENT_TIMESTAMP(0))))
               || ' minutes';


-- d. If the class is less than an hour, only display the number of minutes (not the hour) (use a conditional function)
    -- Clock
    -- The class ends in 32 minutes.

-- e. Based on the end time of the class and the system date, print whether the class has ended or is still in progress.
    -- Clock
    -- The class is still in progress.

-- f. Now depending on the end time of the class and the system date, show how long is left (see d. ) or how long it has been finished.
-- Hint: use the ABS(number) function to make any negative number positive (absolute value).
    -- Clock
    -- Class has been over for 1 hour and 10 minutes.\


SELECT current_timestamp + interval '2 hours',   to_timestamp('26/10/2022 16:30', 'DD/MM/YYYY HH24:MI'), -- why to_timestamp and not to_date
to_timestamp('26/10/2022 16:30', 'DD/MM/YYYY HH24:MI') - (current_timestamp + interval '2 hours'),
date_part('minute', to_timestamp('26/10/2022 16:30', 'DD/MM/YYYY HH24:MI')
                        - (current_timestamp + interval '2 hours')) +
date_part('hour', to_timestamp('26/10/2022 16:30', 'DD/MM/YY HH24:MI')
                      - (current_timestamp + interval '2 hours')) * 60;