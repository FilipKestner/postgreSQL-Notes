/*  Week 2 SQL Notes
        Covering:
                Select/Select DISTINCT
                Where
                Order
                Pagination


    Important Command Overview:
    ########################################################
    |   SELECT - extracts data from a database             |
    |   UPDATE - updates data in a database                |
    |   DELETE - deletes data from a database              |
    |   INSERT INTO - inserts new data into a database     |
    |   CREATE DATABASE - creates a new database           |
    |   ALTER DATABASE - modifies a database               |
    |   CREATE TABLE - creates a new table                 |
    |   ALTER TABLE - modifies a table                     |
    |   DROP TABLE - deletes a table                       |
    |   CREATE INDEX - creates an index (search key)       |
    |   DROP INDEX - deletes an index                      |
    ########################################################
 */
--///////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////

-- 'SELECT' Statement
    --  Select data from a database.
    --  '*' signifies ALL COLUMNS
    --  | SELECT some_column_n1, some_column_n2, ... , FROM table_n
    --  | SELECT * FROM table_n
    SELECT employee_id, name, relationship FROM family_members;
    SELECT * from employees;

-- 'SELECT DISTINCT' Statement
    --  Only selects DISTINCT (different) values from the
    --  given table.
    SELECT DISTINCT department_id FROM projects;

-- 'Where'
    -- Used to extract records that fit a SPECIFIC CONDITION
    -- | SELECT column_n1, column_n2, ...,
    -- |    FROM table_n
    -- |    WHERE some_condition
    SELECT * FROM employees WHERE (employee_id='999666666' OR employee_id = '999555555'); -- AND NOT employee_id = '999333333'
    -- **'AND' and 'OR' and 'NOT' can be used to chain conditionals together and either
    -- expand or narrow our search.
    -- 'IN' IS USED TO INDICATE RANGE LIKE:
        -- | SELECT name FROM family_members WHERE birth_date IN ('1988-01-01','1988-12-31');
        -- ~ Gives you family members born in 1988
    -- 'BETWEEN' IS USED SIMILARLY TO 'IN'
        -- | SELECT name from family_members WHERE birthdate BETWEEN '1988-01-01' AND '1988-12-31';
    -- 'LIKE' IS USED TO CHECK LIKE REGEX WOULD!:
        -- |
    -- 'IS NULL' & 'IS NOT NULL'

-- 'Order by'
    -- Used to sort the result-set in ascending/descending order.
    -- | SELECT column_n1, column_n2, ...,
    -- |    FROM table_n
    -- |    ORDER BY column_n1 ASC | DESC
    --                **^ -> MUST ALSO BE IN THE SELECTED COLUMNS
    SELECT DISTINCT department_id,project_name FROM projects ORDER BY department_id ASC;
    -- 'NULL FIRST' & 'NULL LAST' -> are used to indicate where NULL should go
    -- MULTIPLE ORDERING STATEMENTS:
        -- **| ORDER BY conditionA, ORDER BY conditionG

-- ** 'UPPER(someSTRING)' & 'LOWER(someStRING)' -> ALL LOWER OR UPPER METHOD
-- ** WHEN ADDING/SUBTRACTING TO DATES IT HAS TO BE WITH AN INT OR OTHER DATE

-- Fetch & Cursors (Pagination):
    -- | SELECT someList FROM someTable [OFFSET offset ROWS] [FETCH someRow LIMITING CLAUSE]
    Select department_id,project_name FROM projects OFFSET 2 ROWS;
    Select department_id, project_name FROM projects FETCH NEXT 3 ROWS ONLY;

    -- WITH TIES
    --SELECT last_name, salary FROM employees ORDER BY salary DESC;

    SELECT last_name, salary FROM employees ORDER BY salary DESC
    FETCH NEXT 2 WITH TIES;



    --FETCH NEXT 2 ROWS WITH TIES;


    -- CURSORS: **
    -- | BEGIN WORK
    -- | DECLARE someCURSOR SCROL CURSOR FOR SELECT SOME_COLUMN FROM SOME_TABLE
    -- | FETCH DIRECTION # FROM someCURSOR
    BEGIN WORK; -- MUST BE INCLUDED BEFORE CURSOR IS DECLARED
    DECLARE someCursor SCROLL CURSOR FOR SELECT * FROM employees;
    FETCH FORWARD 3 FROM someCursor; -- GETS NEXT FROM CURSOR

-- 'Group by'
    -- This is used to group redundancies together and then use aggregate
    -- expression o nthem
    -- ---------------------------------------------------------------------------
    -- |  => SELECT * FROM test1;             => SELECT x FROM test1 GROUP BY x; |
    -- |     x | y                                       x                       |
    -- |    ---+---                                    -----                     |
    -- |     a | 3                                       a                       |
    -- |     c | 2                                       b                       |
    -- |     b | 5                                       c                       |
    -- |     a | 1                                    (3 rows)                   |
    -- |   (4 rows)                                                              |
    -- --------------------------------------------------------------------------|
    -- ** Doing this WITHOUT aggregate expressions is the same thing as
    -- doing 'SELECT DISTINCT'
    SELECT department_id FROM projects GROUP BY department_id;
    SELECT DISTINCT department_id FROM projects;

    SELECT location, sum(department_id) FROM locations GROUP BY location;
    -- You see how we added together (Eindhoven | 1 + Eindhoven | 7) This is what
    -- GROUP BY is useful for. For example we can get the total hours worked by
    -- a specific employee ID by aggregating all their hours worked while
    -- grouping by employee_id .

    -- --------------------------------------------------------------------
    --SELECT * from clients WHERE (ROW_NUMBER() OVER %4 = 0;
    --SELECT ROW_NUMBER() OVER(ORDER BY clientno), clientno  FROM clients
    --        WHERE ;

    -- --------------------------------------------------------------------
