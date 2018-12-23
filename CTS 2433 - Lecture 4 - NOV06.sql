
-- November 06 2018
-- CTS 2433

USE AdventureWorks2017;

SELECT PersonPhone.BusinessEntityID, FirstName, LastName, MiddleName, PhoneNumber
FROM Person.Person INNER JOIN Person.PersonPhone
	ON Person.BusinessEntityID = PersonPhone.BusinessEntityID
ORDER BY LastName, FirstName, Person.BusinessEntityID;
/*	In the above query I am selecting the following fields from the tables: BusinessEntityID, FirstName, 
	LastName, MiddleName, PhoneNumber from the two tables 'Person' (FirstName, LastName, MiddleName) and 
	the 'PersonPhone' (BusinessEntityID, PhoneNumber). We are using the FROM statement with the 'Person' 
	table and combining the other table 'PersonPhone' using the INNER JOIN keywords. These two tables are
	being specified to join on the fields 'BusinessEntityID' on each table by writing: 
	"Person.BusinessEntityID = PersonPhone.BusinessEntityID". This is how the two table will be linked in 
	order to get the corresponding phone number for the People in the 'Person' table.
	*/

SELECT PersonPhone.BusinessEntityID, FirstName, LastName, MiddleName = ISNULL(MiddleName, 'No Middle Name'), PhoneNumber
FROM Person.Person INNER JOIN Person.PersonPhone
	ON Person.BusinessEntityID = PersonPhone.BusinessEntityID
ORDER BY LastName, FirstName, Person.BusinessEntityID;
/*	The above query is exactly the same as my previous query but instead of leaving the MiddleName column as 
	a blank field I want to combine the MiddleName field with the ISNULL function in order to return a new 
	value in place of NULL. I do this by specifiying "MiddleName" which is a new field, not the original column 
	to be equal to the ISNULL function. Using the ISNULL function I specify its parameters to check the MiddleName 
	field from the 'Person' table and if the field is a NULL value I want the record to return the string 'NMN' which
	means NO MIDDLE NAME.
	*/

SELECT Person.BusinessEntityAddress.BusinessEntityID, AddressID, AddressTypeID, ContactTypeID
FROM Person.BusinessEntityAddress INNER JOIN Person.BusinessEntityContact
	ON Person.BusinessEntityAddress.BusinessEntityID = Person.BusinessEntityContact.BusinessEntityID
ORDER BY AddressID, AddressTypeID, Person.BusinessEntityAddress.BusinessEntityID;
/*	In the query above I am selecting the columns 'BusinessEntityID' from the 'BusinessEntityAddress' table, as well 
	as the 'AddressID', 'AddressTypeID'. 'ContactTypeID' is from the 'BusinessEntityContact' table. Our FROM 
	keyword indicates that we are pulling from the 'BusinessEntityAddress' table and the the INNER JOIN Keyword 
	indicates that we are joining the second table 'BusinessEntityContact'. We are using the ON statement to say 
	that we are joining the two 'BusinessEntityID' columns within each of them.
	*/

SELECT HE.LoginID, JobTitle, BirthDate, DepartmentID, ShiftID
FROM HumanResources.Employee AS HE INNER JOIN HumanResources.EmployeeDepartmentHistory AS HHist
ON HE.BusinessEntityID = HHist.BusinessEntityID 
WHERE ShiftID = 3
ORDER BY BirthDate ASC;
/*	Here I created my own query of my own creation with a INNER JOIN between the two tables 'Employee' from the 
	'HumanResources' schema and 'EmployeeDepartmentHistory' from the schema 'HumanResources'. The fields that I 
	specified are 'LoginID', 'JobTitle, 'BirthDate', 'DepartmentID', 'ShiftID'. The ladder two fields are from the 
	'EmployeeDepartmentHistory' table. For each of these tables the common field in both of them is the 'BusinessEntityID' 
	field which is what I indicated for the ON clause. After this I further filtered the results by 'ShiftID = 3' so 
	that I would receive the results of the night time crew. I then ordered my results by DESC order by the 'BirthDate' 
	field.

	Results are the following (First 2, last 2)
	LodinID						JobTitle						BirthDate	DeptID	ShiftID
	adventure-works\jo1			Janitor							1954-04-24	14		3
	adventure-works\jolynn0		Production Supervisor - WC60	1956-01-16	7		3
	...
	adventure-works\kathie0		Production Technician - WC45	1990-11-01	7		3
	adventure-works\michael1	Production Technician - WC40	1991-01-04	7		3
	*/

SELECT p.Name, s.DiscountPct
FROM Sales.SpecialOffer s 
INNER JOIN Sales.SpecialOfferProduct o ON s.SpecialOfferID = o.SpecialOfferID
INNER JOIN Production.Product p ON o.ProductID = p.ProductID
WHERE p.Name = 'All-Purpose Bike Stand';
/*	The above query is a really difficult query to grasp because of the twoo INNER JOINs being completed within it. 
	First the two columns I am selecting are from two different tables that do not have any common fields that can 
	be joined on. In order to Join the two tables, we will need to first join them with a common table that has keys 
	from both tables. In order to do this we will need to use the 'SpecialOfferProduct' table. In our select statement 
	we are retreiving 'Name' and 'DiscountPct' from two completely unrelated tables. Our FROM statement begins with the 
	'SpecialOffer' table and we will join it to our first table, which does not have any information that we need to 
	retrieve (Product). After this we will join to the next table using another INNER JOIN with the common table. From 
	this second INNER JOIN is where we are retrieving the field that we need, we are using the 'SpecialOfferProduct' 
	as our common link between the two table we need th fields from.

	The result is only the produc name and Discount we want for the product.
	All-Purpose Bike Stand		0.00
	*/

SELECT p.GroupName, s.JobTitle
FROM HumanResources.Employee s INNER JOIN HumanResources.EmployeeDepartmentHistory o
	ON s.BusinessEntityID = o.BusinessEntityID
INNER JOIN HumanResources.Department p
	ON o.DepartmentID = p.DepartmentID
WHERE p.Name = 'Sales'
ORDER BY 2;
/*	Here we are doing the same thing as the previous queries but we are now renaming the tables as a new name. We are using 
	the following tables in our joins: HumanResources.Employee AS 's', HumanResources.EmployeeDepartmentHistory AS 'o', 
	HumanResources.Department AS 'p'. We are retrieving the 'GroupName' field from the Department table and the 'JobTitle'
	field from the 'Employee' table. We are joining the two tables that have no fields in common by using the 
	'EmployeeDepartmentHistory' First we combine the Employee table to the EmployeeDepartmentHistory using the BusinessEntityID
	on both. Then we are joing the DepartmentID fields from both the Department and EmployeeDepartmentHistory.
	Finally we are filtering the Name field with the String 'Sales' and we are ordering it by column 2 or JobTile.
*/

SELECT he.LoginID, p.FirstName + ' ' + p.MiddleName + ' ' + p.LastName AS 'Name', pe.EmailAddress
FROM Person.Person AS p INNER JOIN HumanResources.Employee AS he
ON p.BusinessEntityID = he.BusinessEntityID
INNER JOIN Person.EmailAddress AS pe 
ON he.BusinessEntityID = pe.BusinessEntityID
WHERE p.EmailPromotion = 1
ORDER BY he.LoginID DESC;
/*  Here I am creating a query where I want the Names of the People along with thier LoginIds 
    and their Email addresses, my only filter is that it has to be the people with an email promotion set to Yes.
	First I retreieve the columns I want from my three tables. My columns are 'LoginID', 'FirstName', 'MiddleName', 
	'LastName', 'EmailAddress' from the tables 'Person', 'Employee', 'EmailAddress'. I see from my own personal 
	queries that the tables can all be joined by the 'BusinessEntityID' field. I execute my first inner join with 
	'BusinessEntityID' field of both 'Person' and 'Employee' then I execute my second inner join with the 
	'EmailAddress' and 'Employee'. After this I specify a WHERE clause to be 'EmailPromotion' equal to 1.
	This indicates that they receieve email notifications. Finally I use an ORDER BY caluse to order everything by 
	'LoginID'. For my results I only retrieve 61 people that match all my criteria. The query was successful.  */