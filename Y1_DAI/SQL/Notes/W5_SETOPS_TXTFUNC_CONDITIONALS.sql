-- Week 5 SQL Notes
--      Set Operators
--      Text Functions
--      Conditional Functions



-- Set Operators (Union, Intersection & Exceptions):
    -------------------------------------------------------
    -- ** REFERENCE FILE 'W5_SETOPS_IMAGE.png' for
    -- VISUAL REPRESENTATION OF SET OPERATORS. ALSO COMPARE
    -- TO FILE 'W3_JOIN_DIAGRAM.png' FOR VISUAL COMPARISON!
    -------------------------------------------------------


    -- UNION        -> Used to combine multiple queries (SELECT statements)
    --                 into a single result SET.
    --
    -- | QUERY_1
    -- | UNION
    -- | QUERY_2

    SELECT employee_id, last_name, first_name FROM employees
    UNION
    SELECT employee_id, relationship, name FROM family_members
    ORDER BY employee_id; -- ** Always put ORDER BY at end of second statement


    -- ** Aliases from first query are kept, and aliases
    -- from second query are DISCARDED!
    SELECT manager_id as FIRST_TAB FROM departments
    UNION
    SELECT manager_id as SECOND_TAB FROM employees;

    -- ** Removes all duplicate entries unless:
    -- | QUERY_1
    -- | UNION ALL
    -- | QUERY_2

    -- Not really sure exactly how useful this is on its own. I would assume
    -- it comes in handy when trying to combine data sets to then further
    -- narrow the search?
    --      USEFUL EXAMPLES:
    --          Combining all ingredients into one column -> shopping list
    --          Getting a list of all airbnb locations for every type (house, apartment, hotel) from diff tables
    --          Getting one long mailing list across multiple data sets?

    -- DIFFERENCE BETWEEN 'UNION' & 'FULL OUTER JOIN' :
    -- ***************************************************************************************************
    --      Graphically 'UNION' & 'FULL OUTER JOIN' both join all items
    --      from two separate tables, however the key difference lies
    --      in the way they combine the data.
    --
    --          'UNION' combines VERTICALLY
    --              := rows from TABLE_A followed by rows from TABLE_B
    --              := both tables MUST HAVE SAME NUMBER OF COLUMNS WITH COMPATIBLE DATATYPES
    --              := NO JOIN CONDITION, ROWS COMBINED INDISCRIMINATELY
    --
    --          'FULL OUTER JOIN' combines HORIZONTALLY
    --              := # of rows    is MAX( TABLE_A, TABLE_B )
    --              := # of columns is    ( TABLE_A_COL + TABLE_B_COL )
    --              := MUST HAVE JOIN CONDITION

                SELECT e.employee_id, e.manager_id FROM employees e             -- | UNION
                UNION                                                           -- |    2 COL
                SELECT d.manager_id, d.manager_id FROM departments d;           -- |    11 ROWS
                                                                                -- |
                SELECT e.employee_id, e.manager_id FROM employees e             -- | FULL OUTER JOIN
                FULL OUTER JOIN departments d                                   -- |    2 COL
                        ON e.employee_id = d.manager_id;                        -- |    9 ROWS

    -- ***************************************************************************************************


    -- ----------------------------------------------------------------------------------------------------------------
    -- INTERSECT            -> Combines the result set of TWO QUERIES and RETURNS
    --                         ROWS that are PRESENT IN BOTH QUERIES! The 'intersect'
    --                         of both queries.
    --
    -- | QUERY_1
    -- | INTERSECT
    -- | QUERY_2

    SELECT employee_id FROM employees
    INTERSECT
    SELECT manager_id FROM departments;
    --> Gives all employee_id that are also managers of a department

    SELECT location FROM employees
    INTERSECT
    SELECT location FROM locations;
    --> Gives all location which have department and employee residences

    -- Overall pretty straight forward stuff, not much else to explain until
    -- exercises.


    -- DIFFERENCE BETWEEN 'INTERSECT' AND 'INNER JOIN'
    -- ***************************************************************************************************
    -- Follows same principles as differences between 'UNION' & 'FULL OUTER JOIN'. Essentially
    -- boils down to:
    --
    --          := 'INTERSECT' WILL RETURN NULL values
    --          := 'INNER JOIN' returns duplicates

            SELECT e.employee_id from employees e
            INNER JOIN departments d ON  e.employee_id = d.manager_id;

            SELECT e.employee_id FROM employees e
            INTERSECT
            SELECT d.manager_id FROM departments d;
            ---------------------------------------------------------------
            SELECT e.manager_id from employees e
            INNER JOIN departments d ON  e.employee_id = d.manager_id;

            SELECT e.manager_id FROM employees e
            INTERSECT
            SELECT d.manager_id FROM departments d;


            -- 'INTERSECT' & 'INNER JOIN' CAN BE MADE TO HAVE SAME RESULTS
            -- IF 'SELECT DISTINCT' AND/OR 'INTERSECT ALL' IS USED APPROPRIATELY BUT
            -- ONLY IN SPECIFIC SCENARIOS!
                SELECT DISTINCT e.employee_id from employees e
                INNER JOIN departments d ON  e.employee_id = d.manager_id;

                SELECT e.employee_id FROM employees e
                INTERSECT
                SELECT d.manager_id FROM departments d;
                -- NOW THEY HAVE THE SAME RESULT!

    -- ** https://blog.sqlauthority.com/2008/08/03/sql-server-2005-difference-between-intersect-and-inner-join-intersect-vs-inner-join/
    -- ** GOOD PLACE FOR SPECIFIC EXAMPLES OF THE DIFFERENCES
    -- ***************************************************************************************************

    -- ----------------------------------------------------------------------------------------------------------------
    -- EXCEPT           -> Takes the results of QUERY_1 and REMOVES ALL THAT ALSO
    --                     EXIST IN QUERY_2. Basically QUERY_1 - INTERSECT(QUERY_1, QUERY_2).
    --                     Also REMOVES DOUBLE RECORDS.

    SELECT employee_id from employees
    EXCEPT
    SELECT manager_id from departments;
    --> All employees that don't manage a department

-- #####################################################################################################################

-- Text Functions:

    -- UPPER(text)      := Makes all characters upper case
        SELECT UPPER(first_name) from employees;
    -- LOWER(text)      := Makes all characters lower case
        SELECT LOWER(first_name) from employees;
    -- INITCAP(text)    := Makes first char UPPER and rest LOWER
        SELECT INITCAP( UPPER( first_name)) FROM employees;

    -- LENGTH (text)
    --      -> Number of characters in a string
        SELECT last_name, LENGTH(last_name) FROM employees;


    -- SUBSTR (text, START_INDEX, END_INDEX) || SUBSTR(text, START_INDEX)
    --      -> Returns a subset of a given string. ** Be wary of how
    --         the indexing works, its not similar to programming.
    --         ** INCLUSIVE
    --                                ↓↓↓
    --  ┌--------┬--------┬--------┬--------┬--------┬--------┬--------┬--------┬--------┬--------┬--------┬--------┬--------┬--------┐
    --  |        |        |        |   B    |    O   |    R   |   D    |    O   |    L   |    O   |    I   |        |        |        |
    --  |--------|--------|--------|--------|--------|--------|--------|--------|--------|--------|--------|--------|--------|--------|
    --  |  -2    |  -1    |   0    |   1    |    2   |    3   |   4    |    5   |    6   |    7   |    8   |    9   |   10   |   11   |
    --  └-----------------------------------------------------------------------------------------------------------------------------┘
    --                                ↑↑↑

        -- SUBSTR (text, START_INDEX, END_INDEX)
        SELECT SUBSTR(last_name, 1, 3), LENGTH(SUBSTR(last_name, 1, 3)) FROM employees; --> Bor | 3
        SELECT SUBSTR(last_name, 0, 3), LENGTH(SUBSTR(last_name, 0, 3)) FROM employees; --> Bo  | 2
        SELECT SUBSTR(last_name,-3, 3), LENGTH(SUBSTR(last_name,-3, 3)) FROM employees; -->     | 0

        -- SUBSTR(text, START_INDEX)
        --          END_INDEX := LENGTH(text)
                SELECT SUBSTR(last_name, 2) FROM employees;
                SELECT SUBSTR(last_name, 2, LENGTH(last_name)) FROM employees;

        SELECT SUBSTR(last_name, 1), LENGTH(SUBSTR(last_name, 1)) FROM employees; --> Bordoloi | 8
        SELECT SUBSTR(last_name, 4), LENGTH(SUBSTR(last_name, 4)) FROM employees; --> doloi    | 5
        SELECT SUBSTR(last_name, 6), LENGTH(SUBSTR(last_name, 6)) FROM employees; --> loi      | 3


    -- POSITION(TEXT_SUBSTRING IN text)
    --      -> Returns what position TEXT_SUBSTRING appears in text
            SELECT last_name, POSITION('oo' IN last_name) FROM employees;

    --      RETURNS     0    -> Substring DNE
    --      RETURNS SOME_INT -> SOME_INT is starting index of Substring

    --      ** ONLY RETURNS FIRST MATCH
            SELECT POSITION('test' IN '.  test appears twice test');

    --      ** CASE INSENSITIVE
    --          'oo' != 'OO'
            SELECT last_name, POSITION('OO' IN last_name) FROM employees; --> ALL 0


    -- CONCAT( VALUE_1, VALUE_2, ..., VALUE_N )
    --          -> Combines all VALUE_N into an output string, as they
    --             are given.
    -- CONCAT_WS( SEPARATOR_TEXT, VALUE_1, VALUE_2, ..., VALUE_N )
    --          -> Combines all VALUE_N into an output string SEPERATED
    --             by the SEPARATOR_TEXT.
    --          ** Can be very useful for combining text with a space separator

    -- ** Essentially '||' but in function form
        --  ** NULL VALUES ARE IGNORED
        SELECT CONCAT(1,2,NULL, 3,'SOME STRING');
        SELECT CONCAT_WS(' | ','word 1', 'word 2', 'word 3');


    -- LPAD(text, DESIRED_LENGTH, FILL_TEXT)
    --          -> Pads text by inserting FILL_TEXT BEFORE
    --             of a given text.
    -- RPAD(text, DESIRED_LENGTH, FILL_TEXT)
    --          -> Pads text by inserting FILL_TEXT AFTER
    --             of a given text.

        SELECT LPAD('test', 10, '-');        --> '------test'
        SELECT RPAD('test', 10, '-');        --> 'test------'

        -- ** If the text is SHORTER THAN DESIRED_LENGTH, text is TRUNCATED
        SELECT LPAD('long long text',5,' ');   --> 'long'
        SELECT RPAD('super long text',3,'**'); --> 'sup

        -- ** Inserts only SUBSTRING of FILL_TEXT if EXCEEDS DESIRED_LENGTH
        SELECT LPAD('long',6,'12345'); --> '12long'
        SELECT RPAD('long',6,'12345'); --> 'long12'

        -- EXAMPLE: Using LPAD to create a bar graph of employee salaries.
        SELECT last_name, salary,
               LPAD('|', CAST(TRUNC(SUM(salary) /1000) AS INT), '▓')
               --LPAD('▓', (TRUNC(SUM(salary) /1000)::INT), '▓') --> Alternate way to cast as INT
        FROM employees
        GROUP BY employee_id;
            -- Can also include other tables and group by location for example, and how much
            -- money is by location.


    -- TRIM( [LEADING || TRAILING || BOTH] [characters] FROM text )
    --          [characters]                  := ' '
    --          [LEADING || TRAILING || BOTH] := BOTH
    --          -> Removes the longest string that contains a specific character from
    --             a given string.

    --      DEFAULT BEHAVIOR:
            SELECT TRIM('   Spaces in the front, and the back   '); --> Removes leading & trailing spaces

        SELECT TRIM('*' FROM '***TST***');          --> 'TST'
        SELECT TRIM(LEADING '*' FROM '***TST***');  --> 'TST***'
        SELECT TRIM(TRAILING '*' FROM '***TST***'); --> '***TST'

        --  Trimming Integers:
            SELECT TRIM(LEADING '0' FROM (00001230)::TEXT);
        --  ** MUST CAST THE NUMBER AS 'TEXT' with either
        --  TO_CHAR(), '::' OR CAST()

    -- REPLACE(text, SEARCH_STRING, REPLACE_STRING);
    --          -> Searches for SEARCH_STRING in text and then
    --             replaces SEARCH_STRING with REPLACE_STRING

        SELECT REPLACE('REPLACE ME into something else', 'REPLACE ME', 'I GOT REPLACED');

        SELECT REPLACE('test', 'g', 'y');
-- #####################################################################################################################


-- Conditional Functions:

    -- GREATEST(VALUE_1, VALUE_2, ..., VALUE_N)
    --          -> Selects largest from given set of data points

    -- LEAST(VALUE_1, VALUE_2, ..., VALUE_N)
    --          -> Selects smallest from given set of data points



    -- CASE
    --      WHEN condition_1 THEN result_1
    --      WHEN condition_2 THEN result_2
    --      ...
    --      ELSE else_result
    -- END
    --          -> Similar to IF/ELSE in programming where it follows
    --             a certain path depending on a given CONDITION
        SELECT employee_id, province,
               CASE province
                    WHEN 'NB' THEN 'Noord Brabant'
                    WHEN 'LI' THEN 'Limburg'
                    ELSE province
               END "Full Name"
        FROM employees;

        -- Combining Conditionals & Complicated Case:
        SELECT employee_id,
                CASE
                    WHEN INITCAP(location) = 'Maastricht' OR INITCAP(location) = 'Maarssen'THEN ''
                    ELSE INITCAP(location)
                END
        FROM employees;


    -- COALESCE( VAR_1, VAR_2, ..., VAR_N)
    --          -> Returns the FIRST NON-NULL ARGUMENT. If ALL variables ARE NULL,
    --             THEN returns NULL
        SELECT COALESCE(NULL, NULL, NULL, 1, NULL, 2, 3, 4);
        -- GOOD EXAMPLE(S):
        --      Lets say people have the option of submitting email, phone or address.
        --      and we want to get all people with some form of contact (email, phone or address).
        --      we could do:
        --          | SELECT name, COALESCE(email, phone, address);
        --      and we would get all persons with their corresponding contact form that is NOT NULL.


    -- NULLIF( VALUE_1, VALUE_2)
    --          -> Returns NULL if BOTH are SAME, ELSE it
    --             RETURNS VALUE_1.
        SELECT NULLIF(10,10+1);