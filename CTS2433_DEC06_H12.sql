USE AdventureWorks;

create table dbo.Person
       (PersonID int identity constraint PK_Person primary key clustered,
		BusinessEntity int not null
		constraint FK_Person References Person.BusinessEntity (BusinessEntityID),
		First_Name Varchar (50) not null);
/*  In the above query is the usual statements to create a table. We are also 
    adding contraints to the columns and references to other columns. In the 
	PersonID column we added constraint called PK_Person to be the Primary Key and 
	to be clustered. Clustered means to store this ID in an index to be found more
	quickly and efficiently when running queries against it. The businessEntity
	column contains another constraint. It is called FK_Person and references the 
	table BusinessEntity from the Person schema, specifically the BusinessEntityID
	column.
    */

create table dbo.PersonPayRates (
PersonID int identity 
  constraint FK_PersonPayRates References dbo.Person (PersonID),
YearlyRate money default 0 not null
);
/*  Building upon what the previous query showed me, I created my own table called
    PersonPayRates. I will add to this table through the lesson.
	*/

alter table dbo.Person ADD Last_Name varchar(50) null;
/*  New olumn using the alter table syntax, this is done because the table already 
    exists and we need to add a column we missed in our first query.
	*/

alter table dbo.PersonPayRates ADD FrequencyScale int default 2;
/*  Here I want the frequency of pay so I add a column as such, I default the 
    value to 2 for every 2 weeks. 
	*/

alter table Production.TransactionHistory
add CostPerUnit AS (ActualCost/Quantity);
/*  Alter table query above indicates to create a new column called CostPerUnit 
    that will calculate ActualCost column divided by Quantity column to be the 
	value in this column. This calculation is done everytime the value is queried
	and likely adds a lot of unnecessary work to the database.
	*/

create table HumanResources.CompanyStatistic (
		companyID int not null,
		StockTicker char(4) not null,
		SharesOutstanding int not null,
		Shareholders int not null,
		AvgSharesPerShareholder as (SharesOutstanding/Shareholders) persisted
);
/*  This creates a table called CompanyStatistic. Again we have a calculated 
    column but we also use the keyword PERSISTED in this particuar column. This
	will take the calculation and store it in the physical memory, this means that
	the columns calculation is not executed everytime that it is called by a query 
	and the calculation will update if the values that create the calculation are 
	altered.
    */

alter table dbo.PersonPayRates ADD PayDatesYear as (52/FrequencyScale);
alter table dbo.PersonPayRates ADD EstimatedPayEarned as (YearlyRate/(FrequencyScale/52)) persisted;
/*  The above queries were created by me to demonstrate the use of calculated 
    columns along with use of persisted keyword. This executes a similar task 
	as the queries above on my own table created for the lesson.
	*/

alter table dbo.Person drop column Last_name; select * from dbo.Person;
/*  I executed the query in the book from recipe 13-6 as it is. The query begins 
    with the alter table syntax. In this case we now want to remove a column, we 
	do so by typing the drop column keywords and we write the column name. In this
	case, it is the Last_Name column. The column is removed after this. The select
	statement following the query is used to demonstrate this.
	*/

if OBJECT_ID('dbo.employees', 'U') is not null
    drop table dbo.Employees;
create table dbo.Employees(
EmployeeID int primary key clustered,
First_Name varchar(50) not null,
Last_name varchar(50) not null,
InsertedDate datetime default getdate());
/*  The above query begins with an if decision. It indicates that if an object id
    for the sepcified object is returned and it is a table ('U'), if all of this 
	is not null we indicate that the table be dropped from the database. Once the
	first portion of the query is terminated we begin with a create table 
	statement to create dbo.Employees. We use much of the syntax we covered
	previously for the creation of tables. The one thing to note is the final
	column. It is a datetime datatype along with a default statement to default 
	it to the GETDATE() function, in other words it returns the current date and
	time of row creation.
	*/

insert into dbo.Employees(EmployeeID, First_Name, Last_name) values (1, 'Wayne', 'Sheffield');
insert into dbo.Employees(EmployeeID, First_Name, Last_name, InsertedDate) values (2, 'Jim', 'Smith', NULL);
Select * from dbo.Employees;
/*  In the above queries, we specified the vaues that we want to insert into the 
    table that we have just created. In the first insert statement we specify
	only the first three columns since the last column with use the GETDATE() 
	function as the defaut value. 
	
	The second insert statement is different. It indicates a specific value for the
	fourth column to be a NULL. This will be a problem because I know the query 
	did not explicitly state that the value in the field cannot be NULL. This 
	NULL value will be inserted.
	
	The select statement after the two other queries indicates that the default 
	value in the first statement worked as well as the NULL valuein the second 
	statement.
	*/

insert into dbo.Employees(EmployeeID, First_Name, Last_name, InsertedDate) values (3, 'Johnny', 'Jones', default);
insert into dbo.Employees(EmployeeID, First_Name, Last_name, InsertedDate) values (4, 'Jimmy', 'Smithy', GETUTCDATE());
Select * from dbo.Employees;
/*  In this query I experimented with some datetime functions we used in previous 
    lectures. I used the default keyword for my first insert statement and then I
	used the GETUTCDATE() function for my second statement. Everything worked 
	fine as indicated after my use of the select statement.
	*/

create table dbo.BooksRead(
	ISBN varchar(20),
	StartDate datetime not null,
	EndDate datetime null,
	constraint CK_BooksRead_EndDate check(EndDate > StartDate)
);
/*  New Table called BooksRead with a check constraint to check if the EndDate 
    column value is greater than the StartDate column value. The constraint is 
	named CK_BooksRead_EndDate.
	*/

insert into BooksRead (ISBN, StartDate, EndDate)
values ('9781430242000', '2011-08-01T16:25:00', '2011-07-15T12:35:00');
/*  After running the above query, it failed the check constraint that we created 
    previously. It references the constraint name as well as the table and 
	indicates afterwards that the query was terminated, see results below:
	----
	Msg 547, Level 16, State 0, Line 128
	The INSERT statement conflicted with the CHECK constraint "CK_BooksRead_EndDate". The conflict occurred in database "AdventureWorks", table "dbo.BooksRead".
	The statement has been terminated.
	----
	*/


/*  Below I am going to use all the queries we have used previously to now add a 
    check constraint for our PayRates table.*/
if OBJECT_ID('dbo.PersonPayRates', 'U') is not null
    drop table dbo.PersonPayRates;
create table dbo.PersonPayRates 
(
PersonID int constraint FK_PersonPayRates References dbo.Person (PersonID),
YearlyRate money default 10000 not null,
constraint CK_YearlyRate_Minimum check(YearlyRate > 9999)
);
/*  The above queries checks to see if I have a table named PerPayRates and 
    deletes it if so. I then create the same table as I did previously, the only
	difference is that I added a constraint to the YearlyRate column, and I 
	removed the identity constraint as it would interfere with the query
	I want to run at the end.
	*/

select * from dbo.PersonPayRates;
-- I confirm the copy with this select statement.

insert into dbo.Person (BusinessEntity, First_Name) VALUES (1, 'Nick'); 
Select * from dbo.Person;
/*  I insert this because I have a foreign key constraint in the PersonPayRate 
    table. I check my inserted data with a select statement to confirm.
	*/
select * from dbo.PersonPayRates;
insert into dbo.PersonPayRates (YearlyRate) Values (9999);
/*  The above query is purposefully set to see if the check is working. It seems 
    to work. The message I receive is below:
	----
	Msg 547, Level 16, State 0, Line 171
	The INSERT statement conflicted with the CHECK constraint "CK_YearlyRate_Minimum". The conflict occurred in database "AdventureWorks", table "dbo.PersonPayRates", column 'YearlyRate'.
	The statement has been terminated.
	----
	*/

/*  I now follow this with a corrected statement using the default keyword. I do 
    not need to indicate default but just for demonstration purposes, it's there.
	*/
insert into dbo.PersonPayRates (PersonID, YearlyRate) Values (1, 10001);
select * from dbo.PersonPayRates;
/*  Everything works as indicated, the check worked and the corrected insert worked.
    */