-- Rename this script to DAI11_T1-<class group>-<family name><first name>.sql
---------
-- KdG email : filip.kestner@student.kdb.be    <-- FILL THIS IN
-- OS in use : MAC <-- FILL THIS IN
-- Laptoptool active : NO <-- FILL THIS IN
-- Date  : 2022-2023
-- Period : T1

-- Check if database has been correctly created,
-- Execute the following query
SELECT COUNT(*) "#clients", (SELECT COUNT(*) FROM events) "#events", (SELECT COUNT(*) FROM songs) "#songs"
FROM clients;
/*
+--------+-------+------+
|#clients|#events|#songs|
+--------+-------+------+
|3       |2      |6     |
+--------+-------+------+
*/

--------------
-- QUESTION  1
-- 5 points --
--------------
------------------------------------------------------------------------------------------------------------------
-- Write a query which shows
-- * the name of an event
-- * the name of the client of that event
-- * the address of the event,
-- * the date of the event
-- * and the description of the event
-- Ensure that
-- * All this info is shown in a single column  (see example of the output below)
-- * The name of the event is in uppercase
-- * The client name (in uppercase) starts with the initials of the first name followed by the full family name
-- * In the description each word starts with a capital letter
-- * The rows are shown in chronological order

/* EXPECTED OUTPUT *
+------------------------------------------------------------------------------------------------------------------------------------------------------------+
|event_report                                                                                                                                                |
+------------------------------------------------------------------------------------------------------------------------------------------------------------+
|The event VIGIL WEDDING of L. VIGIL, taking place at 123 magnolia road, hudson, n.y. 11220 on 2004-04-28, is a Black Tie At Four Season Hotel               |
|The event PETERS GRADUATION of H. PETERS, taking place at 52 west end drive, los angeles, ca 90210 on 2004-05-14, is a Party For 200, Red, White, Blue Motif|
+------------------------------------------------------------------------------------------------------------------------------------------------------------+
*/

/* write answer 1 below */

SELECT CONCAT_WS(
    ' ',
    'The event',
    UPPER(e.name), 'of',
    UPPER(SUBSTR(c.first_name,1,1) || '. ' || (c.last_name)) ||',',
    'taking place at',
    v.address,
    'on',
    e.event_date || ',',
    'is a',
    INITCAP(e.description)
    )event_report
FROM events e
JOIN clients c ON e.client_number = c.client_number
JOIN venues v ON e.id = v.id
ORDER BY e.event_date;


--------------
-- QUESTION  2
-- 5 points --
--------------
------------------------------------------------------------------------------------------------------------------
-- Write a query which shows
-- * the title of the CD's that have been played on the events of clients 'vigil' and 'jones'
-- * the amount of numbers from those cd's that have been played
-- Ensure that
-- * All this info is shown in two columns  (see example of the output below)
-- * the number of songs is preceded by 10 '-' characters
--          [NO - you are not allowed to use '----------' in your query ]
-- * The rows are shown in alphabetical order

/* EXPECTED OUTPUT *
+-----------------------------+---------------+
|cd-title                     |number of songs|
+-----------------------------+---------------+
|here comes the bride         |---------1     |
|party music for all occasions|---------2     |
+-----------------------------+---------------+
*/

/* write answer 2 below */

SELECT cd.title as "cd-title",
       LPAD(
           TO_CHAR(COUNT(tl.song_id),'FM9')
           ,10 -- +LENGTH(TO_CHAR(COUNT(tl.song_id),'FM9'))
               -- -> If you want it to always be preceded by 10 '-' characters
           ,'-') as "number of songs"

FROM events e
    JOIN play_list_items pli on e.id = pli.event_id
    JOIN track_listings tl on pli.song_id = tl.song_id
    JOIN cds cd on tl.cd_number = cd.cd_number
    JOIN clients c on e.client_number = c.client_number
WHERE c.last_name = 'vigil' OR c.last_name = 'jones'
GROUP BY cd.title, c.first_name
ORDER BY cd.title;


--------------
-- QUESTION  3
-- 5 points --
--------------
------------------------------------------------------------------------------------------------------------------
-- Write a query which uses set operators to show 2 sets of events
-- 1. events that have a 'wedding coordinator' as partner
-- 2. events that have as theme 'tropical' or 'mardi gras'
-- Ensure that
-- * All this info is shown in three columns  (see example of the output below)
--     ie, the address, the name and the date of the event
-- * The rows are shown in alphabetical order

/* EXPECTED OUTPUT *
+-------------------------------------------+-----------------+----------+
|event address                              |event name       |event date|
+-------------------------------------------+-----------------+----------+
|123 magnolia road, hudson, n.y. 11220      |vigil wedding    |2004-04-28|
|52 west end drive, los angeles, ca 90210   |peters graduation|2004-05-14|
|200 pennsylvania ave, washington d.c. 09002|vigil wedding    |2004-04-28|
+-------------------------------------------+-----------------+----------+
*/

/* write answer 3 below */


SELECT v.address as "event address",
       e.name as "event name",
       e.event_date as "event date"
FROM events e
    JOIN job_assignments ja on e.id = ja.event_id
    JOIN partners p on ja.partner_id = p.id
    JOIN venues v on e.id = v.id
WHERE p.partner_type = 'wedding coordinator'
UNION ALL -- ** 'UNION' results in INCORRECT ORDER, and ALPHABETIC ORDERING IS NOT AS SHOWN!
SELECT v.address, e.name, e.event_date FROM events e
    JOIN themes t on e.theme_code = t.code
    JOIN venues v on e.venue_id = v.id
WHERE t.description = 'tropical' OR t.description = 'mardi gras'
-- ORDER BY "event name"; -> Real alphabetic ordering

-- ** The way it is set up you have to use event.venue_id = venues.id
-- AND event.id = venues.id while the ERD tells us that the PK and FK
-- are event.venue_id & venues.id respectively. So essentially you are
-- asking me to use a mismatching id to get all 3 results. The correct
-- result would only have 2 entries as an event CAN ONLY HAVE 1 VENUE
-- IN THIS CASE OR THERE SHOULD BE 2 SEPERATE ENTRIES IN EVENTS FOR 'vigil wedding'


