-- SQL Regex Notes,
--      Attribute Searching,
--      Date & Number Formatting
--          + Date Functions/Methods
-- ---------------------------------------------------------------------------------------------------------------------

-- SQL Wildcards
    -- Wildcards are characters in SQL such that they are used to specify a
    -- specific condition within search commands like 'WHERE' & 'LIKE'.
    -- ** NOTE ALL THESE SYMBOLS WORK WITH EVERY STATEMENT
    -- +--------+-------------------------------------------------------------+------------------------------------------+
    -- | Symbol |                           Description                       |                   Example                |
    -- +--------+-------------------------------------------------------------+------------------------------------------+
    -- | %      |  Represents zero or more characters                         |  'bl%'     => 'bl' 'black' 'blue' 'blob' |
    -- | _      |  Represents a single character                              |  'h_t'     => 'hot' 'hat' 'hit'          |
    -- | []     |  Represents any single character within the brackets        |  'h[oa]t'  => 'hot' 'hat' BUT NOT 'hit'  |
    -- | ^      |  Represents any character not in the brackets               |  'h[^oa]t' => 'hit' BUT NOT 'hot' 'hat'  |
    -- | -      |  Represents any single character within the specified range |                                          |
    -- +--------+-------------------------------------------------------------+------------------------------------------+

    -- All employees who's first name starts with |'D'|
    SELECT * from employees WHERE INITCAP(LOWER(first_name)) LIKE 'D%';

    -- All employees who's first name ENDS with 'a'
    SELECT * from employees WHERE LOWER(first_name) LIKE '%a';

    -- All employees that have 'ui' ANYWHERE in their last name
    SELECT * from employees WHERE LOWER(last_name) LIKE '%ui%';

    -- All employees who have first name STARTING WITH 'D' and ENDING WITH 'S'
    SELECT * from employees WHERE LOWER(first_name) LIKE 'd%s';

    -- ** '_' represents a single character and be used to indicate POSITION
    -- of the character that you are looking for. For example

    -- All employees with 'e' as SECOND CHARACTER in their first name
    SELECT * from employees WHERE LOWER(first_name) LIKE '_e%';

    -- Employees who's name starts with 'D' and is at least 7 characters long
    SELECT * from employees WHERE LOWER(first_name) LIKE 'd______%';


-- 'SIMILAR' & More Filtering Tools

    -- 'SIMILAR TO' is similar to 'LIKE' but it interprets the provided comparitor as
    -- SQL standard's definition of a REGEX. Kind of a cross between 'LIKE' and REGEX.


    -- +--------+-------------------------------------------------------------+
    -- | Symbol |                        Description                          |
    -- +--------+-------------------------------------------------------------+
    -- | |      |  Denotes alteration (basically OR)                          |
    -- | *      |  Denotes repetition of previous item ZERO OR MORE times     |
    -- | +      |  Denotes repetition of previous item ONE  OR MORE times     |
    -- | ?      |  Denotes repetition of previous item ZERO OR ONE  times     |
    -- | {m}    |  Denotes repetition of previous item EXACTLY m times        |
    -- | {m,}   |  Denotes repetition of previous item m OR MORE times        |
    -- | {m,n}  |  Denotes repetition of previous item between m and n times  |
    -- | ( )    |  Used to group expressions into single logical term         |
    -- | [...]  |  Specifies a character class, just like POSIX REGEX         |
    -- +--------+-------------------------------------------------------------+

    -- Examples:
            SELECT * from employees WHERE LOWER(first_name) SIMILAR TO 'd%|b%|m%'; -- first_name stars with 'd' || 'b' || m
            SELECT * FROM employees WHERE LOWER(first_name) SIMILAR TO '[abd]%';   -- THE SAME AS ABOVE JUST DIFFERENT

            SELECT * from employees WHERE LOWER(first_name) SIMILAR TO '%o+%';  -- 'o' in first_name AT LEAST ONCE

            SELECT * from employees WHERE LOWER(last_name) SIMILAR TO '%o{2}%'; -- 'oo' in last_name

            SELECT * from employees WHERE employee_id SIMILAR TO '%98%87%77%';

            SELECT * FROM employees WHERE LOWER(first_name) SIMILAR TO '%[eaiou]%[eaiou]%[eaiou]%' -- Names with 3 vowals

    -- ** A lot of these can be made much simpler/easier using regex. So if you want more knowledge on how to narrow
    -- and make your searches more exact, it is detailed in the following section:


-- POSIX REGEX in the Context of PostgreSQL:
    -- ** This honestly could be a file of its own. REGEX in a class is normally something that spans at least
    -- 2 weeks of constant lectures and a big project. So here are the references. If you are interested there is
    -- DISGUSTING amounts of documentation on it, but for now this is what we keep track of for experimentation
    -- purposes regarding PostgreSQL.

    -- Provides a more powerful way of pattern matching than 'LIKE' and 'SIMILAR TO'. Also good to know because many
    -- UNIX tools (egrep, sed, awk) use pattern matching similar to POSIX.

    -- Available REGEX Match Operators:
        -- [SOME STRING] [REGEX OPERATOR] [REGEX EXPRESSION] -> BOOLEAN
        -- +--------+-------------------------------------------------------------+------------------------------------------+
        -- | Symbol |                           Description                       |                   Example                |
        -- +--------+-------------------------------------------------------------+------------------------------------------+
        -- | ~      |  STRING matches REGEX, case sensitive                       |  'thomas' ~ 't.*ma'   -> TRUE            |
        -- | ~*     |  STRING matches REGEX, NOT case sensitive                   |  'thomas' ~* 'T.*ma'  -> TRUE            |
        -- | !~     |  STRING DOES NOT match REGEX, case sensitive                |  'thomas' !~ 't.*max' -> TRUE            |
        -- | !~*    |  STRING DOES NOT match REGEX, NOT case sensitive            |  'thomas' !~* 'T.*ma' -> FALSE           |
        -- +--------+-------------------------------------------------------------+------------------------------------------+

    -- REGEX REFERENCES:
        -- KEY/LEGEND of ATOMS to be used if some symbols dont make sense when described in the reference.
            -- +----------+----------------------------------------------------------------------------------------------------------+
            -- |  Atom    |                                               Description                                                |
            -- +----------+----------------------------------------------------------------------------------------------------------+
            -- | (re)     | (where re is any regular expression) matches a match for re, with the match noted for possible reporting |
            -- | (?:re)   | as above, but the match is not noted for reporting (a “non-capturing” set of parentheses) (AREs only)    |
            -- | .        | matches any single character                                                                             |
            -- | [chars]  | a bracket expression, matching any one of the chars                                                      |
            -- | \k       | (where k is a non-alphanumeric character) matches that character taken as an ordinary character          |
            -- | \c       | where c is alphanumeric (possibly followed by other characters) is an escape                             |
            -- | {        | when followed by a character other than a digit, matches the left-brace character                        |
            -- | x        | where x is a single character with no other significance, matches that character                         |
            -- +----------+----------------------------------------------------------------------------------------------------------+

--      ===============================================================================================================================

        -- QUANTIFIERS : Operators indicating number of a certain character or sequence of chars/numbers.
            -- +-------------+------------------------------------------------------------------------------+
            -- | Quantifier  |                                   Matches                                    |
            -- +-------------+------------------------------------------------------------------------------+
            -- | *           | a sequence of 0 or more matches of the atom                                  |
            -- | +           | a sequence of 1 or more matches of the atom                                  |
            -- | ?           | a sequence of 0 or 1 matches of the atom                                     |
            -- | {m}         | a sequence of exactly m matches of the atom                                  |
            -- | {m,}        | a sequence of m or more matches of the atom                                  |
            -- | {m,n}       | a sequence of m through n (inclusive) matches of the atom; m cannot exceed n |
            -- | *?          | non-greedy version of *                                                      |
            -- | +?          | non-greedy version of +                                                      |
            -- | ??          | non-greedy version of ?                                                      |
            -- | {m}?        | non-greedy version of {m}                                                    |
            -- | {m,}?       | non-greedy version of {m,}                                                   |
            -- | {m,n}?      | non-greedy version of {m,n}                                                  |
            -- +-------------+------------------------------------------------------------------------------+



        -- CONSTRAINTS : Anchors and look(behinds|aheads) (Matches 're' AHEAD OR BEHIND given text '?'
            -- +-------------+-------------------------------------------------------------------------------------------+
            -- | Constraint  |                                        Description                                        |
            -- +-------------+-------------------------------------------------------------------------------------------+
            -- | ^           | matches at the beginning of the string                                                    |
            -- | $           | matches at the end of the string                                                          |
            -- | (?=re)      | positive lookahead matches at any point where a substring matching re begins (AREs only)  |
            -- | (?!re)      | negative lookahead matches at any point where no substring matching re begins (AREs only) |
            -- | (?<=re)     | positive lookbehind matches at any point where a substring matching re ends (AREs only)   |
            -- | (?<!re)     | negative lookbehind matches at any point where no substring matching re ends (AREs only)  |
            -- +-------------+-------------------------------------------------------------------------------------------+

-- #####################################################################################################################
-- #####################################################################################################################


