/* Lesson Objectives
UNION, INTERSECT, MINUS
*/

-- UNION
-- UNION will eliminate duplicates
-- Bill Sykes is in both tables but because the broker_id's 
-- do not match both rows will come out 
SELECT 
  broker_id,
  first_name,
  last_name
FROM broker
UNION
SELECT 
  consultant_id,
  first_name,
  last_name
FROM consultant
ORDER BY last_name
;

-- Bill Sykes is in both tables.  UNION will eliminate the duplicate

-- Show distinct names from both tables
SELECT 
  first_name,
  last_name
FROM broker
UNION
SELECT 
  first_name,
  last_name
FROM consultant
ORDER BY last_name
;

-- UNION ALL
-- UNION ALL does not eliminate duplicates

-- Show all names
SELECT 
  first_name,
  last_name
FROM broker
UNION ALL
SELECT 
  first_name,
  last_name
FROM consultant
ORDER BY last_name
;


/* INTERSECT */

-- Show the names that match between the brokers and consultants
SELECT 
  first_name,
  last_name
FROM broker
INTERSECT
SELECT 
  first_name,
  last_name
FROM consultant
ORDER BY last_name
;

-- A JOIN can do the same job as an INTERSECT
SELECT 
  b.first_name,
  b.last_name
FROM broker b
 JOIN consultant c
   ON b.first_name = c.first_name
   AND b.last_name = c.last_name
;

/* MINUS
Show all rows from the first query, unless they are
repeated in the second query */

-- Show all brokers who are not consultants.
SELECT 
  first_name,
  last_name
FROM broker
MINUS
SELECT 
  first_name,
  last_name
FROM consultant
ORDER BY last_name
;

-- Show all consultants who are not brokers.
SELECT 
  first_name,
  last_name
FROM consultant
MINUS
SELECT 
  first_name,
  last_name
FROM broker
ORDER BY last_name
;
