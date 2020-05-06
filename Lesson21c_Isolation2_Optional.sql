COMMIT;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

SELECT * FROM address;

INSERT INTO address 
(address_id, house_number, street, town)
VALUES
(20,123,'Applewood','AnyTown');
COMMIT;
DELETE FROM address
WHERE address_id > 18;

UPDATE address
  SET set town = 'MyTown'
WHERE address_id = 20;
COMMIT;


DELETE FROM consultant
WHERE consultant_id = 15;

COMMIT;

SELECT * FROM consultant;

INSERT INTO consultant
  (consultant_id, first_name, last_name)
VALUES (15,'Joe','Blow');

COMMIT;

DELETE FROM consultant
WHERE consultant_id = 15;

COMMIT;
