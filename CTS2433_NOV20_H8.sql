Use AdventureWorks2017;

insert into Production.Location 
(Name, CostRate, Availability)
values ('Wheel Storage', 11.25, 80.00);
/*  The query above is a method of inserting records into a a specified table. The 
    query begins with the 'INSERT INTO' keywords followed by the table name that 
	we want to put a record on. After this we speciify the Columns of where to 
	place the record into, in this case it is the 'Name', 'CostRate', 
	'Availability'. After this use the VALUES keyword to input the information into 
	the specified columns. I receieve a '1 row affected' message.  */

select Name, CostRate, Availability
from Production.Location
where Name = 'Wheel Storage';
/*  Here are my results indicating that I was able to insert properly:
	Wheel Storage	11.25	80.00  */

insert into Person.ContactType (Name) values ('Data Analyst');
/*  I created a simplified query using the 'ContactType' table. I placed a new position
    called 'Data Analyst'. This is inserted under the Name column in this table.  */

create table HumanResources.Degree 
-- The Create table indicates that we are creating a table, we can specify schema as above.
(DegreeID  int         not null identity(1,1) primary key,
-- Our first column  is called DegreeID and is an integer and is the primary key
Degree    varchar(30) not null,
-- 'Degree' column is varchar data type and can be 30 in length
Code      varchar(5)  not null,
-- 'Code' column is variable character data type with a length of up to 5.
ModfdDate datetime    not null
-- ModfdDate is a datetime data type that cannot be without a record.
);
go
insert into HumanResources.Degree
-- We begin our insertion of data here with the insert into statement.
(Degree, Code, ModfdDate)
-- We specify the columns to insert into
values 
-- Below are the values we want to insert. They match the columns we are inserting into.
('Bachelor of Arts', 'B.S.', GETDATE()),
('Bachelor of Science', 'B.S.', GETDATE()),
('Master of Arts','M.A.',getdate()),
('Master of Science','M.S.',getdate()),
('Associate''s Degree', 'A.A.', getdate());
-- GETDATE() function indicates todays date and time.

select * from HumanResources.Degree
-- Here I am inspecting the results of my above query. Everything is fine at this point.

create table HumanResources.EmployeePractice 
(
empid      int primary key, -- Here I am creating my own tables with the columns indicated.
firstname  varchar(30) not null, -- empid, firstname, middlename, lastname
middlename varchar (14) default 'X', -- defaulting middle name to be character 'X'
lastname   varchar(30) not null
);

insert into HumanResources.EmployeePractice 
(empid, firstname, middlename, lastname) values
(1, 'Nic', default, 'Ribeira'), -- Dummy data must match columns in my new table.
(2, 'Nan', default, 'Bobby'),
(3, 'Johnny', 'John', 'Johnson')
;

select * from HumanResources.EmployeePractice;
/*  I can see that everything seems to have worked. The middle names were defaulted 
    as indicated. I need to use some kind of generators for the primary key, I believe 
	there's an autonumber keyword in SQL?  */

select UnitPrice -- We retrieve the unitprice column from the table
from Purchasing.PurchaseOrderDetail -- The table is specified using the from statement
where OrderQty > 100; -- We are filtering the columns by orderqtys greater than 100
update Purchasing.PurchaseOrderDetail -- In this query we update the specified table
set UnitPrice = 25.00 -- We are setting the value of unitprice to be 25.00 
where OrderQty > 100; -- We do this on all columns where orderqty is greater than 100.

update HumanResources.EmployeePractice
set middlename = 'C'
where firstname = 'Nic';
/*  Above is my own query, first I begin with specifying which table I want to use. 
    I am using the previous table that I created called: EmployeePractice. I want
	to update a middle name where the firstname column is equal to nicholas.  */

Select * 
from HumanResources.EmployeePractice 
where firstname = 'Nic';
/*  Here I am checking the results of my update query. It seems to have worked.  */

select * into Production.Example_ProductProductPhoto
from Production.ProductProductPhoto;
 /*  Using a select statemment to place all the records from the 
     'Production.ProductProductPhoto' into 'Production.Example_ProductProductPhoto'
	 This put a lrge number of records into the specified table according the rows affected 
	 message.  */
     
delete Production.Example_ProductProductPhoto; -- I did some reasearch and this is a DML statement. Records deleted

select * into Production.Example_TransactionHistory
from Production.TransactionHistory; -- Same as before, a new table to use, lots of rows.

Truncate table Production.Example_TransactionHistory; -- This is a DDL command. Records no longer exist.
select * from Production.Example_TransactionHistory;
/*  From experience, deletion of records is a very serious and concrete action. Deleting 
    something requires a lot of effort to restore. We must be completely specific with 
	our SQL queries as to not delete something we did not intend to delete as it has 
	consequences. 