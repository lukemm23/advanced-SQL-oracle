
-- Can set isolation level only immediately after a commit;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

COMMIT;

SELECT * FROM address;

INSERT INTO address 
(address_id, house_number, street, town)
VALUES
(122,123,'Applewood','AnyTown');

DELETE FROM address
WHERE address_id = 20;

DELETE FROM consultant
WHERE consultant_id = 15;

UPDATE address
  SET street = 'Wall'
WHERE address_id = 21;

COMMIT TRANSACTION;

ROLLBACK TRANSACTION;

-- Does a DDL command cause open transactions to be committed?
CREATE TABLE dummy
(id int);

DROP TABLE dummy;