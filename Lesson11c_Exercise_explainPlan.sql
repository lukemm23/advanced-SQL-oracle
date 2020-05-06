-- Self-Study:  Look at the Explain plan for each of the following:

/* Objectives:
Explain Plan
Cost Value
*/

-- Access One Table
-- Oracle must do a full table scan.  
-- A full table scan scans the data blocks.
SELECT 
   consultant_id, 
   first_name, 
   last_name,
   rowid
FROM consultant;

-- This query accesses ONLY the consultant_id which is covered by
-- the index.  
-- Oracle can scan the index alone. (No need to bother with the 
-- data blocks.)
-- In an full index scan, Oracle scans the bottom level of the index tree.
SELECT 
   consultant_id,
   rowid
FROM consultant;

/* Explain Plan gives a cost value for the query.  The cost
values provide a relative measure where higher values means the 
query will cost more to run.  Cost represents an estimation of 
I/O usage, CPU usage, memory usage and possibly other factors. */


-- The index is used to find the rowid for the record. 
-- Then the data block is accessed to get the first and last name.
SELECT 
  consultant_id,
  first_name, 
  last_name 
FROM consultant
WHERE consultant_id = 2
;

-- The table is not indexed by last_name.  Therefore Oracle must do
-- a full table scan.
SELECT 
   consultant_id, 
   first_name, 
   last_name
FROM consultant
WHERE last_name = 'Sykes';


-- We will build an index on first_name, but first look at the 
-- explain plan without an index.
SELECT first_name
FROM consultant;

SELECT 
   consultant_id,
   first_name, 
   last_name
FROM consultant
WHERE first_name = 'Bill';

SELECT
   consultant_id, 
   first_name, 
   last_name
FROM consultant
WHERE first_name BETWEEN 'A' AND 'Z';

DROP INDEX consultant_fn_idx;

CREATE INDEX consultant_fn_idx
ON consultant(first_name);

exec dbms_stats.gather_table_stats('SCOTMCDERMID', 'CONSULTANT');


--- JOINS 
--  Access More than one table

-- Compare the explain plan for the following three queries.
SELECT
   first_name, 
   last_name,
   ad.house_number,
   ad.street,
   ad.town
FROM address ad
  JOIN consultant p 
    ON ad.address_id = p.address_id;

SELECT 
   first_name, 
   last_name,
   ad.house_number,
   ad.street,
   ad.town
FROM consultant p
   JOIN address ad
    ON ad.address_id = p.address_id;
    
SELECT 
   first_name, 
   last_name,
   ad.house_number,
   ad.street,
   ad.town
FROM consultant p 
  RIGHT OUTER JOIN address ad
    ON ad.address_id = p.address_id;    

-- Add an index to the foreign key and try the queries above again.
CREATE INDEX consultant_add_idx
ON consultant(address_id);


/*
The following three queries give the same output.  Only the order that
the tables are joined is different.  Use explain plan to see if the optimizer
changes the order of the tables.
*/
SELECT
   con.first_name,
   con.last_name,
   A.assignment_id,
   cl.client_name
FROM client cl
  JOIN assignment A
     ON cl.client_id = A.client_id
  JOIN consultant con
     ON A.consultant_id = con.consultant_id
ORDER BY con.last_name, con.first_name, A.assignment_id;

SELECT
   con.first_name,
   con.last_name,
   A.assignment_id,
   cl.client_name
FROM assignment A
  JOIN client cl
   ON cl.client_id = A.client_id
  JOIN consultant con
     ON con.consultant_id = A.consultant_id
ORDER BY con.last_name, con.first_name, A.assignment_id;

SELECT 
   con.first_name,
   con.last_name,
   A.assignment_id,
   cl.client_name
FROM client cl
  JOIN (assignment A
        JOIN consultant con
           ON A.consultant_id = con.consultant_id)
    ON cl.client_id = A.client_id
ORDER BY con.last_name, con.first_name, A.assignment_id;

  
 -- Try the explain plan on the following:
SELECT comments
FROM assignment;

SELECT DISTINCT comments
FROM assignment;

SELECT comments
FROM assignment
GROUP BY comments;

-- Can we help this join with indexes?
SELECT 
   t.trade_id,
   sp.price
FROM trade t
 JOIN stock_price sp
   ON sp.stock_id = t.stock_id
   AND sp.stock_ex_id = t.stock_ex_id
   AND trunc(sp.time_start,'dd') = trunc(t.transaction_time,'dd');

DROP INDEX stock_price_idx;   
CREATE UNIQUE INDEX stock_price_idx
ON stock_price(stock_id, stock_ex_id, trunc(time_start,'dd'));

DROP INDEX trade_idx;
CREATE INDEX trade_idx
ON trade(stock_id, stock_ex_id, trunc(transaction_time,'dd'));
