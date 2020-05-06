/*  PL/SQL Procedures

Lesson Objectives:
How to create a simple PL/SQL Procedure
How to call a PL/SQL Procedure
*/

/* Run the following SQL Developer statement once only in your session 
to allow PL/SQL displayed messages to appear onscreen */

SET SERVEROUTPUT ON

/*  Stored Procedures
The purpose of procedures is to change data using DML statements such as INSERT, UPDATE and DELETE.
This first example simply uses PUT_LINE to display a message to screen.
*/

CREATE OR REPLACE PROCEDURE hello_world AS
BEGIN
  DBMS_OUTPUT.PUT_LINE('Hello World!');
END;
/
SHOW ERROR PROCEDURE hello_world;


/* To execute a procedure in a test environment you can call it directly
	using the EXEC SQL Developer statement */

EXEC hello_world

-- It can also be tested by calling it from an anonymous block, with or without parens.
  

BEGIN
  hello_world();
  hello_world;
END;
/

-- INPUT PARAMETERS
/* Oracle strongly advises that parameters names that start with p_   
This help distinguish parameters from local variables and columns. 
Parameters must have a name, a mode - IN is the default mode, and a datatype with no size*/

--  Here is an example of a procedure that performs a money transfer
CREATE OR REPLACE PROCEDURE transfer 
  (p_from_account IN accounts.accountno%TYPE,  	-- Can use datatype from column in a table
   p_to_account IN NUMBER,						-- Do not provide a size.
   p_transfer_amount NUMBER)	               	-- IN is the deafault mode
   
IS

BEGIN
  UPDATE accounts
   SET balance = balance - p_transfer_amount
  WHERE accountno = p_from_account;
  
  UPDATE accounts
    SET balance = balance + p_transfer_amount
  WHERE accountno = p_to_account;
  
  COMMIT;
END transfer;
/
show errors PROCEDURE transfer;   

SELECT * 
	FROM accounts;

EXEC transfer(2,1,25)

/* -- Substitution Variables
When you use Substitution variables, Oracle will prompt for an input value.
Oracle will use the value provided and execute
*/
SELECT  first_name, last_name
  FROM consultant
  
  WHERE consultant_id = &id;

exec transfer(&from_account,&to_account,&amount_to_transfer);


/*
A procedure to insert a new broker.
We could use a sequence to generate ID numbers.  
*/

CREATE OR REPLACE PROCEDURE insert_broker (
  p_first_name IN broker.first_name%type,
  p_last_name IN VARCHAR2)
IS
  -- Declare local variables
  v_broker_id NUMBER(6) ;
  
BEGIN
  SELECT MAX(broker_id)
  INTO v_broker_id
  FROM broker;
  
  -- Example of IF statement
  IF v_broker_id IS NULL THEN
     v_broker_id := 1;
  ELSE
     v_broker_id := v_broker_id + 1;
  END IF;
  
  INSERT INTO broker (broker_id, first_name, last_name)
    VALUES (v_broker_id, p_first_name, p_last_name);
  
  COMMIT;
END insert_broker;
/

show errors procedure insert_broker; 


SELECT * 
	FROM broker;

-- To call the procedure
EXEC insert_broker('Joe','Duff');

EXEC insert_broker('Jane','Duff');

-- Substitution Variables - Use quotes for character and date data
EXEC insert_broker('&first_name','&last_name');


-- Check on the new brokers
SELECT broker_id, first_name, last_name
  FROM broker;


/* In Class exercise:   Rewrite the INSERT_BROKER procedure to use
a sequence rather than SELECT MAX(broker_id) INTO a variable.

Create an appropriate sequesnce for the broker_id column, and test your procedure */ 





