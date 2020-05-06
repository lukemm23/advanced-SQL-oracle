DROP TABLE person;

CREATE TABLE person
(person_id NUMBER(6) NOT NULL,
first_name  VARCHAR2(30) NOT NULL,
last_name VARCHAR2(30)   NOT NULL);

exec dbms_stats.gather_table_stats('trainee1', 'person');

-- First Row
INSERT INTO person VALUES (20,'Andy','Adams');
COMMIT;

exec dbms_stats.gather_table_stats('trainee1', 'person');


INSERT INTO person VALUES (48,'Andy','Allan');
INSERT INTO person VALUES (43,'Alice','Anderson');
INSERT INTO person VALUES (34,'Sony','Bae');
INSERT INTO person VALUES (44,'Yad','Banga');
INSERT INTO person VALUES (53,'Leah','Barnes');
INSERT INTO person VALUES (16,'Kelly','Capstick');
INSERT INTO person VALUES (15,'Colleen','Cordova');
INSERT INTO person VALUES (18,'Colin','Cabott');
INSERT INTO person VALUES (30,'David','Davies');
INSERT INTO person VALUES (04,'Darnell','Day');
INSERT INTO person VALUES (31,'Doug','Deering');
INSERT INTO person VALUES (11,'Ed','Edward');
INSERT INTO person VALUES (56,'Elliot','Emsley');
INSERT INTO person VALUES (05,'Eunice','Egli');
INSERT INTO person VALUES (41,'Freida','Fairbanks');
INSERT INTO person VALUES (40,'Fan','Fae');
INSERT INTO person VALUES (32,'Fred','Ferguson');
INSERT INTO person VALUES (58,'George','Gagnier');
INSERT INTO person VALUES (51,'Greg','Garofano');
INSERT INTO person VALUES (06,'Gene','Gaudet');
INSERT INTO person VALUES (59,'Harry','Hagyard');
INSERT INTO person VALUES (01,'Howard','Hamilton');
INSERT INTO person VALUES (55,'Heather','Healey');
INSERT INTO person VALUES (02,'Irene','Dover');
INSERT INTO person VALUES (35,'Ismail','Israel');
INSERT INTO person VALUES (07,'Ian','McKellan');
INSERT INTO person VALUES (28,'Jackie','Jacobsen');
INSERT INTO person VALUES (09,'Janet','Jeffries');
INSERT INTO person VALUES (47,'Jerry','Jenson');
INSERT INTO person VALUES (08,'Kyle','Kadatz');
INSERT INTO person VALUES (22,'Kathleen','Kendrick');
INSERT INTO person VALUES (39,'Kelly','Kennedy');
INSERT INTO person VALUES (24,'Larry','Fishburn');
INSERT INTO person VALUES (14,'Lai','Lai');
INSERT INTO person VALUES (50,'Lisa','Laing');
INSERT INTO person VALUES (33,'Lorynn','Langton');
INSERT INTO person VALUES (10,'Lori','Last');
INSERT INTO person VALUES (46,'Mike','MacKinnon');
INSERT INTO person VALUES (54,'Mike','Maloney');
INSERT INTO person VALUES (45,'Mike','Mander');
INSERT INTO person VALUES (57,'Marco','Manno');
INSERT INTO person VALUES (12,'Mark','Margetson');
INSERT INTO person VALUES (49,'Nick','Neumann');
INSERT INTO person VALUES (17,'Ned','Nielson');
INSERT INTO person VALUES (03,'Nancy','Nimchuk');
INSERT INTO person VALUES (27,'Owen','O''Connor');
INSERT INTO person VALUES (13,'Olga','Olsen');
INSERT INTO person VALUES (26,'Ozzy','Osborn');
INSERT INTO person VALUES (38,'Pat','Paulsen');
INSERT INTO person VALUES (19,'Pete','Peters');
INSERT INTO person VALUES (23,'Russell','Peters');
INSERT INTO person VALUES (37,'Paige','Page');
INSERT INTO person VALUES (25,'Quincy','Quan');
INSERT INTO person VALUES (36,'Robbie','Robertson');
INSERT INTO person VALUES (29,'Randon','McNally');
INSERT INTO person VALUES (42,'Roshen','Ramirez');
INSERT INTO person VALUES (52,'Sandra','Sahaydak');
INSERT INTO person VALUES (60,'Jennifer','Saunders');
INSERT INTO person VALUES (21,'Susan','Sarandon');
COMMIT;

exec dbms_stats.gather_table_stats('trainee1', 'person');

-- Without an index, ORACLE must perform a full table scan.
SELECT * 
FROM person
WHERE person_id = 31;

-- Adding a PRIMARY KEY creates an index.
ALTER TABLE person
ADD CONSTRAINT person_pk
  PRIMARY KEY (person_id);

-- Now that the table has a index, ORACLE can use the index to 
-- find the row
SELECT * 
FROM person
WHERE person_id = 31;

-- And the index can be used to cover the following query
SELECT person_id
FROM person;
  
  
-- Without an index on the first_name column, 
-- this query must perform a full table scan.  
SELECT first_name
FROM person;

-- Let's add an index for first_name
CREATE INDEX person_firstname_idx
ON person(first_name);

-- Now the query is covered by the index
SELECT first_name
FROM person;

-- We can use the index to find the rows in the table
SELECT *
FROM person
WHERE first_name = 'Andy';



-- TABLE JOINs

/*  From the outward appearance, the following query looks like
it might scan the consultant table and use the index on the address
table to find the town.  
Explain Plan will show the truth.
*/
SELECT 
   c.first_name,
   c.last_name,
   A.town
FROM consultant c
 JOIN address A
  ON A.address_id = c.address_id
;

/*  From the outward appearance, the following query looks like
it might scan the address table and scan the consultant table to see
who lives at those addresses. 
Use Explain Plan to find out the truth.
*/
SELECT 
   c.first_name,
   c.last_name,
   A.town
FROM address A
   JOIN consultant c
  ON A.address_id = c.address_id
;

