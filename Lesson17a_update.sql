/*
Lesson Objectives:
Basic UPDATE
UPDATE with correlated subquery

COMMIT and ROLLBACK - Atomic Transactions
DELETE
TRUNCATE

*/

/*
-- BASIC UPDATE
UPDATE table
  SET col1 = ...,
      col2 = ...,
      col3 = ...
WHERE <filter condition>
;
*/

-- Example Situation:  Euro takes over the world!
--  (unlikely but concrete)

-- Update the LSE to use Euro

-- Step 1:  Check the currency ids for Euro
SELECT 
  currency_id,
  symbol,
  name
FROM currency;

-- Step 2:  Check the stock_exchange information
SELECT 
   stock_ex_id,
   NAME,
   symbol,
   place_id,
   currency_id
FROM stock_exchange;

/* This will update the London Stock Exchange to use
Euro but requires us to lookup currency codes and the 
stock exchange ID. */
UPDATE stock_exchange se
  SET se.currency_id = 2
WHERE se.stock_ex_id = 1;

-- Check that the change occurred
SELECT 
   stock_ex_id,
   NAME,
   symbol,
   place_id,
   currency_id
FROM stock_exchange;

ROLLBACK;

-- Check that the change was rolled back
SELECT 
   stock_ex_id,
   NAME,
   symbol,
   place_id,
   currency_id
FROM stock_exchange;


/* The following statement will update the London Stock Exchange 
to use Euro but performs the currency code and the stock exchange 
lookup for us. */
UPDATE stock_exchange se
  SET se.currency_id = (SELECT currency_id 
                        FROM currency
                        WHERE currency.NAME = 'Euro')
WHERE se.NAME = 'London Stock Exchange';

-- Check that the change occurred
SELECT 
   stock_ex_id,
   NAME,
   symbol,
   place_id,
   currency_id
FROM stock_exchange;

ROLLBACK;
  

-- Update all the stock_exchanges in the USA to use Euro
UPDATE stock_exchange se
  SET se.currency_id = (SELECT currency_id FROM currency 
                       WHERE currency.name = 'Euro')
WHERE se.place_id IN (SELECT place_id FROM place
                      WHERE country = 'USA');
                      
-- Check that the change occurred
SELECT 
   stock_ex_id,
   NAME,
   symbol,
   place_id,
   currency_id
FROM stock_exchange;

ROLLBACK;


-- Another Example
/*  
In this scenario, banking transactions are made throughout the day
and after hours the account balances are updated
*/

-- These statements are included for trainers to reset their accounts  
DROP TABLE deposits;
DROP TABLE accounts;

CREATE TABLE accounts
  (accountno number(4) CONSTRAINT accounts_pk PRIMARY KEY,
   balance   number(6,2));

    
CREATE TABLE deposits
  (accountno  NUMBER(4) CONSTRAINT dep_acc_fk REFERENCES accounts(accountno),
   deposit    NUMBER (6,2),
   processed  CHAR(1) 
       DEFAULT 'F' 
       CONSTRAINT processed_chk CHECK (processed IN ('T','F'))
  );
     
    
-- setup three accounts     
INSERT INTO accounts
  (accountno,
  balance)
  VALUES (1, 0);
INSERT INTO accounts
  (accountno,
  balance)
  VALUES (2, 15);
INSERT INTO accounts
  (accountno,
  balance)
  VALUES (3, 20);
    
SELECT 
   accountno, 
   balance
FROM accounts;
    
-- setup some deposits that occurred during the day    
INSERT INTO deposits
   (accountno,
    deposit)
VALUES (1, 10);
INSERT INTO deposits
  (accountno,
   deposit)
VALUES (1, 15);
INSERT INTO deposits
  (accountno,
   deposit)
VALUES (2, -5);


-- Check values 
SELECT 
  accountno,
  balance
FROM accounts;

SELECT 
  accountno,
  deposit,
  processed  
FROM deposits;

-- Evening Process:  Update the accounts         
/* This example uses the accountno from the accounts table
(which is the table being updated) to find the deposits that were
made and adds the deposits to the balance. */
UPDATE accounts A
   SET balance = balance + (SELECT nvl(sum(deposit),0)
                          FROM deposits d 
                          WHERE d.accountno = A.accountno
                            AND d.processed = 'F');

-- Evening Process: delete the transactions
UPDATE deposits
  SET processed = 'T';
commit;                            

-- Check Balances
SELECT 
  accountno,
  balance
FROM accounts;
                
-- Check deposits
SELECT 
  accountno,
  deposit,
  processed
FROM deposits;
         

/*  DATABASE TRANSACTIONS */
--Transactions are implemented using  COMMIT and ROLLBACK

-- Sometimes a transaction involves a number of steps.
-- ALL of the steps must be completed before the transaction is done
-- Therefore you should not commit until the end.
-- Example:  Money transfer
SELECT 
  accountno,
  balance
FROM accounts;

-- Transfer $10 from account 1 to account 2
-- (This example does both parts of the transaction, then commits.)
UPDATE accounts
   SET balance = balance - 10
WHERE accountno = 1;
UPDATE accounts
   SET balance = balance + 10
WHERE accountno = 2;
COMMIT;



/*  DELETE  */
--A DELETE statement looks like this:
--    DELETE FROM TABLE
--    WHERE ...;


--If you know how to write an UPDATE, you know how to write a DELETE.

--Without a WHERE clause, a DELETE statement will remove every row in the table.

--DELETE must be committed or can be rolled back.

SELECT * FROM deposits;
DELETE FROM deposits;
COMMIT;


-- Check to see if blocks are still allocated.

exec dbms_stats.gather_table_stats('trainee1', 'deposits');


/*  TRUNCATE  TABLE */
/*
The TRUNCATE command removes data from a table in a very fast way

A DELETE without a WHERE will remove every row but any blocks 
that have been allocated to the table will remain allocated to the table.

A TRUNCATE deallocates blocks and resets the "high-water mark".

***  TRUNCATE is considered to be DDL      ***

***  ALL DDL does NOT need to be COMMITTED and CANNOT be rolled back  ***
*/


TRUNCATE TABLE deposits;

-- Check to see if blocks are still allocated.
exec dbms_stats.gather_table_stats('trainee1', 'deposits');




/*  Additional Information */

--  A table cannot be truncated if there are any foreign keys referencing 
-- the table.

SELECT
  accountno,
  balance
FROM accounts;

TRUNCATE TABLE accounts;

ALTER TABLE deposits
DISABLE CONSTRAINT DEP_ACC_FK;

SELECT
  accountno,
  balance
FROM accounts;

exec dbms_stats.gather_table_stats('trainee1', 'accounts');


