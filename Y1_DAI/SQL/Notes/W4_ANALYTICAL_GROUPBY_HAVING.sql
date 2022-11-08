-- Week 4 SQL Notes
    -- Analytical Functions
    -- Group By
    -- Having
    -- ** All joins covered by W3_Join.sql

-- Analytical Functions
    --AVG       -> Computes the average ( MEAN )
    --             of all NON-NULL input values
    SELECT AVG(salary) FROM employees;
    -- | SELECT AVG( SOME_DATA_COLUMN ) FROM SOME_TABLE;

    -- Possible Outcomes of AVG:
        -- AVG( smallint         ) -> numeric
        -- AVG( integer          ) -> numeric
        -- AVG( bigint           ) -> numeric
        -- AVG( numeric          ) -> numeric
        -- AVG( real             ) -> double precision
        -- AVG( double precision ) -> double precision
        -- AVG( interval         ) -> interval

    -- ** Averaging 'date' types are not as easy as it seems
    -- | SELECT AVG(birth_date) from family_members; -> INVALID
    -- To be able to AVG dates you cant really average the entire
    -- date so you have to EXTRACT and rebuild it like so:

    SELECT extract(year from family_members.birth_date) AS year_of_birth,
           to_timestamp( avg( extract( epoch from birth_date)))::date AS avg_dob
    FROM family_members
    GROUP BY 1;

    -- This complicated as sequence basically takes all the dates
    -- WITHIN THE SAME YEAR, converts them to epoch time and then
    -- averages them. So essentially you could only average
    -- a set of dates if they are all in the same year.
    -- -----------------------------------------------------------------------------------------------------------------

    -- SUM      -> Computes the sum of all
    --             NON-NULL input values
    SELECT department_id, SUM(salary) from employees GROUP BY department_id ; --> Department salary expenditure

    -- Possible Outcomes of SUM:
        -- SUM( smallint         ) -> bigint
        -- SUM( integer          ) -> bigint
        -- SUM( bigint           ) -> numeric
        -- SUM( numeric          ) -> numeric
        -- SUM( real             ) -> real
        -- SUM( double precision ) -> double precision
        -- SUM( interval         ) -> interval
        -- SUM( money            ) -> money

    -- ** PostgreSQL has a shit ton of data types so be wary
    -- when working with new ones.
    -- -----------------------------------------------------------------------------------------------------------------

    -- MIN      -> Computes the MINIMUM of the NOT-NULL
    --             input values.

    -- MAX      -> Computes the MAXIMUM of the NOT-NULL
    --             input values

    -- ** Both can be used for the following data types:
    --      numeric, string, date/time, enum
    --      inet, interval, money, oid,
    --      pg_lsn, tid, and arrays of these types

    SELECT MAX(salary), MIN(salary) FROM employees;
    -- -----------------------------------------------------------------------------------------------------------------

    -- COUNT(*)                         -> Counts number of input rows
    -- COUNT(ALL DISTINCT expression)   -> Counts number of input rows for which the input is NOT-NULL

    SELECT COUNT(*) FROM employees;          --> Counts all employees (8)
    SELECT COUNT(manager_id) FROM employees; --> Counts NOT-NULL m_ids (7)

    -- ** Could so some funny stuff like count the number of employees WITHOUT a manager:
    SELECT COUNT(*) - COUNT(manager_id) FROM employees; --> (1)

-- #####################################################################################################################

-- 'GROUP BY' Clause
    -- Divides the rows returned by 'SELECT' into different groups based
    -- on the conditionals given. You are then able to use analytical
    -- functions on these groups INDIVIDUALLY.

    -- ** It is important to note the order of operations in PostgreSQL as it is why
    -- we are able to act on these groupings using functions.

    -- ** NOTE that each command is not necessarily only that command on that level. For example
    -- 'ON' is part of the FROM because it is part of choosing which table to create before it is
    -- being filtered by 'WHERE'. Be cognizant when comparing commands not listed and trying
    -- to fit them into the order of operations.

    --      _________________
    --     |                 | => Creating the table
    --     |      FROM       |
    --     |_________________|
    --            ↓↓↓↓↓
    --      _________________
    --     |                 | => Filtering the table
    --     |      WHERE      |
    --     |_________________|
    --            ↓↓↓↓↓
    --      _________________
    --     |                 |     ** Because 'GROUP BY' comes earlier in the order of
    --     |     GROUP BY    |     operations, we are able to use its groups in all functions
    --     |_________________|     in layers below it.
    --            ↓↓↓↓↓
    --      _________________
    --     |                 |
    --     |      HAVING     |
    --     |_________________|
    --            ↓↓↓↓↓
    --      _________________
    --     |                 |    ** Interesting to see 'SELECT' so far down. Maybe there are some
    --     |     SELECT      |    tricks we can do like selecting from 'GROUP BY' groups.
    --     |_________________|
    --            ↓↓↓↓↓
    --      _________________
    --     |                 |
    --     |    DISTINCT     |
    --     |_________________|
    --            ↓↓↓↓↓
    --      _________________
    --     |                 |
    --     |    ORDER BY     |
    --     |_________________|
    --            ↓↓↓↓↓
    --      _________________
    --     |                 |
    --     |      LIMIT      |
    --     |_________________|

    -- Seeing how many employees are managed by each manager
    SELECT manager_id, count(employee_id) FROM employees
        GROUP BY manager_id;

    -- Seeing how many projects each department is in charge of:
    SELECT department_id, COUNT(project_id) FROM projects
        GROUP BY department_id;

    -- ** When 'GROUP BY' is used, NO OTHER ATTRIBUTES
    -- (that are not also in the 'GROUP BY') ARE ALLOWED
    -- | SELECT manager_id, employee_id FROM employees    } -> INVALID
    -- | GROUP BY manager_id;                             } -> GARBAGE
        SELECT manager_id, employee_id FROM employees  -- } -> IT WORKS BUT
            GROUP BY 1,2;                              -- } -> IS USELESS
    --    ↓↓↓      SAME      ↓↓↓    SHIT       ↓↓↓
        SELECT manager_id, employee_id FROM employees;


    -- Using MULTIPLE 'GROUP BY' Correctly:
        SELECT department_id, project_id FROM projects
            GROUP BY department_id,2
            ORDER BY department_id;
        -- ** You can use |GROUP BY 1,2,...,n| where
        -- n is the total number of columns in the SELECT
        -- statement, but then you CANNOT REFERENCE THEM IN
        -- FUTURE FUNCTIONS LIKE 'ORDER BY'
-- #####################################################################################################################

-- HAVING Clause
    -- Specifies a search condition for a group/aggregate in the 'GROUP BY' statement

    -- Only showing managers with 3 or more employees under them
    SELECT manager_id, COUNT(employee_id) as amount
        FROM employees
        GROUP BY manager_id
        HAVING COUNT(employee_id)>=3; -- Narrows our table

    -- ** 'WHERE' applies to rows while 'HAVING' applies to
    -- GROUPS OF ROWS



    -- Show all employees with 2 or more family members
    SELECT e.employee_id, COUNT(fm.name) FROM employees e
        JOIN family_members fm on e.employee_id = fm.employee_id
        GROUP BY e.employee_id
        HAVING COUNT(fm.name) >= 2;


