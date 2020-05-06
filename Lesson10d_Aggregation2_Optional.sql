/*
Lesson Objectives  - Optional

Window Functions  - OVER Clause


Secondary Objectives - Also optional
GROUP BY ROLLUP
GROUP BY CUBE
GROUP BY GROUPING SETS
*/

/*  Window Functions 
 
  OVER ([PARTITION BY col [,...n] [ ORDER BY col [ , ...n] ])
*/

-- Let's look at the consultant_ids in the assignment table
SELECT 
   consultant_id
FROM assignment;  

-- Let's count the records in assignment table
SELECT count(*) 
FROM assignment;  
  
-- Display the consultant_id 
--  and the total number of records in the table
SELECT 
    consultant_id,
    COUNT(*) OVER ()
FROM assignment;

-- Compare pay to average overall pay
-- Show the pay and overal average side-by-side
SELECT 
    assignment_id,
    pay,
    ROUND(AVG(pay) OVER (),2)
FROM assignment;


/* OVER (ORDER BY) */

-- Number the rows in order of pay
SELECT 
   assignment_id,
   pay,
   row_number() OVER (ORDER BY pay DESC NULLS LAST)
FROM assignment
ORDER BY pay DESC;  -- try re-sorting by assignment_id



/* OVER (PARTITION BY) */

-- Compare pay to average for consultants in the town.
SELECT 
   A.town,
   c.first_name || ' ' || last_name,
   assign.pay,
   ROUND(AVG(assign.pay) OVER (),0) AS "Overall Average",
   AVG(assign.pay) OVER (PARTITION BY town) AS "Town Average"
FROM address A
   JOIN consultant c
     ON c.address_id = A.address_id
   JOIN assignment assign
     ON assign.consultant_id = c.consultant_id
;  


/* OVER (PARTITION BY col1 ORDER BY col2) */

-- number the consultants in each town
SELECT 
 first_name || ' ' || last_name, 
 town,
 ROW_NUMBER() OVER (PARTITION BY town ORDER BY first_name || ' ' || last_name)
FROM consultant c
 JOIN address A
   ON A.address_id = c.address_id
order by town, 3;



-- rank the assignments done for each client by pay amounts descending
SELECT 
 client_name,
 assignment_id,
 pay,
 RANK() OVER (PARTITION BY client_name ORDER BY pay DESC NULLS LAST)
FROM client c
 JOIN assignment A
   ON A.client_id = c.client_id
ORDER BY client_name, pay desc NULLS LAST;








/* Optional Secondary Objectives
GROUP BY ROLLUP,
GROUP BY CUBE,
GROUP BY GROUPING SETS,
GROUP_ID function


Run the TShirtData.sql script to create the data

*/


DESC tshirtdata

-- raw data
SELECT 
   MONTH,
   shirt_size,
   color,
   num_sold
FROM tshirtdata
ORDER BY MONTH, shirt_size, color;


-- summarized by month and color
SELECT 
  MONTH,
  color,
  SUM(num_sold) Total
FROM tshirtdata
GROUP BY month, color;

-- summarized by month, color with ROLLUP (month, color) 
SELECT 
  MONTH,
  color,
  SUM(num_sold) Total
FROM tshirtdata
GROUP BY ROLLUP (MONTH, color);

-- summarized by month, color with ROLLUP (color, month) 
SELECT 
  MONTH,
  color,
  SUM(num_sold) Total
FROM tshirtdata
GROUP BY ROLLUP (color, month);

-- summarized by month and color with CUBE
/* CUBE is a combination of the previous two rollups */
SELECT 
  MONTH,
  color,
  SUM(num_sold) Total
FROM tshirtdata
GROUP BY CUBE (MONTH, color);
 --MONTH, color;

-- CUBE with a single column is not at all interesting. 
SELECT 
  color,
  SUM(num_sold) Total
FROM tshirtdata
GROUP BY CUBE (color);

-- GROUP BY GROUPING SETS
SELECT 
  MONTH,
  color,
  SUM(num_sold) Total
FROM tshirtdata
GROUP BY GROUPING SETS ((MONTH, color));

SELECT 
  MONTH,
  color,
  SUM(num_sold) Total
FROM tshirtdata
GROUP BY GROUPING SETS ((MONTH, color),(MONTH));

SELECT 
  MONTH,
  color,
  SUM(num_sold) Total
FROM tshirtdata
GROUP BY GROUPING SETS ((MONTH, color),(MONTH),(COLOR),());

-- GROUPING, GROUPING ID 
SELECT 
  MONTH,
  color,
  GROUPING(MONTH) AS "Month Bit",
  GROUPING(color) AS "Color Bit",
  GROUPING_ID(MONTH, color) AS "Grouping ID",
  CASE GROUPING_ID(MONTH,color)
    WHEN 0 THEN 'Total for Month and Color'
    WHEN 1 THEN 'Total for Month'
    WHEN 2 THEN 'Total for Color'
    WHEN 3 THEN 'GRAND TOTAL'
    ELSE 'Something seriously wrong'
   END AS  GroupLevelDesc, 
  SUM(num_sold) Total
FROM tshirtdata
GROUP BY CUBE (MONTH, color);

SELECT 
  MONTH,
  color,
  shirt_SIZE as "SIZE",
  GROUPING(MONTH) AS "Month Bit",
  GROUPING(color) AS "Color Bit",
  GROUPING(shirt_size)  AS "Size Bit",
  GROUPING_ID(MONTH, color, shirt_size) AS "Grouping ID",
  CASE GROUPING_ID(MONTH,color, shirt_size)
    WHEN 0 THEN 'Raw Data'
    WHEN 1 THEN 'Total for Month AND Color'
    WHEN 2 THEN 'Total for Month AND Size'
    WHEN 3 THEN 'Total for Month'
    WHEN 4 THEN 'Total for Color AND Size'
    WHEN 5 THEN 'Total for Color'
    WHEN 6 THEN 'Total for Size'
    WHEN 7 THEN 'GRAND TOTAL'
    ELSE 'Something seriously wrong'
   END AS  GroupLevelDesc, 
  SUM(num_sold) Total
FROM tshirtdata
GROUP BY CUBE (MONTH, color, shirt_size);





