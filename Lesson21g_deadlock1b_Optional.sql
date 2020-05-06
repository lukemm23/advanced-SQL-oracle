--  Deadlocking Step 2
--  Highlight BOTH UPDATE commands below and execute
--  This will cause a LIVELOCK, but not a deadlock.
--- Then return to docklock1a.sql and continue instructions.


UPDATE assignment
SET consultant_id = 1
WHERE assignment_id = 19;

UPDATE consultant
SET last_name = 'Lee'
WHERE consultant_id = 11;


ROLLBACK TRANSACTION;

