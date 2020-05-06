/* 
Objectives:

 -SORTING might be better than JOINing
 
 -CROSS JOIN
 -Old JOIN syntax
 -JOIN USING
 -NATURAL JOIN

*/

-- Unnecessary self-join ------
/* Show pairs of companies that have their head office in the 
same place */
-- This query would be good if the data came in pairs, 
-- but it doesn't.  There are triples.
SELECT 
   c1.NAME,
   c2.NAME
FROM company c1
   JOIN company c2
     ON c1.place_id = c2.place_id
WHERE c1.company_id > c2.company_id
ORDER BY 1,2
;

-- It is a lot simpler just to sort the companies by the place 
-- so we can see which companies are in the same place.
SELECT 
   p.city, 
   c.NAME
FROM company c
   JOIN place p
   ON p.place_id = c.place_id
ORDER BY c.place_id;


 
/*   CROSS JOIN.
A cross join gives every combination of rows from the left table with the 
rows from the right table. 
A cross join might possibly be used for creating test data, where you want
to create every possible combination.
*/
SELECT
   c.consultant_id,
   c.first_name,
   c.last_name,
   a.consultant_id,
   a.assignment_id
FROM consultant c  
   CROSS JOIN assignment a
ORDER BY c.last_name, c.first_name, a.assignment_id;

    
/*  OLD JOIN SYNTAX
In ANSI 92, the American National Standards Institute endorsed the JOIN
clause syntax that we have seen so far (above). Prior to ANSI 92, the syntax 
was to simply list tables in the FROM clause, separated by commas, and 
put the JOIN criteria in the WHERE clause.
Microsoft and Oracle both support the ANSI 92 JOIN standards as well as the 
old join syntax.  
You might see the old syntax on the job, but FDM prefers that you write
queries using the new JOIN ON syntax.
*/
SELECT
   c.consultant_id,
   c.first_name,
   c.last_name,
   a.consultant_id,
   a.assignment_id,
   cl.client_name
FROM consultant c, assignment a, client cl
WHERE cl.client_id = a.client_id
  AND c.consultant_id = a.consultant_id
ORDER BY c.last_name, c.first_name, a.assignment_id;
  
-- CROSS JOIN in old syntax.
-- It was very easy to make a cross join by mistake in the old syntax.
SELECT
   c.consultant_id,
   c.first_name,
   c.last_name,
   a.consultant_id,
   a.assignment_id
FROM consultant c, assignment a
ORDER BY c.last_name, c.first_name, a.assignment_id;


/* Additional ANSI JOIN Syntax:  Using */
SELECT 
 first_name,
 last_name,
 address_id,         -- no table qualifier needed
 house_number,
 street,
 town
FROM address
  JOIN consultant
  USING (address_id)
;
SELECT 
 first_name,
 last_name,
 address.address_id,         -- need the table qualifier
 house_number,
 street,
 town
FROM address
  JOIN consultant
   ON address.address_id = consultant.address_id
;


/*  Natural join assumes that the columns whose names are the same are 
the columns to join on.
*/
SELECT 
 first_name,
 last_name,
 address_id,         -- no table qualifier
 house_number,
 street,
 town
FROM address
  NATURAL JOIN consultant;
















