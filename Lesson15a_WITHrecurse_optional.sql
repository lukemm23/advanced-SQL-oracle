
/* Recursion and recusive algorithms.

Recursion is when a procedure/function calls itself.


Recursion :  Definition
     See recursion.
     
     
In order to understand recursion, 
you must first understand recursion.


Classic Example: factorial
factorial (5) = 5 * 4 * 3* 2* 1  
factorial (n) = n * (n-1) * (n-2) * ... * 1 

a recursive definition and algorithm would be
factorial (n) = n * factorial(n-1)


-- pseudocode
create procedure factorial (int n)
as
  if n = 1 then
     return 1
  else
     return n * factorial(n-1)
  end if
end

*/

/* Below is an  example of when we want to use recursion.  The goal is to 
generate a list of managers, and  their employees, and THEIR employees and 
so on...
*/

WITH direct_reports (consultant_id, first_name, last_name, boss_id, rank)
AS
(
    -- Anchor member definition
    SELECT 
       consultant_id,
       first_name, 
       last_name, 
       boss_id, 
       1 AS rank
    FROM consultant
    WHERE boss_id IS NULL
    UNION ALL
    -- Recursive member definition
    SELECT 
       sub.consultant_id,
       sub.first_name, 
       sub.last_name,
       sub.boss_id,
       d.rank + 1
    FROM direct_reports d
      INNER JOIN consultant sub
      ON sub.boss_id = d.consultant_id
)
SELECT *
FROM direct_reports
;


-- What is the maximum level?
WITH direct_reports (consultant_id, first_name, last_name, boss_id, rank)
AS
(
-- Anchor member definition
    SELECT 
       consultant_id,
       first_name, 
       last_name, 
       boss_id, 
       1 AS rank
    FROM consultant
    WHERE boss_id IS NULL
    UNION ALL
 -- Recursive member definition
    SELECT 
       sub.consultant_id,
       sub.first_name, 
       sub.last_name,
       sub.boss_id,
       d.rank + 1
    FROM direct_reports d
      INNER JOIN consultant sub
      ON sub.boss_id = d.consultant_id
)
SELECT MAX(rank)
FROM direct_reports
;

