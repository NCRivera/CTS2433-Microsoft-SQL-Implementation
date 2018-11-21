-- Nicholas Rivera
-- CTS2433
-- November 15, 2018
-- Handout 7

USE AdventureWorks2017;

select TaxType, AVG(TaxRate) as AvgTaxRate
from Sales.SalesTaxRate
group by TaxType;
/*  In my first query we are running a simple select query using the columns 'TaxType' 
    and 'TaxRate' from the table 'SalesTaxRate' but we are not including one of SQL 
	Server's functions; the avg() function returns the total count of the integers in 
	the row and divided it by the total amount. An interesting note about the AVG() 
	function is that it will ignore the NULL value within the rows. After our selection,
	I then group by the 'TaxType' field. The GROUP BY clause is needed when using aggregate 
	functions as it will help to sort the groups within the field that was not aggregated.  */

select * from HumanResources.Employee;
select Gender, Year(BirthDate) as birth_year, AVG(VacationHours + SickLeaveHours) as AVG_time_off
from HumanResources.Employee
group by rollup(Gender, BirthDate);
/*  Here I am creating my own query to demonstrate the use of the avg() function. I am 
    first selecting the columns 'Gender', 'BirthDate', 'VacationHours', and 'SickLeaveHours'.
	I am applying two functions: first to 'BirthDate' using the Year() function and avg() 
	function on the total of 'VacationHours' and 'SickLeaveHours'.  From here I am grouping 
	the two fields by using the ROLLUP keyword. The query returns first the gender and then 
	the year which is the shelf. This query gives us the Average time off of the gender and 
	the birth year of that particular row. Results are as follows (I'm pasting first five 
	results of female and then male):  
	F	1952	27
	F	1954	156
	F	1956	143
	F	1956	150
	F	1956	149
	...
	M	1951	41
	M	1952	119
	M	1952	107
	M	1953	27
	M	1955	65  */

/*
COUNT() function and the COUNT_BIG() function returns the same information. Although 
the difference is the data types between the two. COUNT_BIG returns the value in the 
data type BIGINT, COUNT returns the vaue as an INT data type. Most times it seems 
COUNT_BIG can be used in situations where COUNT is used.

I can use COUNT within AdventureWorks2017 but I don't believe it is possible to properly 
demonstrate the COUNT_BIG function as it should be used.

Below is a query in how to use the COUNT() function, I do it with the COUNT_BIG() 
function as well.
*/
-- COUNT() function
select JobTitle, Count(Gender) AS gender_count
from HumanResources.Employee
GROUP BY JobTitle
ORDER BY JobTitle ASC;

-- COUNT_BIG() function
select JobTitle, Count_BIG(Gender) AS gender_count
from HumanResources.Employee
GROUP BY JobTitle
ORDER BY JobTitle DESC;


select top(5) Name, COUNT(TaxType) as TaxTypeCount, COUNT_BIG(TaxType) as TaxTypeBig
from sales.SalesTaxRate
group by Name
order by Name;
/*  The ladder query demonstrates use of the COUNT() and COUNT_BIG() and shows the 
    differences between the two. The counts under each of the aggregated function fields
	are grouped by the 'Name' field. As I said previously, the COUNT() and COUNT_BIG() 
	functions are eesentially the same thing except that the COUNT_BIG() does not have 
	the number limitation that COUNT() function has. The COUNT_BIG() function is a 
	difficult to demonstrate as the AdventureWorks2017 table does not have millions of rows.
	We can use each interchangebly in these smaller databases.  */

select a.GroupName, c.Name, COUNT(b.ShiftID) as ShiftCounts
from HumanResources.Department as a
inner join HumanResources.EmployeeDepartmentHistory as b 
on a.DepartmentID = b.DepartmentID
inner join HumanResources.Shift as c on b.ShiftID = c.ShiftID
group by c.Name, a.GroupName;
/*  My custom query above demonstrates the use of the COUNT() aggregate function using the
    three tables: 'HumanResources.Department', 'HumanResources.EmployeeDepartmentHistory', 
	'HumanResources.Shift' using the INNER JOIN keyword. The results of my query show the 
	count of all the shifts by their shift name as well as the category of job within the 
	organization. For my results we can see what Job Categories have which shifts. All 
	categories seem to be within all three shift types except for 'Research and Development' 
	and 'Sales and Marketing'.

	My results are below:
	Executive General and Administration	Day	31
	Executive General and Administration	Evening	3
	Executive General and Administration	Night	2
	Inventory Management	Day	16
	Inventory Management	Evening	2
	Inventory Management	Night	1
	Manufacturing	Day	84
	Manufacturing	Evening	55
	Manufacturing	Night	47
	Quality Assurance	Day	8
	Quality Assurance	Evening	2
	Quality Assurance	Night	2
	Research and Development	Day	15
	Sales and Marketing	Day	28  */

select top(5) ProductID, SUM(ActualCost) as TotalCostByProductID
from Production.TransactionHistory
group by ProductID
order by ProductID;
/*  The query above takes the top five 'ProductID' and 'ActualCost' from the 
    'Production.TransactionHistory'. We pass the SUM() function using the 
	'ActualCost' column and we alias it as 'TotalCostByProductID'. In the clauses
	ORDER BY and GROUP BY we use 'ProductID' with both. Doing this we are retrieving
	the sums of the 'ActualCost' field and grouping them by 'ProductID'.
	This gives us the results below, we find that 'ProductID' 4 has the highest sum.
	1	2261.8575
	2	1886.22
	3	0.00
	4	2566.1475
	316	0.00  */

select table1.Name, QuantitySold = SUM(table2.Quantity) 
from Production.Product as table1
inner join Production.TransactionHistory as table2 
on table1.ProductID = table2.ProductID
group by table1.Name
having SUM(table2.Quantity) > 50000
order by SUM(table2.Quantity);
/*  Here I am running a similar query using the SUM() function. I use the fields from 
    two different tables being: 'Name' from 'Production.Product' and 'Quantity' from 
	'Production.TransactionHistory'. They are both joined on the 'ProductID' field.
	I want to summarize the total sums of the quantity sold for each product, where the 
	sold quantity is more than 50000. I do this by passing the SUM() function using the 
	'Quantity' field and grouping by 'Name' and then finally using a HAVING clause where 
	'Quantity is greater than 50000. I also order it by the amount. My results are as 
	follows:

	HL Spindle/Axle	50050
	LL Spindle/Axle	50050
	LL Mountain Rim	50600
	ML Mountain Rim	50600
	ML Mountain Pedal	50869
	LL Mountain Pedal	50922
	Decal 1	56250
	Decal 2	56250
	HL Hub	56264
	HL Crankarm	64900
	Fork End	93688
	Blade	93688
	Chain Stays	93688
	Seat Stays	187376
	BB Ball Bearing	374090  */

select MIN(TaxRate) MinTaxRate, MAX(TaxRate)MaxTaxRate
from Sales.SalesTaxRate;
/*  This is a straightforward query. We are retrieving the highest and lowest values 
    in each of these fields. We do this when we pass the particular functions for 
	each, MIN() for the lowest number of a field and MAX() for the highest value in 
	a field.  */

select Quantity_MIN = MIN(Quantity), Quantity_MAX = MAX(Quantity), Quantity_AVG = AVG(Quantity)
from Production.TransactionHistory
where ProductID = 870;
/*  Here I want the minimum amount and maximum amounts of ProductID 870. I want to 
    see how much of each has been sold and the average amount sold. I do this using the MIN(),
	MAX(), AVG() functions to retrieve this information. This gives me some insight on this 
	product by retrieving this information.  */

select VAR(CreditRating) as Variance_sample, VARP(CreditRating) as Variance_EntirePopulation
from Purchasing.Vendor;

select Quantity_VAR = VAR(Quantity), Quantity_VARP = VARP(Quantity)
from Production.TransactionHistory
where ProductID = 870;
/*  As with my previously created query I am going to use the Variance functions on 
    it because I believe this will produce more insight within the quantities being sold
	for the Product with the ID 870. My results are as follows:
	
	2.78454436188001	2.78387931665386
	
	I can see from my analysis that generally there is the equal variance between the 
	sample(VAR) and population(VARP).  */

select STDEV(CreditRating) as StandDevCreditRating, STDEVP(CreditRating) as StandDevCreditRating
from Purchasing.Vendor;
/*  The context for a manager to ask for these types of calculations would be for insight 
    into the credit ratings of the customers that bought products. This information can be 
	used to resolve who to market to. Which customers to target.These are the types of 
	insights we can observe with these functions.  */

select Quantity_STDEV = STDEV(Quantity), Quantity_STDEVP = STDEVP(Quantity)
from Production.TransactionHistory
where ProductID = 870;
/*  Using the product in my analysis, I use the standard deviation functions: STDEV() 
    and STDEVP. I want to find out more about ProductID 870. I use the Transaction history 
	table to find out what the standard deviation is between the quantities that were sold.
	I need to find the deviation  amongst the quantites sold for my product. Below are my
	results:
	
	1.66869540716094	1.66849612425497.  */