-- Aggregation : Consultant Questions
--Write queries to output the following:
/* 1.	Total number of assignment rows.
*/

/* 2.	Total number of assignment rows if consultants have been 
allocated. Assignments can have null consultant_ids.
*/

/* 3.	Give the consultant's name and the number of assignment rows 
he or she is named on.
*/

/* 4.	Number of consultants who live in each town. Show zero if no 
consultants live in the town.
*/

/* 5.	Number of clients in each town. Show zero if there are no clients.
*/

/* 6.	Number of clients in each town but show only if the count is greater 
		than 2.
*/

/* 7.	Number of employees who report to each consultant.  Please give the 
consultant's full name and the number of people who report to this 
person.  Show zero if no one reports to this person.
*/

-- Aggregation:  Stock Market Schema
--Write queries that retrieve the following information :


/* 8.	List the stock exchanges and the number of brokers registered to trade 
			there.
*/

/* 9.	List the stock exchanges and count the distinct number of brokers 
		who have made trades there.
*/

/* 10.	For each broker, list the name of the exchanges where they have 
had trades and total money earned by the broker at the exchange.  To 
calculate the broker’s earning for each trade, use:
PRICE TOTAL – (SHARE_AMOUNT * SHARE_PRICE) 
Use the trade’s date to look up the daily price per share in the 
stock_price table.
*/


/* 11.	List stock exchanges and months that have more than 2 trades per 
month. Do not mistakenly group the same month from different years 
together.
*/

/* 12.	Average price for each stock traded at each exchange.  
Include the name of the company, the name of the stock exchange 
and the name of the currency.
*/

/* 13.	Average of stock prices per month per company at each stock exchange.
*/

/* 14.	A list of brokers ordered best to worst, in terms of number of trades 
made.
*/

/* 15.	Create a list of brokers and the number of trades each broker made.  
Add a CASE statement to display 'Excellent' when the number of trades is 
greater than 20, 'Good' if the number of trades is greater than 10, 'Zero' 
if the number of trades is zero, and 'Acceptable' for any other number.
*/


-- Challenge Exercises
--Write queries that retrieve the following information:


/* 16.	A list of brokers ordered best to worst, in terms of total sum of 
the price_totals for his or her trades.  Convert all currency 
amounts to the currency of your choice.  Feel free to hardcode the 
conversion.to_currency_id for the currency that you choose.
*/

/* 17.	For each broker at each stock exchange, compute the broker's 
average earnings per share.
*/

/* 18.	Compute each broker's average earning per share worldwide.   
Convert all currency amounts to US Dollars the same way you did in 
question 16.
*/

