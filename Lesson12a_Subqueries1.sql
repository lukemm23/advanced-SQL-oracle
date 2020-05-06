/*
Module Objectives:
Subqueries:  
IN, EXISTS, NOT EXISTS,
=

*/

/* --    QUERY Within a Query
In Oracle terminology, if there is a query within the
WHERE clause (or within the HAVING clause) then it is 
referred to as a SUBQUERY.
*/

-- This query uses a plain IN (IN without a subquery.)
-- The list (1,3) is a set.  IN uses a set.
SELECT 
   company_id,
   NAME,
   place_id
FROM company
WHERE place_id IN (1, 3);

-- This query produces a set as its output.
SELECT place_id FROM place
WHERE country = 'United Kingdom'
      OR country = 'USA';
      
-- IN uses a set.  The output of a query is a set.  
-- IN can use the output of a query.

-- Show all companies in the USA or the UK
SELECT 
   company_id,
   NAME,
   place_id
FROM company
WHERE place_id 
   IN 
    (
    SELECT place_id 
    FROM place
    WHERE country = 'United Kingdom'
      OR country = 'USA'
    );


-- Sometimes queries involving subqueries can be rewritten 
-- to use joins.
-- (Check the Explain Plan to see if the plan is different)
SELECT
   company_id,
   NAME,
   co.place_id
FROM company co
  JOIN place p
    ON p.place_id = co.place_id
WHERE p.country = 'United Kingdom'
      OR country = 'USA'
;


/*
 Subquery using EXISTS
The following query finds places WHERE companies exist at that place
*/
SELECT place.city, place.country
FROM place 
WHERE EXISTS (SELECT co.company_id 
              FROM company co
              WHERE co.place_id = place.place_id
         )
ORDER BY place.city, place.country;

/*
The subquery in the EXISTS is called a "correlated subquery".  That is,
the inner query is correlated with the outer query because information
is passed from the outer query into the inner query.

All subqueries pass information to their outer query.  Only correlated
subqueries have information being passed from the outer query into the 
inner query.
*/


/* The following query does not have a correlated subquery but performs the 
same jobs as the preceding query.
Check the Explain Plan to see whether the plan is different
*/
SELECT  DISTINCT
 p.city, p.country
FROM place p
  JOIN company co
     ON co.place_id = p.place_id
ORDER BY p.city, p.country; 

  
-- The following query finds places WHERE THERE ARE NO companies at that place.              
SELECT 
  city,
  country
FROM place
WHERE NOT EXISTS (SELECT co.company_id FROM company co
              WHERE co.place_id = place.place_id);
                     

-- This also finds the places where there are no companies.              
SELECT
p.place_id,
p.city,
p.country
FROM place p
  LEFT OUTER JOIN company c
  ON c.place_id = p.place_id  
WHERE c.place_id IS NULL
;




-- Finding the one with maximal value.
SELECT
  MAX(shares)
FROM trade
;

-- Find ALL the trade information for
-- the largest trade.
-- This query cannot be rewritten to avoid a subquery.
SELECT 
  trade_id,
  stock_id,
  transaction_time,
  shares,
  stock_ex_id,
  price_total  
FROM trade
WHERE shares =
  (SELECT 
     MAX(shares)
   FROM trade
  )
;

-- Find the trades that are larger than average
-- Again this query cannot be rewritten to avoid a subquery.
SELECT 
  trade_id,
  stock_id,
  transaction_time,
  shares,
  stock_ex_id,
  price_total  
FROM trade
WHERE shares >
  (SELECT 
     AVG(shares)
   FROM trade
  )
;


-- In class exercise
-- You can find the highest amount any of our consultants was paid
-- the following
SELECT MAX(pay)
FROM assignment;

-- But try to find the SECOND highest amount (and only that number)
-- (This is just a little test of SQL programming prowess.)










-- big hint
SELECT pay
FROM assignment
WHERE pay < (SELECT MAX(pay) 
              FROM assignment);





-- Final Solution
SELECT MAX(pay)
FROM assignment
WHERE pay < (SELECT MAX(pay) 
              FROM assignment);

-- Get the third highest pay
SELECT MAX(pay)
FROM assignment
WHERE pay < (SELECT MAX(pay) 
             FROM assignment
             WHERE pay < (SELECT MAX(pay)
                          FROM assignment))
;
/* this is a little silly, isn't it? 
In the next lesson, we will learn another way to find the "nth" entry in a list
*/

  
/* Goal:  Show the information about the trade where each
broker has his or her best trade (in terms of most shares traded).
*/
-- Step 1:  Get each brokers personal best trade */
SELECT 
   broker_id,
   MAX(shares)
FROM trade
GROUP BY broker_id
;

-- Use the query from Step 1 to find the trade information
-- where each broker traded the most shares
SELECT 
  b.first_name || ' ' || b.last_name as broker, 
  t.transaction_time,
  t.stock_id,
  t.shares,
  t.price_total
FROM trade t
  JOIN broker b
    ON b.broker_id = t.broker_id
WHERE shares =
  (SELECT 
       MAX(t_sub.shares)
   FROM trade t_sub   
   WHERE t_sub.broker_id = t.broker_id
  )
ORDER BY price_total DESC;

/* It is important to distinguish between the tables in the main
query from the tables in the query by using different table aliases.  
In this instance, t_sub was used as the for the trade table in the 
subquery. */
