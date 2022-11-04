-- W2: Date & Time + Formatting + Conversions
-- ---------------------------------------------------------------------------------------------------------------------

-- References:

-- Date Type in PostgreSQL:
    -- The 'Date' data type in SQL has many different forms it can come in. They all follow
    -- one of these general formats:
        -- +------------------------------------------+---------------+----------------------------------------+-------------------+------------------+---------------+
        -- |                  Name                    | Storage Size  |              Description               |    Low Value      |   High Value     |  Resolution   |
        -- +------------------------------------------+---------------+----------------------------------------+-------------------+------------------+---------------+
        -- | timestamp [ (p) ] [ without time zone ]  | 8 bytes       | both date and time (no time zone)      | 4713 BC           | 294276 AD        | 1 microsecond |
        -- | timestamp [ (p) ] with time zone         | 8 bytes       | both date and time, with time zone     | 4713 BC           | 294276 AD        | 1 microsecond |
        -- | date                                     | 4 bytes       | date (no time of day)                  | 4713 BC           | 5874897 AD       | 1 day         |
        -- | time [ (p) ] [ without time zone ]       | 8 bytes       | time of day (no date)                  | 00:00:00          | 24:00:00         | 1 microsecond |
        -- | time [ (p) ] with time zone              | 12 bytes      | time of day (no date), with time zone  | 00:00:00+1559     | 24:00:00-1559    | 1 microsecond |
        -- | interval [ fields ] [ (p) ]              | 16 bytes      | time interval                          | -178000000 years  | 178000000 years  | 1 microsecond |
        -- +------------------------------------------+---------------+----------------------------------------+-------------------+------------------+---------------+


-- Date Formatting:
    -- DATE FORMAT REFERENCE
    -- +---------------------------+--------------------------------------------------------------------+
    -- |         Pattern           |                            Description                             |
    -- +---------------------------+--------------------------------------------------------------------+
    -- | HH                        | hour of day (01–12)                                                |
    -- | HH12                      | hour of day (01–12)                                                |
    -- | HH24                      | hour of day (00–23)                                                |
    -- | MI                        | minute (00–59)                                                     |
    -- | SS                        | second (00–59)                                                     |
    -- | MS                        | millisecond (000–999)                                              |
    -- | US                        | microsecond (000000–999999)                                        |
    -- | FF1                       | tenth of second (0–9)                                              |
    -- | FF2                       | hundredth of second (00–99)                                        |
    -- | FF3                       | millisecond (000–999)                                              |
    -- | FF4                       | tenth of a millisecond (0000–9999)                                 |
    -- | FF5                       | hundredth of a millisecond (00000–99999)                           |
    -- | FF6                       | microsecond (000000–999999)                                        |
    -- | SSSS, SSSSS               | seconds past midnight (0–86399)                                    |
    -- | AM, am, PM or pm          | meridiem indicator (without periods)                               |
    -- | A.M., a.m., P.M. or p.m.  | meridiem indicator (with periods)                                  |
    -- | Y,YYY                     | year (4 or more digits) with comma                                 |
    -- | YYYY                      | year (4 or more digits)                                            |
    -- | YYY                       | last 3 digits of year                                              |
    -- | YY                        | last 2 digits of year                                              |
    -- | Y                         | last digit of year                                                 |
    -- | IYYY                      | ISO 8601 week-numbering year (4 or more digits)                    |
    -- | IYY                       | last 3 digits of ISO 8601 week-numbering year                      |
    -- | IY                        | last 2 digits of ISO 8601 week-numbering year                      |
    -- | I                         | last digit of ISO 8601 week-numbering year                         |
    -- | BC, bc, AD or ad          | era indicator (without periods)                                    |
    -- | B.C., b.c., A.D. or a.d.  | era indicator (with periods)                                       |
    -- | MONTH                     | full upper case month name (blank-padded to 9 chars)               |
    -- | Month                     | full capitalized month name (blank-padded to 9 chars)              |
    -- | month                     | full lower case month name (blank-padded to 9 chars)               |
    -- | MON                       | abbreviated upper case month name                                  |
    -- | Mon                       | abbreviated capitalized month name                                 |
    -- | mon                       | abbreviated lower case month name                                  |
    -- | MM                        | month number (01–12)                                               |
    -- | DAY                       | full upper case day name (blank-padded to 9 chars)                 |
    -- | Day                       | full capitalized day name (blank-padded to 9 chars)                |
    -- | day                       | full lower case day name (blank-padded to 9 chars)                 |
    -- | DY                        | abbreviated upper case day name                                    |
    -- | Dy                        | abbreviated capitalized day name                                   |
    -- | dy                        | abbreviated lower case day name                                    |
    -- | DDD                       | day of year (001–366)                                              |
    -- | IDDD                      | day of ISO 8601 week-numbering year                                |
    -- | DD                        | day of month (01–31)                                               |
    -- | D                         | day of the week, Sunday (1) to Saturday (7)                        |
    -- | ID                        | ISO 8601 day of the week, Monday (1) to Sunday (7)                 |
    -- | W                         | week of month (1–5) (the first week starts first day of the month) |
    -- | WW                        | week number of year (1–53)                                         |
    -- | IW                        | week number of ISO 8601 week-numbering year                        |
    -- | CC                        | century (2 digits) (the twenty-first century starts on 2001-01-01) |
    -- | J                         | Julian Date (INT days since November 24, 4714 BC at local midnight |
    -- | Q                         | quarter                                                            |
    -- | RM                        | month in upper case Roman numerals (I–XII; I=January)              |
    -- | rm                        | month in lower case Roman numerals (i–xii; i=January)              |
    -- | TZ                        | upper case time-zone abbreviation (only supported in to_char)      |
    -- | tz                        | lower case time-zone abbreviation (only supported in to_char)      |
    -- | TZH                       | time-zone hours                                                    |
    -- | TZM                       | time-zone minutes                                                  |
    -- | OF                        | time-zone offset from UTC (only supported in to_char)              |
    -- +---------------------------+--------------------------------------------------------------------+

-- ------------------------------------------------------------------------------------------------------

-- Everything Dates:

-- Useful Date Functions
    -- TO_CHAR(EXPRESSION, 'FORMAT' )
    --          -> Converts a timestamp, interval, integer, double or
    --             numeric value TO A STRING.
    --
    --          EXPRESSION => Value to convert ( Timestamp|Interval|Integer|Double|Numeric Value )
    --          FORMAT     => What formatting rules to follow while converting

        -- Converting timestamp to string
        SELECT birth_date,
               TO_CHAR(
                   birth_date, 'Born FMDD FMMonth, FMYYYY' ) pay_test
        FROM family_members;

        -- Getting retirement date (assuming 65 y/o and retirement on birth date)
        SELECT first_name, last_name, birth_date,
               TO_CHAR(birth_date + interval '65 years', 'FMDay FMDD FMMonth FMYYYY') as "Pension Date"
        FROM employees;

    -- DATE_PART( 'field', source) || EXTRACT( field FROM source)
    --          -> Extracts a specific part ofa given date or interval
            SELECT DATE_PART('year', birth_date) FROM employees; --} SAME
            SELECT EXTRACT(YEAR FROM birth_date) FROM employees; --} OUTPUT

    -- CURRENT_DATE -> Returns current date

    -- CURRENT_TIME(p) -> Returns current time with time zone
    --          p := precision (0 to 6)

    -- AGE(LATER_TIME_STAMP, BIRTH_TIME_STAMP)
    --          -> Calculates the age (BIRTH_TS - LATER_TS) and RETURNS AN INTERVAL
    -- AGE(TIME_STAMP)
    --          -> TIME_STAMP calculates age by doing CURRENT_DATE() - TIME_STAMP


    -- TO_DATE( 'TEXT', 'FORMAT_STYLE')
    --              -> Converts string to date according to given FORMAT_STYLE.
    --              ** FORMAT_STYLE has to essentially copy the format of TEXT
    --                 for CORRECT EXTRACTION.
        SELECT TO_DATE('20 September, 2022', 'DD Month, YYYY');

    -- Language Conversion:
    SET lc_time = 'fr_FR';
    SELECT to_char(birth_date, 'TMMonth') FROM employees;


    -- WHAT IS AN 'INTERVAL' & HOW DOES IT WORK?
    -- *************************************************************************************************************
    -- INTERVAL '[ fields ] [ direction ]' [ (p) ]
    --      [ fields ] := Quantity unit, effectively how big you want the interval
    --          [ '65 years' ]
    --          [ '1 year 2 months 3 days' ]
    --      [ direction ] := either '' or 'ago' to indicate future or past respectively
    --          [ '2 weeks ago' ]
    --      [ (p) ]    := How much precision do you want (NORMALLY BETWEEN 0 to 6,
    --                    this is how its done with other date/time formats. but Intervals
    --                    also have another particular way of restricting precision and fields.
    --                   [ YEAR | MONTH | DAY | HOUR | MINUTE | SECOND ]
    --          [ INTERVAL '10 years 4 month 2 days' YEAR TO MONTH ]
    --                      -> 10 years 4 mons 0 days 0 hours 0 mins 0.0 secs
    --                      ** ONLY TAKES YEARS AND MONTH, REST IS DISCARDED


        SELECT birth_date,                              --> The birth date
               birth_date + INTERVAL '2 weeks',         --> Adding 2 weeks
               TO_CHAR(birth_date +                     --> Converting it to appropriate text
                       INTERVAL '2 weeks', 'FMDay FMDD FMMonth FMYYYY')
        FROM employees;

        SELECT current_date, current_date + INTERVAL '5 microseconds';

        -- DIFFERENT INTERVAL OUTPUT STYLES:
            -- sql_standard       : +6-5 +4 +3:02:01
            -- postgres           : 6 years 5 mons 4 days 03:02:01
            -- postgres_verbose   : @ 6 years 5 mons 4 days 3 hours 2 mins 1 sec
            -- iso_8601           :P6Y5M4DT3H2M1S

            -- SET intervalstyle = 'sql_standard' || 'postgres' ...

            SET intervalstyle = 'postgres_verbose';
            SELECT INTERVAL '10 years 5 months 4days 1 hour 2 minutes 20 seconds';

            SET intervalstyle = 'iso_8601';
            SELECT INTERVAL '10 years 5 months 4days 1 hour 2 minutes 20 seconds';

        -- INTERVAL ARITHMETIC:
            -- You can use '+', '-' or '*' on INTERVALs
            SELECT INTERVAL '2h 50m' + INTERVAL '10m'; -- 03:00:00
            SELECT INTERVAL '2h 50m' - INTERVAL '50m'; -- 02:00:00
            SELECT 600 * INTERVAL '1 minute'; -- 10:00:00

        -- EXTRACTING FROM INTERVAL:
            SELECT EXTRACT(DAY FROM INTERVAL'10 years 5 months 4days 1 hour 2 minutes 20 seconds');
    -- *************************************************************************************************************

-- Everything Numerical

    -- Numeric Formatting:
    -- +------------+--------------------------------------------------------------------------+
    -- |   Format   |                               Description                                |
    -- +------------+--------------------------------------------------------------------------+
    -- | 9          | Numeric value with the specified number of digits                        |
    -- | 0          | Numeric value with leading zeros                                         |
    -- | . (period) | decimal point                                                            |
    -- | D          | decimal point that uses locale                                           |
    -- | , (comma)  | group (thousand) separator                                               |
    -- | FM         | Fill mode, which suppresses padding blanks and leading zeroes.           |
    -- | PR         | Negative value in angle brackets.                                        |
    -- | S          | Sign anchored to a number that uses locale                               |
    -- | L          | Currency symbol that uses locale                                         |
    -- | G          | Group separator that uses locale                                         |
    -- | MI         | Minus sign in the specified position for numbers that are less than 0.   |
    -- | PL         | Plus sign in the specified position for numbers that are greater than 0. |
    -- | SG         | Plus / minus sign in the specified position                              |
    -- | RN         | Roman numeral that ranges from 1 to 3999                                 |
    -- | TH or th   | Upper case or lower case ordinal number suffix                           |
    -- +------------+--------------------------------------------------------------------------+

    -- TO_NUMBER(STRING, FORMAT_STRING)
    --              -> Converts character string to a numeric value.
    --                 Similar as TO_DATE() in that the FORMAT_STRING
    --                 is used to identify all parts of the given STRING.

        SELECT TO_NUMBER('123,456.7-', '999G999D9S');

        -- Converting Money:
        SELECT TO_NUMBER('$5,567,332.63', 'L9G999G999.99');


    -- ROUND( SOURCE, [, n] )
    --          -> Rounds a given SOURCE number with n decimal places
    --          SOURCE := source number to be rounded
    --          n      := level of precision, default n=0

        SELECT ROUND(1234.446,2);

    -- TRUNC( SOURCE [, n] )
    --          -> Truncates a given SOURCE number to n decimal places
    --          SOURCE := source number to be truncated
    --          n      := precision, number of decimal places, defualt n=0

        SELECT TRUNC(123.123123);
        SELECT TRUNC(123.2222222222,2);

    --      ** DOES NOT ROUND JUST REMOVES

    -- MOD( X_INT, Y_INT)
    --          -> Performs modular division, X_INT MOD Y_INT
        SELECT MOD(10,3);


