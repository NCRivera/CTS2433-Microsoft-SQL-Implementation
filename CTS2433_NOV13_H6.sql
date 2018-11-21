-- Nicholas Rivera
-- CTS2433
-- November 13, 2018
-- Handout 6

USE AdventureWorks;

SELECT City 
	FROM Person.Address;
/*  In this query we are returning 19614 rows of information. No doubt some of these 
    records are going to be duplicated cities. This is not a practical way to observe 
	the records of this column, we will need a way to return only the unique values 
	in order to filter out much of the records.  */

SELECT DISTINCT City
	FROM Person.Address
	ORDER BY City;
/*  In this query we are returning only 575 rows of information. We can that when we 
    use the keyword 'DISTINCT' after the 'SELECT' this will return the unique values 
	in the column that we specified. We also sort the results of the query by the 
	'City' field which gives a more visually pleasing result.  */


SELECT  * FROM Sales.SalesOrderHeaderSalesReason ;
SELECT  * FROM Sales.SalesReason ;

SELECT DISTINCT t1.SalesReasonID, t2.Name, t2.ReasonType
	FROM Sales.SalesOrderHeaderSalesReason AS t1
	INNER JOIN Sales.SalesReason AS t2 ON t1.SalesReasonID = t2.SalesReasonID
	ORDER BY t1.SalesReasonID;
/*  In the query I created I wanted the distinct 'SalesReasonID' from 'SalesOrderHeaderSalesReason'
    (Alias as 't1'). I wanted the all the types of reasons on why customers purchased 
	their product so I had to JOIN two tables, the second table is 'SalesReason' which 
	contains the second and third field I want: 'Name' and 'ReasonType'. I inner joined 
	SalesReason on the 'SalesReasonID' field. I then ordered by SalesReasonID from 
	'SalesOrderHeaderSalesReason'.  */

SELECT City
	FROM Person.Address
	GROUP BY City
	ORDER BY City;
/*  In the following query, we retreive the distinct values by using the GROUP BY 
    statement in order to "group" the cities together. By grouping the cities together 
	and only retreiving the 'City' column we are able to get Distinct cities in this 
	way.  */

SELECT DISTINCT PostalCode FROM Person.Address ORDER BY PostalCode;
SELECT PostalCode
	FROM Person.Address
	GROUP BY PostalCode
	ORDER BY PostalCode;
/*  I am doing somthing similar to the previous query but I will select the distinct 
    values within the same table, but I am using 'PostalCode' column in place.  */

SELECT CardType 
	FROM Sales.CreditCard
	GROUP BY CardType
	ORDER BY CardType;
/*  In order to demonstrate getting distinct values by using the GROUP BY statement I 
    created my own query as well to demonstrate with only a few rows of information.
	I retrieve the distinct types of cards from the 'CreditCard' table.  */

SELECT TOP (5) ModifiedDate 
	FROM Production.ProductInventory
	GROUP BY ModifiedDate
	ORDER BY ModifiedDate DESC;
/*  The query begins with a SELECT statement along with the TOP keyword to retrieve the 
    first five rows in the column 'ModifiedDate' from the 'ProductInventory' table, after 
	this we are applying an method to retrieve the distinct values of the field, the 
	method is GROUP BY. After this we are retreiving the latest values in the records. I
	receieved back my results, I only retreive five dates. I do not think this would be a 
	critical task in a work setting as we are only retreiving some dates. I am unable 
	to find out anything from just the dates by themselves.  */


SELECT * FROM Production.ProductInventory;

SELECT TOP (10) Shelf, Bin, Quantity
	FROM Production.ProductInventory
	GROUP BY Shelf, Bin, Quantity
	ORDER BY Quantity DESC;
/*  Here I am running a query to retrieve the top 10 portion of my select query.
    In my query I am retreiving the 'Shelf', 'Bin', and 'Quantity' columns from the 
	table 'Production.ProductInventory'. This particular table is a great way to 
	use the GROUP BY clause as it contains many fields to categorize products. In my 
	query I use the GROUP BY clause for my data and finally I specify an ORDER BY 
	clause to order my results by the quantity in descending order. I do so because I 
	want the largest quantities to show up as my results for the query. 

	My results are below. We can see that my query worked as intended.
	F	5	924
	R	21	897
	B	4	888
	R	35	780
	E	39	763
	E	3	729
	J	3	724
	F	4	715
	R	29	710
	F	11	702   */

DECLARE @FirstHireDate DATE, @LastHireDate DATE;
SELECT @FirstHireDate = MIN(HireDate), @LastHireDate = MAX(HireDate)
FROM HumanResources.Employee;
SELECT @FirstHireDate AS FirstHireDate, @LastHireDate AS LastHireDate;
/*  The above query retreives the Minimum value within the field 'FirstHireDate' and the
    maximum field of the 'LastHireDate' field. All of this is from the 'HumanResources.Employee'
	We are able to retrieve these values from the specified table by placing them within 
	two variables. The two variables are: '@FirstHireDate' and '@LastHireDate' with the date 
	data type. In order to see what was placed with the variables we use a SELECT statement
	to retrieve the records inside the variables. 
	
	This is interesting because we seem to be retrieving two records from separate rows into 
	a single row, I feel this is a useful feature of variables as we can retrieve multiple 
	pieces of information into a single row instead of retrieving multiple rows. I do not 
	believe this is error prone unless the query contains an error within it.  */

DECLARE @AverageRate money, @EndofDayRate money;
SELECT @AverageRate = MAX(AverageRate), @EndofDayRate = MAX(AverageRate)
FROM Sales.CurrencyRate;
SELECT @AverageRate AS AverageRate, @EndofDayRate AS EndofDayRate;
/*  In this particular case, I do not believe that this particular use of variables is a great 
    use due to the specified query. These MAX() functions do not retrieve too much information
	due to the nature of the fields. The max average of currrency exchange does not contain
	any type of evaluation.  */

SELECT MAX(PhoneNumberTypeID) FROM Person.PersonPhone GROUP BY PhoneNumberTypeID; -- Contains 3 records, not what I wanted but is this ordered in who has the most?
SELECT MIN(PhoneNumberTypeID) FROM Person.PersonPhone GROUP BY PhoneNumberTypeID; -- Same results, seems like my query is not explicit enough.
SELECT COUNT(*) FROM Person.PersonPhone WHERE PhoneNumberTypeID = 3; -- Contains   736 rows
DECLARE @LeastUsedPhoneType VARCHAR (20);
SELECT @LeastUsedPhoneType = Name 
FROM Person.PersonPhone AS pp
INNER JOIN Person.PhoneNumberType AS pp2 ON pp.PhoneNumberTypeID = pp2.PhoneNumberTypeID
WHERE pp2.PhoneNumberTypeID = 3
GROUP BY Name;
SELECT @LeastUsedPhoneType AS LEAST_USED_CONTACT_TYPE;
/*  In my query above I tried to use a COUNT(), MIN(), MAX() functions query to retrieve 
    the information I needed. I was not able to retrieve the information I wanted with 
	the MAX and MIN functions but count gave me what I needed as it specifically counts 
	the rows in the results. I created a Variable and a query to return the observations 
	I made with the previous select queries and returned the result using the field 'LEAST_USED_CONTACT_TYPE' */




CREATE FUNCTION dbo.fn_WorkOrderRouting (@WorkOrderID INT) 
RETURNS TABLE
AS
RETURN
	SELECT 
		WorkOrderID, 
		ProductID, 
		OperationSequence, 
		LocationID
	FROM Production.WorkOrderRouting
	WHERE WorkOrderID = @WorkOrderID;
GO
SELECT TOP (5) w.WorkOrderID, w.OrderQty, w.ProductID, r.ProductID, r.OperationSequence
FROM Production.WorkOrder w
CROSS APPLY dbo.fn_WorkOrderRouting(w.WorkOrderID) AS r
ORDER BY w.WorkOrderID, w.OrderQty, r.ProductID;
/*  I do not actually know what happpened to this query, as it did not work on completely. I 
    believe I tried creating it more than once and I have effected rows in my database so 
	I do not want to try to do it again. I will try to interpret the query without running 
	it again. My results form the query that ran are below.
	
	-----
	Msg 2714, Level 16, State 3, Procedure fn_WorkOrderRouting, Line 2 [Batch Start Line 143]
	There is already an object named 'fn_WorkOrderRouting' in the database.

	(5 rows affected)
	-----

	I can tell from the function that we want to return a table a table within the function 
	with the SELECT statement. This statement is our TABLE.
	After this we use another SELECT statement to return results in order to put into the 
	table created by the function. 

	I tried running the query on a fresh table AdventureWorks, and receive the following results.
	13	4	747	1
	13	4	747	2
	13	4	747	3
	13	4	747	4
	13	4	747	6

	As I said before, I'm not understanding the entire function process but it seems like we 
	are placing a table within a function and then returning results into the table.
*/

CREATE FUNCTION dbo.fn_WorkOrderRouting2 (@WorkOrderID2 INT) 
RETURNS TABLE
AS
RETURN
	SELECT 
		WorkOrderID, 
		ProductID, 
		OperationSequence, 
		LocationID
	FROM Production.WorkOrderRouting
	WHERE WorkOrderID = @WorkOrderID2;
GO
SELECT TOP (10) w.WorkOrderID, w.OrderQty, w.ProductID, r.ProductID, r.OperationSequence
FROM Production.WorkOrder w
CROSS APPLY dbo.fn_WorkOrderRouting(w.WorkOrderID) AS r
ORDER BY w.WorkOrderID, w.OrderQty, r.ProductID;
/*  Since I do not understand what is happening with the funtion we used previous I attempted 
    to do it again, this time changing the query to return the top 10 results. I created the 
	same variable but instead gave it the ending '2'. This is to differentiate between the two 
	functions created. I tried running the function part of the query, and then the select part 
	of the query and this seems to fix the previous issue I was having before. I now receive 10 
	results. This matches what I said before where we seem to be creating a sort of table variable 
	with the creation of the function and then returning results onto this table using another 
	select statement. Functions are quite dificult if this is how they are generally used. I do not
	understand them which is why I could not create my own uniwue function. 
	My results:
	13	4	747	747	1
	13	4	747	747	2
	13	4	747	747	3
	13	4	747	747	4
	13	4	747	747	6
	13	4	747	747	7
	14	2	748	748	1
	14	2	748	748	2
	14	2	748	748	3
	14	2	748	748	5  */