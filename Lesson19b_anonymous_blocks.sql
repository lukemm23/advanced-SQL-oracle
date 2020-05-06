/*  PL/SQL Anonymous Block 

[DECLARE]  -- declare local variables (optional)
BEGIN

END;
/

*/

-- SETUP accounts for a Money Transfer
DROP TABLE accounts CASCADE CONSTRAINTS;

CREATE TABLE accounts
  (accountno number(4) PRIMARY KEY,
   balance   number(6,2));

INSERT INTO accounts VALUES (1, 100);
INSERT INTO accounts VALUES (2, 0);
COMMIT;

SELECT accountno, balance
  FROM accounts;


-- PL/SQL Anonymous Block - Money Transfer

/*  Oracle recommends the v_ prefix for variables.  
	A meaningful and consistent naming convention should be used when writing code.
	This helps distinguish variables from column names.
*/


DECLARE
  v_transfer_amount NUMBER(6,2) := 50;   -- := is the PL/SQL assignment operator
  
BEGIN
 
  UPDATE accounts
    SET balance = balance - v_transfer_amount    
    WHERE accountno = 1;      
                            
  UPDATE accounts
    SET balance = balance + v_transfer_amount
    WHERE accountno = 2;

  COMMIT;
END;
/

-- Check on the transfer
SELECT accountno, balance
  FROM accounts;




