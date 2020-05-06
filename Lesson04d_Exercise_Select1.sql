/*
Explore the WHERE clause.
Look through the examples in Lesson04e_WHERE.sql and attempt the following.
Objectives:  
=, >, < etc.  
“BETWEEN x AND y”, “NOT BETWEEN x AND y”
IN, NOT IN
Logical: AND, OR, and NOT
*/

/* 
1.	Show the first name, last name and birth date for the consultant 
with a consultant_id of 5.
*/
SELECT 
    first_name,
    last_name,
    birthdate
FROM 
    consultant
WHERE consultant_id = 5;


/* 2.	WHERE also works with >, <, >=, <=, <>, and !=.   
Show all consultants WHERE consultant_id > 5.
*/

SELECT * FROM consultant
WHERE consultant_id > 5;


/* 3.	“NOT” can be applied to any conditional.  Show all consultants 
WHERE NOT consultant_id > 5
*/

SELECT * FROM consultant
WHERE NOT consultant_id  > 5;

/* 4.	Show all consultants WHERE consultant_id BETWEEN 5 AND 8.
*/
SELECT * FROM Consultant
WHERE consultant_id > 5 AND consultant_id < 8; 

/* 5.	Show all consultants WHERE consultant_id >= 5 
  AND consultant_id <= 8.
*/
SELECT * FROM consultant
WHERE consultant_id >= 5 AND consultant_id <= 8;

/* 6.	Show all consultants with consultant_id NOT BETWEEN 5 AND 8.
*/
SELECT * FROM consultant
WHERE consultant_id !=5 AND consultant_id !=6 AND consultant_id !=7 AND consultant_id !=8;

/* 7.	Show all consultants with consultant_id < 5 OR consultant_id > 8.
*/
SELECT * FROM consultant
WHERE consultant_id < 5 OR consultant_id > 8;

/* 8.	Show all consultants with consultant_id IN (1,3,5,7,8). */

SELECT * FROM consultant
WHERE 
  consultant_id =1 
  AND consultant_id =3 
  AND consultant_id =5 
  AND consultant_id =7 
  AND consultant_id =8;

/* 9.	Show all consultants with consultant_id NOT IN (1,3,5,7,8).
*/

SELECT * FROM consultant
WHERE NOT consultant_id =1 
  AND consultant_id =3 
  AND consultant_id =5 
  AND consultant_id =7 
  AND consultant_id =8;


/* 10.  Show all assignments where a consultant has not been allocated. */
SELECT * FROM assignments
WHERE consultant_id IS NULL;


 -- 11.  Show all assignments where a consultant has been assigned but 
 --        the pay has not been specified. *

SELECT * FROM assignments
WHERE pay IS NULL;


/*******  Exploring Date Functions   *********
/*
Look through the examples in Lesson04f_DateFunctions.sql and attempt the following.
Objectives:
SYSDATE,
TO_CHAR(), TO_DATE()
Date and Time Formatting:
	HH:MI:SSAM,  HH24:MI:SS,  hh:mi:ss
	DD, DY, Dy, dy, DAY, Day, day, fmDay
	Ddspth, fmDdspth
	MM, MONTH, Month, fmMonth, Mon, mon
	YYYY, YY, YEAR, Year
	WW   - number for week of the year
	Q   - quarter
TRUNC()
Trunc Format:
	SS, MI, HH, DD, MM, YYYY
NVL
Date Arithmetic
NEXT_DAY(), LAST_DAY()
ADD_MONTHS(), MONTHS_BETWEEN()


/* 12.	Try this:         SELECT to_char(SYSDATE,'HH:MI:SS AM') 
                          FROM dual;
*/
printing a string version of current date and time from SYSDATE

/* 13.	Show consultants birthdates in the form 
'fmDay "the" fmDdspth "of" fmMonth, fmYear'
*/
SELECT
  to_char(birth_date,'fmDay "the" fmDdspth "of" fmMonth, fmYear')
FROM consultant;

/* 14.	Try this:         
SELECT to_date('January 1, 2000','Month dd, yyyy') 
FROM dual;
*/
printing a string version of date january 1, 2000 in the format of month dd, yyyy

/* 15.	What was the day (Monday, Tuesday) that you were born?  
You will have to write a string for your birth date and use TO_DATE 
to convert it to date and then use TO_CHAR to convert that date to 
the string format you need.  You will have to select this from dual.
*/
SELECT 
to_char(to_date('07-24-1984', 'DD-MM-YYYY'), 'DAY')
FROM dual;


/* 16.	Select the SYSDATE AND display THE numbers FOR EACH OF THE 
FOLLOWING: YEAR, MONTH, DAY, HOUR, MINUTE, AND SECOND.
*/ 
SELECT 
  to_char(SYSDATE,'YYYY-MM-DD HH:MI:SSAM') AS SYSDATE_FULL,
  to_char(TRUNC(SYSDATE,'YYYY'),'YYYY-MM-DD HH:MI:SSAM') AS YEAR,
  to_char(TRUNC(SYSDATE,'MM'),'YYYY-MM-DD HH:MI:SSAM') AS MONTH,
  to_char(TRUNC(SYSDATE,'DD'),'YYYY-MM-DD HH:MI:SSAM') AS DAY,
  to_char(TRUNC(SYSDATE,'HH'),'YYYY-MM-DD HH:MI:SSAM') AS HOUR,
  to_char(TRUNC(SYSDATE,'MI'),'YYYY-MM-DD HH:MI:SSAM') AS MINUTE,
  to_char(TRUNC(SYSDATE,'SS'),'YYYY-MM-DD HH:MI:SSAM') AS SECOND
FROM dual;

SELECT
TO_CHAR(SYSDATE, 'YYYY-MON-DD HH:MI:SS')
FROM dual;
/* 17.	What IS THE meaning OF 
    to_char(trunc(SYSDATE,'dd'),'yyyy mm dd hh:mi:ss') ? 
Try selecting it from dual.  
Also try these abbreviations inside the trunc function:  mi,  hh, dd, yyyy.
*/
printing a string version of current date only in SYSDATE from dual

/* 18.	Display records in the assignment table.  Show records which have 
a start date, but have no end date.
*/
SELECT 
  ASSIGNMENT_ID,
  CONSULTANT_ID, 
  CLIENT_ID,
  START_DATE,
  END_DATE,
  PAY,
  COMMENTS
FROM assignment
WHERE START_DATE != NULL AND END_DATE = NULL;

/* 19.	If you subtract one date from another, Oracle will tell you the number 
of days difference.  How many days between 'Mar 1, 2012' and 'Feb 1, 2012'? Does 
Oracle know about leap years?
*/
ORACLE KNOWS ABOUT LEAP YEAR IN MONTHS_BETWEEN

SELECT
  to_date('1-mar-2012','dd-mon-yyyy') -
     to_date('1-feb-2012','dd-mon-yyyy') AS days_between
FROM dual;

/* 20.	Use the MONTHS_BETWEEN() function to determine the number of months 
difference. How many months between ‘Mar 15, 2012’ and ‘Feb 1, 2012’?  
*/

SELECT
   MONTHS_BETWEEN(
     to_date('15-march-2012','dd-month-yyyy'),
     to_date('1-february-2012','dd-month-yyyy'))
FROM dual;


/*******    String Manipulation   ********/
/*  Look through the examples in Lesson04g_StringFunctions.sql and 
attempt the following. 

Objectives:
||
NVL
LIKE %, _
UPPER(), LOWER(), INITCAP(), LENGTH(), 
INSTR(), SUBSTR()
LTRIM, RTRIM, TRIM, LPAD, RPAD
*/

--21.	Use || to concatenate the consultant's first name with the last name 
-- with a space in between.
SELECT 
first_name || ' ' || last_name
FROM consultant;

/* 22.	Show all consultants with a first name that comes after 
‘Bill’ (in alphabetical order).
*/
SELECT 
   first_name
FROM consultant
WHERE NOT first_name LIKE 'A%';

/* 23.	Display all comments in the assignment table.  If the comment is 
null then display "No comment given".
*/
  SELECT NVL(comments, 'No comment given')
  FROM assignment;

/* 24.	--The LIKE operator uses % to match 0 or more characters.
--Show all consultants whose first_name begins with a capital 'S'.
*/
SELECT
first_name
FROM consultant
WHERE first_name LIKE 'S%';

/* 25.	The LIKE operator uses the underscore _ to match any ONE character.  
Show all consultants with first_name LIKE 'S___n'   (Three underscores.)
*/
SELECT
first_name
FROM consultant
WHERE first_name LIKE 'S___n%';


/* 26.	Create a query that will list consultants with initials PB or BP.
*/
SELECT 
first_name,
last_name
FROM consultant
WHERE first_name LIKE 'P%' AND first_name LIKE 'B%' AND last_name LIKE 'B%' AND last_name LIKE 'P%';


/* 27.	Create a query that will list consultants with last_name that 
begins with S and first name Susan or Bill.
*/
SELECT 
first_name,
last_name
FROM consultant
WHERE first_name LIKE 'Susan' AND first_name LIKE 'Bill' AND last_name LIKE 'S%';

/* 28.	Show all consultants with called Bill or Simon
*/
SELECT
first_name,
last_name
FROM consultant
WHERE first_name LIKE 'Bill' OR first_name LIKE 'Simon';

/* 29.	Oracle allows the where clause to do pairwise comparisons. 
Show all consultants with (first_name, last_name) IN (('Bill','Sykes'),('Simon','Adebisi'))
Microsoft SQL Server does not have this feature
*/
SELECT
first_name,
last_name
FROM consultant
WHERE first_name = 'Bill' AND first_name = 'Simon' 
IN (SELECT last_name FROM consultant WHERE last_name = 'Sykes' AND last_name = 'Adebisi'); 

/* 30.	Investigate UPPER(), LOWER(), INITCAP().
*/

CHANGES OUTPUT TO UPPERCASE, LOWERCASE, OR CAPITALIZING INITIALS RESPECTIVELY

/* 31.	Investigate INSTR().  Use INSTR() to determine the position of the 
space ' ' in all the street names in the address table.
*/

SELECT 
INSTR(STREET, ' ')
FROM address;

/* 32.	Investigate SUBSTR(). Use SUBSTR() to separate the name from the 
designation,such as street, lane, avenue, etc.  
Display the name and the designation as separate columns.
*/

SELECT 
SUBSTR(STREET, INSTR(STREET, 'street')),
SUBSTR(STREET, INSTR(STREET, 'lane')),
SUBSTR(STREET, INSTR(STREET, 'avenue'))
FROM address;

/**********  Numeric Functions   ***********/
/* Look through the examples in Lesson04h_NumberFunctions.sql 
and attempt the following.

Objectives:
TO_NUMBER(), TO_CHAR()
Numeric Formats:
	‘9,999,999.9’
ABS(), SIGN(),
CEIL(), FLOOR(), ROUND(), TRUNC()
GREATEST(), LEAST()
*/


/* 33.	Try this:   
SELECT to_char(1234567,'9,999,999') FROM dual;
*/
SELECT 
to_char(1234567, '9,999,999')
FROM dual;

CONVERTS NUMBER TO characters
/* 34.	Try this:   
SELECT 1230 + 4 FROM dual;
*/
SELECT 1230 + 4
FROM dual;

ADDS 4 TO 1230
/* 35.	Try this:   
SELECT greatest(1,5,10,15,11,6) FROM dual;
Greatest returns the greatest number from a “row”.
*/
SELECT greatest(1,5,10,15,11,6)
FROM dual;

RETURN THE GREATEST NUMBER OUT OF THE LIST OF NUMBERS
/* 36.	What is the difference between 
CEIL(), FLOOR(), ROUND() and TRUNC()? Investigate
*/
CEIL() ROUNDS UP A FLOAT NUMBER WITH DECIMAL
FLOOR() ROUNDS DOWN A NUMBER WITH DECIMAL 
ROUND() ROUNDS A NUMBER WITH DECIMAL BY ROUNDING RULES
TRUNC() CUTS A NUMBER WITH DECIMAL BY THE specified DECIMAL PLACE

/* 37.	Display all the Pay amounts in the assignment table.  
If the pay amount is NULL then display 1000000 instead.
*/
SELECT 
PAY,
REPLACE(PAY, NULL, 1000000),
FROM assignment;



/**********  DECODE and CASE   *********/
/* Look through the examples in Lesson04i_DecodeCase.sql 
and attempt the following.

Objectives:
DECODE()  
CASE (Two Forms)
*/

/* 38.	CASE Example 1:
SELECT 
   first_name,
   consultant_id,
   CASE consultant_id
    WHEN 1 THEN 'First Consultant'
    WHEN 2 THEN 'Second Consultant'
   ELSE 'Another one'
   END
FROM consultant
ORDER BY consultant_id;

38A:  Try the statement to see what it does.
*/

PRINT first_name, consultant_id WHEN consultant_id IS 1 THEN PRINT FIRST consultant
WHEN consultant_id IS 2 PRINT SECOND consultant, ELSE PRINT ANOTHER ONE

/* 38B.	What happens if you remove the line containing 
 ELSE 'Another one'?
*/
PRINTS AS NORMAL consultant_id

/* 38C.	Can you add more WHEN options?
*/
YES


/* 39.
CASE Example 2:
SELECT 
   CASE 
      WHEN pay >= 650 THEN 'Equal or above 650'
      WHEN pay >= 500 THEN 'Equal or above 500 but less than 650'
      WHEN pay >= 400 THEN 'Equal or above 400 but less than 500'
      ELSE 'less than 400'
   END AS pay_range
FROM assignment
ORDER BY 1

How is this case statement different from the previous one?
*/

THIS CASE DEALS WITH NUMBERS, AND IS PRINTED IN ORDER BY 1

/* 40.  DECODE Example:
SELECT
   first_name,
   consultant_id, 
   DECODE(consultant_id, 
          1,'Consultant Number 1', 
          2, 'Second Consultant', 
          'another one')
FROM consultant
ORDER BY first_name;
Try the statement to see what it does.
*/
SIMILAR TO QUESTION NUMBER 38 EXCEPT IT USES THE DECODE FUNCTION IN PLACE OF CASE FUNCTION. 

/* 41.	What happens if you remove 'another one' so that the 
DECODE function uses only 5 parameters instead of six?
*/
IT BECOMES INVALID

/* 42.	Add two more parameters so that if the consultant_id is 3 
then the DECODE will return 'Third Consultant'
*/

SELECT
   first_name,
   consultant_id, 
   DECODE(consultant_id, 
          1,'Consultant Number 1', 
          2, 'Second Consultant', 
          3, 'THIRD consultant',
          'another one')
FROM consultant
ORDER BY first_name;
    

/* 43.	Try the following:
SELECT 
DECODE(consultant_id,
        1,'Bill',
        1,'Joe',
        'Unknown')
FROM consultant;
Will the DECODE return 'Bill' or 'Joe' for consultant_id = 1?
*/
will return Bill



-- SELECT 
--   consultant.first_name,
--   consultant.last_name,
--   address.town,
--   client.client_name AS "Client Town",
--   FROM consultant
--     JOIN assignment ON Consultant.consultant_id = assignment.consultant_id,
--     JOIN client ON assignment.client_id = client.client_id,
--     JOIN address ON client.address_id = address.address_id;

















