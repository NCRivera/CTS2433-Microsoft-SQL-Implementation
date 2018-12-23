-- December 13, 2018
-- CTS2433

Use AdventureWorks;

Create procedure dbo.ListCustomerNames
as 
select CustomerID,
       LastName,
	   FirstName
from Sales.Customer sc
inner join Person.Person pp
on sc.CustomerID = pp.BusinessEntityID
order by LastName, FirstName;
/*
By using a CREATE PROCEDURE syntax we are creating a procedure to be executed
that is indicated after the create procedure keywords are used. In this case we 
want to  use the select statement after the as keyword. We are selecting 
CustomerID, LastName, FirstName using an inner join of two tables. Although we
are putting a select query within, this can contain other statements.
*/

Exec dbo.ListCustomerNames;
/*
We use EXEC keyword in order to run the procedure that we have just created. We
indicate the name of the procedure after the exec keyword.
*/

create procedure dbo.SalaryCheck -- My own query
as
select HRE.LoginID, HRE.JobTitle, SalariedFlag, HREPH.PayFrequency, HREPH.Rate
from HumanResources.Employee as HRE
inner join HumanResources.EmployeePayHistory HREPH
on HREPH.BusinessEntityID = HRE.BusinessEntityID
order by HREPH.Rate;
/*
Here I follow the design of the previous query to create my own procedure
called SalaryCheck. Within the procedure I create a select statement to return the 
results of of saary information from the EmployeePayHistory table and another
to return employee information.
*/

exec dbo.SalaryCheck;
/*
I use exec against the procedure I just created. My results show the salaries of 
all employees.
*/

Create procedure dbo.LookupByAccount
(@AccountNumber varchar(10), @UpperFlag char(1))
as
select 
	case UPPER(@UpperFlag)
	when 'U' then upper(FirstName)
	else FirstName
end as FirstName,
	case upper(@UpperFlag)
	when 'U' then upper(LastName)
	else LastName
end as LastName
	from Person.Person
	where BusinessEntityID in 
	(select CustomerID from Sales.Customer where AccountNumber = @AccountNumber);
/*
Here we are continuing with the syntax we learned to create a procedure but now we 
add two variables to be indicated along with the procedure to be executed. In this
case within the procedure exists a select statement with a case expression to 
complete a task based on whaat is passed along with the procedure. We can look up
a specific account along with a "flag" indicating whether the results are Upper or
lower case. We do this using a case expression.
*/

exec LookupByAccount 'AW00000019', 'u';
/*
Here we execute the procedure, with an lowercase 'u' character. The results return
the results in uppercase, the  type of case for the caracter has no effect.
*/

exec LookupByAccount 'AW00000019', 'U';
/*
Same procedure executed with an uppercase 'U', no difference between the previous
query. Same results.
*/

exec LookupByAccount 'AW00000019', 'x';
/*
Here we check to see if the case expression within the procedure will execute
depending on the character passed through. Our results show that we have a
lowercase results.
*/

Create procedure dbo.LookupEmployeeRatesJobs -- My own query
(@LowerRate float, @UpperRate float)
as
select HRE.LoginID, HRE.JobTitle, SalariedFlag, HREPH.PayFrequency, HREPH.Rate
from HumanResources.Employee as HRE
inner join HumanResources.EmployeePayHistory HREPH
on HREPH.BusinessEntityID = HRE.BusinessEntityID
where HREPH.Rate between @LowerRate and @UpperRate;
/*
Using the previous example I create a procdure to check employee pay rates based on 
two floats, a lower rate and a higher rate. It uses my previously created 
procedure.
*/

exec LookupEmployeeRatesJobs '15.00', '16.00';
/*
I run my created procedure with a minimum rate of 15 and a higher rate of 16 to 
see if it runs. My results show that they do run as intended.
*/
exec LookupEmployeeRatesJobs '25.00', '50.00';
/*
Same as my previous query but a higher range to return more results.
*/

exec LookupEmployeeRatesJobs '75.00', '100.00'; -- My own query
/*
Last example query to check if it works perfectly. Results return as expected.
*/

create procedure dbo.SEL_Department -- Here we create a new stored procedure
@GroupName nvarchar(50), -- First variable to be a data type nvarchar
@DeptCount int output --  A second variable to be returned as output.
as -- The alias keyword
select Name from HumanResources.Department -- A select query to return
where GroupName = @GroupName -- We return results where the clause is equal to group name variable
order by Name;
select @DeptCount = @@ROWCOUNT; -- I don't understand this particular clause. It returns a count I believe.

Declare @DeptCount int; -- We declare our variable to be returnes
exec DBO.SEL_Department 'Executive General and Administration', -- we run the procedure against this particular string.
@DeptCount OUTPUT; -- This variable we declared will be returned as results
Print @DeptCount; -- My results show the count in the messages tab.

Create procedure dbo.JobCounts -- My own query to count jobs
@Job nvarchar(50), -- job variable
@JobCount int output -- output will be the count
as
select JobTitle -- job titles to check
from HumanResources.Employee  -- against this tble
where @Job = JobTitle; -- variable must be equal to jobtitle in table
select @JobCount = @@ROWCOUNT;

Declare @JobCount int; -- I declare my count variable
exec dbo.JobCounts 'Production Technician - WC40', -- I want the count of this job
@JobCount output; -- my output variable
print @JobCount; -- print the count of the job number.

alter procedure dbo.SEL_Department -- Altering our previous query
@GroupName nvarchar(50)
as
select Name
From HumanResources.Department -- All the same except for the second variable.
where GroupName = @GroupName
order by Name;
select @@ROWCOUNT as DepartmentCount; 
-- The entire query remains the same except for this line above, instead of output we use a select statement to return the number.

exec dbo.SEL_Department 'Research and Development';
-- The results of the two select statements are returned in two different windows

Drop procedure dbo.SEL_Department;
-- Here we remove the previously created query


alter procedure dbo.JobCounts -- My own query to count jobs but modified
@Job nvarchar(50) -- job variable only
as -- I removed the count variable.
select JobTitle -- job titles remains the same
from HumanResources.Employee  
where @Job = JobTitle; 
select @@ROWCOUNT as JobCount;


exec dbo.JobCounts 'Production Technician - WC40';
-- Works just like our previous query but in one window, I prefer this than the previous output parameter.

Drop procedure dbo.JobCounts;
-- Here I drop the procedure I created.