/*  PL/SQL Functions

Lesson Objectives:
Create Functions
Call Functions

*/

/*
  Functions should not perform inserts, updates and deletes.  Functions take input 
  parameters, can look up values in tables, perform calculations and return one
  value.
*/

/* The following example is intended to show the syntax to create a
function.  The function looks up a value in a table, performs
some manipulations and returns ONE value. */

-- Return a street name without the "Avenue", "Street" or "Road" etc.

CREATE OR REPLACE FUNCTION get_street_name (
  p_address_id IN address.address_id%type) RETURN address.street%type
IS
  -- Declare local variables
  v_street address.street%type;
BEGIN
  SELECT street
    INTO v_street		--Must select into a variable in PL/SQL
    FROM address
    WHERE address_id = p_address_id;
  
  v_street := SUBSTR(v_street, 1, INSTR(v_street,' ')-1);
  RETURN v_street;  
END get_street_name;
/

show errors function get_street_name; 

-- To call the function from SQL statements:
SELECT get_street_name(2)
  FROM dual;


SELECT   consultant_id,  first_name,  last_name,  get_street_name(address_id) as street
  FROM consultant;
