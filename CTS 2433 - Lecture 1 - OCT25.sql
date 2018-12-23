USE AdventureWorks2017; -- Here I am connecting to the most current Adventure Works Database, "AdventureWorks2017"

SELECT NationalIDNumber, LoginID, JobTitle FROM HumanResources.Employee;
/*  In this Query I selected some fields from the Employee table under the Human resources schema. The NationalIDNumber
  looks like the Primary Key of this table as it seems to be unique to each of the Employees in this company. The
  loginID field contains the actual database and the ID of the user. The titles for each of the employees is shown on
  the last field.
  */

SELECT * FROM HumanResources.Employee;
/*  In this query I retreive all the fields from the table employees. There are a lot of fields in this, some examples
  are Date of birth, Marital Status Gender, and a few columns of salary information.
  */

SELECT Title, FirstName, LastName FROM Person.Person WHERE Title = 'Ms.';
/*  With this Query I selected the Title, First Name and last name of people from the person table with the filter
  "Ms." on the title field.
  */

SELECT Title, FirstName, LastName FROM Person.Person WHERE Title = 'Mr.';
/*  For this query I completed the same as above but I wanted to receive the people in the table with the title filtered
  as "Mr."
  */

SELECT FirstName + ' ' + MiddleName + ' ' + LastName AS "Full Name"
  FROM Person.Person
  WHERE MiddleName IS NOT NULL AND LastName LIKE 'Ri%'
    ORDER BY LastName, FirstName, MiddleName ASC;
/*  For the query I created I want the same information as the previous example query but I want the middle name, I also
  filter out any person without a middle name and with the last name beginning with "Ri". Then I order the results of 
  the query by the last name, first name, and middle name in an ascending order. The query returns 113 rows.
  */

-- Below I am testing out some operators as discussing the the lecture.
SELECT FirstName + ' ' + LastName
FROM Person.Person
WHERE LastName != 'Johnson';
/*  In this query I am testing out the does not equal operator, I am retreiving all the rows that do not have the 
  LastName field equal to Johnson. The row counts for this table is usally 19972 and we can see that we have 19884
  records returned to us in the results.
  */

SELECT BusinessEntityID AS "Employee ID",
VacationHours AS "Vacation",
SickLeaveHours AS "Sick Time"
FROM HumanResources.Employee;
/*  In this select query I selected the following columns: BusinessEntityID, VacationHours, SickLeaveHours. All of the
  fields are from the HumanResources.Employee. The "AS" T-SQL statement sets the name of the fields in my results to the
  string that is specified after it. So for my three fields they will be called: Employee ID, Vacation, and Sick Time.
  */

SELECT BusinessEntityID AS "Employee ID",
VacationHours + SickLeaveHours AS "AvailableTimeOff"
FROM HumanResources.Employee;
/*  Like the previous query, we are retrieving the same data as a previous example but instead of having three separate
  fields we are now combing two of those fields, specifically VacationHours and SickLeaveHours by using the "+" sign. As
  before we are renaming the fields to something else, BusinessEntityID is still going to be known as "Employee ID" but
  now the concatenation of the VacationHours and SickLeaveHours fields is called "AvailableTimeOff". The results of the
  query show us that the quantities in those fields have been are now summed together. I assume that certain data types
  will combine in this way.
  */

SELECT Gender + ' - ' + JobTitle + ' - ' + MaritalStatus AS "Gender, Title, Marital Status"
FROM HumanResources.Employee
ORDER BY Gender, OrganizationLevel, JobTitle ASC;
/*  In this query I am combining the three fields Gender, Title and Marital Status to return all the records of employees
  from the employee table and I am ordering it by Gender, then the Organizational Level (the lower the better), then the 
  job title if the Organizational level is equal. Previously I attempted to combine an integer data type with these 
  strings but the query came back as an error. It seems like I can't combine different data types, which is obvious in 
  hindsight.
  */

SELECT Title, FirstName, LastName
FROM Person.Person
WHERE NOT (Title = 'Ms.' OR Title = 'Mrs.');
/*  The query will select the Title, FirstName and LastName fields from the person table (in the person schema). This is
  a straightforward query until the NOT operator is added. With the NOT operator, we are going to get the records where
  the Title is not 'Ms.' or 'Mrs.' In other words, we will likely the get everyone with 'Mr.' in the Title field or a
  NULL value. The results of the query show us that there is no actual NULL values in the Title field. Also I notice
  there are people with the title 'Ms' without the '.'. There is also a 'Sr.' title.
 */

 SELECT CountryRegionCode, Name 
 FROM Person.CountryRegion 
 WHERE CountryRegionCode NOT LIKE '[A-S]%'
 ORDER BY 1 ASC;
/*  The query above using the same idea as the previous query where I use the NOT keyword in the WHERE clause except 
  that I specify that I do not want any country codes that begin with any of the letters between A and S. The query
  result returns 36 records. I use the ascending order to show that my results came back as I specified. The codes
  beginning with the letter T are at the top of my results.
  */

SELECT ProductID, Name, Weight 
FROM Production.Product
WHERE Weight IS NULL;
/*  The query selects the ProductID, Name, Weight fields from the Product table. The WHERE clause in this query will
  filter the records using the Weight field, it will return all the NULL values of this table. The results of the query
  show us that...
 */
 SELECT BillOfMaterialsID, StartDate, EndDate FROM Production.BillOfMaterials WHERE EndDate IS NOT NULL;
/*  I am creating a similar query as the previous one, I notice that the table I am using has a lot of NULL values in 
  the EndDate field. There are a total of 2679 records so by specifying the condition where the EndDate field is NOT NULL,
  I return 199 rows as a result.
*/

SELECT ProductID, Name
FROM Production.Product
WHERE Name LIKE '_B%';
/*  In this query I am selecting the ProductID and Name of all the products in the Product table. Using the WHERE clause
  I am selecting the records with the product name with the second letter of "B" and the "%" specifies that anything
  after the letter can come. I believe this is called a wildcard character. The results of the query show us that there
  is only one row that fits this criteria.
 */

SELECT Name
FROM Production.ProductCategory
WHERE Name LIKE '_B%';
/*  Per the profssors instructions I used the exact same query as above for the table ProductCategory but I receive an error 
  as there is no ProductID field. I removed the missing field so that the query would work. After the query was working I 
  received no results as there is no record that fits the criteria that I specified.
  */

UPDATE Production.ProductDescription
SET Description = 'High-density rubber. Very low inventory'
WHERE ProductDescriptionID = 909;
/*  This is an update statement. In this query I am updating the Description field within the ProductDescription table.
  The SET keyword will change the Description record to have the string 'High-density rubber. Very low inventory'.
  The WHERE caluse specifies that I want this paticular update to only change the Description of the record where the
  ProductDescriptionID is equal to 909.
 */

UPDATE Production.ProductDescription
SET Description = 'Write a new description.'
WHERE ProductDescriptionID > 10; -- I ran this by accident as I meant to use the less than symbol. I accidentally edited more than 700 rows.
UPDATE Production.ProductDescription
SET Description = 'The steel is top quality.'
WHERE ProductDescriptionID = 3;
/*  In these two queries I am going to specify that I want to write a new description of the products with an ID less than
  10 (NOTE: See the other comment I made above, I made a huge error!). I checked my results and they work as intended. I
  also update the ProductDescription field of the product description ID that equals 3.
  */

SELECT * FROM Production.ProductDescription WHERE Description LIKE '%aluminum%' and ProductDescriptionID < 1000;
/*  I'm only practicing some queries, this particular one returns 19 rows with the word aluminum within and that has an 
  ID less than 1000. Normally this would have brought back more results but since I accidentally changed all my records
  it returns a lot less rows.
  */