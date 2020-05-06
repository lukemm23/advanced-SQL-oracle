/* INNER JOIN Exercises */
/* 1.	Show a listing of all consultants who live in Linlithgow and 
Whitecross (towns).  
*/

/* 2.	Re-write the previous query so that the tables are joined in a 
different order.  For example, if your query had “FROM consultant 
JOIN address” then change it to “FROM address JOIN consultant”.   
Does the query work both ways?  Change the ON criteria as well.  
If you had “ON c.address_id = a.address_id” then change it to 
“ON a.address_id = c.address_id”.  Does the query work both ways?
*/


/* 3.	List all clients in the towns of Falkirk and Armadale.
*/


/* 4.	Show a list of all consultants who have performed assignments.
Show the names of the clients they worked with and the comments for the 
assignment.
*/


/* 5.	Create a listing which shows consultants, the towns where they 
live, the assignment ids and the names of the clients for their 
assignments. Sort the records by town, and client name.
*/

--  Challenge Exercises --

/* 6.	Create a listing of consultants (name and town) and the clients 
(name, and town) for the jobs that they performed in their own home town.
*/


/* 7.	Show A listing which shows consultants, clients AND towns WHERE 
THE consultant lives IN THE town WHERE THE client’s office IS.  
(Disregard whether THE consultant has performed an assignment AT THE 
client site.  THE ONLY issue IS whether THE consultant lives IN THE town.)
*/
