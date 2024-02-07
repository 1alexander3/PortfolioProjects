-- Query for names of people in all unique competitions (removing duplicates in same competition)
SELECT DISTINCT name, competition
FROM PianoProject..piano_table
ORDER BY competition DESC

-- Query for finding total number of people who got to the finals &/or semi-finals
SELECT COUNT(DISTINCT name)
FROM PianoProject..piano_table
WHERE got_through = 1 AND stage_num >= 3

-- Removing duplicate names in same competitions and filtering for female candidates who got into semi-finals or finals (third rounds or higher)
SELECT DISTINCT name
FROM PianoProject..piano_table
WHERE stage_num >= 3 AND gender = 'F'

-- All Competition names
SELECT DISTINCT competition
FROM PianoProject..piano_table

-- Stages for each competition
SELECT DISTINCT competition, stage_name, stage_num
FROM PianoProject..piano_table
ORDER BY competition, stage_num

-- Finals for each competition (Rachmaninoff uses different stage_name for final, which is why LIKE 'Round 3%' is included
SELECT DISTINCT competition, stage_name, stage_num
FROM PianoProject..piano_table
WHERE stage_name LIKE 'Final%' OR stage_name LIKE 'Round 3%' 
ORDER BY competition, stage_num

-- How many finalists in each competition
SELECT DISTINCT competition, COUNT(name) AS 'Number of Finalists'
FROM PianoProject..piano_table
WHERE stage_name LIKE 'Final%' OR stage_name LIKE 'Round 3%' 
GROUP BY competition
ORDER BY competition

-- Total number of finalists from all competitions
SELECT COUNT(name) AS 'Total # of Finalists'
FROM PianoProject..piano_table
WHERE stage_name LIKE 'Final%' OR stage_name LIKE 'Round 3%'

-- Total number of finalists who won from all competitions
SELECT COUNT(name) AS 'Total # of Finalists'
FROM PianoProject..piano_table
WHERE got_through = 1 AND stage_name LIKE 'Final%' OR stage_name LIKE 'Round 3%'

-- Finalists in 14th Arthur Rubinstein International Piano Master Competition (can be used for other competitions)
SELECT DISTINCT competition, COUNT(name) AS 'Number of Finalists'
FROM PianoProject..piano_table
WHERE competition = '14th Arthur Rubinstein International Piano Master Competition' AND stage_name LIKE 'Final%' 
GROUP BY competition
ORDER BY competition

---- Creating new table with all finalists from all competitions
--SELECT name, competition
--INTO PianoProject..finalists_table
--FROM PianoProject..piano_table
--WHERE stage_name LIKE 'Final%' OR stage_name LIKE 'Round 3%'

-- Finalists table, removed duplicate names with distinct function
SELECT DISTINCT name
FROM PianoProject..finalists_table

---- Creating new table with finalists who got through finals from all competitions -> winners_table
--SELECT DISTINCT name, competition, stage_name
--INTO PianoProject..winners_table
--FROM PianoProject..piano_table
--WHERE got_through = 1 AND stage_name LIKE 'Final%' OR stage_name LIKE 'Round 3%'
--ORDER BY competition

-- ID for each competitor (unique ID, no duplicates)
SELECT DISTINCT name
FROM PianoProject..piano_table
