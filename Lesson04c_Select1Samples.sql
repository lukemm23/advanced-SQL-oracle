/*
Lesson Objectives:
==================
SELECT from a single table

Column Aliases

Filter rows to find NULL values
NVL - Substitute for null

ORDER BY

DISTINCT

SELECT FROM dual
*/


/*
- A select statement, or query, requires a select clause and a from clause.
- This query selects all columns in the consultant table. 
*/

SELECT * 
  FROM consultant ;

-- Show specific columns from the table

SELECT consultant_id, first_name, last_name, birth_date
  FROM consultant;


/*  Column ALIAS  */

-- If you want to rename a column, you can supply an alias.

SELECT 
   consultant_id AS id,             -- Column heading will be ID
   first_name,
   last_name     AS "Last Name"     -- double quotes preserve case and allow spaces
FROM consultant;


/*  We can specify which ROWS to display.
	The WHERE clause serves this purpose. */
  
  SELECT *
    FROM address
    WHERE town = 'Falkirk'; --Character data, always in quotes, is CaSe seNsitIve
  
--Filter rows to find NULL values *
-- NULL has a special meaning.  
-- It means a value is unknown, unassigned, unavailable, or inapplicable.

-- find consultant(s) who do not have a boss 
SELECT consultant_id, first_name, last_name, boss_id
  FROM consultant
  WHERE boss_id IS NULL;

-- find consultant(s) who do have a boss
SELECT consultant_id, first_name, last_name,  boss_id
  FROM consultant
  WHERE boss_id IS NOT NULL;


-- this also finds consultants who do have a boss
SELECT consultant_id, first_name, last_name, boss_id
  FROM consultant
  WHERE NOT boss_id IS NULL;


/*  NVL  */

-- The nvl function substitutes a different value for a NULL

-- Replace a NULL from a character column

-- If there is no comment, return "No comment given"
-- The two operands must be of the same datatype

SELECT 
  assignment_id, 
  comments, 
  nvl(comments, 'No comment given') 
FROM assignment;

-- Substitute 0 for a NULL in a number column
SELECT 
    consultant_id,
    first_name,
    last_name,
    boss_id,
    nvl(boss_id,0)  -- boss_id is number a column. 
FROM consultant;    -- The substitution value must be a number.

-- If you convert boss_id to characters using the to_char function, then 
-- the substitution value can be characters
SELECT 
    first_name,
    last_name,
    boss_id,
    nvl(to_char(boss_id),'Does not have a boss') AS "Boss ID"
FROM consultant;

    

/*  ORDER BY  */

--  Sorts the results based on columns you specify.
--  The ORDER BY clause is almost always the last clause in a query.

-- Primary sort on last_name, secondary sort on first_name.
SELECT 
   first_name, 
   last_name,
   birth_date
FROM consultant
ORDER BY last_name, first_name;


-- ORDER BY second column selected
SELECT client_id, client_name, address_id
  FROM client
  ORDER BY 2;
  
-- ORDER BY an unselected column
SELECT consultant_id, last_name, birth_date
  FROM consultant
  ORDER BY first_name;



/* DISTINCT  
   The DISTINCT keyword eliminates duplicate rows of output.
*/

-- Show all the rows
SELECT  first_name
  FROM consultant
  ORDER BY first_name;

--Removes duplicate rows.
SELECT DISTINCT first_name
  FROM consultant
  ORDER BY 1;

SELECT DISTINCT last_name
  FROM consultant
  ORDER BY last_name;

--DISTINCT returns the unique combinations of first_name and last_name

SELECT DISTINCT first_name, last_name
  FROM consultant
  ORDER BY first_name;

/*  DUAL
Dual is a "dummy table" that allows selecting when the answer 
  is not stored in a real table.
You can use dual for testing bits of code.
*/

SELECT 123 * 321
  FROM dual;

-- SYSDATE is a built-in function that returns the date and time at the database server.
-- The function must be selected from somewhere.
SELECT  SYSDATE  
  FROM dual;

-- You can select literal values from dual
SELECT 'Hello',  1,  '04-JUL-76'  
  FROM dual;


-- You can select literals or functions in queries and they will simply 
-- appear for each row that is returned from the table.   
SELECT 	first_name, 
		'hello' AS text, 
		1 ,  
		SYSDATE 
  FROM consultant;


