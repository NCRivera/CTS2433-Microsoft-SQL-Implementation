use AdventureWorks;

create view dbo.v_Product_TransactionHistory as 
-- Here we are creating a view that will contain a complicated select statement
select p.Name as ProductName, 
-- We can see from the select statement we are retrieving from multiple tables
       p.ProductNumber, 
	   pc.Name as ProductCategory,
-- By creating a view, one observation I have is that we will not need to recreate a complicated select query
	   ps.Name as ProductSubCategory,
-- So far we retrieve columns from 3 different tables.
	   pm.Name as ProductModel,
	   th.TransactionID,
-- Noow here is the fourth table. If the tables follow normalization rules, this
-- is a likely scenario for many database users.
	   th.ReferenceOrderID,
	   th.ReferenceOrderLineID,
	   th.TransactionDate,
	   th.TransactionType,
	   th.Quantity,
	   th.ActualCost,
	   th.Quantity * th.ActualCost as ExtendeedPrice
-- If a table contains many rows, this is not a good use of formulas in a query.
-- It will slow down the query results.
from Production.TransactionHistory th
inner join Production.Product p					on th.ProductID = p.ProductID
inner join Production.ProductModel pm			on pm.ProductModelID = p.ProductModelID
inner join Production.ProductSubcategory ps		on ps.ProductSubcategoryID = p.ProductSubcategoryID
inner join Production.ProductCategory pc		on pc.ProductCategoryID = ps.ProductCategoryID
-- Here we can see that we are actuallly querying results from five tables
-- All are connected by an inner join.
where pc.Name = 'Bikes';
-- The results we want are rows with the Name contining the string 'Bikes' within.
GO

create view dbo.v_Clothing_Transaction as
-- My own view is based on the previous one. I want to add functions to the 
-- previous query
select p.Name as Clothing, 
-- I am retrieving results regarding clothing in pplace of bokes.
       p.ProductNumber,
	   ps.Name as PClothingSubCategory,
	   pm.Name as ClothingType,
	   th.TransactionID,
	   th.ReferenceOrderID,
	   th.ReferenceOrderLineID,
	   th.TransactionDate,
	   th.TransactionType,
	   th.Quantity,
	   round(th.ActualCost, 2) as CostRounded,
-- I feel that there are too many decimals in the money categories, I remove some
-- and round to the nearest second decimal using the round() function
	   round(th.Quantity * th.ActualCost, 2) as ExtendedPrice
-- I use round() on this extended price as well. There is no use for a price
-- with this precision to so many numbers.
from Production.TransactionHistory th
inner join Production.Product p
on th.ProductID = p.ProductID
inner join Production.ProductModel pm
on pm. ProductModelID = p.ProductModelID
inner join Production.ProductSubcategory ps
on ps.ProductSubcategoryID = p.ProductSubcategoryID
inner join Production.ProductCategory pc
on pc.ProductCategoryID = ps.ProductCategoryID
-- I formatted my joins to be more readbale in this context.
where pc.Name = 'Clothing'; -- My Query for clothing prices
GO

select 
	ClothingType, 
	AverageBelow100 = ROUND(AVG(CostRounded), 2), 
	ExAverageAbove100 = ROUND(AVG(ExtendedPrice), 2)
from dbo.v_Clothing_Transaction
where CostRounded < 100 and ExtendedPrice > 100
group by ClothingType;
/* 
I want to query my own view that I created to find the average of the cost
of clothing below a certain aount and the extended average above a certain amount,
sepcifically $100 for both.
*/

Select ProductName, ProductNumber, ReferenceOrderID, ActualCost
-- This is a uncomplicated select query, but in place of an actual table
-- we query an actual database object known as a view.
from v_Product_TransactionHistory
-- a view was created from another complicated select query. We can see that
-- using an actual view is much more simple in this context.
order by ProductName;
/* 
As a result of a view we will not need to continue using a query with complicated 
syntax, which means less mistakes.
*/

select definition
from sys.sql_modules as sm
where OBJECT_ID = OBJECT_ID('dbo.v_Product_TransactionHistory');
/*
Retrieiving the definition of the view is usefull because we can see the syntax
of the view that was created. Normally a database user would not be able to 
see the query behind a view but by selecting the definition of the view from
the modules object of the system view, we can see how this view was created.
A use case for this would be to ensure that we are using a view of the rows
that a user needs.
*/

select OBJECT_DEFINITION(OBJECT_ID('dbo.v_Product_TransactionHistory'));
/*
This has the same result of the previous query with different syntax.

I prefer the use of this query because it is simplified and uses built-in 
system functions in place of querying from a table.
*/

select OBJECT_SCHEMA_NAME(v.object_id) as SchemaName, v.name
from sys.views as v;
/*
The query above retrieves the schema names within the adventureworks database
and lists them individually by object id's. We specify that we want the schema 
names from the sys.views table in the database. So the results we retrieve are
the views in each of the schema names.
*/

select OBJECT_SCHEMA_NAME(o.object_id) as SchemaName, o.name
from sys.objects as o
where type = 'V';
/*
This returns the same results as the previous query done in a different manner. It
uses a different system table called objects and in this case we speicify the 
WHERE clause to be 'V'.
*/

SELECT OBJECT_NAME(object_id) AS TableName, COL.name AS TableColumns
FROM sys.columns AS COL
WHERE object_id IN (SELECT object_id FROM sys.views);
/*
The query I created above retrieves the columns in each view within the 
adventureworks database. I do this by specifying the system columns and I specify
a WHERE clause with a query to select the object id's from the views table. In
the select statement I specify I want the Object Name's of the object id's 
returned as well as the name of the columns. The results are all the columns 
within all the views as well as the view names.
*/

select name, column_id
from sys.columns
where object_id = OBJECT_ID('dbo.v_Product_TransactionHistory');
/*
This is a similar query to my query that I created previously. This query is 
specific to only the 'v_Product_TransactionHistory' view that was created in this 
lesson. My previous query is a more general use of retrieving columns for created 
views.
*/

alter view dbo.v_Product_TransactionHistory as 
select p.Name as ProductName,
       p.ProductNumber,
	   pc.Name as ProductCategory,
	   ps.Name as ProductSubCategory,
	   pm.Name as ProductModel,
	   th.TransactionID,
	   th.ReferenceOrderID,
	   th.ReferenceOrderLineID,
	   th.TransactionDate,
	   th.TransactionType,
	   th.Quantity,
	   th.ActualCost,
	   th.Quantity * th.ActualCost as ExtendedPrice 
from Production.TransactionHistory th
inner join Production.Product p
on th.ProductID = p.ProductID
inner join Production.ProductModel pm
on pm.ProductModelID = p.ProductModelID
inner join Production.ProductSubcategory ps
on ps.ProductSubcategoryID = p.ProductSubcategoryID
inner join Production.ProductCategory pc
on pc.ProductCategoryID = ps.ProductCategoryID
where pc.Name in ('Bikes', 'Bicycles'); 
GO
/*
The only change to the previous view is now the string Bicycles is added to the
view. I don't believe this will change the row count too much. See the select 
query below for results.
*/

select * from v_Product_TransactionHistory; -- 25262, 25262
/* 
We can see that adding Bicycles to the where caluse does not change the amount 
of rows that were orignally retrieved before the view was altered. I'm now going 
to alter my created view to add Bikes to the view.
*/

alter view dbo.v_Clothing_Transaction as
select p.Name as Clothing_Bikes, 
-- I am updating my columns to make sense since it includes more products now. 
       p.ProductNumber,
	   ps.Name as PClothing_BikesSubCategory,
	   pm.Name as [Types],
	   th.TransactionID,
	   th.ReferenceOrderID,
	   th.ReferenceOrderLineID,
	   th.TransactionDate,
	   th.TransactionType,
	   th.Quantity,
	   round(th.ActualCost, 2) as CostRounded,
	   round(th.Quantity * th.ActualCost, 2) as ExtendedPrice
from Production.TransactionHistory th
inner join Production.Product p
on th.ProductID = p.ProductID
inner join Production.ProductModel pm
on pm. ProductModelID = p.ProductModelID
inner join Production.ProductSubcategory ps
on ps.ProductSubcategoryID = p.ProductSubcategoryID
inner join Production.ProductCategory pc
on pc.ProductCategoryID = ps.ProductCategoryID
where pc.Name IN ('Clothing', 'Bikes'); 
-- Bikes added to the where clause in my v_Clothing_Transaction view.
GO

select * from v_Clothing_Transaction;
/*
We can see from previous queries that my view has grown in the amount of rows,
it went from around 10000 to almost 40000 rows. Altering views is a great way
to make sure that you do not alter the original tables and only work with a 
view object.
*/

select ProductName, 
	ProductNumber, 
	ReferenceOrderID, 
	Quantity, 
	ActualCost, 
	ExtendedPrice
from dbo.v_Product_TransactionHistory
where ReferenceOrderID = 53463
order by ProductName;

Update dbo.v_Product_TransactionHistory
set Quantity = 2
where ReferenceOrderID = 53463;
/*
We can update the values in a view, with a regular update query. We do this by 
referencing the view in the Update clause. There are limitations in that we have 
to reference a specific cell in the row.
*/

Update dbo.v_Clothing_Transaction
set Quantity = 8
where TransactionID = 100092;
/*
Here I am running an update query on the view I created previously, where the 
transactionid is 100092
*/

create view dbo.v_Product_TopTenListPrice
with encryption
as
select top 10
p.Name,
p.ProductNumber,
p.ListPrice
from Production.Product p
order by p.ListPrice desc;
go

select definition
	from sys.sql_modules as sm
	where object_id = OBJECT_ID('dbo.v_Product_TopTenListPrice');
-- This returns a NULL value.

select 
	OBJECT_DEFINITION(OBJECT_ID('dbo.v_Product_TopTenListPrice')) 
	as definition; 
	-- This returns a NULL value, as well. Functions as previous query.
/*
The encryption statement seems useful if we do not want others to view the 
background comments and the syntax in regards to the view. It is another level of
security to add to the database in order to protect its integrity.
*/

select * from v_Product_TopTenListPrice; 
/*
Encryption does not limit our access to seeing the rows in a view. This is all
a database user will need in most cases.
*/