-- December 16, 2018
-- CTS2433

/*
Final Project

Use T-SQL to execute the following tasks:
1-Handling Batch errors.(Book,20-1)

2-Identify errors numbers as well as the messages in SQL (Book,20-2)

3-Implement structured error handling in the queries you are using (Book,20-3)

I will allow you to use similar queries  to the ones in the book as long as you 
recreate a different case scenario (changing some parameters of the query, if 
not clear consult with the instructor during class or office hours). It is 
vital that you explain every line of code in detail as well as the output 
obtained after having ran your corresponding queries. 
*/


-- 20-1
USE master;

IF EXISTS(SELECT * FROM sys.databases WHERE name = 'Errors')
BEGIN
DROP DATABASE Errors;
CREATE DATABASE Errors;
END;
ELSE CREATE DATABASE Errors;
/*
The above statement will first search the mmaster database for the specified 
Object called 'Errors'. It does this by using the EXISTS() function which
passes through it a select query that specifies the object we want returned.
If this object 'Errors' exists, the query will first grop the database called
'Errors'. It will then create a database called 'Errors'. These statements are 
followed by another statement else which will create a database called 'Errors'
if the previous statement if returned as False. Since this Object does not exist
in my environment the else statement is the one that executes in this case.
*/

USE Errors;
/*
Here the statement indicates to use the database I just created, called 'Errors'.
*/

CREATE TABLE Works(
number	INT);
/*
This query creates a simple table called Works on the Errors Database.
*/

INSERT Works
VALUES(1), 
	  ('A'),
	  (3);
/*
The insert statement above should not be able to run because of the data type 
of the second entry. 'A' is not an integer.
*/

SELECT *
FROM Works;
/*
This shows the results of the table that we have just created and the values 
we tried to insert. By itself, it will be blank due to the failed queries.
*/

/*
If the above few statements are run together, they will not be able to all be 
evaluated, there will be failures. According to the book, SQL Server is executing 
all of the queries at the same time. In the previous case we are running
queries against a database and table that have not yet been created. What this 
means is that some of the queries that are based on other queries, such as the 
insert statement will not execute because it does not exist yet. In order for 
everything to execute without issue, we would need to run everything individually
by highlighting and selecting the queries by themselves and executing.
*/


USE master;
/*
We now begin with the master database as we did in the previous query in order to
run the following queries without issue.
*/

IF EXISTS(SELECT * FROM sys.databases WHERE name = 'Errors')
BEGIN
DROP DATABASE Errors;
CREATE DATABASE Errors;
END;
ELSE CREATE DATABASE Errors;
GO
/*
As before we are running the if statement to react based on the existence of a 
database object, specifically the Errors database. The difference between this
query and our previous one is the keyword following the execution of the query.
GO indicates to SQL server that it should run the previous query, individually.
In place of selecting the query that we want to run by itself, the GO statement 
takes the place of this.
*/

USE Errors;
/*
As a result of the GO statement previously. This statement will run without issue 
as well. You will see the next Go statement to indicate that this is a new batch 
of to run.
*/

CREATE TABLE Works(
number	INT);
GO
/*
Now, with the GO keyword, we indicate that the previous queries be run which
include our the Use of the errors database and the creation of the table.
The particular query is executed without any errors, as well.
*/


INSERT Works
VALUES(1), 
	  ('A'),
	  (3);
GO
/*
This particular query is a perfect example of use case scenarios when it comes to 
error handling. We can see that the table that was created previously was only the
data type of integer. The second value that is being inserted here is a string 
value 'A'. Once this query executes, it will fail. As a result of the go 
statement, only this particular query will fail and not the whole set of queries.
*/

INSERT Works
VALUES(1), 
	  (2),
	  (3);
GO
/*
This is an example of the proper use of the previous query. Again, it will execute
individually instead of as a set of queries. The results from this query indicate
that three rows are effected.
*/

SELECT *
FROM Works;

GO
/*
And finally we are wraaping the last select statement in its own individual
statement to be executed.
*/


/* -- MY OWN QUERY BELOW DEMONSTRATING USE OF PREVIOUS LESSON. -- */

USE master;
/*
I am making sure my query will not run into errors by using the master database.
*/

IF EXISTS(SELECT * FROM sys.databases WHERE name = 'Alphabet')
BEGIN
	DROP DATABASE Alphabet;
	CREATE DATABASE Alphabet;
END;
ELSE 
	CREATE DATABASE Alphabet;
GO
/*
As with my previous query I am checking whether the Alphabet Database Object
exists in my environment. As it does not exists, The else statement is executed 
in this case. This is followed by a go keyword indicating that this needs to be 
run before continuing with the next queries.
*/

USE Alphabet;
/*
I am now refering to the database Alphabet with my next queries, this will
ensure that I start using it.
*/

CREATE TABLE AlphaCharacters(
Letters CHAR(1));
GO
/*
Following the formatting of the book example I am testing the use of the GO 
statement using a table called AlphaCharacters that has a column called letters.
It will only receive a character the size of 1. Afterwards, these are followed by
the GO in order to run by itself.
*/

INSERT AlphaCharacters
VALUES('X'), 
	  (2),
	  ('Z');
GO
/*
I am wrapping this current statement to demonstrate a failure and use of the GO.
This fails because of the second value, 2, which is an integer in a column which 
takes ony characters.
*/

INSERT AlphaCharacters
VALUES('A'), 
	  ('B'),
	  ('C');
GO
/*
A successfully executed statement, this insert statement fits all the criteria in 
that the column requires. It is individually executed because of the GO statement.
*/

SELECT *
FROM AlphaCharacters;
GO
/*
A select statement to check the results of my query, it is completed by iteslf.
We can see which queries were successful and which ones were terminated due to 
an error.


--QUERY RESULTS--
Msg 245, Level 16, State 1, Line 189
Conversion failed when converting the varchar value 'X' to data type int.

(3 rows affected)

(3 rows affected)



GO is a useful way to do what I have been doing manually throughout the semester.
Execute each statement individually as if it is in its own bubble. I will use
this from now on.
*/



-- 20-2
SELECT 
	message_id,  -- Here we are checking the id of the message, this is likely the PK of the table.
	severity, -- There are different severity levels in the table with a large range.
	text -- Attached to the table is an explanation of each unique error message.
FROM 
	sys.messages -- This is where all the error messages are stored
WHERE 
	language_id = 1033; -- the language id of english is 1033, there are many others in the table
GO


Declare @MaxLevel int = (
SELECT MAX(severity) 
FROM sys.messages 
WHERE language_id = 1033
)

SELECT 
	message_id, 
	severity, 
	text
FROM 
	sys.messages
WHERE 
	language_id = 1033
	AND
	severity = @MaxLevel
ORDER BY 
	message_id
GO
/*
The error meesages that we can recieve in SQL is very large. We cannot possibly
go through each one of these. A use case for the query we ran previously is 
finding the error messages with the highest severity levels.
I first declare a variable to to be an integer and it will return the max value of
the severity level in the table, this is done with a select statement. I specify
my query as usual and pass. the declared variable into the where statement.
There are 10 errors with a severity of the highest value which is 24.
*/


-- 20-3
BEGIN TRY
SELECT 1/0
END TRY
BEGIN CATCH
END CATCH;
GO
/*
The above query is a demonstration of error handling in SQL.
It begins by introduing the keywords BEGIN TRY indicating that the following
statements after it can result in a error. In this case, we are creating a Zero
Division error with the manner that we use the select statement. We indicate the 
end of the statement with a END TRY.

After this we use the syntax BEGIN CATCH to indicate what should be done with a 
failure of the try statement. This should be followed by another group of 
statements to complete. We end the BEGIN CATCH with the syntax END CATCH.
In this case nothing is returned and we retrieve nothing back, but we were able 
to avoid an error occurring by implementing those statements.
*/

BEGIN TRY
	SELECT 1/0
END TRY
BEGIN CATCH
	SELECT 'This will work because it does not contain an error' as String
END CATCH;
GO
/*
In order to demonstrate use of the error handling statements, I use the 
previous zero division error statement along with a str to return if I 
receieve an error from the first try statement.
I am able to retrieve back a statement that I created to demonstrate its use.
The Catch Statement was executed without issue.
*/



BEGIN TRY
  SELECT 1/0 
END TRY
BEGIN CATCH
  SELECT ERROR_LINE() AS 'Line',
		 ERROR_MESSAGE() AS 'Message',
		 ERROR_NUMBER() AS 'Number',
		 ERROR_PROCEDURE() AS 'Procedure',
		 ERROR_SEVERITY() AS 'Severity',
		 ERROR_STATE() AS 'State'
END CATCH;
GO
/*
The query above contains the same syntax as above in order to purposefully throw 
back an error. Now CATCH statement contains the information regarding the error
that was returned in the first query using functions.

ERRORLINE() indicates the relative line number of the error.
ERROR_MESSAGE() the text describing the type of error
ERROR_NUMBER() 
ERROR_PROCEDURE() returns procedure type
ERROR_SEVERITY() returns system-wide severity level
ERROR_STATE() returns the state of the error
*/

BEGIN TRY
	THROW 50000, 'Error by using THROW statement.', 10;
END TRY
BEGIN CATCH
  SELECT ERROR_LINE() AS 'Line',
		 ERROR_MESSAGE() AS 'Message',
		 ERROR_NUMBER() AS 'Number',
		 ERROR_STATE() AS 'State'
END CATCH;
GO
/*
Here I created my own query to demonstrate use of the previous functions.
Using the RAISERROR() function does not work with the TRY-CATCH block as will
not return the CATCH block. In order to make use of the CATCH block I use the 
THROW to raise an exception. I create my own exception as I don't want to use
a ZeroDivision exception. I trimmed the functions used because not all return 
relevant data in reagrds to the exception I raised.
*/


BEGIN TRY
  SELCT -- Syntax error!
END TRY
BEGIN CATCH
END CATCH;
GO
/*
The TRY and CATCH blocks do not catch syntax query errors as demonstrated by the
error in the above query. I demonstrate this below with GETDATE() function.
*/

BEGIN TRY
  SELECT GETDATE()
END TRY
BEGIN CATCH
END CATCH;
GO
/*
No exceptions or errors are raised so we retrieve the current date and time. The
TRY block is activated in this case.
*/

BEGIN TRY
  SELECT NoSuchTable -- This does not exist anywhere.
END TRY
BEGIN CATCH
END CATCH;
GO
/*
Another error raised as a result of a non-existent column. The TRY-CATCH block 
will not be caught in this context as well.
*/

BEGIN TRY
  SELECT NonExistentColumn from AlphaCharacters 
END TRY
BEGIN CATCH
END CATCH;
GO
/*
Here I'm calling a column that does not exist in my Alphabet Database like the 
query above.
*/

BEGIN TRY
  RAISERROR('Information ONLY', 10, 1)
END TRY
BEGIN CATCH
	PRINT('Will not be caught!') -- Here, I modified the syntax of the recipe.
END CATCH;
GO
/*
RAISERROR() function does not return the catch block because it is limited to a 
severity level high than 10.
*/

BEGIN TRY
  RAISERROR('Will not be executed because severity level is high enough', 11, 1)
END TRY
BEGIN CATCH
	PRINT('CATCH block. This is caught because severity level is high enough. 
Severity must be GREATER THAN 10!')
END CATCH;
GO
/*
With my own query you can see the severity level activates the CATCH block of code
so my own print message comes out as the results of the query.
*/