SELECT * FROM v$version;

-- Efficiency Comparison
-- The following 4 queries give the same result.  Which is the most
-- efficient?



-- Show each broker_id, his or her lowest price_total and
-- the id for the trade(s) and the time(s) when the trade(s) 
-- occurred.  
-- 1
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
ORDER BY broker_id
;

-- 2 - Equivalent query with an IN
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

-- 3 - Equivalent query with a correlated subquery.
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

-- 4 - Equivalent query with a HAVING correlated subquery
SELECT 
  t.broker_id, 
  t.transaction_time,
  t.shares,
  min(t.price_total)
FROM trade t
GROUP BY t.broker_id, t.transaction_time, t.shares
HAVING min(t.price_total) =
  (SELECT 
     min(sub.price_total)
   FROM trade sub   
   WHERE sub.broker_id = t.broker_id
  )
ORDER BY
broker_id
;

SET autotrace OFF;

-- Turn on all autotrace options
SET autotrace ON;

-- Display the explain plan only (no statistics)
SET autotrace ON EXPLAIN;

--Or to turn on only the statistics
SET autotrace ON STATISTICS;



/*  Explain Plan Cost   */


/*   You cannot compare the explain plan cost of 2 queries with each other.
They are simply not comparable.

When Oracle gets a query, the optimizer comes up with lots of plans. Each step
of the plan is assigned some relative cost.  At the end, Oracle applies a 
function to derive the total cost of that query for each plan.  These costs 
can be compared as they are for the exact same SQL using the same exact
environment.

If Oracle gets a second query, the optimizer goes through the same steps.  
It builds lots of plans, assign a cost to each plan, and picks the plan with 
the lowest cost from that set. If the two plans for these two queries end up
being the same, then the two queries are, for all intents and purposes,
equivalent.  The explain plan costs will be the same.

But if the two plans end up different, then the approaches that are used for
gathering the data are different and and the explain plan cost numbers cannot 
be compared. 

So do not compare explain plan cost numbers between queries. You can't. 
-- they might as well be random numbers.

*/


/*   AUTOTRACE    */

/* 
AUTOTRACE provides statistics that can be used to compare the execution of
one query against another.

Statistics
----------------------------------------------------------
 recursive calls
 db block gets
 consistent gets
 physical reads
 redo size
 bytes sent via SQL*Net to client
 bytes received via SQL*Net from client
 SQL*Net roundtrips to/from client
 sorts (memory)
 sorts (disk)
 rows processed


Recursive Calls:
This is the number of SQL calls that are generated in User and System levels 
on behalf of our main SQL. Suppose in order to execute our main query, Oracle 
needs to PARSE the query. For this Oracle might generate further queries in 
data dictionary tables etc. Such additional queries are be counted as 
recursive calls. 

Db Block Gets:
Oracle needs to fetch internal information.  The DB Block Gets represents
how many blocks of this internal data must be read.

One can not do much to reduce the db block gets. 


Consistent Gets:
The number of consistent gets represents how many times Oracle must read the
blocks in memory (logical reads) in order to process the query.  It is the
best representation of how much work the database engine is doing.


Physical Reads:
Physical Read means total number of data blocks read directly or from 
buffer cache. If the number of physical reads is high, you might need to
add more physical memory to the server.


Redo Size:
This is total number of Redo Log generated sized in bytes. 


Sorts:
Sorts are performed either in memory (RAM) or in disk. These sorts are often 
necessary by Oracle to perform certain search algorithm. In memory sort is 
much faster than disk sort. 



The basic thing we need to concentrate on is reducing Consistent Gets.

*/

