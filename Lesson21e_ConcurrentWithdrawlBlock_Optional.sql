
/*  A husband and wife are both trying to get 
$100 from their bank account at the same time.
*/
DROP TABLE accounts;

CREATE TABLE accounts
(accountno NUMBER(2) PRIMARY KEY,
balance  NUMBER(6,2)
);

INSERT INTO accounts VALUES(1,100);
commit;

set serveroutput on;

DECLARE
    acc    NUMBER(2);
    bal    accounts.balance%type;
    withdrawal  accounts.balance%type;
    
BEGIN
   acc    := 1;
   withdrawal := 100;
   
   SELECT balance INTO bal
   FROM accounts
   WHERE accountno = acc
 --  FOR UPDATE
   ;
   
 --  DBMS_LOCK.SLEEP(15);
   
   IF bal >= withdrawal THEN
       UPDATE accounts
           SET balance = balance - withdrawal
      WHERE accountno = acc;
      COMMIT;
      dbms_output.put_line('Withdrawal successful');
   ELSE
       dbms_output.put_line('Insufficient funds');
       ROLLBACK;
   END IF;
END;
/

-- SELECT * FROM accounts;



