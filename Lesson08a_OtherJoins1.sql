/* 
 Objectives:

 -More Complex ON

 -LEFT RIGHT FULL OUTER JOIN

 -SELF JOIN

*/

/******** More Complex ON   **********
Usually a JOIN will be between a single foreign key column 
and single primary key column but sometimes it can be 
more complex.
*/

-- First let's check the trade table.
-- There is only one record for each trade_id
SELECT 
   trade_id, 
   stock_id,
   shares
FROM trade
ORDER BY trade_id;

-- Goal:  List trades, stock_ids and the price per share that was used 
--        for the trade.
-- There is a problem with the following query.
-- Each trade_id coming out multiple times.
SELECT 
  t.trade_id,
  t.stock_id,
  sp.price     AS price_per_share
FROM trade t
  JOIN stock_price sp
   ON sp.stock_id = t.stock_id
ORDER BY t.trade_id, t.stock_id;

-- There are different prices for stocks on different days so
-- we need to specify both the stock_id AND the day of the trade.
-- But the following query is STILL not good enough.
SELECT 
  t.trade_id,
  t.stock_id,
  sp.price     AS price_per_share
FROM trade t
  JOIN stock_price sp
   ON sp.stock_id = t.stock_id
   AND trunc(sp.time_start,'dd') = trunc(t.transaction_time,'dd')
ORDER BY t.trade_id, t.stock_id;

/*
In the previous query a few trades appear more than once.  This is
because some stocks are traded on more than one exchange.  To look up the price 
for a trade we need the stock_id AND the stock_ex_id AND the day of the trade.
*/
SELECT 
  t.trade_id,
  t.stock_id,
  sp.price    AS price_per_share
FROM trade t
  JOIN stock_price sp
   ON sp.stock_ex_id = t.stock_ex_id
   AND sp.stock_id = t.stock_id
   AND trunc(sp.time_start,'dd') = trunc(t.transaction_time,'dd')
ORDER BY t.trade_id, t.stock_id;


/*
Show Trade_id, stock_id, number of shares traded,
the price per share, the price_total,
and the amount of the broker fee
*/
SELECT 
  t.trade_id,
  t.stock_id,
  t.shares,
  sp.price    AS price_per_share,
  t.price_total,
  t.price_total - (t.shares * sp.price) AS brokers_fee
FROM trade t
  JOIN stock_price sp
   ON sp.stock_ex_id = t.stock_ex_id
   AND sp.stock_id = t.stock_id
   AND trunc(sp.time_start,'dd') = trunc(t.transaction_time,'dd')
ORDER BY t.trade_id, t.stock_id;
  

/*******   OUTER JOIN   ***************
The joins we have seen so far have all been INNER joins.  
INNER JOIN is the default. 
For an INNER join rows are returned only if matching rows exist in both tables.
*/
-- Show all matches between the consultant table and the assigment table.
-- See INNER JOIN VISUALIZATION in Lesson08b_otherJoinVisuals.pptx
SELECT
   c.consultant_id,
   c.first_name,
   c.last_name,
   a.consultant_id,
   a.assignment_id
FROM consultant c  
   INNER JOIN assignment A
      ON c.consultant_id = a.consultant_id
ORDER BY c.last_name, c.first_name, A.assignment_id;

/*
Consider the following join statement:
   consultant c  JOIN  assignment A ON ...
The consultant table is considered to be the "left" table simply because it
is mentioned to the left of the word JOIN.  The assignment table is considered 
to be the "right" table because it is mentioned to the right of the word JOIN.
There are three types of outer joins:  LEFT, RIGHT and FULL.
In an INNER JOIN, rows are returned only where there is a match between the 
left and right tables.
In a LEFT OUTER JOIN all rows from the left table are returned (as well as
any matches that can be found in the right table).
In a RIGHT OUTER JOIN all rows from the right table are returned (as well as
any matches that can be found in the left table).
In a FULL OUTER JOIN all rows from both tables are returned and where a match
can be found between the tables, the rows are joined.
*/

-- LEFT JOIN - Include the consultants who have not done any assignments
-- See LEFT OUTER JOIN VISUALIZATION in Lesson08b_otherJoinVisuals.pptx
SELECT
   c.consultant_id,
   c.first_name,
   c.last_name,
   a.consultant_id,
   A.assignment_id
FROM consultant c LEFT OUTER JOIN assignment a
      ON c.consultant_id = a.consultant_id
ORDER BY c.last_name, c.first_name, a.assignment_id;

/*
RIGHT JOIN - Include the assignments that do not have a consultant
assigned yet
-- See RIGHT OUTER JOIN VISUALIZATION in Lesson08b_otherJoinVisuals.pptx
*/
SELECT
   c.consultant_id,
   c.first_name,
   c.last_name,
   a.consultant_id,
   a.assignment_id
FROM consultant c  
   RIGHT OUTER JOIN assignment a
      ON c.consultant_id = a.consultant_id
ORDER BY c.last_name, c.first_name, a.assignment_id;


/*
FULL OUTER JOIN - Include the inner join, the extra rows that you get for the
left join, and the extra rows that you get for the right join.

If you don't include an ORDER BY when using a FULL OUTER JOIN then
typically the rows will come out in groups of "inner" rows, then either
the "right outer" rows or "left outer" rows then the remaining group of rows
But the only true way to ensure ordering of rows is to use an ORDER BY.
*/
-- See FULL OUTER JOIN VISUALIZATION in Lesson08b_otherJoinVisuals.pptx
SELECT
   c.consultant_id,
   c.first_name,
   c.last_name,
   a.consultant_id,
   a.assignment_id
FROM consultant c  
   FULL OUTER JOIN assignment a
      ON c.consultant_id = a.consultant_id;

/*
When joining more that two tables involving outer joins, you need 
to be very careful and test to make sure you are getting the 
result you want.
In the following query, consultant and assignment are joined first.
When client is joined the the rows which have no client_ids are
eliminated by the inner join.
*/
SELECT
   c.consultant_id,
   c.first_name,
   c.last_name,
   a.consultant_id,
   a.assignment_id,
   cl.client_name
FROM consultant c  
   LEFT OUTER JOIN assignment A
      ON c.consultant_id = A.consultant_id
   INNER JOIN client cl
      ON cl.client_id = a.client_id
ORDER BY c.last_name, c.first_name, a.assignment_id;

-- Solution 1 - double LEFT JOIN
SELECT
   c.consultant_id,
   c.first_name,
   c.last_name,
   a.consultant_id,
   a.assignment_id,
   cl.client_name
FROM consultant c  
   LEFT OUTER JOIN assignment a
      ON c.consultant_id = a.consultant_id
   LEFT OUTER JOIN client cl
      ON cl.client_id = a.client_id
ORDER BY c.last_name, c.first_name, a.assignment_id;

-- Solution 2 - Join the consultant table last using a RIGHT OUTER
SELECT
   c.consultant_id,
   c.first_name,
   c.last_name,
   a.consultant_id,
   a.assignment_id,
   cl.client_name
FROM assignment a
   JOIN client cl
      ON cl.client_id = a.client_id
   RIGHT OUTER JOIN consultant c  
      ON c.consultant_id = a.consultant_id
ORDER BY c.last_name, c.first_name, a.assignment_id;


-- Solution 3 - Join the consultant table last by specifying the ON last.
SELECT
   c.consultant_id,
   c.first_name,
   c.last_name,
   a.consultant_id,
   a.assignment_id,
   cl.client_name
FROM consultant c  
   LEFT OUTER JOIN assignment a
       INNER JOIN client cl
           ON cl.client_id = a.client_id
   ON c.consultant_id = a.consultant_id
ORDER BY c.last_name, c.first_name, A.assignment_id;




/****   Self-Join *******
In the consultants table, there is a column for boss_id: each consultant
reports to a boss.  But the boss is, himself or herself, a consultant.  
Therefore, to list the consultant's name, and the boss' name, you need to 
join the table to itself.
Think of it this way: you retrieve the consultant's information from the 
"consultant's table" and retrieve the boss's information from the "boss's table" 
(but the boss's table is really just the consultants table after all.)
*/
-- (Query 1)
-- Show the consultant's information and info about his or her boss.
SELECT
  c.consultant_id,
  c.first_name || ' ' || c.last_name AS consultant,
  c.boss_id AS "My Boss ID", 
  b.consultant_id AS "Boss ID",
  b.first_name || ' ' || b.last_name AS boss
FROM consultant c
  JOIN consultant b
    ON b.consultant_id = c.boss_id;

-- Query 1 will not return a consultant unless that consultant has a boss.
-- SELF Join 1 - Revised
-- This query will return all employees (even those who don't have a boss).
SELECT
  c.consultant_id,
  c.first_name || ' ' || c.last_name AS consultant,
  c.boss_id AS "My Boss ID", 
  b.consultant_id AS "Boss ID",
  nvl(b.first_name,'n/a') || ' ' || nvl(b.last_name,'n/a') AS boss
FROM consultant c
  LEFT JOIN consultant b
    ON b.consultant_id = c.boss_id;


-- We can also list the information from the
-- boss' perpective.  
-- (Query 2)
-- Show the boss's information and then information about the people
-- he or she supervises.
SELECT 
  b.consultant_id   AS "My ID",
  b.first_name || ' ' || b.last_name AS boss,
  c.consultant_id   AS "My Direct Report's ID",
  c.first_name || ' ' || c.last_name AS consultant,
  c.boss_id         AS "Consultant's Boss ID"
FROM consultant b
  JOIN consultant c
    ON b.consultant_id = c.boss_id
ORDER BY boss, consultant;

-- SELF Join 2 - Revised 
-- This query will return all employees (even those who don't have anyone reporting to them).
SELECT 
  b.consultant_id   AS "My ID",
  b.first_name || ' ' || b.last_name AS boss,
  c.consultant_id   AS "My Direct Report's ID",
  c.first_name || ' ' || c.last_name AS consultant,
  c.boss_id         AS "Consultant's Boss ID"
FROM consultant b
  LEFT OUTER JOIN consultant c
    ON b.consultant_id = c.boss_id
ORDER BY boss, consultant;










