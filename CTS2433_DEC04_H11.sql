-- CTS2433
-- December 04, 2018

USE AdventureWorks;

declare @cur_bal decimal (7, 2) = 84235.49
/*  Here we are declaring a variable called Cur_Bal to be a decimal of seven 
    digits long and at a precision of two digits. It will be 84235.49.
	*/

declare @new_bal decimal (7, 2)
/*  Here we are declaring a new variable where we will place the results we 
    get after we run our query. It is also a decimal to a precision of two. 
	It is seven digits long.
	*/

set @new_bal = @cur_bal - (1500.00 - ROUND(@cur_bal * 0.05 / 12.00, 2))
/*  In this line we are setting the empty variable we created to be equal to the 
    above calculation. The above calculation subtracts the calculation of the
	current balance multiplied and divided by 5% interest and 12 months. This
	number is subtracted from the $1500 monthly payment. This leaves us with
	$1149.02 subtracted form the current balance. The new value is set in the 
	variable @newbal.  */

select  @new_bal
/*  The balance now is $83086.47.
    */
declare @balance decimal (8, 2) = 189299.59
declare @paidBalance decimal (8, 2)
set @PaidBalance = @balance - (675.00 - ROUND(@balance * 0.09 /12.00, 2))
select @paidBalance 
/*  First I declare my variable @balance to be an decimal that equals 189299.59 
    I create a @paidBalance variable to be a decimal data type with length of 
	8 (00000000) and precision of 2 (.00). Like the previous query I am taking 
	the interest charged and rounding it to 2 places and then I subtract this 
	value from the monthly payment to retrieve an number. I then subtract the 
	decimal number in the @balance variable from the returned number and I set
	the new result to be the @paidBalance variable. I select the @paidBalance
	to check my result: $190044.34.
	*/

USE AdventureWorks;
select 
EndOfDayRate, 
ROUND(EndOfDayRate, 1) as EODR_Dollar, 
ROUND(EndOfDayRate, 3) as EODR_Cent 
from Sales.CurrencyRate; -- Explain this
/*  Here, the query is demonstrating the use of the ROUND() function. The function
    takes two arguments, the record from the query and an integer to represent
	the precision. In the query, we retrieve the orginal EndOfDayRate column,
	we then take the same column with two different precisions. EODR_Dollar is
	precise up to one decimal place. EODR_Cent is precise up to three decimal
	places. So when we retrieve our results, if the EndOfDayRate was 1.9419 then
	the EODR_Dollar is 1.90 and the EODR_Cent is 1.942.
	*/

USE AdventureWorks;
select 
EndOfDayRate, 
ROUND(EndOfDayRate, 2) as EODR_Dollar, 
ROUND(EndOfDayRate, 5) as EODR_Cent 
from Sales.CurrencyRate; 
/*  Here I am modifying the previous query that was run. I am demonstrating
    the use of the precision argument for the ROUND() function. I used two 
	places in the EODR_Dollar column and five in the EODR_Cent column.
	*/

select SpecialOfferID, MaxQty, COALESCE(MaxQty, 0) as MaxQtyAlt
from Sales.SpecialOffer 
/*  First we begin the query by retrieving the SpecialOfferID followed by MaxQty.
    In the second column we have the possibility to retrieve NULLs in its fields.
	In order to replace NULL values that we do not want, we are going to replace
	the NULLs with a '0'. To do this, we will need the COALESCE() function. The 
	first argument of the function will takke the name of the column we want to
	use it against, in this case MaxQty. The second argument will take the 
	replacement value, which will be 0. The coalesced column wil be renamed 
	MaxQtyAlt. We can see from the resolts that any NULL in one column is a 0 in 
	the coalesced column.
    */

select SpecialOfferID, MaxQty, 
COALESCE(Cast(MaxQty as varchar), 'NaN') as MaxQtyNaN
from Sales.SpecialOffer
/*  Here I am retrieving the results that we have retrieved in the previous query 
    but now I want to return NaN (NaN means "Not A Number") in place of a 0 
	because the integer does not indicate anything to me. To do this I create 
	the previous query as before but in order to retrieve a character in a column
	with integer data types, i will need to convert it as such. I do thi by using
	the CAST() function on the MaxQty column as a VARCHAR data type. This is all
	placed within my COALESCE() function as the first argument. In the second 
	argument I then put the string 'NaN' that I want returned. You can see the 
	results are completed as I wanted, all NULLs are replaced with a 'NaN'.
    */

select FirstName, MiddleName = coalesce(MiddleName, 'NMN'), LastName
from Person.Person
/*  This is another example of the COALESCE() function. I replaced any MiddleName
    on the Person table with the string 'NMN' meaning 'No Middle Name'
	*/


declare @rmin int, @rmax int; set @rmin = 800; set @rmax = 1000;
select Name, cast(rand(CHECKSUM(NEWID())) * (@rmax - @rmin) as int) + @rmin
from Production.Product;
/*  This is a difficult query to follow so I will begin wwith the variables 
    and then break down the select statement by its individual parts/functions.
	First we declare our variables to be integer data type: @rmin, @rmax. Both
	are set to 800 and 1000 respectively.
	The select statement begins with the name column from the product table which
	is simple enogh. The scond column gets difficult in its generation of a random
	integer. The NEWID() function generates a random unique ID as the data type 
	uniqueidentifier. We pass this function through another function called 
	CHECKSUM() which takes the sum of the value it was passed and returns a 
	number. Our previous functions are passed through the RAND() function as a 
	seed argument. RAND() returns a random float number between 0 and 1. Since the 
	returned number in RAND() is a tiny float number we multiply this value by the
	value of @rmax minus @rmin or 200. Finally, we add the result of all 
	this by @rmin.
	*/

declare @step1 uniqueidentifier = NEWID()
declare @step2 int = cast(checksum(@step1) as int)
declare @step3 float = rand(@step2)
declare @step4 int = @step3 * 1000

select top 1 CONCAT(FirstName, ' ', LastName) as Name,
@step1 as step1,
@step2 as step2,
@step3 as step3,
@step4 as step4
from Person.Person

/*  This is my query to generate a unique id for an employee each time. Step1 
    column generates an ID with the NEWID() function.

	Step2 uses the CAST() function and CHECKSUM() function to return an integer.
	
	Step3 demonstrates the use of the previous steps result to be used as a seed
	number for use in the RAND() function. 
	
	Step4 generates an integer based on the returned value from Step3 by 
	multiplying the value by 1000. This gives us our new number.
	*/