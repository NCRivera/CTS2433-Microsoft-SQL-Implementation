
-- November 08 2018
-- CTS 2433

USE AdventureWorks2017;

SELECT SUM(i.DiscountPct) AS Total 
FROM Sales.SpecialOffer i;
/*  Straightforward query, we are taking the sum of the values in 'DiscountPct' and adding them all 
    together using the SUM function.  */

SELECT SUM(PT.Quantity) AS Quantity_Total 
FROM Production.TransactionHistory AS PT;
/*  I created my own query using the sum function. I took the field 'Quantity' and counted the records
    in the field. I received back 'Quantity_Total' which was '3977209'.  */

SELECT OrderDate, SUM(TotalDue) AS TotalDueByOrderDate 
/*  Our SELECT statement is taking the 'OrderDate' and we are calling the SUM() function on the 'TotalDue' 
    column and returning it as a new column called 'TotalDueByOrderDate'  */
FROM Sales.SalesOrderHeader 
WHERE OrderDate >= '2014-06-01' 
GROUP BY OrderDate;
/*  Our FROM statement retrieves the results from the 'SalesOrderHeader' and the WHERE clause indicates
    that we want the results to have the 'OrderDate' greater than or equal to June 01, 2014. Finally, 
	the results will be GROUP BY 'OrderDate'.
	
	RESULTS:
	2014-06-21 00:00:00.000	2015.4322
    2014-06-04 00:00:00.000	1360.9299
    2014-06-07 00:00:00.000	2791.088
    2014-06-27 00:00:00.000	1931.1761
    2014-06-13 00:00:00.000	2110.5399
    2014-06-24 00:00:00.000	1493.143  */

SELECT ssod.CarrierTrackingNumber, SUM(LineTotal) AS TOTAL_SALES_CARRIER 
FROM Sales.SalesOrderDetail AS ssod
WHERE ssod.ModifiedDate BETWEEN '2011-01-01' AND '2012-12-31'
GROUP BY ssod.CarrierTrackingNumber
ORDER BY ssod.CarrierTrackingNumber;
/*  The query I created begins with the 'CarrierTrackingNumber' as the grouping column. I use the 
    aggregating function SUM on the 'LineTotal' Field and I am aliasing it to 'TOTAL_SALES_CARRIER'
	I then group the aggregated data by 'CarrierTrackingNumber'and finally i also order by 
	'CarrierTrackingNumber'
	
	First few results of my query follow:

	NULL	10253720.160700
	0083-444C-8D	419.458900
	00A2-4AD1-88	86.521200
	00C8-44A6-B1	4294.943800
	00EC-47DF-BB	6223.390525
	0161-4740-91	838.917800
	017E-486E-BC	15842.625800  */

SELECT s.ModifiedDate, COUNT(w.MaxQty) AS Cnt 
FROM Sales.SpecialOfferProduct s INNER JOIN Sales.SpecialOffer w ON s.SpecialOfferID = w.SpecialOfferID 
GROUP BY s.ModifiedDate 
HAVING COUNT(*) > 25;
/*  We are using the SELECT statement to retrieve the 'ModifiedDate' and 'MaxQty' using the COUNT() 
    function as 'cnt'. We are joing two of the tables because we are retrieving two columns from 
	different different tables. We group by 'ModifiedDate' and we are filtering our agregated data by 
	a count of more than 25.
	
	The results of the query is odd as I am receiving to values of 0 in the cnt field. I am going to 
	run another query without using the aggregate functions so that I ccan view the results without 
	the added functions.  */
	
SELECT s.ModifiedDate, w.MaxQty FROM Sales.SpecialOfferProduct s INNER JOIN Sales.SpecialOffer w ON s.SpecialOfferID = w.SpecialOfferID;  
	
/*  After running my query above I see that there are NULL values within the 'MaxQty'. I believe this is 
	havving an effect on my results. I believe that the original query is counting the number of NULL values.
	The query is correct syntactically but results are not what we want in them. In order to fix my original 
	query I will need to specify the 'MaxQty' in my HAVING clause in order to correct the results of the 
	query.  */

SELECT s.ModifiedDate, COUNT(w.MaxQty) AS Cnt 
FROM Sales.SpecialOfferProduct s 
INNER JOIN Sales.SpecialOffer w ON s.SpecialOfferID = w.SpecialOfferID 
GROUP BY s.ModifiedDate 
HAVING COUNT(w.MaxQty) > 25;
/*  Here is the query that returns just one row with the HAVING clause of my query being properly applied.
    In place of two 0 values, nothing now shows that does not fit the criteria.  */

SELECT  i.UnitPrice, i.PurchaseOrderID, SUM(i.ReceivedQty) AS Total 
FROM Purchasing.PurchaseOrderDetail i 
GROUP BY CUBE(i.UnitPrice, i.PurchaseOrderID);

/*  In the query we are querying two columns: 'UnitPrice', 'PurchaseOrderID'. We are using the aggregate 
    SUM function on 'ReceivedQty' and aliasing it as ''Total'. In the GROUP BY clause, we add the keyword 
	CUBE and within a parenthesis we add our two columns which we group by 'UnitPrice', 'PurchaseOrderID'.
	From our results, I can see that we receive back many NULL values after each 'PurchaseOrderID'. I can 
	see from this that after each unique value within a 'PurchaseOrderID' we receive back a total from each
	row of a 'UnitPrice'For example the 'PurchaseOrderID' of '2' has two UnitPrice values and two 'Total'
	records that equal 3, the NULL value of PurchaseOrderID contains a sum of the two 'Total' records from 
	the previous records, which total 6. We can replace these NULL values with an entry of a similar data 
	type using the ISNULL function I will now create the same query but replace the NULLs.  */

SELECT  ISNULL(i.UnitPrice, 0) AS UnitPrice, i.PurchaseOrderID, SUM(i.ReceivedQty) AS Total 
FROM Purchasing.PurchaseOrderDetail i 
GROUP BY CUBE(i.UnitPrice, i.PurchaseOrderID);
/*  I was able to successfully replace my NULL values with a 0 value. Since these fields contain money data 
    types, I cannot remove the trailing 0's that follow my value. I'm not able to return a string in NULL 
	values as well since a different data type cannot be mixed with another in the field.  */

SELECT PurchaseOrderDetailID = ISNULL(PurchaseOrderDetailID, 0), PurchaseOrderID, SUM(LineTotal) AS LineTotal_TOTAL
FROM Purchasing.PurchaseOrderDetail 
GROUP BY CUBE(PurchaseOrderDetailID, PurchaseOrderID);
/*  Here I believe I created a good example query to demonstrate the function of the CUBE Keyword. The 
    select statement chooses the 'PurchaseOrderDetailID', 'PurchaseOrderID' and I use the aggregate on the 
	'LineTotal' column. I wrap the two fields I am selecting with the GROUP BY clause followed by the CUBE 
	keyword. LineTotal is a good measurement because the NULL row will return the total of all 'LineTotals'.
	My NULL rows are also being returned as 0 because there is no 0 in the PurchaseOrderDetailID.  */

SELECT i.Shelf, p.Name, SUM(i.Quantity) AS Total 
FROM Production.ProductInventory i 
INNER JOIN Production.Product p ON i.ProductID = p.ProductID 
GROUP BY ROLLUP(i.Shelf, p.Name);
/*  Our select statement retrieves the results of the 'Shelf', 'Name', 'Quantity'. We are using the aggregating 
    function on the 'Quantity' column. Since we are using two different tables we must join the tables, we use 
	the INNER JOIN on 'ProductInventory' and 'Product' using the 'ProductID' fields on both tables in the ON 
	keyword. After this we use the GROUP BY clause to sort the aggregated data, except we are containing the 
	fields that we are going to group by in the Keyword ROLLUP. From the results we can see that we are doing 
	something similar to the CUBE keyword previously used. We are getting a total of column 'Total' for each 
	'Name' on the 'Shelf'. Looking at the end of the results we can see also that we receive a Grand Total of 
	all values in column 'Total'.  */

SELECT i.Shelf, p.Name, SUM(i.Quantity) AS Total 
FROM Production.ProductInventory i 
INNER JOIN Production.Product p ON i.ProductID = p.ProductID 
WHERE p.Name = 'Bearing Ball'
GROUP BY ROLLUP(i.Shelf, p.Name);
/*  In my own query, I want to demonstrate on a smaller scale what happens after using ROLLUP. I created a 
    similar query as before but this time I added a WHERE clause to indicate that I only want the columns 
	where the record is 'Bearing Ball'. I can see from my results that this particular item shows in both 
	'Shelf' of 'A' as well as 'B'. I receive a subtotal of the 'Total' column for the item and then a total 
	of the shelf for each. At the end I get a Grand Total of everything on the 'shelves' total which is 1109.
	
	Results:
	A		Bearing Ball	791
	A		NULL			791
	B		Bearing Ball	318
	B		NULL			318
	NULL	NULL			1109
	*/