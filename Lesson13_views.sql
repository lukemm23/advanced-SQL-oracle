/*
Primary Objectives:
Creating views
Selecting from views


Optional Objectives:
Inserting 
WITH CHECK OPTION
*/

/* What is a view?

A view is an object on the database that users can query just 
like a table.  But a view is actually a "virtual table'.  It 
is a query that has been give a name and stored in the database.


A view is a gift that you give your users to make their lives
easier.
*/

/*
This view performs a number of joins.  A view like this might be useful to
people who don't know as much SQL as you now know.*/
CREATE OR REPLACE VIEW myview 
AS
SELECT 
   t.trade_id,
   b.first_name || ' ' || b.last_name broker_name,
   co.name company_name,
   co.place_id company_place_id,
   se.name stockex_name,
   cu.name currency_name,
   t.shares
FROM trade t
  JOIN broker b
    ON b.broker_id = t.broker_id
  JOIN stock_exchange se
    ON se.stock_ex_id = t.stock_ex_id
  JOIN currency cu
    ON cu.currency_id = se.currency_id
  JOIN company co
    ON co.stock_id = t.stock_id
    ;
      
-- You can use a view just like a table
SELECT 
  broker_name,
  company_name,
  stockex_name,
  currency_name,
  shares
FROM myview
WHERE broker_name = 'John Smith'
;


/*  In our stock market schema, currency conversion is actually a view 
based on a table called conversion_rate.  
*/
CREATE or REPLACE VIEW conversion
AS 
   SELECT
     from_currency_id,
     to_currency_id,
     exchange_rate
   FROM conversion_rate
   UNION
   SELECT
    to_currency_id,
    from_currency_id,
    1/exchange_rate
   FROM conversion_rate;

/* The conversion_rate table holds data for one direction
of conversion only. It has the exchange rate to convert from
currency 1 to currency 2 but not to convert from currency 2 to currency
1.*/
SELECT 
  from_currency_id,
  to_currency_id,
  exchange_rate
FROM conversion_rate
;

/* The conversion view has exchange rates for both directions */
SELECT 
  from_currency_id,
  to_currency_id,
  exchange_rate
FROM conversion;

/*  A view can be used in a query just like a table.  If you know
how to join tables, then you can join a view. */

-- Return all prices in British Pounds
SELECT
  stock_id, 
  time_start, 
  from_cur.symbol || to_char(price) AS "Original Currency",
  price * con.exchange_rate AS "Price in Pounds"
FROM stock_price sp
  JOIN stock_exchange se
    ON se.stock_ex_id = sp.stock_ex_id
  JOIN conversion con                      -- this is a view
    ON con.from_currency_id = se.currency_id
  JOIN currency from_cur
    ON from_cur.currency_id = se.currency_id
WHERE con.to_currency_id = 
    (SELECT currency_id 
     FROM currency c
     WHERE c.NAME = 'British Pound')
;


------  Optional Extra Information -------

/* INSERTING, UPDATING, and DELETING through views.
It is actually possible to make inserts, updates and deletes on a view.  
The inserted and/or updated data goes into a base table.
*/

-- Consultant Schema:  above average assignments
CREATE OR REPLACE VIEW
	better_assignment
AS
	SELECT
    assignment_id,
    client_id,
    consultant_id,
    start_date,
    end_date,
    pay,
    comments
	FROM
			assignment A
  WHERE A.pay > (SELECT avg(pay) FROM assignment)
;

-- Insert a record through the view.
INSERT INTO better_assignment (assignment_id, client_id, pay)
VALUES (25, 4,625);

-- The added row shows up in the base table
SELECT 
    assignment_id,
    client_id,
    consultant_id,
    start_date,
    end_date,
    pay,
    comments
FROM assignment;

-- Insert into the base table, a value that will appear in the view
INSERT INTO assignment (assignment_id, client_id, pay)
VALUES (26, 4,675);

-- The row inserted into the base table will appear in the view
SELECT 
    assignment_id,
    client_id,
    consultant_id,
    start_date,
    end_date,
    pay,
    comments
FROM better_assignment;

-- UPDATE through a View  
UPDATE better_assignment
  SET pay = 650
WHERE assignment_id = 26;

-- The data is changed in the base table
SELECT 
    assignment_id,
    client_id,
    consultant_id,
    start_date,
    end_date,
    pay,
    comments
FROM assignment;
   
ROLLBACK;

/* --  WITH CHECK OPTION -----
Sometimes a view will restrict what rows can be seen from the base
table.  When inserting or updating through a view, it might be possible 
to insert a row that would not appear when read back from the view.
The "WITH CHECK OPTION" performs a check so that any data inserted 
through a view or updated through a view will be visible when read 
back through the view.  
*/
CREATE OR REPLACE VIEW
	better_assignment
AS
	SELECT
    assignment_id,
    client_id,
    consultant_id,
    start_date,
    end_date,
    pay,
    comments
	FROM
			assignment A
  WHERE A.pay > (SELECT avg(pay) FROM assignment)
WITH CHECK OPTION
;

-- Attempt to insert a record through the view.
-- If the insert succeeds, the assignment will not appear in the view
-- This will cause a WHERE CLAUSE violation
INSERT INTO better_assignment (assignment_id, client_id, pay)
VALUES (30, 4, 200);

-- Insert into the base table, a value that will appear in the view
INSERT INTO better_assignment (assignment_id, client_id, pay)
VALUES (30, 4, 600);

-- Attempt to update.  
-- If the update succeeds, the assignment would no longer appear in the view
-- Therefore the update fails because of the WITH CHECK OPTION
UPDATE better_assignment
  SET pay = 200
WHERE assignment_id = 30;
   
ROLLBACK;
