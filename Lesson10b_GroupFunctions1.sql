/* 
Lesson Objectives:
COUNT, COUNT DISTINCT,
MAX, MIN, SUM, AVG

GROUP BY
HAVING
HAVING and WHERE
*/

--  Show all the records from consultant table 
SELECT 
  consultant_id,
  first_name,
  last_name,
  birth_date,
  boss_id, 
  address_id
FROM consultant;

-- Show the number of rows in the table
SELECT COUNT(*)  -- COUNT(*) counts the number of rows
FROM consultant;

/* Count on a column will count only non-null values in the column
*/
-- Show the number of boss ids that are not null
SELECT COUNT(boss_id) 
FROM consultant;

-- query to confirm the boss_id.  (To confirm the count.)
SELECT boss_id 
FROM consultant
--WHERE boss_id is not null
ORDER BY boss_id;

/* COUNT DISTINCT */
-- Show the number of distinct boss ids that are not null
SELECT COUNT(DISTINCT boss_id)
FROM consultant;

-- COUNT, MAX, MIN
-- ORACLE can find the count, max's and min's on a single pass through
-- the table
SELECT 
   place_id, 
   NAME
FROM company;

SELECT 
  COUNT(*) AS numrows, 
  MAX(place_id) AS max_place_id, -- Determined by numeric value not count
  MIN(place_id) AS min_place_id, -- Determined by numeric value not count
  MAX(name) AS max_name,        -- Determined by alphabetic order not characters
  MIN(name) AS min_name         -- Determined by alphabetic order not characters
FROM company;

/*  SUM, AVG */

-- Show the pay column of the assignment table
SELECT pay 
FROM assignment;

-- Show the sum of pay
SELECT 
   SUM(pay)
FROM assignment;

-- Show the average of pay (and a rounded average the average as well)
SELECT 
  ROUND(AVG(pay),0),
  AVG(pay)
FROM assignment;

-- Show the average, the standard deviation 
-- and the number of rows where pay was not null
-- and the number of rows in the table
SELECT 
    ROUND(AVG(pay),2), 
    ROUND(STDDEV(pay),2),
    count(pay),
    count(*)
FROM assignment;

/* GROUP BY
A GROUP BY finds DISTINCT groups (just like DISTINCT).
But a group by can be used together with aggregation functions
to find totals, average, max etc. for the group
*/

-- Show the raw data for comments
SELECT comments
FROM assignment
ORDER BY comments;

-- Show comment groups
SELECT comments
FROM assignment
GROUP BY comments;

-- Using GROUP BY in this context is equivalent query using DISTINCT
SELECT DISTINCT
   comments
FROM assignment
ORDER BY comments NULLS FIRST;

-- Number of rows for each group 
-- Output looks better with "Run Statement" rather than "Run Script"
SELECT 
  comments, 
  COUNT(*) 
FROM assignment
GROUP BY comments
ORDER BY count(*) DESC, comments NULLS FIRST
;

/* Count the number of times each consultant has gone on the
type of role */

-- Show the raw data for consultant_ids and comments
SELECT consultant_id, comments
FROM assignment
ORDER BY consultant_id, comments;

-- Number of rows for each group
SELECT
  consultant_id, 
  comments,
  COUNT(*)
FROM assignment
GROUP BY consultant_id, comments
;

-- AGGREGATION ACROSS DIFFERENT TABLES
-- Visualization available in Lesson10b_AggregationVisuals.pptx

-- raw data 
SELECT
   co.name, 
   tr.price_total
FROM company co
  JOIN trade tr
    ON tr.stock_id = co.stock_id
ORDER BY co.name;

-- Show name of the company and the sum of price totals 
-- for stock
SELECT
   co.NAME,
   SUM(tr.price_total)
FROM company co
  JOIN trade tr
    ON tr.stock_id = co.stock_id
GROUP BY co.name
ORDER BY co.name;

-- The following will give a "not a GROUP BY expression" error
SELECT
   co.company_id,
   co.NAME,
   SUM(tr.price_total)
FROM company co
  JOIN trade tr
    ON tr.stock_id = co.stock_id
GROUP BY co.company_id  
ORDER BY sum(tr.price_total) DESC;

/* The preceding query has a column inside an aggregation function,
and columns not inside aggregation functions.  
In a query that has aggregation functions, any column that is NOT inside 
an aggregation function must be listed in the GROUP BY. */

SELECT
   co.company_id,
   co.NAME,
   SUM(tr.price_total)
FROM company co
  JOIN trade tr
    ON tr.stock_id = co.stock_id
GROUP BY co.company_id, co.name
ORDER BY sum(tr.price_total) DESC;


/* HAVING CLAUSE */

-- Show the comments that have been made more than one time
SELECT 
   comments, 
   COUNT(*)
FROM assignment
GROUP BY comments
HAVING count(comments) > 1
;

/* Using both a WHERE and a HAVING.
The WHERE filters the raw records.
*/
-- (1) Show comments for assignments done by certain consultants
SELECT 
   consultant_id,
   comments
FROM assignment
WHERE consultant_id IN (2,4,5)
ORDER BY comments
;

-- (2) The GROUP BY consolidates the raw data into groups.
SELECT 
  comments, 
  COUNT(*)
FROM assignment
WHERE consultant_id IN (2,4,5)
GROUP BY comments
ORDER BY comments ASC;

-- (3) The HAVING clause filters the groups.

-- Show the comments for assignments for consultants 
-- 2,4,and 5 but only if the comment has been made 
-- more than once.
SELECT 
  comments, 
  COUNT(*)
FROM assignment
WHERE consultant_id IN (2,4,5)
GROUP BY comments
HAVING COUNT(*) > 1
ORDER BY comments ASC;













