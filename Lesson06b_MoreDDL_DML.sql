/* 
Objectives:
Learn the Syntax for
   CHECK CONSTRAINTS
   DEFAULT CONSTRAINTS
   UNIQUE CONSTRAINTS

Additional DDL 
   CREATE TABLE as ...
   INSERT FROM SELECT

   ALTER TABLE 
   COMMENTS
   
This file contains examples of syntax.   
*/

-- CHECK CONSTRAINTS   
DROP TABLE person;

CREATE TABLE person
(person_id NUMBER(4) CONSTRAINT person_pk PRIMARY KEY,
 person_name VARCHAR2(40) NOT NULL,
 gpa NUMBER(4,2) NOT NULL,
 CONSTRAINT ck_persongpa 
     CHECK (gpa > 2.5 AND gpa <= 4.0)
);

-- This should fail.  GPA too low.    
INSERT INTO person (person_id, person_name,gpa)
VALUES (1,'Bob',2.4);

-- This should succeed.
INSERT INTO person (person_id, person_name,gpa)
VALUES (1,'Bob',2.6);

SELECT 
  person_id,
  person_name,
  gpa
FROM person;

-- This should fail.  GPA too low.
UPDATE person
  SET gpa = 1.5
WHERE person_id = 1;

SELECT 
  person_id,
  person_name,
  gpa
FROM person;

-- To remove a constraint
ALTER TABLE Person
DROP CONSTRAINT CK_PersonGPA;

-- Without the constraint, the update statement above should now work.
-- Go back and try it.
 
 
-- DEFAULT CONSTRAINTS
DROP TABLE person;

-- Numeric Default
CREATE TABLE Person
(Person_ID NUMBER(4) CONSTRAINT person_pk PRIMARY KEY,
 Person_Name VARCHAR2(40) NOT NULL,
 GPA NUMBER(4,2) DEFAULT 2.0);

INSERT INTO PERSON
(Person_ID, Person_Name)
VALUES
(1,'Andy');

SELECT 
  person_id,
  person_name,
  gpa
FROM PERSON;


DROP TABLE person;

-- Character Default
CREATE TABLE Person
(
Person_Id number(4) CONSTRAINT person_pk PRIMARY KEY,
person_Name VARCHAR2(40) NOT NULL,
Address VARCHAR2(40),
City varchar2(40) DEFAULT 'New York'
);

-- Try the Default for City
INSERT INTO person (person_id, person_name, address)
VALUES (1,'Gordon Gecko','14 Wall Street');

SELECT 
  person_id,
  person_name,
  address,
  city
FROM PERSON;

-- To Modify a constraint
ALTER TABLE person
 MODIFY city DEFAULT 'London';

-- Try the modified constraint
INSERT INTO person (person_id, person_name, address)
VALUES (2,'Sherlock Holmes','221b Baker Street');

SELECT 
  person_id,
  person_name,
  address,
  city
FROM PERSON;

DROP TABLE Person;

-- UNIQUE CONSTRAINTS
CREATE TABLE Person
(
person_Id NUMBER(4) CONSTRAINT PERSON_PK PRIMARY KEY,
person_name VARCHAR2(40) NOT NULL,
Address VARCHAR2(40),
City VARCHAR2(40) DEFAULT 'London',
CONSTRAINT uc_Person UNIQUE (person_name, city)
);


/******  Secondary Objectives *******
CREATE TABLE AS

ALTER TABLE  ... add and remove columns
COMMENTS
*/

-- CREATE TABLE AS
DROP TABLE consultant_backup;

desc consultant;
-- This will copy the table structure but none of the rows.
CREATE TABLE consultant_backup
AS
SELECT 
   consultant_id, 
   first_name, 
   last_name
FROM consultant
WHERE 1 = 2   -- no rows will be copied.
;

DESC consultant_backup;
-- describes the table

SELECT * 
FROM consultant_backup
;
-- Constraints are not copied to the new table
ALTER TABLE consultant_backup
ADD CONSTRAINT consultant_backup_pk
  PRIMARY KEY (consultant_id);


-- DML   -  INSERT INTO SELECT
-- This will insert all the rows from consultant into consultant_backup.
INSERT INTO consultant_backup (consultant_id, first_name, last_name)
SELECT
   consultant_id,
   first_name,
   last_name
FROM consultant;
commit;



-- Altering Tables  -  Add a column
DROP TABLE person;

CREATE TABLE Person
(
person_Id NUMBER(4) CONSTRAINT PERSON_PK PRIMARY KEY,
person_name VARCHAR2(40) NOT NULL
);

-- We are going to add some data first, then try altering the table
INSERT INTO person VALUES (1,'William');
 
SELECT 
  person_id,
  person_name
FROM person;
 
-- To add a column to a table.
-- If the table already contains data, you cannot add a NOT NULL column
ALTER TABLE person
  ADD email varchar2(50) NOT NULL ;

-- You can add a nullable column
ALTER TABLE person
  ADD email varchar2(50) NULL ;

ALTER TABLE person
  DROP COLUMN email;

-- To modify a column
desc person;

-- If there is already data, you might not be able to shorten
-- the width of a column.
ALTER TABLE person
MODIFY person_name VARCHAR2(4);

desc person

-- You can make a column wider
ALTER TABLE person
MODIFY person_name VARCHAR2(50);


/*
-- Final table
The previous examples were meant just as examples of syntax.
But here is the entire table
*/
DROP TABLE Person;

CREATE TABLE Person
(
person_Id NUMBER(4) CONSTRAINT PERSON_PK PRIMARY KEY,
person_name VARCHAR2(50) NOT NULL,
gpa NUMBER(4,2) NOT NULL,
CONSTRAINT ck_persongpa CHECK (gpa > 2.5 AND gpa <= 4.0),
Address VARCHAR2(40),
City VARCHAR2(40) DEFAULT 'London',
CONSTRAINT uc_Person UNIQUE (person_name, city)
);


/* 
-- Adding Comments about Tables and Columns
The Entity Relationship diagram is good documentation for a data model
but it isn't enough.  Sometimes explanation is required for tables
and columns.  Oracle allows you to add comments to your data dictionary.
*/
COMMENT ON TABLE person IS
   'Information about persons in our database.';

COMMENT ON COLUMN person.city IS 'Defaults to London';

/* Although it is possible to make comments, this potentially
useful feature is hardly ever used.
*/



