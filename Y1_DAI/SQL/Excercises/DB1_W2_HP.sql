-- Week 2 Excercises (2.3.2)


-- 1
    SELECT DISTINCT clientno FROM reservations;

-- 2
    SELECT clientno, ' goes on ', start_date, ' to park', park_code FROM reservations
    WHERE start_date >= '2021-1-1' FETCH NEXT 5 ROWS ONLY;

-- 3
    SELECT current_date;

-- 4. How will the reservations for cottages at Het Meerdal (code MD)
-- look if we let everyone stay an extra 2 days for free? Print out reservation nr,
-- travel agency nr, client nr and the new end date, which you call 'extension by 2 days'.

    SELECT resno, tano, clientno, end_date + 2 AS "extension by 2 days"
    FROM reservations WHERE park_code = 'MD';

--  5. Print information on reservations made by travel agent 3 whose start
--  date is after 31/12/2020. Print only travel agency no, customer no and beginning
--  and end of period. Sort by start date.

    SELECT tano, clientno, start_date, end_date FROM reservations
    WHERE start_date > '2020-12-31' AND tano = '3' ORDER BY start_date;

--  6. Which customers still have their reservations set to "Open"?
--  Give only the first 25% of results and sort by customer number.
    SELECT COUNT(houseno) FROM reservations WHERE status='OPEN';
    SELECT * from reservations WHERE status='OPEN' FETCH FIRST 6 ROWS ONLY;
    -- ** Screw it, no idea

    -- ALTERNATE SOLUTION
    SELECT clientno, status FROM (
        SELECT
            ROW_NUMBER() OVER (ORDER BY clientno) n,
            clientno,
            status
        FROM reservations WHERE status = 'OPEN'
                  ) AS firstTable
    WHERE n<=6 ORDER BY clientno;
    --No idea how to formulate because I have no idea how to get
    -- the NUMBER OF TOTAL_ROWS and therefor no idea how
    -- to get TOTAL_ROWS/4.


--  7. Which customers have already paid their reservations for periods beginning July 1, 2020?
    SELECT clientno from reservations WHERE start_date >= ('2020-7-1') AND status = 'PAID';

--  8. Which cottages have a house number less than 12 and either have a playground or
--  are located on a corner? Give all details and sort by park code.
    SELECT * FROM cottages WHERE houseno < 12 AND (corner = 'Y' OR playground = 'Y')
    ORDER BY park_code;

--  9. Is there a bungalow type where you pay less than 20% more for a weekend than
--  for a midweek? Also show the park code.
    SELECT * FROM cottype_prices WHERE ((price_midweek * 1.2) < price_weekend);

-- 10. List the parks located in Belgium (code 1) or the Netherlands (code 2).
-- Note the spelling in the RT.
    SELECT * from parks WHERE country_code = '1' OR country_code = '2';

-- 11. List those reservations for which no type and/or house number is known
-- yet and which are either open or paid.
    SELECT * from reservations WHERE (houseno IS NULL OR typeno IS NULL)
            AND (status = 'PAID' OR status = 'OPEN') ;

-- 12. Enter customers who live in zip codes 2060, 2100 or 2640.
    SELECT * from clients WHERE postcode = '2060' OR postcode = '2100' OR postcode = '2640';

-- 13. Which customers live at house number 106 and live at a location with a zip code equal to 2640
-- either Have a municipality whose first letter is between A and D (A and D included)?
    SELECT * FROM clients WHERE (houseno = '106' AND postcode = '2640')
        OR LOWER(city) LIKE 'a%'
        OR LOWER(city) LIKE 'b%'
        OR LOWER(city) LIKE 'c%'
        OR LOWER(city) LIKE 'd%' ORDER BY city;

        --SELECT * FROM clients WHERE (houseno = '106' AND postcode = '2640')
        --    AND LEFT(city,1) IS ;

-- 14. Give all information about the houses for which the price of a midweek is less than
-- 250 and for which the price of an extra day is not yet known and/or is less than 30.
    SELECT * FROM cottype_prices WHERE price_midweek < 250
                                       AND (price_extra_day < 30 OR price_extra_day IS NULL);

-- 15. List all payments except those with mode 'O' (=transfer) made before February 1, 2019.
    SELECT * FROM payments WHERE payment_method != 'O' AND (payment_date - '2019-2-1')<0;

-- 16. Enter next select and explain the error.
    -- | SELECT DISTINCT last_name FROM clients WHERE zip code = '2640' ORDER BY clientno;
    -- 'zip code' is incorrect, it should be 'postcode'

-- 17. For vacation park LES BOIS FRANCS (code BF), give the vacation homes for
-- which animals are not allowed and a beach is present (or not yet filled in)
    SELECT * fROM cottages WHERE park_code = 'BF' AND pet = 'N' and (beach = 'Y' OR beach IS NULL);

--  18. List all countriesNAMES beginning with N, in capital letters,sorted alphabetically.
    SELECT UPPER(country_name) FROM countries WHERE country_name LIKE 'N%'
            ORDER BY country_name;

--  19. Provide the names of customers who have the word "LAAN" in the street attribute.
    SELECT first_name || ' ' || last_name, street FROM clients WHERE street LIKE '%LAAN%';




