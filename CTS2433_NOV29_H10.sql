-- CTS2433
-- November 29, 2018

USE AdventureWorks;

select 'GETDATE()' as [Function], GETDATE() as [Value];
/*  The value I receieve from the GETDATE() function is the current date and 
    time in the format: YYYY-MM-DD HH:MM:SS.SSS. The time is precise up to 
	hundreds of milliseconds.
	*/

select 'CURRENT_TIMESTAMP' as [Function], CURRENT_TIMESTAMP as [VALUE]; 
/*  The CURRENT_TIMESTAMP function is similar to the previous function we 
    queried with, GETDATE(). There is a syntax difference in CURRENT_TIMESTAMP
	in that you do not need to complete it with parenthesis. This makes me 
	think that it is not a "technical" function in SQL. Just a command that 
	can be run to return the current date/time.
	*/

select 'GETUTCDATE()' as [Function], GETUTCDATE() as [VALUE];
/*  Again, this retrieves the current date and time as previous functions. 
    The difference with this particular function is the fact that it returns 
	the Coordinated Universal Time which is the format many systems follow to 
	a basis/basic time for which can be converted to current area time.
	*/

select 'SYSDATETIME()' as [Function], SYSDATETIME() as [VALUE];
/*  This retrieves the computer systems date and time in 24 hr format.
    It drills down to milliseconds as well, up to 7 places. It is very 
	precise. It uses the Y/M/D formaat as well.
	*/

select 'SYSUTCDATETIME' as [Function], SYSUTCDATETIME() as [VALUE];
/*  Exactly the same as the previous SYSTEMDATETME() function, but now the
    current time retrieved is in UTC format. In our case we are -05:00, so we 
	are 5 hrs behind UTC.
	*/

select 'SYSDATETIMEOFFSET()' as [Function], SYSDATETIMEOFFSET() as [VALUE];
/*  This is a useful function. In this case we retrieve, again the SYSDATETIME.
    It is the same format up to the same milliseconds. But the function now 
	returns the users offset regarding UTC. So if I run this function it will
	return DATE and TIME and UTC offset values at the end of it: '-05:00'.
	*/

select SWITCHOFFSET('2007-06-12T07:43:25-05:00', '+03:00');
/*  This particular function will take a date and time input with a UTC value
    such as what SYSTIMEOFFSET() function returns and it will convert the time 
	given in the first argument, and when given a second argument: a UTC value, 
	it will then return the vaue given into the UTC value specified. In this 
	case, the DATETIME given is in UTC '-05:00' and it will be converted to UTC 
	'+03:00'. 
	*/

select SWITCHOFFSET('2018-05-23T15:55:01-08:00', '-05:00');
/*  Here is my query using the function we used previously. I am using the UTC of
    '-08:00' or california time and I want to return our equivalent time. I do
	this by using our UTC value which is '-05:00'. My results follow: 
	2018-05-23 18:55:01.0000000 -05:00
	*/

select TODATETIMEOFFSET(GETDATE(), '-05:00') as [Eastern Time Zone Time],
SYSDATETIMEOFFSET() [Current System Time];
/*  In this query we use the TODATETIMEOFFSET to retrieve the current system 
    time and pass it a second argument indicating its Offset value.
	 We get the current system date by passing the GETDATE function. After 
	 this we are passing the SYSDATETIMEOFFSET(), which functionally, does 
	 the same thing we did in the other line of the query.
	*/
/*  The previous query is usefull because if an international company has 
    data from a different timezone, there are plenty of methods to retrieve 
	their dates and times using the functions used previously. We can convert 
	times back and forth as we know the OFFSET values.
	*/

select TODATETIMEOFFSET(SYSUTCDATETIME(), '-08:00') as [Pacific Time Zone Time],
SYSUTCDATETIME() [UTC System Time];
/*  In this Case I want the pacific time and I want to see the difference 
    between the UTC TIME to find out what the difference is.
	*/

select DATEADD(MONTH, -2, '2009-04-02T00:00:00');
/*  This particular query takes the month of the specified date and then we are 
    substracting the number we placed in the argument.
	*/

use AdventureWorks;
select ProductID, DueDate, EndDate, 
	DATEDIFF(DAY, DueDate, EndDate) as Elapseddays
from Production.WorkOrder where EndDate IS NOT NULL;
/*  This query selects the ProductID, DueDate, EndDate, from the WorkOrder table
    and combines DueDate and EndDate with the function DATEDIFF in order 
	to retrieve elapsedays, the difference between date of payment and due date.
	The WHERE CLAUSE indicates that we want EndDates that are not null.
	The results of the query returns all the speicifed columns and finally the 
	total elapsed. The query works in what it does, retrieves the days necessary.
	I would further better the query by adding more statements to the where clause
	depending on the information needed. For example, if you only need late
	payments, indicate not to retrieve anything less than 1, etc.*/ 

/*  The query in 10-5 does essentially the same thing as our previous query except 
    in that it specifies todays date using the getdate function. It retrieves the datediff
	between enddate and todays date. I dont believe this is a great query based on the 
	the information that is retrieved does not tells us anything other than the days that 
	have passed and the top 5 dates retrieved.*/

select SalesOrderID, OrderDate, ShipDate, DATEDIFF(DAY, OrderDate, ShipDate) As OrderProcessingTime
from Sales.SalesOrderHeader
order by 4 desc;
/*  Here I found the perfect table to use in place of the ones we used in both 
    examples. I used the table SalesOrderHeader which contains an OrderDate
	and a ShipDate. I want to find the difference between the two dates so 
	first I specify my select query to retreive SalesOrderID, OrderDate, ShipDate.
	I use the function datediff, specifying to return days and the difference 
	between OrderDate and ShipDate and call it order processing time. This 
	gives me back how long it took an order to be shipped and the date the order 
	was placed.
	*/

select ProductID, EndDate,
	DATEPART(YEAR, EndDate) as [Year],
	DATEPART(MONTH, EndDate) as [Month],
	DATEPART(DAY, EndDate) as [Day]
from Production.WorkOrder
where EndDate IS NOT NULL
order by 2 desc;
/*  The query is demonstrating the use of the DATEPART function and showing 
    its uses. You can specify particular parts of a day in order to return them 
	as a result in the query. Here we are retrieving one column, EndDate, and 
	returning its parts such as year, month and day.
	*/

select OrderDate,
	DATEPART(YEAR, OrderDate) as [Year],
	DATEPART(MONTH, OrderDate) as [Month],
	DATEPART(DAY, OrderDate) as [Day]
from Sales.SalesOrderHeader
group by OrderDate
order by OrderDate;
/*  In order to show off the use of datepart function, we retrieve the orderdate
    column from the SalesOrderHeader and using the group by clause in order to 
	get the distinct dates in the table. we use datepart on the year, month and 
	day. Finally I order everything by the date. My results do not show any
	relevant information other than the demonstration of the function and its
	parts.
	*/
