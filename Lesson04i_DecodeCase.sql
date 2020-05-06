/*
Objectives:

CASE expression creates a case structure. There are two forms of CASE.
DECODE is an Oracle function that creates a case structure with less syntax.

*/

/******* CASE EXPRESSION  **********/
-- Place the input between the word CASE and the first WHEN.
-- When 'Bill' means when first_name = 'Bill'.
SELECT 
  first_name,
  CASE first_name
     WHEN 'Bill' THEN 'Hello Bill'
     WHEN 'Alan' THEN 'Hi Alan'
     WHEN 'Kareem' THEN 'Hello K'
     ELSE 'Who are you?'
  END   AS greeting     -- else is always optional
from consultant;

-- Following is a searched case expression.
-- There is no input between the word CASE and the first WHEN.
-- It must be used when the comparison operator is not an = sign.

SELECT 
  consultant_id,
  client_id,
  pay,
  CASE 
     WHEN pay > 650 THEN 'High'
     WHEN pay >= 400 THEN 'Medium'
     ELSE 'Low'
  END as "Rate"
FROM assignment
ORDER BY pay;


-- Case Expression used in an Update statement
UPDATE  consultant
 SET FIRST_NAME =  
         CASE UPPER(first_name)
            WHEN 'BILL' THEN 'William'
            WHEN 'ALAN' THEN 'Al'
            WHEN 'SIMON' THEN 'Scott'
         ELSE first_name
        END,
        last_name = 'Ramirez'
WHERE first_name IN ('Bill','Alan','Simon');

SELECT 
  consultant_id,
  first_name,
  last_name
FROM consultant;

ROLLBACK;


/* DECODE function is a shorthand for the Case Expression. It relies
    heavily on commas. Its format is:
    decode(var,
          if1,then1,
          if2,then2,
          if3,then3,
          else something)     --else is always optional */

SELECT
  first_name         AS decode_input,
  DECODE(first_name,   
       'Bill','Hello Bill',
       'Alan','Hi Alan',
       'Kareem','Hello K',
       'Who are you?') AS decode_output
from consultant;

-- Decode can take numbers and return text
-- Run this statment to see the output in table format:
SELECT 
   consultant_id    AS "numeric decode Input",
   DECODE(consultant_id, 
            1, 'a', 
            2,'b',
            consultant_id) AS "text decode output"
FROM consultant;


