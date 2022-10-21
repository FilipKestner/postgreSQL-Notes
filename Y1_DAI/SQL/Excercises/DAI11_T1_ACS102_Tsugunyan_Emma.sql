-- KdG email :         emma.tsugunyan@student.kdg.be     <-- FILL THIS IN
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

SELECT e.last_name last_name , e.first_name first_name , e.street
FROM employees e
INTERSECT
SELECT f.first_name, f.relation
FROM family_members
    JOIN employees ON e.last_name=f.first_name
WHERE UPPER (e.street)!= '14');


-- 0/1 CONCAT or || + constants
-- 0/1 INITCAP relation
-- 0/1 OUTER JOIN
-- 0/1 WHERE NOT LIKE street
-- 0/1 ORDER e.last_name desc, fm.name

-- 0/5 ==> Total for this assignment





