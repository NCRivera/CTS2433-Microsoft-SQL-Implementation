SELECT 
	h.SalesOrderID, 
	h.CreditCardApprovalCode,
	CreditApprovalCode_Display = ISNULL(h.CreditCardApprovalCode,'**NO APPROVAL**')
FROM Sales.SalesOrderHeader h;
/*	For this query we are beginning with the primary key of salesorderID, the column CreditCardApprovalCode, 
	and a created column called CreditCardApprovalCode_Display. All of these fields are from the SalesOrderHeader 
	table from the Sales schema, they are called h for our query. In the query our created column called 
	'CreditApprovalCode_Display' will have the function ISNULL within it. ISNULL will look at the 'CreditCardApprovalCode' 
	and if it is null we inidicate that '**NO APPROVAL**' will be displayed.
	
	Results below include a null example:

	44690	934964Vi21508	934964Vi21508
	44691	NULL			**NO APPROVAL**
	44692	NULL			**NO APPROVAL**
	44693	232757Vi45555	232757Vi45555
	44694	832866Vi86304	832866Vi86304
	*/
USE AdventureWorks2017;

SELECT * FROM Sales.Customer;

SELECT SC.CustomerID, SC.StoreID,-- SC.PersonID, 
	IS_STORE = ISNULL(SC.StoreID, '0')
	FROM Sales.Customer AS SC WHERE SC.CustomerID > 10000;
/*	I created a simple query for this example as it is a difficult function for me to grasp.
	First I wanted the customer id and the store id from the Customers table in the sales schema.
	Here I then createthe IS_STORE column to contin my ISNULL function. I want the function to 
	return 0 when there is a null value withiin the StoreID column. I first attempted to return a
	string of text but it did not work because they were both incompatible data types, I don't 
	know how to resolve this as of yet. I indicated that the customerid has to be grater than 10000 
	to reduce my results more. My query returned 19119 rows of recoords and it seems my isnull 
	function did return 0 when there was a null in StoreID. The other odd thing is that if it was 
	not null it would return the Customer ID value, I don't know why this is the case.
*/


SELECT BusinessEntityID, OrganizationNode
	FROM HumanResources.Employee
		WHERE OrganizationNode IS NULL;
/*	In comparison, this is a reativey easy query. We are returning the results of the two fields 
	BusinessEntityID and OrganizationNode from the Employee table of the HumanResources Schema and 
	we are filtering it by the OrganizationNode field, where it is NULL.
	The query results in only one record returning, the ID is 1 and the OrganizationNode record is NULL.
	*/

SELECT 
	TOP 5 * 
FROM Person.Person;
/*	Here I am selecting the first five records from the Person table, the results that return are sorted 
	by the Primary key which is the BusinessEntityID. Using the TOP syntax is a good idea when you want 
	to take a look at the fields of a table without using the wildcard character. If you were to use a 
	wildcard character in a select statement with a table that contains millions of records, it wwould 
	not be a practical method to apply in those cases.
	*/

SELECT r.WorkOrderID, r.ProductID,
	StartDateVariance = AVG(DATEDIFF(day, DueDate, EndDate)),
	StartDateVariance_Adjusted = AVG(NULLIF(DATEDIFF(day, DueDate, EndDate), 0))
FROM Production.WorkOrder r
GROUP BY r.WorkOrderID, r.ProductID
ORDER BY r.WorkOrderID, r.ProductID;
/*	This is an interesting query as it is combining multiple functions within each other to return specific 
	results. The query is selecting from the table WorkOrder which is indicated to be known as r. The query 
	is retreiving WorkOrderID as well as ProductID field from the table. The query then creates two fields called 
	StartDateVariance and StartDateVariance_Adjusted, both contain multiple functions. The StartDateVariance field
	uses the DATEDIFF function to return the difference between the Due Date and End Date fields and returns 
	the amount in days, after this we are using the AVG function to get the average amount of days.
	StartDateVariance_Adjusted field uses the DATEDIFF function to return the difference between the Due Date 
	and End Date fields and returns the amount in days, after this it uses the NULLIF function to eliminate the 
	NULL fields. After this we are then using the AVG function to get the average amount of days like the previous field.
	This NULLIF function returns null values in the adjusted column because it eliinates all the fields that were 
	not needed instead of being interpreted by the previous field we created which returns 0 if it was NULL.
	*/

SELECT HRE.Gender, HRE.MaritalStatus,
	VacationHOURS_AVG = AVG(VacationHours),
	SickHOURS_AVG = AVG(SickLeaveHours), 
	TotalHours_AVG = (AVG(VacationHours) - AVG(SickLeaveHours))
FROM HumanResources.Employee AS HRE
GROUP BY HRE.Gender, HRE.MaritalStatus
ORDER BY HRE.Gender, HRE.MaritalStatus DESC;
/*	I created a query to compare the difference between the two genders and their vacation/sick hours in order 
	to see who has the greater amount of hours. I took into acount the marital status as well to see if there 
	would be a difference based on this. From the Employee Table in the Human resources schema I retreived the 
	Gender and MaritalStatus Column. I created three new columns to call the AVG function on: VacationHOURS_AVG,
	SickHOURS_AVG, TotalHours_AVG. VacationHOURS_AVG will take the average of the VacationHours field, SickHOURS_AVG 
	will take the average of the field SickLeaveHours, TotalHours_AVG will take the average of both SickHours and 
	Vacation Hours. I tried calling the fields I created but I received an error. In the GROUP BY clause I grouped 
	by gender and marital status and in the ORDER BY clause I ordered by the same as well except I used descending 
	order in Marital status.

	My results are the following: 
	F	S	56	48	8
	F	M	48	44	4
	M	S	52	46	6
	M	M	47	43	4

	There doesn't seemt o be much difference in terms of gender and Marriage status:
	The women seems to have more hours on average and those who are married have less 
	hours in both categories. Everyone has more vacation hours then sick hours, single 
	people have more hours total then married.
	*/