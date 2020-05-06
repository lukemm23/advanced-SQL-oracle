desc tshirtdata


SELECT 
  shirt_size,
  color,
  sum(num_sold)
FROM tshirtdata
group by shirt_size, color;

SELECT 
  shirt_size,
  sum( CASE color
       WHEN 'red' THEN num_sold
       END ) AS "Red",
  sum( CASE color
       WHEN 'blue' THEN num_sold
       END ) AS "Blue",
  sum( CASE color
       WHEN 'black' THEN num_sold
       END ) AS "Black"       
FROM tshirtdata
GROUP BY shirt_size;

SELECT 
  shirt_size,
  color,
   CASE color
       WHEN 'red' THEN num_sold
       END  AS "Red",
   CASE color
       WHEN 'blue' THEN num_sold
       END  AS "Blue",
   CASE color
       WHEN 'black' THEN num_sold
       END  AS "Black"       
FROM tshirtdata
;

SELECT *
FROM 
   (SELECT
      shirt_size AS shirt_size,
      color,
      num_sold
    FROM tshirtdata)
PIVOT ( sum(num_sold)
   FOR color IN ('red','blue','black'));
   

with TS AS
  (SELECT
      shirt_size AS shirt_size,
      color,
      num_sold
    FROM tshirtdata)
SELECT *
FROM TS
PIVOT ( MAX(num_sold)
   FOR color IN ('red','blue','black'));

WITH TS AS
  (SELECT
      shirt_size AS shirt_size,
      color,
      num_sold
    FROM tshirtdata)
SELECT *
FROM TS
PIVOT ( MAX(num_sold)
   FOR SHIRT_SIZE IN ('Small','Medium','Large'));


-- This does not work.
SELECT 
  UPPER(shirt_size) AS shirt_size,
  color,
  num_sold
FROM tshirtdata
PIVOT ( sum(num_sold)
   FOR color IN ('red','blue','black'));
   
   



