-- SubQuery Practice Exercises:  Set Three

/*
1/ (Level 3)	Show every combination of brokers and companies and count the 
number of trades handled by that broker for that company.  Broker/Company 
combinations that have zero trades should still be shown. 
TIP:  SELECT nvl(boss_id,0) FROM consultants will display a zero in any case 
where the boss_id is null.
*/

/* 2/ (Level 3)	I want to see how each broker’s total number of trades 
compares to the average number of trades.  Please put the broker’s name,
total number of trades he/she made and the average total number of trades 
on the same row.
*/

/* 3a/ (Level 1:  warm up)	Give me a list of all symbols for the 
stock_exchanges, the names of companies and the number of trades that 
were made by those companies at those stock_exchanges. (No subquery required 
for this one.)
*/

/* 3b/ (Level 3)	I would like to see the above output in the following 
"cross tab" format.  The numbers shown are the number of trades made on 
a company at a stock exchange.
NAME            EP      LSE       NYSE
BNP Paribas     2       0         0
British Airways 0       8         0
Google          0       0        19
IBM             0       8         0
TESCO           0       8         0
*/


/* 4/ (Level 4)	List the broker (first_name and last_name) with the second 
highest number of trades overall.
*/


/* 5/ (Level 4) The consultants are back to their idea of carpooling again.  
On each row in the result set list the number of people in the carpool, 
the name of the town where the consultants live, the consultants name, 
town, client id, and client name.  List ONLY the names of the consultant 
who should carpool.  (People who live in the same town, and are driving to 
the same client should carpool.)
*/

