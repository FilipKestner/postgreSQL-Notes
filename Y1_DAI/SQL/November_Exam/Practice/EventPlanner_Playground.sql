SELECT * FROM clients;


SELECT first_name || '.' || last_name || '@DJBookings.com' FROM clients;



-- 1. a. List the number of songs in each genre of music
    --  ------------------
    -- | Genre:  | Count: |
    -- | new age |      2 |
    -- | pop     |      2 |
    -- | country |      1 |
    -- | jazz    |      1 |
    --  ------------------

    SELECT description, COUNT(id) FROM songs s
    JOIN types t ON s.type_code = t.code
    GROUP BY description;

-- 2. For EACH SONG display the name of the song, genre (type), cd NAME, cd YEAR OF RELEASE
    SELECT s.title, t.description, cd.title, cd.producer, cd.year FROM track_listings tl
    JOIN songs s ON tl.song_id = s.id
    JOIN types t ON s.type_code = t.code
    JOIN cds cd ON tl.cd_number = cd.cd_number;

-- 3.

SELECT t.description FROM types t
UNION ALL
SELECT c.first_name FROM clients c;

-- 4. List the type of venue for each event

SELECT e.id, v.loc_type FROM events e
LEFT JOIN venues v ON v.id = e.id;



SELECT year, COUNT(title) FROM cds
         GROUP BY year;


SELECT date_part('year',AGE(to_date(year,'YYYY'))) || ' years since release' FROM cds;

SELECT current_date;