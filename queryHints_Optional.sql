-- use rule based optimization
select /*+ RULE */
* 
FROM address a
  JOIN consultant c
    ON c.address_id = a.address_id;
    
    
-- use nested loops
select /*+ USE_NL (c a) */
* 
FROM address a
  JOIN consultant c
    ON c.address_id = a.address_id;    
    
    
-- use hashing
select /*+ USE_HASH (c a) */
* 
FROM address a
  JOIN consultant c
    ON c.address_id = a.address_id;    

select /*+ USE_MERGE (c a) */
* 
FROM address a
  JOIN consultant c
    ON c.address_id = a.address_id;    