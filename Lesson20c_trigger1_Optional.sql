/* PL/SQL Triggers

Lesson Objectives:

Using triggers to enforce rules:
   Comparison of triggers vs. check constraints
Triggers:
  BEFORE INSERT, UPDATE, DELETE
  FOR EACH ROW
*/


/*  
A Check Constraint can enforce only very simple rules.
Triggers can be used to enforce more elaborate rules
*/

-- Check Constraint to ensure that trades are made only during trading hours.
-- Trading hours are 4:00am to 6:00pm M - F

ALTER TABLE trade
 ADD CONSTRAINT time_chk
   CHECK ( to_char(transaction_time,'HH24:MI') BETWEEN '04:00' AND '18:00'
       AND to_char(transaction_time, 'DY') NOT IN ('SAT','SUN'));

-- It is not possible to add a constraint if there is already data
-- in the table which violates the constraint
DELETE FROM trade
WHERE   ( to_char(transaction_time,'HH24:MI') NOT BETWEEN '04:00' AND '18:00'
       OR to_char(transaction_time, 'DY') IN ('SAT','SUN'));
COMMIT;

-- Try the constraint again.
ALTER TABLE trade
 ADD CONSTRAINT time_chk
   CHECK ( to_char(transaction_time,'HH24:MI') BETWEEN '04:00' AND '18:00'
       AND to_char(transaction_time, 'DY') NOT IN ('SAT','SUN'));

-- It is not possible to insert a value that violates the constraint
INSERT INTO trade 
  (trade_id, 
   stock_id, 
   broker_id, 
   stock_ex_id, 
   transaction_time, 
   shares, 
   price_total)
VALUES (60, 1,1,3,to_date('06-24-2011 06:01PM','MM-DD-YYYY HH:MIAM'), 1000,1000000);

-- Let drop the constraint and then try the insert above again.
ALTER TABLE trade
  DROP CONSTRAINT time_chk;


/*    TRIGGERS    */

-- Enforcing a Rule
--=========== Example ================
--  Before a trade can be recorded at a stock_exchange, 
--  there must be an active price in stock_price table
--  for the stock_id
CREATE OR REPLACE TRIGGER trade_active_price 
BEFORE INSERT OR UPDATE OF stock_id, stock_ex_id, transaction_time ON trade 
FOR EACH ROW 
 DECLARE  
     record_count INTEGER;
BEGIN 
     SELECT COUNT(*) INTO record_count 
     FROM stock_price
     WHERE stock_id = :new.stock_id
       AND stock_ex_id = :new.stock_ex_id
       AND time_start <= :new.transaction_time;
               
      IF record_count = 0 THEN 
          RAISE_APPLICATION_ERROR(-20000, 'no active price for transaction time'); 
      END IF; 
END; 
/

SHOW ERROR TRIGGER trade_active_price;

-- Test the trigger by inserting a transaction before any price in effect
SELECT MIN(time_start) FROM stock_price;

-- This insert should fail if the trigger is in place
INSERT INTO trade
  (trade_id, stock_id, broker_id, stock_ex_id, transaction_time, shares, price_total)
VALUES
 ( 1000, 1, 1, 3, to_date('01-01-2009','mm-dd-yyyy'), 100, 100000);
 
-- Let's drop the trigger then try the insert above again
DROP TRIGGER trade_active_price;
 
 
 
 
 
 
 
 
