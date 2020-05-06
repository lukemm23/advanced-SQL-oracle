/* Dead Lock 
To setup a deadlock, you need two 
instances of SQL Developer.  Load Deadlock1a
into one instance and Deadlock1b in the other.

Deadlocking Step 1:
Highlight the UPDATE consultant command 
below and execute. 
Then switch to deadlock1b for Deadlocking 
Step 2
*/
UPDATE consultant
SET first_name = 'Sarah'
WHERE consultant_id = 11;

-- switch now to deadlock1b for the next step...

/* Dead Locking: Step 3
Highlight the UPDATE assignment command below
and execute.  This should cause a deadlock.
*/
UPDATE assignment
SET consultant_id = 2
WHERE assignment_id = 19;


COMMIT TRANSACTION;

ROLLBACK TRANSACTION;
