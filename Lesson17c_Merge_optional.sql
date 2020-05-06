
/* 
MERGE INTO <target_table>
USING <table_view_or_query>
   ON (<condition>)
WHEN MATCHED THEN 
   <update_clause>
   [ DELETE <where_clause> ]
WHEN NOT MATCHED THEN 
   <insert_clause> 
  ;
*/
DROP TABLE target;


/* Simple Example */
CREATE TABLE target
(target_id NUMBER(2) PRIMARY KEY,
 first_name VARCHAR2(20),
 last_name  VARCHAR2(20)
);

INSERT INTO target VALUES (1, 'Scot','McDermid');
INSERT INTO target VALUES (2, 'Keith','Doris');

SELECT * from target;

DROP TABLE temp;

CREATE TABLE temp
(temp_id NUMBER(2) PRIMARY KEY,
 first_name VARCHAR2(20),
 last_name  VARCHAR2(20)
);
INSERT INTO temp VALUES (2,'Keith','Dauris');
INSERT INTO temp VALUES (3,'Stuart','Werner');

select * from target;
select * from temp;

MERGE INTO target t
USING temp s
   ON (s.temp_id = t.target_id)
WHEN MATCHED THEN 
   UPDATE SET 
      first_name = s.first_name,
      last_name  = s.last_name
WHEN NOT MATCHED THEN 
   INSERT (target_id, first_name, last_name)
   VALUES (s.temp_id, s.first_name, s.last_name) 
  ;
  
SELECT * FROM target;




/*  Complex Example
We have employees and we want to assign bonuses.
*/
drop table employee cascade constraint;

CREATE TABLE employee (
employee_id NUMBER(5),
first_name  VARCHAR2(20),
last_name   VARCHAR2(20),
dept_no     NUMBER(2),
salary      NUMBER(10));

truncate table employee;
delete from bonuses;

INSERT INTO employee VALUES (1, 'Dan', 'Morgan', 10, 100000);
INSERT INTO employee VALUES (2, 'Helen', 'Lofstrom', 20, 100000);
INSERT INTO employee VALUES (3, 'Akiko', 'Toyota', 20, 50000);
INSERT INTO employee VALUES (4, 'Jackie', 'Stough', 20, 40000);
INSERT INTO employee VALUES (5, 'Richard', 'Foote', 20, 70000);
INSERT INTO employee VALUES (6, 'Joe', 'Johnson', 20, 30000);
INSERT INTO employee VALUES (7, 'Clark', 'Urling', 20, 90000);
commit;

drop table bonuses;

CREATE TABLE bonuses (
employee_id NUMBER, bonus NUMBER DEFAULT 100);

INSERT INTO bonuses (employee_id) VALUES (1);
INSERT INTO bonuses (employee_id) VALUES (2);
INSERT INTO bonuses (employee_id) VALUES (4);
INSERT INTO bonuses (employee_id) VALUES (6);
INSERT INTO bonuses (employee_id) VALUES (7);
COMMIT;

SELECT * FROM employee;
SELECT * FROM bonuses;

SELECT 
 e.*,
 b.*
FROM bonuses b
  full outer JOIN employee e
     ON e.employee_id = b.employee_id;
     
/*  The Goal: give a bonus to employees in dept 20.
    If they had a bonus before, give them 10%
   If they didn't have a bonus before give them 5%.
   If their salary is less that $40,000 then no bonus at all.
*/
MERGE INTO bonuses b
USING (
  SELECT employee_id, salary, dept_no
  FROM employee
  WHERE dept_no = 20) e
ON (b.employee_id = e.employee_id)
WHEN MATCHED THEN
   UPDATE SET b.bonus = e.salary * 0.1
   DELETE WHERE (e.salary < 40000)
WHEN NOT MATCHED THEN
  INSERT (b.employee_id, b.bonus)
  VALUES (e.employee_id, e.salary * 0.05)
  WHERE (e.salary > 40000);

