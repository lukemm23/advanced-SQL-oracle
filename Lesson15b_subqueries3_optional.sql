 /*
 Lesson Objectives
 Subqueries used AS A COLUMN 
 
 Applications of DECODE and CASE
 
 PIVOT
 
 */

-- In any query, a constant can be selected as a column
SELECT  
  first_name,
  1,
  'hello'
FROM consultant;


-- This query compares consultant's pay to the average consultant's pay.
-- In this case, the subquery is used as a column.
SELECT 
  consultant_id, 
  pay,
  (SELECT AVG(pay) FROM assignment) AS avgjob
FROM assignment;
 

SELECT 
  consultant_id,
  pay,
  (SELECT round(AVG(pay),2) FROM assignment) avgjob,
  (SELECT round(STDDEV(pay),2) FROM assignment) stdev,
  (SELECT COUNT(*) FROM assignment) numjobs
FROM assignment;

-- How to make a running total
SELECT
  t.trade_id,
  t.price_total,
  (SELECT sum(sub.price_total)
   FROM trade sub
   WHERE sub.trade_id <= t.trade_id) running_total
FROM trade t
ORDER BY trade_id;


/* More challenging applications */

-- How does a consultant compare to other consultants in the same town.
SELECT 
  A.consultant_id, 
  p.first_name,
  p.last_name,
  a.town,
  a.pay,
  round( (SELECT AVG(sub_a.pay) 
   FROM assignment sub_a
        JOIN consultant sub_c
            ON sub_c.consultant_id = sub_a.consultant_id
        JOIN address sub_a
            ON sub_a.address_id = sub_c.address_id
        WHERE sub_a.town = a.town
          ),
         2)  AS avg_town_pay
FROM assignment a
   JOIN consultant p 
      ON p.consultant_id = a.consultant_id
    JOIN address a 
      ON a.address_id = p.address_id
ORDER BY a.town
    ;

-- Same as above but with an in-line view rather that a correlated subquery used as
-- a column.
SELECT 
  a.consultant_id, 
  a.town,
  a.pay,
  ROUND(town_avg.avg_pay,2)        
FROM assignment a
   JOIN consultant c 
      ON c.consultant_id = a.consultant_id
    JOIN address a 
      ON a.address_id = c.address_id    
    JOIN  (SELECT sub_a.town, AVG(sub_a.pay) avg_pay
           FROM assignment sub_a
              JOIN consultant sub_c
                 ON sub_c.consultant_id = sub_a.consultant_id
              JOIN address sub_a
                 ON sub_a.address_id = sub_c.address_id
           GROUP BY sub_a.town) town_avg
      ON town_avg.town = a.town
  ORDER BY a.town
     ;


-- Compares the total pay for the consultant to the average 
-- total pay for consultants.
SELECT 
   c.consultant_id,
   sum(a.pay) consultanttotal,
   (SELECT  AVG(consultanttotal)
     FROM    
       (SELECT sum(sub_a.pay) consultanttotal
         FROM assignment sub_a
          GROUP BY sub_a.consultant_id)
    ) AS consultantavg
FROM consultant c
  JOIN assignment a
    ON a.consultant_id = c.consultant_id
GROUP BY c.consultant_id;


-- Prior to the next examples, determine what the months
-- for which we have stock price data
SELECT DISTINCT
  to_char(sp.time_start,'mm')
FROM stock_price sp;

/* CASE and DECODE Revisited */

-- The DECODE will return the values only for the given month.
SELECT
	c.name,
  to_char(sp.time_start,'MM'),
	DECODE(TO_CHAR(sp.time_start,'MM'),
     '11',sp.price)  price1,
	DECODE(TO_CHAR(sp.time_start,'MM'),
     '12',sp.price) price2,
	DECODE(TO_CHAR(sp.time_start,'MM'),
     '01',sp.price,NULL) price3
FROM stock_price sp
	JOIN company c
	ON c.stock_id = sp.stock_id
ORDER BY 1,2;

-- Mindblowing DECODE example 1
-- This example finds the average of the prices for the given month.
SELECT
	c.name,
	ROUND(AVG(DECODE(TO_CHAR(sp.time_start,'MM'),
     '11',sp.price)),2) AS Nov,
	ROUND(AVG(DECODE(TO_CHAR(sp.time_start,'MM'),
     '12',sp.price,NULL)),2) AS Dec,
	ROUND(AVG(DECODE(TO_CHAR(sp.time_start,'MM'),
     '01',sp.price,NULL)),2) AS Jan
FROM stock_price sp
	JOIN company c
	ON c.stock_id = sp.stock_id
GROUP BY c.name
ORDER BY c.name;


-- Mindblowing DECODE example 2
-- Overall goal:  How many trades did each broker make 
-- in the last seven days?

-- Step 1: Determine what trades occurred in the last seven days.
SELECT
   broker_id,
   SIGN(7-(SYSDATE - transaction_time)) AS WithinLastSevenDay,
   DECODE(SIGN(7-(SYSDATE - transaction_time)),1,1)
FROM trade;
-- The decode with return NULL if the trade was more than 7 days ago.

-- Step 2: Count the number of trades in the last seven days.
SELECT
   broker_id,
   COUNT(DECODE( SIGN(7-(SYSDATE - transaction_time)),
                 1, 1)) num
FROM trade
GROUP BY broker_id;


-- Rewrite using a CASE statement 
SELECT
   broker_id,
   COUNT(CASE SIGN(7-(SYSDATE - transaction_time))
         WHEN 1 THEN 1 END) num
FROM trade
GROUP BY broker_id;

/*  PIVOT
In ORACLE 11g, the PIVOT clause was introduced.
The purpose of PIVOT is to create a pivot table or a "cross-tab".
To set up a SELECT that contains a PIVOT, the input set must have only three columns.
One of the columns will be used as the row label.  One of the columns will be used 
as the column label, and the third column will be summarized and used in the intersection
between the row label and column label.
*/
-- Example 1 
-- Show a "cross-tab" which indicates whether
-- a stock is traded on a particular exchange
SELECT
   *               -- asterisk
FROM stock_listing
PIVOT ( count(stock_symbol)
   FOR stock_ex_id IN (1,2,3)
   )
;


-- Example 2
-- Show a cross-tab for the average price
-- for each stock_id at each exchange.
WITH sp
  AS (SELECT 
           co.NAME, 
           se.symbol, 
           price 
         FROM stock_price sp
             JOIN company co
                ON co.stock_id = sp.stock_id
              JOIN stock_exchange se
                ON se.stock_ex_id = sp.stock_ex_id)
SELECT
  *                           -- must be an asterisk
FROM sp
PIVOT ( sum(price)
    FOR symbol IN ('NYSE','LSE','EP')
      
    )
;

-- Example 3  
/* Rewrite the first mind-blowing DECODE example to use PIVOT
instead
*/
SELECT 
     *                            -- asterisk
FROM
     (SELECT
     	c.NAME,
      TO_CHAR(sp.time_start,'Mon') AS mnth,
      sp.price
      FROM stock_price sp
	       JOIN company c
	          ON c.stock_id = sp.stock_id)
PIVOT ( avg(price)
       FOR mnth IN ('Feb','Mar','Apr')
       )
;

SELECT 
   NAME,
   round("'Apr'",2),
   round("'May'",2),
   round("'Jun'",2)
FROM
     (SELECT
     	c.NAME,
      TO_CHAR(sp.time_start,'Mon') AS mnth,
      sp.price
      FROM stock_price sp
	       JOIN company c
	          ON c.stock_id = sp.stock_id)
PIVOT ( avg(price)
       FOR mnth IN ('Apr','May','Jun')
       )
;



