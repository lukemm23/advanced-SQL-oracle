/*
-- BASIC DDL

Lesson Objectives:

Datatypes:  VARCHAR2, NUMBER, DATE

CREATE TABLE

Create PRIMARY KEYs, and FOREIGN KEYs

DROP TABLE 
DROP TABLE CASCADE CONSTRAINTS


*/


/*  Basic Data Types
VARCHAR2(n) - stores strings up to n characters
NUMBER(n,m) - stores numbers.  Total number of digits is n and 
              number of digits to the right of the decimal is m.
DATE        - stores dates (and times).
*/

/*
When you write your own creation scripts, you will probably want to add 
DROP statements at the top of your script.  The first time you run it 
you will get errors on the DROP statements, but thereafter you should
be able to re-run your code to recreate your schema.
*/

DROP TABLE enrollment;
DROP TABLE CLASS;
DROP TABLE student;
DROP TABLE mentor;


/*  --- CREATE TABLE ------ */

CREATE TABLE mentor
(mentor_id NUMBER(6),
first_name VARCHAR2(30) NOT NULL,
last_name VARCHAR2(30),
phone    VARCHAR2(14)
);


/* -- Primary Keys */
-- There are several variations on how to create keys.

DROP TABLE mentor;

CREATE TABLE mentor
(mentor_id NUMBER(6),
first_name VARCHAR2(30) NOT NULL,
last_name VARCHAR2(30),
phone    VARCHAR2(14),
PRIMARY KEY (mentor_id)   -- this adds a primary key to the table
);

DROP TABLE mentor;
-- This will give the constraint a name.
CREATE TABLE mentor
(mentor_id NUMBER(6),
first_name VARCHAR2(30) NOT NULL,
last_name VARCHAR2(30),
phone    VARCHAR2(14),
CONSTRAINT mentor_pk PRIMARY KEY (mentor_id)
);

describe mentor;


-- FOREIGN KEY CONSTRAINT - One-to-Many Relationship
CREATE TABLE Student
(Student_ID NUMBER(6),
 First_Name VARCHAR2(30),
 Last_Name  VARCHAR2(30),
 Phone     VARCHAR2(14),
 birth_date DATE,
 Mentor_ID  NUMBER(6),
 CONSTRAINT student_pk PRIMARY KEY (student_id),
 CONSTRAINT student_mentor_fk 
    FOREIGN KEY (mentor_id) 
    REFERENCES mentor(mentor_id)
);

-- DESCRIBE can be abbreviated as DESC
DESC student

CREATE TABLE class
(
  class_id    NUMBER(4),
  class_name  VARCHAR2(30) NOT NULL,
  CONSTRAINT class_pk PRIMARY KEY (class_id)
);

desc CLASS

-- Enrollment is the "associative entity" or "linking table"
CREATE TABLE enrollment
( class_id   NUMBER(4),
  student_id NUMBER(6),
  CONSTRAINT enroll_pk PRIMARY KEY (class_id, student_id),  -- composite key
  CONSTRAINT enroll_class_fk 
     FOREIGN KEY (class_id) REFERENCES CLASS (class_id),
  CONSTRAINT enroll_student_fk 
     FOREIGN KEY (student_id) REFERENCES student (student_id)
);

DESC enrollment;


/* --  DROP TABLE -- */
/*
Try this. (If the student table exists and has a foreign key which
references the mentor table, then the following command will fail.)
*/
DROP TABLE mentor;

/* Because the student table references the mentor table, you
cannot drop the mentor table */

-- Try this:
DROP TABLE mentor CASCADE CONSTRAINTS;

/*  With CASCADE CONSTRAINTS the command will drop the mentor table
and also drop any foreign keys that reference the mentor table */


/*   Optional :  Additional Information  */
/*  DDL - Additional Information 
Objectives:

ALTER TABLE

This file demonstrates a number of methods for creating primary
keys and foreign keys, some of which you saw earlier.
Although the syntax is different, the results are the same.
*/

-- One way to create a primary key : ALTER
CREATE TABLE mentor
(mentor_id NUMBER(6),
first_name VARCHAR2(30) NOT NULL,
last_name VARCHAR2(30),
phone    VARCHAR2(14)
);

-- Use ALTER to add A PRIMARY KEY
ALTER TABLE  mentor
ADD CONSTRAINT mentor_pk
  PRIMARY KEY (mentor_id);



DROP TABLE mentor CASCADE CONSTRAINTS;

-- A second way to create a primary key. A contraint can be
-- declared in a manner similar to how you declare a column.
CREATE TABLE mentor
(mentor_id NUMBER(6),
first_name VARCHAR2(30) NOT NULL,
last_name VARCHAR2(30),
phone    VARCHAR2(14),
CONSTRAINT mentor_pk 
  PRIMARY KEY (mentor_id) );



DROP TABLE mentor CASCADE CONSTRAINTS;

-- A Third way - Together with the column definition itself.
CREATE TABLE mentor
(mentor_id NUMBER(6) CONSTRAINT mentor_id PRIMARY KEY,
first_name VARCHAR2(30) NOT NULL,
last_name VARCHAR2(30),
phone    VARCHAR2(14)
);

DROP TABLE mentor CASCADE CONSTRAINTS;

/* Fourth Way 
The following creates a primary key, but does not provide a name for the 
constraint.  Oracle creates a system generated name for the contraint.
The system generated names are not helpful at all so it is recommended
that you supply a name for the constraint (as shown in the previous
examples
*/
CREATE TABLE mentor
(mentor_id NUMBER(6) PRIMARY KEY,
first_name VARCHAR2(30) NOT NULL,
last_name VARCHAR2(30),
phone    VARCHAR2(14)
);


-- Alternate syntax for creating foreign keys

-- One way - use ALTER
DROP TABLE student CASCADE CONSTRAINTS;
CREATE TABLE student
(student_id NUMBER(6) PRIMARY KEY,
 first_name VARCHAR2(30),
 last_name  VARCHAR2(30),
 phone     VARCHAR2(14),
 mentor_id  NUMBER(6));
 
 ALTER TABLE student
 ADD CONSTRAINT student_mentor_fk
 FOREIGN KEY (mentor_id) REFERENCES mentor(mentor_id);

-- Another version of the syntax.
DROP TABLE student CASCADE CONSTRAINTS;

CREATE TABLE student
(student_id NUMBER(6) PRIMARY KEY,
 first_name VARCHAR2(30),
 last_name  VARCHAR2(30),
 phone     VARCHAR2(14),
 mentor_id  NUMBER(6),
 CONSTRAINT student_mentor_fk
    FOREIGN KEY (mentor_id)
       REFERENCES mentor(mentor_id)  );

DROP TABLE student CASCADE CONSTRAINTS;

-- Foreign key as part of the column defintion
CREATE TABLE student
(student_id NUMBER(6) CONSTRAINT student_pk PRIMARY KEY,
 first_name VARCHAR2(30),
 last_name  VARCHAR2(30),
 phone     VARCHAR2(14),
 mentor_id  NUMBER(6) CONSTRAINT student_mentor_fk REFERENCES mentor(mentor_id)
);

-- Foreign key as part of the column definition without a name for the 
-- constraint.  Oracle will generate a name but these names
-- are not helpful.
DROP TABLE student CASCADE CONSTRAINTS;
CREATE TABLE student
(student_id NUMBER(6) CONSTRAINT student_pk PRIMARY KEY,
 first_name VARCHAR2(30),
 last_name  VARCHAR2(30),
 phone      VARCHAR2(14),
 mentor_id  NUMBER(6) REFERENCES mentor(mentor_id)
);






