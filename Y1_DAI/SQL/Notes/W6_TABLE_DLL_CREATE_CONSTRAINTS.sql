-- W6 PostgreSQL Notes 
--      Properties of (Relational) Databases
--      Create Table
--      Constraints



-- Creating a Table:
    -- CREATE TABLE         -> Used to initiate the creation of a table
    --
    --  | CREATE TABLE TABLE_NAME (
    --  |       COLUMN_NAME_1 datatype
    --  |       COLUMN_NAME_2 datatype
    --  |           . . .
    --  |       COLUMN_NAME_N datatype
    --  |
    --  |       PRIMARY KEY( 1+ columns)
    --  |   );

    CREATE TABLE COMPANY(
        ID INT PRIMARY KEY NOT NULL,
        NAME TEXT NOT NULL,
        AGE INT NOT NULL,
        ADDRESS CHAR(50),
        SALARY REAL
    ); -- ** Sub commands explained later





-- THEORY
-----------------------------------------------
-- Properties of a Relational Database:
--> rows are unique
--           in random order
--> column names are unique
--> attribute values are atomic

-- Integrity Rules:
--      Key Constraint                   := a PK IS and REMAINS UNIQUE
--
--      Entity Integrity Constraint      := PK must ALWAYS have a value OTHER
--                                          THAN NULL (valid value)
--
--      Referential Integrity Constraint := For each FK there exists a corresponding
--                                          PK in the referenced table
-- ----------------------------------------------------------------------------------------------------------------