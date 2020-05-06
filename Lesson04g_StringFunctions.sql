/*  Important String Functions  */

-- Changing Case

SELECT UPPER('hello')
FROM dual;

SELECT LOWER('HELLO')
FROM dual;

SELECT INITCAP('heLLO to yOU')
FROM dual;


-- String Concatenation  -   ||
SELECT 'Hello' || ' from ' || 'FDM'
FROM dual;


-- Find the length of a string
SELECT LENGTH('Hello to you')
FROM dual;


-- INSTR -  find the character position

-- Where does the ' and' start in the string?
SELECT INSTR('first name and second name',' and')
FROM dual;

-- INSTR() has another version that takes 4 parameters.
-- The following means: start looking at position 6 and find the 2nd
--  instance of 's'
SELECT INSTR('This is the string to be searched.','s',6,2)
FROM DUAL;


-- SUBSTR - cut characters from the string
-- Read 3 characters starting from the 6th character in the string.
SELECT substr('UNIX and ORACLE', 6, 3)
FROM dual;

-- read from the 10th character to the end of the string
SELECT substr('UNIX and ORACLE', 10) AS part
FROM dual;

-- Cutting FROM the end
SELECT substr('UNIX and ORACLE', -8) AS part
FROM dual;

-- Using INSTR and SUBSTR together
SELECT 
   last_name,
   INSTR(last_name,'e')                           AS "Position of e",
   SUBSTR(last_name,1,INSTR(last_name,'e')-1)     AS "Left of e - 3 parameter",
   SUBSTR(last_name,INSTR(last_name,'e')+1)       AS "Right of e - 2 parameter"    
FROM consultant;

/* LIKE
If you want to filter using wildcards, you must use LIKE.
SQL has two wildcard:   % and _
%  - any number of characters (including zero characters)
_  - any single character (but there must be a character)
*/

SELECT 
   first_name
FROM consultant
WHERE first_name LIKE 'B%';

/*
 Using % or _ as a literal.
 If you literally want to find strings that contain the % character
 you have to define and use an escape character.  You can use any
 character you want for an escape character, but \ is usually a good
 choice.

 Examples involving escape characters:
 What if you wanted to search LITERALLY for '%'
*/   

-- This example creates some data with a literal '%' and a '_'

CREATE TABLE ProductDescription
(ProductID  NUMBER(4) CONSTRAINT ProductDescription_PK PRIMARY KEY,
 Description varchar2(40));
 
INSERT INTO ProductDescription (ProductID, Description)
VALUES (1,'Bike Frame %50 Chromoly');
INSERT INTO ProductDescription (ProductID, Description)
VALUES (2,'#5 Monkey_Wrench');
commit;

-- The following query will return all rows where the description
-- column contains '%'.
SELECT
  productid,
  description
FROM ProductDescription
WHERE Description LIKE '%\%%' ESCAPE '\';

-- The following query will return all rows where the description
-- starts with #, followed by any number of characters, followed by
-- a literal _ followed by any number of characters.
SELECT
  productid,
  description
FROM ProductDescription
WHERE Description LIKE '#%\_%' ESCAPE '\'
;



-- replace will find a string and replace it
SELECT replace('UNIX and ORACLE','and','or')
FROM dual;

-- replace will change characters whether they appear inside words or not
SELECT REPLACE('Change characters "rac" to "rake"', 'rac','rake')
FROM dual;

-- translate changes on a character by character basis,
-- respectively.
SELECT translate('Unix and Oracle','UiaO','EoiU')
FROM dual;


-- ltrim and rtrim 
SELECT ltrim('    Welcome to FDM Academy     ') as ltrimmed
FROM dual;

-- LTRIM can take an additional parameter
SELECT ltrim('  a eeae  aaeeaa    eWelcome to FDM Academy eeee','ea ')
   AS "Remove left e, a, space"
FROM dual;


SELECT rtrim('    Welcome to FDM Academy   ') as rtrimmed
FROM dual;

-- RTRIM can also take an additional parameter
SELECT rtrim('eaeaeaea Welcome to FDM Academy ea ea eae aaaa','ea ') 
  AS "Remove right e, a, space"
FROM dual;


SELECT trim('    Welcome to FDM Academy     ') as trimmed
FROM dual;

-- IF ltrim and rtrim can take two parameters, can trim ?
SELECT trim('aaa Welcome to FDM Academy eeee', 'ae ')
FROM dual;
-- answer: no

-- Solution:  Nest the rtrim and ltrim
SELECT rtrim(
    ltrim('  a eeaeaaeeaa    Welcome to FDM Academy eeee','ea '),
      'ea ') as result
FROM dual;


/* LPAD and RPAD
Pad with extra spaces (or characters)

Run the following queries as Run Statement (F9 or CTRL- Enter)
The column alias is intentionally short so the width of the column
is the width of the content, not the width of the alias
*/

SELECT lpad('hello',15) AS a
FROM DUAL;

SELECT lpad('hello',15,':') AS a
FROM DUAL;

SELECT rpad('hello',15) AS a
FROM DUAL;

SELECT rpad('hello',15,':') AS a
FROM DUAL;