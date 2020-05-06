/* Lesson Objectives
SEQUENCE database object
*/

-- A "sequence" is a database object which generates numbers in a 
-- sequence.
-- We are going to create a sequence to generate broker_id numbers
DESC broker;

--  STEP ONE - Find the current maximum ID number
SELECT MAX(broker_id)
FROM broker;


--  STEP TWO - Create the sequence object 
--  (but start at the next number after the number from step one.)
DROP SEQUENCE broker_id_seq;

CREATE SEQUENCE broker_id_seq
   INCREMENT BY 1
   START WITH 17
;
   
-- STEP THREE - Use the sequence to generate IDs for insert statements.
INSERT INTO broker (
	broker_id,
	first_name,
	last_name
) VALUES (
	broker_id_seq.NEXTVAL,
	'Andrew',
	'Wiltshire'
)
;

INSERT INTO broker (
	broker_id,
	first_name,
	last_name
) VALUES (
	broker_id_seq.NEXTVAL,
	'Bruce',
	'Beckensale'
)
;
commit;

SELECT 
  broker_id,
  first_name,
  last_name
FROM broker
ORDER BY broker_id;

-- You can select the CURRVAL from dual to see what the current
-- value is.
SELECT 
   broker_id_seq.CURRVAL
FROM dual;

--  You can select the NEXTVAL from dual but you will lose that ID
SELECT 
   broker_id_seq.NEXTVAL
FROM dual;


-- To insert multiple rows, you could do something like this
-- Add all the consultant records to the broker table
INSERT INTO broker (broker_id, first_name, last_name)
SELECT 
   broker_id_seq.nextval, 
   first_name,
   last_name
FROM consultant;
COMMIT;

SELECT 
   broker_id,
   first_name,
   last_name
FROM broker
ORDER BY broker_id;



-- This will work.  You can alter the increment size.
-- Oracle allows whatever increment size you want.
ALTER SEQUENCE broker_id_seq
  INCREMENT BY 10;


-- This will fail.  You can't alter the starting point.
-- You would have to drop and re-create the sequence.
ALTER SEQUENCE broker_id_seq
  START WITH 90;


-- Automated 
/* Many trainees have asked whether a CREATE SEQUENCE statement could use a 
subquery to determine the starting value instead of hardcoding the starting 
value.  Unfortunately, a subquery cannot be used.
Oracle demands that you use hardcoded numbers.
*/

--  Optional Extra Information

-- MAX VALUE
DROP SEQUENCE broker_id_seq;
CREATE SEQUENCE broker_id_seq
  INCREMENT BY 1
  START WITH 1
  MAXVALUE 5;

SELECT broker_id_seq.NEXTVAL
FROM dual;



