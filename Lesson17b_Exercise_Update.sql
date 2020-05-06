-- UPDATE Exercises
-- For these exercises, please hardcode only the names and numbers
-- mentioned in the question.
-- (1) The consultant with id 8 is moving to address_id 13.  Update the 
-- consultant table.



-- (2) All consultants named 'Bill' would like to be known as "William".



-- (3) Consultant Kareem Said is moving to the only address on 'Brimley Mansions' 
-- street.  Write the necessary UPDATE statement to change his address but 
-- please hardcode only 'Kareem', 'Said', and write a subquery to lookup the 
-- address_id for 'Brimley Mansions'.




-- (4) Three of the clients have decided to use their own flat pay rate for all
-- assignments.  The following will create a table and the pay rates.
CREATE TABLE pay_rates
(client_id NUMBER(4) PRIMARY KEY,
pay        NUMBER(8,2));
INSERT INTO pay_rates VALUES (1,300);
INSERT INTO pay_rates VALUES (2,700);
INSERT INTO pay_rates VALUES (3,425);
COMMIT;
-- Write a single update statement that will update all of the assignment
-- records for these clients.  Use a correlated subquery to lookup the 
-- pay rate for each assignment record.






-- (5) Challenge Exercise:   Currency Conversion Exercise 
/*
Use the following code to add a column to the stock_prices table 
called PRICE_EURO. */

ALTER TABLE stock_price
 ADD price_EURO NUMBER(10,4);


/* Your task is to Write an UPDATE statement to calculate the value for the PRICE_EURO column.

The following queries are provided as hints for number 5.  Please read:
*/

-- Show Stock Prices, displaying the original currency symbol and the 
-- currencies converted to Euro.
SELECT 
  sp.price,  
  c.symbol from_symbol,
  c_euro.symbol to_symbol, 
  conv.exchange_rate , 
  sp.price * conv.exchange_rate AS Price_Euro
FROM stock_price sp
  JOIN stock_exchange se
    ON se.stock_ex_id = sp.stock_ex_id
  JOIN currency c
    ON c.currency_id = se.currency_id
  JOIN conversion conv
    ON conv.from_currency_id = se.currency_id
  JOIN currency c_euro
    ON c_euro.currency_id = conv.to_currency_id
WHERE c_euro.name = 'Euro';

-- Show stock prices and the prices converted to Euro.
-- (This version uses a correlated subquery as a column.)
SELECT 
  sp.stock_id,
  sp.stock_ex_id,
  sp.time_start,
  sp.price,    
  sp.price * (SELECT exchange_rate
                    FROM conversion c
                       JOIN stock_exchange se
                          ON c.from_currency_id = se.currency_id
                          AND c.to_currency_id = 2
                     WHERE se.stock_ex_id = sp.stock_ex_id) AS Price_Euro
FROM stock_price sp
;


-- You need to complete the following:
UPDATE stock_price
 SET price_euro = price * (SELECT exchange_rate
                           FROM conversion 
                           WHERE ...)
;

