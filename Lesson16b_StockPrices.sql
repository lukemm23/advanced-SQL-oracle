/*
Objective:
Understand queries involving time.
*/


/* These queries may help you to understand the data model.

trade.shares         is the number of shares being traded.
stock_price.price    has the price of per share.

trade.price_total   is the total cost of the trade.

trade.price_total - (trade.shares * stock_price.price) is how much the broker earned for the trade.
  
*/

-- This query assumes that prices do not change throughout the day 
-- Of course, in reality this is not the case.
SELECT 
   t.trade_id,
   t.stock_id,
   to_char(t.transaction_time,'yyyy-mon-dd'),
   t.shares,
   sp.price,
   t.shares * sp.price AS calctotal,
   t.price_total,
   t.price_total - (t.shares * sp.price) AS BrokerProfit
FROM trade t
  JOIN stock_price sp
     ON sp.stock_id = t.stock_id
       AND sp.stock_ex_id = t.stock_ex_id
       AND trunc(sp.time_start,'dd') = trunc(t.transaction_time,'dd')
ORDER BY t.trade_id, t.stock_id, t.transaction_time;

/*
The following query will fail.
However, if the time_start and time_end were both present and correctly
populated then the query would successfully find the trade and the 
current price at the time of the trade.
*/
SELECT 
   t.trade_id,
   t.stock_id,
   to_char(t.transaction_time,'yyyy-mon-dd'),
   t.shares,
   sp.price,
   t.shares * sp.price AS calctotal,
   t.price_total,
   t.price_total - (t.shares * sp.price) AS BrokerProfit
FROM trade t
  JOIN stock_price sp
     ON sp.stock_id = t.stock_id
       AND sp.stock_ex_id = t.stock_ex_id
       AND sp.time_start <= t.transaction_time
       AND (sp.time_end > t.transaction_time
         OR sp.time_end IS NULL)
ORDER BY t.trade_id, t.stock_id, t.transaction_time;


-- This query allows prices to change, and picks up the price that would 
-- be in effect when the trade occurs, and only a time_start is available
-- (no end time).
SELECT 
   t.trade_id,
   t.stock_id,
   to_char(t.transaction_time,'yyyy-mon-dd'),
   t.shares,
   sp.price,
   t.shares * sp.price AS calctotal,
   t.price_total,
   t.price_total - (t.shares * sp.price) AS BrokerProfit
FROM trade t
  JOIN stock_price sp
     ON sp.stock_id = t.stock_id
       AND sp.stock_ex_id = t.stock_ex_id
       AND sp.time_start = (SELECT MAX(sub.time_start)
                            FROM stock_price sub
                            WHERE sub.stock_id = t.stock_id
                              AND sub.stock_ex_id = t.stock_ex_id
                              AND sub.time_start <= t.transaction_time)
ORDER BY t.trade_id, t.stock_id, t.transaction_time;










