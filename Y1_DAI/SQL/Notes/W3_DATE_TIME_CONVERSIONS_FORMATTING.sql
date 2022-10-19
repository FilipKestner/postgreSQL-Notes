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

-- Date & Number Formatting Notes:

-- Useful Date Functions
    -- TO_CHAR(timestmap, )

-- TO_CHAR
-- SET -> Language
-- TO_DATE
-- TO_NUMBER

-- current_date
-- current_time

-- date_part

-- age


-- ROUND
-- TRUNC
-- MOD
