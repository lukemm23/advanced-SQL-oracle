/*
Lesson Objectives:
INNER JOIN 
Table Alias
*/


/* ******** TABLE JOINS ********
-- To get the information you need, you will often need to join tables.
*/
-- Show the consultant's first name, last name, and address information.
SELECT 
 first_name,
 last_name,
 consultant.address_id,        -- consultant address_id
 address.address_id,           -- matches up with address.address_id
 house_number,
 street,
 town
FROM consultant
   JOIN address
     ON address.address_id = consultant.address_id;
-- The query above is represented graphically in Lesson5a_InnerJoin.pptx

--  In the above query, there is an address_id column in both tables.
--  To eliminate confusion, the query must explicitly give the name
--  of the table every time the column name is used.



/****  TABLE ALIASES
To save on typing, tables can be given an alias.
For column aliases, the AS is optional.  (Please use it.)
For table aliases, Oracle does not use AS.
*/
SELECT 
 first_name,
 last_name,
 town AS "My town"
FROM consultant c
  JOIN address a
     ON a.address_id = c.address_id;


/* More than two tables?
You can easily join all the tables that you need. The following 
query will give the consultant's name, assignment_ids and the 
names of clients for his or her assignments
*/
SELECT 
   con.first_name,
   con.last_name,
   a.assignment_id,
   cl.client_name
FROM consultant con
  JOIN assignment a
     ON a.consultant_id = con.consultant_id
  JOIN client cl 
     ON cl.client_id = A.client_id
ORDER BY con.last_name, con.first_name, cl.client_name;

-- The query above is represented graphically in Lesson5a_InnerJoin.pptx

/*
Question:  Can you use DISTINCT in a query that has a table join?
Answer:    Absolutely!
*/
SELECT  DISTINCT
   last_name,
   town
FROM consultant con
  JOIN address a
     ON a.address_id = con.address_id
ORDER BY town, last_name;

/*
Question:  Can you use a WHERE in a query that has a table join?
Answer:    Absolutely!
*/
SELECT 
   con.consultant_id,
   con.first_name || ' ' || con.last_name AS "Full Name",
   cl.client_name,
   a.pay
FROM assignment a
  JOIN client cl
   ON cl.client_id = a.client_id
  JOIN consultant con
     ON con.consultant_id = a.consultant_id
WHERE con.consultant_id  IN (4, 5, 6)
  AND pay > 400
;
-- Try the preceeding query with the "AND pay > 400" commented out
