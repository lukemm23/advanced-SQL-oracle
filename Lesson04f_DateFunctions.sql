/*
Module Objectives:
to_char,
to_date
trunc
*/

/*      IMPORTANT CONCEPT  ! 
Inside the database, dates are always stored in one internal numeric format
(probably floating point).  It is not necessary to convert from one date
format to another because inside the database there is only one format.

Whenever you input a date into a database, you 
should always explicitly convert the input using the TO_DATE() function.  
Conversely, whenever you retrieve dates from a database, you should 
explicitly convert the outout to character using TO_CHAR().  

If you do not use explicit conversion the system will convert dates for you 
implicitly, but this is considered a lazy programming practice.
*/

SELECT 
  SYSDATE
FROM dual
;  


-- CONVERTING from DATE to CHAR  
SELECT 
  TO_CHAR(sysdate,'yyyy/mm/dd hh24:mi:ss'),
  SYSDATE
FROM dual;


--  Dates in USA
SELECT 
   first_name,
   last_name,
   birth_date  implicitconversion, 
   to_char(birth_date,'mm/dd/yy') exconvert1,
   to_char(birth_date,'MON/dd/yyyy') exconvert2,
   to_char(birth_date,'Mon/dd/yyyy') exconvert3
FROM consultant;

--  Dates in UK
SELECT 
   first_name,
   last_name,
   birth_date  implicitconversion, 
   to_char(birth_date,'dd/mm/yy') exconvert1,
   to_char(birth_date,'dd/MON/yyyy') exconvert2,
   to_char(birth_date,'dd/Mon/yyyy') exconvert3
FROM consultant;

-- More formatting options
SELECT 
   to_char(birth_date,'Month dd, yyyy'),
   to_char(birth_date,'fmMonth dd, yyyy'),
   to_char(birth_date,'fmDay "the" fmDdspth "of" fmMonth, fmYear') AS "very long"
FROM consultant;

-- Quarter
SELECT
   to_char(SYSDATE,'Q')       AS "Current Quarter",
   to_char(add_months(SYSDATE,-4),'Q') AS "Quarter 4 Months Ago", 
   to_char(SYSDATE,'Q YYYY')  AS "Current Quarter and Year",
   to_char(add_months(sysdate,-12),'Q YYYY') AS "This quarter last year" 
FROM dual;

SELECT 
   TO_CHAR(SYSDATE,'DAY') AS "Full word UPPERCASE",
   TO_CHAR(SYSDATE,'Day') AS "Full word Mixedcase",
   TO_CHAR(SYSDATE,'DY')  AS "Abbrv. UPPERCASE",
   TO_CHAR(SYSDATE,'Dy')  AS "Abbrv. Mixedcase"
FROM dual;


-- Time Options
-- Note that minute is MI, not MM.
SELECT 
  to_char(SYSDATE,'HH:MI:SSAM')  AS "Time with AM or PM",
  to_char(SYSDATE,'HH24:MI:SS')  AS "24 hour time"
FROM dual;



-- CONVERTING from CHAR to DATE
-- TO_DATE function (in this example) is used in the WHERE clause.
SELECT 
   first_name,
   last_name,
   to_char(birth_date,'Month dd, yyyy') AS birthdate
FROM  consultant
WHERE birth_date > = TO_DATE('apr-26-1980','mon-dd-yyyy');

/*  Do comparisons in date (not text)
The preceding query performs the comparison using date.

The following query performs the comparison using string.
Does is really seem that all these people were born after "apr-26-1980" ?
*/
SELECT 
   first_name,
   last_name,
   to_char(birth_date,'Month dd, yyyy') AS birthdate
FROM  consultant
WHERE to_char(birth_date,'mon-dd-yyyy') >= 'apr-26-1980';


-- BETWEEN works with dates.
-- BETWEEN is INCLUSIVE.
SELECT 
   first_name,
   last_name,
   to_char(birth_date,'dd-MON-YYYY')
FROM 
   consultant 
WHERE birth_date 
    BETWEEN to_date('22-OCT-1974','DD-MON-YYYY') 
        AND to_date('03-DEC-1976','DD-MON-YYYY')
ORDER BY birth_date;


/* What DAY were you born?  (Monday, Tuesday, etc...)
Hint:  SELECT to_char(to_date( your birthdate, your format),'Day') FROM dual;
*/


/* TRUNC 
In facilitate date comparisons, ORACLE has a TRUNC function
The TRUNC function truncates the date down to hour or minute etc.
*/
SELECT
   TO_CHAR(SYSDATE,'YYYY-MM-DD HH:MI:SSAM') AS full_date_time,
   TO_CHAR(TRUNC(SYSDATE,'MI'),'YYYY-MM-DD HH:MI:SSAM') AS ChopToMinute,
   TO_CHAR(TRUNC(SYSDATE,'HH'),'YYYY-MM-DD HH:MI:SSAM') AS ChopToHour,
   TO_CHAR(TRUNC(SYSDATE,'DD'),'YYYY-MM-DD HH:MI:SSAM') AS ChopToDay,
   TO_CHAR(TRUNC(SYSDATE,'MM'),'YYYY-MM-DD HH:MI:SSAM') AS ChopToMonth,
   TO_CHAR(TRUNC(SYSDATE,'Q'),'YYYY-MM-DD HH:MI:SSAM') AS ChopToQuarter,
   TO_CHAR(TRUNC(SYSDATE,'YYYY'),'YYYY-MM-DD HH:MI:SSAM') AS ChopToYear
FROM dual;

-- Date Math
SELECT 
  to_char(SYSDATE,'dd/mm/yyyy hh:mi:ssAM')     now,
  to_char(SYSDATE+1,'dd/mm/yyyy hh:mi:ssAM')   tomorrow,
  to_char(SYSDATE+30,'dd/mm/yyyy hh:mi:ssAM')  thirty_days,
  to_char(SYSDATE+(1/24),'hh:mi:ssAM')         one_hour_from_now,
  to_char(SYSDATE+(1/(24*60)),'hh:mi:ssAM')      one_minute_from_now,
  to_char(SYSDATE + (1/(24*60*60)),'hh:mi:ssAM') one_second_from_now,
  to_char(SYSDATE + INTERVAL '0 00:00:01' DAY TO SECOND, 
            'hh:mi:ssAM')                      also_one_second_from_now
FROM dual;


/* You might never use the following date functions, but ORACLE
has them.
*/

-- last_day returns the last day of the month.
select 
   sysdate,
   last_day(sysdate),
   last_day(sysdate-25),
   to_char(last_day(sysdate-25),'day')
from dual;

select next_day(sysdate, 'Tuesday')
from dual;

select next_day(sysdate, 'Thursday')
from dual;

SELECT
	SYSDATE,
  ADD_MONTHS(SYSDATE,3)
FROM DUAL;

SELECT
	MONTHS_BETWEEN(SYSDATE+31,SYSDATE)
FROM dual;


/* MONTHS_BETWEEN knows about leap year */
SELECT
	to_date('1-mar-2012','dd-mon-yyyy')
     - to_date('1-feb-2012','dd-mon-yyyy') days_between,
	MONTHS_BETWEEN(
     to_date('1-mar-2012','dd-mon-yyyy'),
     to_date('1-feb-2012','dd-mon-yyyy'))
FROM dual;

SELECT
  to_date('1-mar-2013','dd-mon-yyyy') -
     to_date('1-feb-2013','dd-mon-yyyy') AS days_between, 
   MONTHS_BETWEEN(
     to_date('1-march-2013','dd-month-yyyy'),
     to_date('1-february-2013','dd-month-yyyy'))
FROM dual;
