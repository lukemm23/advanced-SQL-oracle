
/* Simple Arithmetic */
SELECT 
pay,
pay + 100,
pay - 100,
pay * 2,
pay / 5,
pay * pay
FROM assignment;


SELECT 
  abs(-6),
  ceil(2.2), 
  ceil(-2.9), 
  floor(-2.1),
  floor(2.9),
  round(12345.58765,0),
  trunc(2.9),
  trunc(-2.9),
  sign(-2),
  sign(100),
  sign(0)
FROM dual;

SELECT ROUND(1234.5678,-2)
FROM dual;


SELECT greatest(1, 5, 10, 6, 99, 11, 55)
FROM dual;

SELECT least(1, -5, 10, 6, 99, 11, 55)
FROM dual;

SELECT 
 pay,
 greatest(pay, 450)
FROM assignment;

SELECT 
  pay,
  least(pay, 200)
FROM assignment;

-- Convert string to number
SELECT 
   to_number('15,001','9,999,999,999')
FROM dual;

SELECT 
   to_number('15,001.05','9,999,999.99')
FROM dual;


SELECT 15001 + 5, to_number('15,001','9,999,999') + 5
FROM dual;
