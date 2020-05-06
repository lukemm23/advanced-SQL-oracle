/* 
Module Objectives:

Subquery used as a table (in the FROM or JOIN)

Subquery in the HAVING

ROWNUM

*/



/******  SUBQUERIES in the FROM ******/
/*  Oracle refers to these as "inline views".

-- A "table" is really a set of rows.  You can use a set of rows
-- in a FROM or JOIN.
*/

-- The following query is a regular aggregation query.
-- The output of this query is just a set of rows.  It can be used in
-- the FROM of another query.
SELECT 
   a.consultant_id,
   sum(a.pay) consultanttotal
FROM assignment a
GROUP BY a.consultant_id
ORDER BY A.consultant_id;
 
-- The result set of a query is also a set of rows.  You use a set of rows in a 
-- FROM or a JOIN.
-- Aggregated data passed to an outer query.
SELECT 
  AVG(consultanttotal)
FROM    
    (SELECT consultant_id, sum(a.pay) AS consultanttotal
     FROM  assignment A
     GROUP BY consultant_id);
 
-- Note that the AVG(SUM()) is not the same as simply the AVG()
SELECT 
   AVG(pay)
FROM assignment;

-- Compacting a query.
-- The following query can be written in a more compact form
SELECT
   AVG(consultanttotal)
FROM    
    (SELECT consultant_id, sum(a.pay) AS consultanttotal
     FROM  assignment A
     GROUP BY consultant_id);

-- The consultant_id is not needed in the in-line view
-- but the following is not the most compact version.
SELECT
   AVG(consultanttotal)
FROM    
    (SELECT sum(a.pay) AS consultanttotal
     FROM  assignment A
     GROUP BY consultant_id);

-- Here is the compact version
SELECT
   AVG(SUM(a.pay)) AS Average
FROM  assignment A
GROUP BY consultant_id;


/* 
What if you want to find information about the broker's trade with
the lowest price?
*/

-- Step 1 - Show each broker_id and his or her lowest price_total
SELECT 
   broker_id,
   MIN(price_total)  
FROM trade
GROUP BY broker_id
;

-- Show each broker_id, his or her lowest price_total and
-- the id for the trade(s) and the time(s) when the trade(s) 
-- occurred.  
SELECT    
   t.broker_id,
   t.trade_id,
   t.transaction_time,
   t.shares,
   t.price_total
FROM trade t
   JOIN 
      (SELECT 
          broker_id,
          MIN(price_total) AS mintotal
      FROM trade
      GROUP BY broker_id) sub
   ON sub.broker_id = t.broker_id
       AND sub.mintotal = t.price_total
;

-- Equivalent query with an IN (This is a sub-query not an inline view)
SELECT 
  broker_id, 
  trade_id,
  transaction_time,
  shares,
  price_total 
FROM trade
WHERE (broker_id, price_total) 
 IN (SELECT 
       broker_id,
       MIN(price_total)
     FROM trade
     GROUP BY broker_id)
ORDER BY broker_id
;

-- Equivalent query with a correlated subquery.
SELECT 
  t.broker_id, 
  t.trade_id,
  t.transaction_time,
  t.shares,
  t.price_total
FROM trade t
WHERE price_total =
  (SELECT 
     MIN(price_total)
   FROM trade sub   
   WHERE sub.broker_id = t.broker_id
  )
ORDER BY broker_id
;



/******  SUBQUERIES in a HAVING ******/
  
---    TOP LEVEL GOAL   
-- Query to show brokers who have
-- made more trades than the average broker.


--Step 1.  Find the number of trades for each broker
SELECT
   broker_id,
   COUNT(trade_id)
FROM trade
GROUP BY broker_id;



--Step2.  Find the average.  We have to find the average of the list
-- that was created in step 1.
SELECT AVG(numtrades)
FROM (
    SELECT
       COUNT(trade_id) AS numtrades
    FROM trade
    GROUP BY broker_id);

-- compact version
SELECT
   AVG(COUNT(trade_id))
FROM trade
GROUP BY broker_id;

  
-- STEP Three. Put it together.
SELECT
   b.First_Name,
   b.Last_Name,
   COUNT(trade_id)
FROM broker b
   JOIN trade t
      ON t.broker_id = b.broker_id
GROUP BY b.First_Name, b.Last_Name
HAVING COUNT(trade_id) > 
     (  SELECT AVG(COUNT(trade_id))
        FROM trade
        GROUP BY broker_id)
;



/* ROWNUM
Returns a number for each row
*/

-- Show the pay from each assignment and rownum
SELECT 
   ROWNUM, 
   pay
FROM assignment
;

-- We can use the rownum to restrict output
SELECT 
   ROWNUM, 
   pay
FROM assignment
WHERE ROWNUM <= 5
;

-- The following will not work
-- We cannot retrieve row 2 without first retrieving row 1
SELECT 
   ROWNUM, 
   pay
FROM assignment
WHERE rownum = 2
;

-- If the rownumber is applied in an inner query, then the number can be 
-- used to select a particular row.
SELECT *
FROM (SELECT 
        ROWNUM as rnum, 
        pay
      FROM assignment)
WHERE rnum = 5;


-- What about sorting a list and using rownum?
SELECT 
   ROWNUM, 
   pay
FROM assignment
ORDER BY pay DESC NULLS LAST;

-- Problem is rownum is set before the ORDER BY is applied, not after.
-- But we can sort within an in-line view and apply the rownum after.
SELECT 
  ROWNUM AS num,
  pay
FROM (
   SELECT 
      pay
   FROM assignment
   ORDER BY pay DESC NULLS LAST
   );

-- And we can select the "nth" row like this:
SELECT 
   pay
FROM 
   (SELECT 
      ROWNUM AS rnum,
      pay
    FROM (
          SELECT 
            pay
          FROM assignment
          ORDER BY pay DESC NULLS LAST
          )
    )
WHERE rnum = 7;


