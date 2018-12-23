USE AdventureWorks2017; -- I am now using the AdventureWorks Database to run my queries.

DECLARE @AddressLine1 nvarchar(60) = 'Heiderplatz';
SELECT AddressID, AddressLine1	
FROM Person.Address	
WHERE AddressLine1 LIKE '%' + @AddressLine1 + '%';	
/*	The Declare statement along with the @ symbol will create a new variable that will be 
	called @AddressLine1, nvarchar(60) indicates the length and data type of the data to 
	be stored in the variable. In this case it will be 'Heiderplatz'. The query will then 
	Select the fields from the Address table (in the person schema) called 'AddressID' and 
	'AddressLine1'. This is not the same as the Variable @AddressLine1. The WHERE clause 
	indicates that I want the records that have a similar string to that which is stored 
	in the declared variable. In other words Search AddressLine1 for records that contain 
	the string 'Heiderplatz'
	*/

DECLARE @TargetAddress nvarchar(20) = 'Birchwood'; 
SELECT AddressID AS ID, AddressLine1 AS Address
FROM Person.Address	
WHERE AddressLine1 LIKE '%' + @TargetAddress + '%'
ORDER BY 1 ASC;	
/*	The above query is based on the concepts of the first query except I make the Variable 
	very distinct from the field names. I also give the field names a 'nickname' to further 
	distinguish my fields and variables. I am now searching for the variable @TargetAddress 
	which contains the string 'Birchwood' when I declared it. I order the results by my 'ID' 
	column. The query results return 26 rows that are ordered by 'ID'. My first result is 
	ID "111" and the Address is "77 Birchwood".
	*/

DECLARE @AddressLine1 nvarchar (60);
DECLARE @AddressLine2 nvarchar (60);
SELECT @AddressLine1 = AddressLine1, @AddressLine2 = AddressLine2 
	FROM Person.Address
	WHERE AddressID = 66;
SELECT @AddressLine1 AS Address1, @AddressLine2 AS Address;
/*	In this example I am declaring two varibles without placing anything within them, called
	@AddressLine1 and @AddressLine2. After this I am selecting AddressLine1 and making it equal 
	to variable @AddressLine1 and making the field AddressLine2 equal to the variable 
	@AddressLine2. These fields are coming from the Address table and I am filtering the query 
	by the primary Key field to equal 66. This seems like this would return back results but it 
	does not. From here we have to select the actual variables to return the results we received 
	from the query where we initialized the variables. The result is "4775 Kentucky Dr." and 
	"Unit E".
	*/

DECLARE @Name nvarchar(50);
DECLARE @CostRate smallmoney;
 SELECT @Name = Name, @CostRate = CostRate
 FROM Production.Location
 WHERE LocationID = 66;
 SELECT @Name AS Name, @CostRate AS CostRate;
/*	The first two line are declaring my variables called @Name and @CostRate. Using the Select 
	statement we are initializing the two variables to equal name and costrate from the table 
	fields. We are retreiving the results from the Location table of the production schema and 
	we are filtering by the location id of 66. Again we are selecting the two variables and 
	naming them Name and CostRate. The query returns two NULL values because the variables are 
	empty. 	They are empty because there are no actual results that were returned, so the two 
	variables remain empty instead of returning anything. They reamin the same.
	*/
SELECT * FROM Person.StateProvince;

DECLARE @LocationName VARCHAR(50);
DECLARE @Code NVARCHAR(3);
SELECT @LocationName = Name, @Code = StateProvinceCode
FROM Person.StateProvince
WHERE StateProvinceID BETWEEN 60 AND 70;
SELECT @LocationName AS LOCNAME, @Code as ID;
/*	In my own personal query I am declaring two variables called @LocationName and @Code along 
	with their data types. Using a Select statement I am initializing the two variables to be 
	Name and StateProvinceCode with the filter of the numbers between 60 and 70. I then select 
	the variables as LOCNAME and ID. My query only returned one result. I think this is the case 
	because only one record can be contained at a time.
*/


DECLARE @QuerySelector int = 3;
IF @QuerySelector = 1 
	BEGIN 
		SELECT TOP 3 ProductID, Name, Color FROM Production.Product WHERE Color = 'Silver' ORDER BY Name 
	END 
ELSE 
	BEGIN 
		SELECT TOP 3 ProductID, Name, Color FROM Production.Product WHERE Color = 'Black' ORDER BY Name 
	END;
/*	Here we are beginning by declaring @QuerySelector to be 3. Now I am startinga IF statement 
	and with the BEGIN statement I am asking IF the query selector is equal to what comes after 
	the BEGIN. A select statement comes after the BEGIN statement and it returns the top 3 results 
	from the Product Table. This is the same case with the else portion of the if statement, it 
	is running a query depending on the criteria. In this case the Else statement is by itself, 
	so if the IF statement is not selected then the ELSE statement is selected.
	
	RESULTS:
	322	Chainring	Black
	863	Full-Finger Gloves, L	Black
	862	Full-Finger Gloves, M	Black
	*/

DECLARE @QuerySelector int = 1;
IF @QuerySelector = 1
	BEGIN 
		SELECT TOP 3 BusinessEntityID, PersonType, Title FROM Person.Person WHERE Title = 'Ms.' ORDER BY PersonType 
	END 
ELSE 
	BEGIN 
		SELECT TOP 3 BusinessEntityID, PersonType, Title FROM Person.Person WHERE Title = 'Mr.' ORDER BY PersonType 
	END;
/*	This query begins with a variable declaration of queryselector equal to one. Now when we begin 
	the IF and ELSE statements we are comparing the declared variable to the expression of the 
	statement. So the IF statement says that if the variable equals one, execute. If the IF Statement 
	does not execute the ELSE statement will execute.

	Our Results are:
	24	EM	Ms.
	13	EM	Ms.
	5	EM	Ms.
*/

DECLARE @Example int = 1;
IF @Example = 2
	BEGIN 
		SELECT AddressID, AddressLine1 FROM Person.Address WHERE AddressID < 10
	END 
ELSE 
	BEGIN 
		SELECT AddressID, AddressLine1 FROM Person.Address WHERE AddressID BETWEEN 10 AND 15
	END;
/*	Now here I am writing a new query using the IF and ELSE statements to demonstrate a use case. 
	Here I have a variable called @Example and I make it equal to 1. My first statement IF only 
	executes the select statement if the Variable equals 2. It will not run the IF statement, only 
	the ELSE statement because it equals 1.
	
	The results are:

	10	250 Race Court
	11	1318 Lasalle Street
	12	5415 San Gabriel Dr.
	13	9265 La Paz
	14	8157 W. Book
	15	4912 La Vuelta
	*/

SELECT DepartmentID AS DeptID, Name, GroupName, 
	CASE GroupName 
		WHEN 'Research and Development' THEN 'Room C' 
		ELSE 'Room D' 
	END AS ConfRoom 
FROM HumanResources.Department;
/*	This is a different sort of IF statement. In the cae when we have certain results we want a 
	new reult displayed in another field. For example in the example above: We Select three fields 
	from the Department Table and we want to return a fourth field depending on GroupName using the 
	CASE keyword. We are indicating that when GroupName field is 'Research and Development' return 
	'Room C'. With the Else statement, anythig else is 'Room D'. END AS with call the new field 
	ConfRoom and at the end we are specifying what table.
*/


SELECT LoginID, JobTitle, 
	CASE JobTitle
		WHEN 'Senior Tool Designer' THEN 'DESIGNER'
		WHEN 'Tool Designer' THEN 'DESIGNER'
		WHEN 'Senior Design Engineer' THEN 'ENGINEER'
		WHEN 'Design Engineer' THEN 'ENGINEER'
		WHEN 'Research and Development Engineer' THEN 'ENGINEER'
		WHEN 'Research and Development Manager' THEN 'R&D MNGR'
		ELSE 'N/A'
	END AS RoleName
FROM HumanResources.Employee
WHERE (VacationHours < 40) OR 
	(SickLeaveHours > 40) OR 
	(VacationHours + SickLeaveHours > 100);
/*	Like the previous example I am trying to come up with an example of using the CASE expressions.
	I indicated to my query that with the cases with Jobtitles I want 'DESIGNER' to show with 'Sr. 
	Tool Designer' and 'Tool Designer', I want 'ENGINEER' to show under rolenamme for 'Design Engineer' 
	and 'Sr. Designer Engineer' and 'Research and Development Engineer', finally I want the 'R and 
	D Manager' to return as 'R&D MNGR'. All of this will be from  the Employee table for the human 
	resources schema. I further filter the results by vacation hours and sick leave ours.
	*/

SELECT DepartmentID, Name,
	CASE 
		WHEN Name = 'Research and Development' THEN 'Room A'
		WHEN (Name = 'Sales and Marketing' OR DepartmentID = 10) THEN 'Room B'
		WHEN Name LIKE 'T%' THEN 'Room C'
		ELSE 'Room D' 
	END AS ConferenceRoom
FROM HumanResources.Department;
/*	This is an iteresting query because the case refers to the Name column but we do not have to 
	explicit state this. It seems to be that the field is implicit. As we can see from this query 
	we can further specify the case expressions in the manner of where statements. Really, CASE 
	expressions are WHERE clauses in their own manner, I want this result when we have this condition. 
	You can see everything we have ever used in a where clause such as the LIKE statement, OR, parentheses, 
	equals symbols can all be used in the WHERE clauses. The second WHEN clause is an example: The 
	condition is "Name = 'Sales and Marketing'" and "OR" and "DepartmentID = 10", then they are 'Room B'. 
	This seems very powerful to me.
	*/

SELECT * FROM Person.Person;

SELECT LastName + ', ' + FirstName EmployeeName, MiddleName,
	CASE
		WHEN MiddleName IS NULL THEN 'NO-MIDDLE-NAME'
		WHEN MiddleName LIKE 'M%' OR MiddleName LIKE 's%' THEN 'MUST GET WHOLE MIDDLE NAME'
		WHEN MiddleName IS NOT NULL THEN 'OK!'
		ELSE 'It is FINE'
	END AS 'Complete?'
FROM Person.Person
WHERE LastName LIKE 'RI%';
/*	I didn't want to get too complicated with my own query in this case as I ran into a lot of 
	trouble with it. In the beginning I tried to use an inner join to create a case expression 
	with two tables but it became too difficult to fix as I didn't recognize the errors I was receiving.
	
	In the above query I took the employee names and I need to create a message based on the 
	lastname and middle name. I created the case expression to indicate when there is no middle 
	name, an expression for when there is a specific lettered middle name, and a case expressions 
	for values that are not null. I have an else statement but I do not believe it will get used 
	because my final case expression statement for not null values takes care of those cases. I 
	used a where statement to further reduce my results to just those people with lastname beginning 
	with 'RI' as I do not want the entire table to be returned. My results return with 196 rows and 
	the case expressions seem to be working. See below for results.

	RESULTS
Richards, Dave		NULL	NO-MIDDLE-NAME
Richards, Thomas	M.		MUST GET WHOLE MIDDLE NAME
Richardson, Abigail	S		MUST GET WHOLE MIDDLE NAME
Richardson, Adrian	C		OK!
Richardson, Alex	E		OK!