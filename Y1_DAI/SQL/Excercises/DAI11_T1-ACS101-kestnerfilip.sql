-- KdG email :          filip.kestner@student.kdg.be      <-- FILL THIS IN
-- OS in use :          MAC   <-- FILL THIS IN
-- Date  :              2022-10-19          
-- Period :             Term1               

--***********************
--Combo exercises week 4
--***********************


-------------
--Exercise 1
-------------

-- Show for ALL employees (except those whose live in house number 14)
--   their full name,
--   and street,
--   and their family_members's name,
--   and also the relationship with those family_members.
-- Sort your results like the output
-- Make sure the you get exactly the output as shown below.
--   (e.g. 5 column, aliases, constants and concatenations)

/*
 Employee full name |    -->    |        street         |        -->        |   Family relation
--------------------+-----------+-----------------------+-------------------+---------------------
 Zuiderweg Willem   | lives in  | Lindberghdreef 303    | and is related to | Andrew (Son)
 Zuiderweg Willem   | lives in  | Lindberghdreef 303    | and is related to | Josefine (Daughter)
 Zuiderweg Willem   | lives in  | Lindberghdreef 303    | and is related to | Suzan (Partner)
 Pregers Shanya     | lives in  | Overtoomweg 44        | and is related to | <null>
 Joosten Dennis     | lives in  | Eikenstraat 10        | and is related to | <null>
 Jochems Suzan      | lives in  | Nuthseweg 17          | and is related to | Alex (Partner)
 Bordoloi Bijoy     | lives in  | Zuidelijke Rondweg 12 | and is related to | <null>
 Bock Douglas       | lives in  | Monteverdidreef 2     | and is related to | Diana (Daughter)
 Bock Douglas       | lives in  | Monteverdidreef 2     | and is related to | Jos (Son)
 Bock Douglas       | lives in  | Monteverdidreef 2     | and is related to | Mary (Partner)
(10 rows)
*/
--Type your answer here:

SELECT e.last_name || ' ' || e.first_name as "Employee full name",
       'lives in' as "-->",
       e.street as "street",
       'and is related to' as "-->",
       fm.name || ' (' || INITCAP(LOWER(fm.relationship)) || ')' as "Family relation"
    FROM employees e
    LEFT JOIN family_members fm ON e.employee_id = fm.employee_id
    WHERE e.street NOT LIKE '%14'
    ORDER BY "Employee full name" DESC, "Family relation";