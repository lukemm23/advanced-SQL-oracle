/*
Lesson Objectives:
==================
WHERE =
Filtering by number, string, date
Filtering by NULL, NOT NULL

*/


/******* WHERE Clause *****************/
/* Basic Filtering */
-- Numeric filtering criteria.

-- Show the information for consultant id 1
SELECT 
   consultant_id,
   first_name,
   last_name,
   birth_date,
   boss_id,
   address_id
FROM 
   consultant 
WHERE consultant_id = 1
;

-- String filtering
SELECT 
   consultant_id,
   first_name,
   last_name,
   birth_date,
   boss_id,
   address_id
FROM 
   consultant 
WHERE first_name = 'Bill';


/* Date filtering:
It is recommended that you convert strings to date and perform
the comparison in date format, rather than converting dates to string
and performing the comparison in string format.
Consider the following two examples:
*/
SELECT 
   first_name,
   last_name,
   to_char(birth_date,'Month dd, yyyy') AS birthdate
FROM  consultant
WHERE birth_date >= TO_DATE('apr-26-1980','mon-dd-yyyy');
/* 
The preceding query shows consultants born after apr-26-1980
The following query does not work correctly if your want to show 
consultants born after apr-26-1980.
*/
SELECT 
   first_name,
   last_name,
   to_char(birth_date,'Month dd, yyyy') AS birthdate
FROM  consultant
WHERE to_char(birth_date,'mon-dd-yyyy') >= 'apr-26-1980';



 /*****************  NULL VALUES **************
 NULL is special.  
 NULL means "I don't know" or "I do not have an answer".
 You cannot say:  "  'I don't know' = 'I don't know' "
 and cannot say:  "  'I don't know' != 'I don't know' "
 Therefore:
 NULL = NULL    is false
 NULL <> NULL   is false
 NULL != NULL   is false
 
 However,
 NULL IS NULL   is true
 */

-- Show all consultants who do not have a boss.
SELECT 
  consultant_id,
  first_name, 
  last_name,
  boss_id
FROM consultant
WHERE boss_id IS NULL;


-- Show all consultants who DO have a boss.
SELECT 
  consultant_id,
  first_name, 
  last_name,
  boss_id
FROM consultant
WHERE boss_id IS NOT NULL;

/*
NUMBER, DATE, VARCHAR2 could all be null.
Whether a column allows nulls is independent of the datatype.
*/

