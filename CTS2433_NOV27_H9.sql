Use AdventureWorks;

select ExpDate = CONCAT(ExpMonth, '/', ExpYear) 
from Sales.CreditCard as p;
/*  The query we just ran above uses the concat function in order to return the 
    'ExpMonth' and the 'ExpYear' columns from the CreditCard table. We are 
	returning the results as a column called 'ExpDate'.  */

select distinct top 10 
ExpDate = CONCAT(ExpMonth, '/', ExpYear) 
from Sales.CreditCard as p
order by ExpDate desc;
/*  In the query we just ran, we are using the DISTINCT keyword along with 
    the TOP keyword and the number 10. This will select only the distinct 
	values as well as the top 10 results. All of this will be selecting from 
	the string that is created form the concatenating function. Finally, the 
	order by clause is by descending order. From the results we can see the 
	query results are ordered weird.  */

SELECT CONCAT(StateProvinceCode, ' - ', Name) AS 'US-STATES' 
from Person.StateProvince
where CountryRegionCode = 'US';
/*  Here I am using the 'StateProvince' table in order to concatenate two 
    different columns in a meaningful manner. I am using the CONCAT() 
	function on the columns 'StateProvinceCode' and 'Name' and I am 
	indicating in the WHERE clause that I want the rows where the column
	has 'CountryRegionCode'. */

Select CONCAT(CountryRegionCode, ' | ', UPPER(Name)) AS COUNTRY 
from Person.CountryRegion;
/*  In my new query I am concatenating the CountryRegionCode with the Name 
    of the country. I am also using the UPPER() function on the Name of 
	the country in order to match the Region code. I am seprating both by 
	ucing a pipe character.  */

select SOUNDEX(Name), SOUNDEX('Bike'), Name
from Production.ProductSubcategory where SOUNDEX(Name) = SOUNDEX('Bike');
/*  Using the SOUNDEX function in the query above we are able to return a 4 digit
    code that indicates the sound of the string that was passed through.
	I this example we are using the word 'Bike' as the example. The word returns 
	the 4 digit code 'B200' to indicate the chosen string. In the where clause,
	we are indicating the soundex of the 'bike' to be returned. Using the 
	particular where clause returns the specific soundex code we want returned.
	*/

select JobTitle, OrganizationLevel 
from HumanResources.Employee 
where SOUNDEX(JobTitle) = SOUNDEX('chief');
/*  A use case for the SOUNDEX function can be someone on the phone who had 
    trouble hearing the specific title of an employee. In this example we use 
	the example of the string 'chief'. If we do not know the exact title to 
	search, we can use the soundex function to retrieve the titles that sound
	similar to it. My query above retrieves all of the JobTitles that contain
	the chief word within it.
	*/

Select REPLACE('The Classic Roadie is a stunning example of the bikes that AdventureWorks have been producing for years - Order your classic Roadie today and experience AdventureWorks history.', 
'Classic', 'Vintage');
/*  In this example we are using the replace() function in order to replace 
    certain keywords within the string that we placed inside the function. 
	The syntax is followed by the word we want replaced and finally by what 
	we are replacing it for. In this case we replace Classic with the word 
	vintage. */

Declare @JobTitle VARCHAR(40) = (SELECT JobTitle 
                                 from HumanResources.Employee 
								 where BusinessEntityID = 1)
Select REPLACE(@JobTitle, 'Executive', 'Financial') AS NEWTITLE
/*  In my query above, I want to replace the title of the chief executive officer.
    In order to do this I specify a variable called @Jobtitle and I specify the 
	value to be the results of a select query. I follow the query with the
	actual REPLACE() function and pass the required arguments. I alias it 
	to be NEWTITLE.
	*/