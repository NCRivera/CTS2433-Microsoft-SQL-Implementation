DECLARE @Employees TABLE
-- Here we are declaring a variable called @Employees to be a table.
( 
EmplId INT PRIMARY KEY CLUSTERED,
-- The variable with the table inside contains thre columns, 'EmplId' is the PK.
DeptId INT,
-- DeptId is another column that can contain an integer data type.
Salary NUMERIC(8, 2)
-- Salary column is a numeric value with up to 8 digits and a decimal points of 2.
);

INSERT INTO @Employees 
VALUES 
(1, 1, 10000), -- All of the following will be placed inside of the variable. 
(2, 1, 11000), -- Format is: Emplooyee ID, Department ID, salary
(3, 1, 12000),
(4, 2, 25000),
(5, 2, 35000),
(6, 2, 75000),
(7, 2, 100000); -- This query runs.

SELECT EmplId, DeptId, Salary, 
/* 
the first part of the query selects the employee information that was 
previously placed into the variable called @Employees. 
*/

PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Salary ASC) OVER (PARTITION BY DeptId) AS MedianCont, 
/*
 We begin the query by using the PERCENTILE_CONT() function followed by its syntax
This part of the query calculates the median of the salaries, due to the
use of the '0.5' in the function. This function returns a median number
that does not necessarily exists on the table.
*/

PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY Salary ASC) OVER (PARTITION BY DeptId) AS MedianDisc, 
/* 
The PERCENTILE_DISC(0.5) function again calculates the median salary of
of the employees in the department. The difference between the PERCENTILE_DISC()
and the PERCENTILE_CONT() function is the values returned in the results.
*/

PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Salary ASC) OVER (PARTITION BY DeptId) AS Percent75Cont, 
/*
PERCENTILE_DISC() returns a number, median value in this case but does not
exist within the table. PERCENTILE_CONT() returns the median value that exists
within the table.
*/

PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY Salary ASC) OVER (PARTITION BY DeptId) AS Percent75Disc, 
/*
We continue by retreiving the 75th percentile of salaries by using '0.75'
of the employees in department 1 and department 2.
*/

CUME_DIST() OVER (PARTITION BY DeptId ORDER BY Salary) AS CumeDist 
/*
The CUME_DIST() function calculates the cumulative distribution of 
all the values indicated by the select statement, in this case it is
salary information.
*/

FROM @Employees 
/*
All of this is done on the variable that contains a table and the 
values inserted into it.
*/
ORDER BY DeptId, EmplId; 
/*
Output
1	1	10000.00	11255	11255.00	11627.5	12000.00	0.333333333333333
2	1	11255.00	11255	11255.00	11627.5	12000.00	0.666666666666667
3	1	12000.00	11255	11255.00	11627.5	12000.00	1
4	2	25000.00	55000	35000.00	81250	75000.00	0.25
5	2	35000.00	55000	35000.00	81250	75000.00	0.5
6	2	75000.00	55000	35000.00	81250	75000.00	0.75
7	2	100000.00	55000	35000.00	81250	75000.00	1
*/