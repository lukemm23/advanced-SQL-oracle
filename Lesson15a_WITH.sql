/*  WITH Clause

Also known as a "common table expression".  
Essentially, any subquery could be rewritten as a WITH

A Common table expression is like a temporary view that can be
used in one or more places of a query.
*/

-- The following will be rewritten using WITH.

-- Show brokers and the number of trades they have done but only
-- if they have done more than the average number of trades.
SELECT
   b.First_Name,
   b.Last_Name,
   count(trade_id)
FROM broker b
   JOIN trade t
      ON t.broker_id = b.broker_id
GROUP BY b.First_Name, b.Last_Name
HAVING Count(trade_id) > 
     (SELECT 
        avg(numtrades)
     FROM
       (SELECT
           b.broker_id,
           count(trade_id) numtrades
       FROM broker b
         JOIN trade t
         ON t.broker_id = b.broker_id
       GROUP BY b.broker_id))
ORDER BY count(trade_id) DESC
    ;
    
    
    
-- Common Table Expression 
-- WITH Clause
WITH brokerCount  AS
    (SELECT b.broker_id,
           b.first_name,
           b.last_name,
           count(trade_id) AS numtrades
       FROM broker b
         join trade t  
             on b.broker_id = t.broker_id
       GROUP BY b.broker_id, b.first_name, b.last_name)
SELECT
   bc.first_name,
   bc.last_name,
   bc.numtrades
FROM brokerCount bc
WHERE bc.numtrades >
    (SELECT avg(numtrades)
     FROM brokerCount);

     
-- A Couple of Trivial Examples.     

-- Simply a subquery     
SELECT
* 
FROM place p
WHERE EXISTS (SELECT * FROM company c
              WHERE c.place_id = p.place_id);              
            
-- The WITH can appear within the subquery            
SELECT 
* 
FROM place p
WHERE EXISTS 
  (WITH co AS
    (SELECT * FROM company)
  SELECT * 
  FROM co
  WHERE co.place_id = p.place_id
  ); 


WITH co AS
    (SELECT * FROM company)
SELECT 
* 
FROM place p
WHERE EXISTS (
            SELECT * FROM co
            WHERE co.place_id = p.place_id); 



-- The WITH can also define multiple common table expressions.             
WITH pl AS
    (SELECT * FROM place p),
   co AS
    (SELECT * FROM company)
SELECT * FROM pl
WHERE EXISTS (SELECT * FROM co
     WHERE co.place_id = pl.place_id);
          
          
              
          
          
          