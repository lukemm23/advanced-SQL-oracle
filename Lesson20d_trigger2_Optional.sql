/*  PL/SQL Triggers
Lesson Objective:
  - Use a BEFORE trigger
*/

/*  
Use a trigger to automatically generate id numbers
*/

-- CREATE a SEQUENCE
SELECT 
   MAX(place_id)
FROM place;

CREATE SEQUENCE place_sq
   START WITH 7;
   
CREATE OR REPLACE TRIGGER place_TR
BEFORE INSERT ON place
FOR EACH ROW
BEGIN
   IF :new.place_id IS NOT NULL THEN
       RAISE_APPLICATION_ERROR(-20000, 'Put in NULL for the ID PLEASE!!!!!');
   ELSE
       SELECT place_sq.NEXTVAL
       INTO   :new.place_id
       FROM   dual;
  END IF;
END;
/

show errors trigger place_tr;

SELECT place_id, city, country
  FROM place;

INSERT INTO place (city, country)
  VALUES ('Toronto', 'Canada');

-- Check that the trigger worked
SELECT place_id, city, country
  FROM place;


-- The trigger will raise an error if you try to specify an ID.
INSERT INTO place (place_id, city, country)
  VALUES (8, 'Chicago', 'USA');

