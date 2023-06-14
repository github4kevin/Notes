/*****************************
 Useful MSSQL String Functions
*****************************/

-- Drop the TempTable if it already exists --

IF OBJECT_ID('TempDB..#Temp') IS NOT NULL
	DROP TABLE #TempName;

-- Drop scalar-valued function if it already exists --

IF OBJECT_ID('dbo.[FunctionName]') IS NOT NULL
	DROP FUNCTION
	dbo.[FunctionName];

-- Count the Length of any String --

SELECT
	LENGTH('Hello, my name is')

-- Count the Length of any Column --

SELECT
	LENGTH([ColumnName])

-- This will pull results in lowercase --

SELECT
	LOWER('Hello, my name is Paul');

-- This will pull results in uppercase --

SELECT
	UPPER('Hello, my name is Paul');

-- Return string text/values starting from 'x' - 'z' --
-- Below Output = 'ohn'

SELECT
	SUBSTRING('John', 2, 20)

-- Example #2 --

SELECT
	SUBSTRING(ColumnName, 2, 20)

-- Below Output = 'oh'

SELECT
	SUBSTRING('John', 2, 2)

-- Example #2 --

SELECT
	SUBSTRING([ColumnName], 2, 2)

-- Replace a String based on "find this" & "replace with that" (or removing it completely) --
-- Replacing a [ColumnName] > Find a name > Replace it with Another --

SELECT
	REPLACE([ColumnName], 'John Smirh', 'John Smith')

/*********************************************
 How to Convert / Combine Multiple Data-Types 
*********************************************/

-- Below Converts INT to VARCHAR - Then Combines with Text --

SELECT
	CONVERT(VARCHAR(20), 10) + 'Text'

SELECT
	CAST(10 AS VARCHAR(20)) + 'Text'

-- Below Converts VARCHAR to INT - Then Combines with Number --

SELECT
	CONVERT(INT, '10') + 40

SELECT
	CAST('10' AS INT) + 40

/*****************************
 Useful MSSQL Number Functions
*****************************/

-- This will round certain decimals (float data-types) to the nearest whole number --

SELECT
   ROUND(5.4),
   ROUND(5.5),
   ROUND(5.6);

-- This will ALWAYS round up any decimal to the next whole number --

SELECT
	CEILING(5.4),
	CEILING(5.5),
	CEILING(6);

-- This will ALWAYS round down any decimal to the below whole number --

SELECT
	FLOOR(5.4),
	FLOOR(5.5),
	FLOOR(6);

/**********************
 SQL Aggregation Notes 
**********************/

-- This will COUNT all records in the results --

SELECT
	COUNT(*)
FROM [TableName]

-- This will Add (SUM) all records in the results --

SELECT
   SUM(*)
FROM [TableName]

-- This will Average (AVG) all records in the results --

SELECT
   AVG(*)
FROM [TableName]

-- This will calculate the minimum (MIN) all records in the results --

SELECT
   MIN(*)
FROM [TableName]

-- This will calculate the maximum (MAX) all records in the results --

SELECT
   MAX(*)
FROM [TableName]

/*********************
 Concatenate Function 
*********************/

-- Below Output = FirstNameLastName (Without a Space) --

SELECT
	ColumnA + ColumnB AS FirstAndLastName

-- Bewlo Output = FirstName LastName (With a Space) --

SELECT
	ColumnA + ' ' + ColumnB AS FirstAndLastName

/******************************
 Casting Statements - Examples 
******************************/

-- Below Results: 14 (result is truncated) --

SELECT
	CAST(14.85 AS INT);

-- Below Results: 14.85 (result is not truncated)

SELECT
	CAST(14.85 AS FLOAT);

-- Below Results: '15.6' (as a text value, meaning you can concatenate with another text value)

SELECT
	CAST(15.6 AS VARCHAR);

-- Below Results: '15.6'(Also as a text value, meaning you can concatenate with another text value)

SELECT
	CAST(15.6 AS VARCHAR(4));

-- Below Results: 15.6 (as a decimal output - assuming it was a different data-type)

SELECT
	CAST('15.6' AS FLOAT);

-- Below Results: '2014-05-02 00:00:00.000' (adds the time values)

SELECT
	CAST('2014-05-02' AS DATETIME);

/********************
Declaring a Variable 
********************/

-- Short Example of Declaring a Variable --

DECLARE @number INT

SET @number = 50

SELECT
	@number

/****************
COALESCE function
****************/

-- The COALESCE function results the first non-null value it finds --

SELECT
	COALESCE(Column1, Column2, Column3)

/****************************
Mass Updating DATETIME Field 
****************************/

-- From 00:00:00.000 to 23:59:59:997 (Of The Next Day) --

UPDATE [TABLE]
SET [ColumnDate] = DATEADD(ms, -3, [ColumnDate])

/****************************************
 Drop vs Truncate vs Delete Commands 
 
 Truncate will:
	- Maintain all table columns
	- No where clause
	- Locks the table/database
	- Cannot be rolledback
	- Pretty fast
	- DDL
 Delete will:
	- Maintain all table columns
	- A where clause can be included
	- Locks each row during deletion
	- Less faster than truncate
	- We can rollback changes
	- DML
 Drop will:
	- Does not maintain the table columns
		- You will have to recreate the columns
	- The slowest action out of the 3
	- No where clause
	- DDL
****************************************/

-- Truncate Table -- 

TRUNCATE TABLE [TableName]

-- Drop Table -- 

DROP TABLE [TableName]

-- Delete Table --

DELETE FROM [TableName]

/***************************************
 Creating Table Variables & Temp Tables 
***************************************/

IF OBJECT_ID('TempDB..#test') IS NOT NULL
	DROP TABLE #test;

-- Creating a Temp Table --
-- These are only available in the creator's instance --

CREATE TABLE #test (RowNum INT)

INSERT INTO #test
	SELECT 1

SELECT
	*
FROM #test

-- Creating a Table Variable --

DECLARE @test TABLE (RowNum INT
	PRIMARY KEY NOT NULL IDENTITY (1, 1)) -- Including an identity column to keep count of the rows --

SELECT
	*
FROM @test

-- Creating a Regular Table with Identity as PK

CREATE TABLE test (RowNum INT IDENTITY (1, 1) NOT NULL,
				   CONSTRAINT PK_test PRIMARY KEY (RowNum)) -- Auto Generate ID & Making it PK --


-- Creating a Global Temp Table --
-- These will be available by multiple users until all users close their instances --

CREATE TABLE ##GlobalTempTable -- Characterized by the double hashtag --
(column_1 INT
 PRIMARY KEY NOT NULL IDENTITY (1, 1),
 column_2 INT NULL,
 column_3 VARCHAR(50) NULL,
 column_4 BIT NOT NULL)

/***************************
 CASE WHEN Statement Example
***************************/

SELECT
	CASE [ColumnName]
		WHEN 1
		THEN 2
		ELSE 0 END AS [NewColumnName]
FROM [TableName]

-- Another CASE WHEN Statement --

SELECT
	[Original Salary] = p.salary,
	[New Salary] = CASE
					  WHEN p.salary IS NULL  -- If Salary is NULL
					  THEN '0'					  -- Then Output a "0" value
					  ELSE p.salary			  -- Otherwise, output the salary value that exists
				  END
FROM placement AS p
WHERE p.salary IS NULL

-- Advanced CASE WHEN Statement with Subquery -- 

SELECT
	[Original Country] = c.code_text,
	[New Country] = CASE
					   WHEN NOT EXISTS		  -- When Country Doesn't Exist --
						   (SELECT
								   country_id
							   FROM placement_address AS pla
							   WHERE pla.country_id = pa.country_id)
					   THEN 'United States'  -- Then Output "United States"
				   END
FROM placement AS p
INNER JOIN placement_address AS pa ON p.placement_id = pa.placement_id
LEFT OUTER JOIN codes AS c ON pa.country_id = c.code_id
WHERE c.code_text IS NULL

/****************************************
 DataLength - Storage Size per Data-Type 
****************************************/

DECLARE @big BIGINT = 60, -- +/- huge number over 2 billion
		@int INT = 40, -- +/- 2 billion
		@small SMALLINT = 20, -- +/- 32k
		@tiny TINYINT = 10, -- +/- 0 - 255
		@bit BIT = 1   -- 0 or 1 (Used for True or False)

SELECT
	DATALENGTH(@big) AS big_bytes,
	DATALENGTH(@int) AS int_bytes,
	DATALENGTH(@small) AS small_bytes,
	DATALENGTH(@tiny) AS tiny_bytes,
	DATALENGTH(@bit) AS bit_bytes

DECLARE @regmoney MONEY = 12345.89, -- +/- a huge number
		@smallmoney SMALLMONEY = 12345.89  -- +/- 214k

SELECT
	DATALENGTH(@regmoney) AS regular_money_bytes,
	DATALENGTH(@smallmoney) AS small_money_bytes

/*******************
WRITING A WHILE LOOP
*******************/

DECLARE @loopcounter INT = 1

WHILE (@loopcounter <= 4)
BEGIN
	PRINT @loopcounter
	SET @loopcounter = @loopcounter + 1
END

/*************************
DIFFERENCE BETWEEN 2 DATES
*************************/

DECLARE @start DATETIME = '2/1/2008',
		@end DATETIME = '2/1/2009'

-- ww = Difference by Weeks --

SELECT
	DATEDIFF(ww, @start, @end)

/****************************************************************************************
USING WILDCARDS IN SQL SERVER

WHERE CustomerName LIKE 'a%'	 - Any values that starts with "a"
WHERE CustomerName LIKE '%a'	 - Any values that ends with "a"
WHERE CustomerName LIKE '%or%'	 - Any values that have "or" in any position
WHERE CustomerName LIKE '_r%'	 - Any values that have "r" in the second position
WHERE CustomerName LIKE 'a_%_%'	 - Any values that starts with "a" & at least 3 characters
WHERE CustomerName LIKE 'a%o'	 - Any values that starts with "a" and ends with "o"
WHERE CustomerName LIKE 'c[a-b]t'- Any Values that starts with 'c' & ends with 't' []

%	- Zero or more characters				- Ex: bl% finds bl, black, blue, and blob
_	- A single character					- Ex: h_t finds hot, hat, and hit
[]	- Any single character within brackets  - Ex: h[oa]t finds hot and hat, but not hit
^	- Any character not in the brackets		- Ex: h[^oa]t finds hit, but not hot and hat
-	- A range of characters					- Ex: c[a-b]t finds cat and cbt
****************************************************************************************/

-- Output Below Shows Any Text That Has "Kevin" --

SELECT
	*
FROM [TableName]
WHERE [ColumnName] LIKE '%Kevin%'

-- Output Below Shows Any Text That Has "?evin" --

SELECT
	*
FROM [TableName]
WHERE [ColumnName] LIKE '%_evin%'

-- Output Below Shows Any Ending Alphabet Character --

SELECT
	*
FROM [TableName]
WHERE [ColumnName] LIKE '%[A-Z]'

-- Output Below Shows Any Beginning Alphabet Character --

SELECT
	*
FROM [TableName]
WHERE [ColumnName] LIKE '[A-Z]%'

-- Output Below Shows Any Non-Alphabet Characters (The '^' Means Not Within a Range) --

SELECT
	*
FROM [TableName]
WHERE [ColumnName] LIKE '^[A-Z]%'

/*****************************************
 Converting Milliseconds to HH:MM:SS:MS

- Good for movie/shows/appointments, etc. 
*****************************************/

SELECT
	[MilliSecondColumn]
(SELECT
	CONVERT(VARCHAR, DATEADD(ms, [MilliSecondColumn], 0), 114) -- ms = Millisecond
)
FROM [TableName]


/******************************************************************
Creating a View via Stored Procedure

You cannot include an ORDER BY clause when creating views this way.
******************************************************************/

CREATE PROC [ProcedureName]
AS
EXEC ('
CREATE VIEW [ViewName]
AS
SELECT
   [ColumnName]
FROM [TableName]
')

/*********************************
Creating a Simple Stored Procedure
*********************************/

CREATE PROC [ProcedureName]
AS
   BEGIN
      SET NOCOUNT ON
      SELECT
         [ColumnName]
      FROM [TableName]
   END

/**************************************************
Creating a Stored Procedure with Optional Parameters 
**************************************************/

CREATE PROC [ProcedureName] @parameter1 INT, 
                            @parameter2 INT
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT [ColumnName1], 
               [ColumnName2]
        FROM [TableName]
        WHERE([ColumnName1] = @parameter1
              OR @parameter1 IS NULL) -- This makes it an optional parameter
             AND ([ColumnName2] = @parameter2
                  OR @parameter2 IS NULL); -- This makes it an optional parameter
    END

/**************************************************************
If a date range is not supplied, default this years date range
**************************************************************/

DECLARE
	@fromdate DATETIME = NULL,
	@todate   DATETIME = NULL

IF @fromdate IS NULL
	SELECT
		@fromdate = CONVERT(DATETIME, '1/1/' + CONVERT(VARCHAR, YEAR(GETDATE())))

IF @todate IS NULL
	SELECT
		@todate = CONVERT(DATETIME, '12/31/' + CONVERT(VARCHAR, YEAR(GETDATE())))

SELECT
	@fromdate,
	@todate

/*******************************************************
When Replacing 'NTEXT', It Must Be Converted to NVARCHAR
*******************************************************/

SELECT
	m.message_id,
	m.message_text,
	updated_message_text =
                            (
                            SELECT
                                (REPLACE(CAST(m.message_text AS NVARCHAR(MAX)), 'Career Management Center', 'Center for Career and Professional Development'))
                            FROM messages
                            WHERE message_id = m.message_id -- Joining Back to Outside Query
                            )
FROM #screenmessages_careermanagementcenter AS cmc
	INNER JOIN messages AS m ON cmc.msg_id = m.message_id

/****************************************
Returning the Full Month Name from a Date
****************************************/

SELECT
	DATENAME(MONTH, GETDATE())

/*****************************************
DATALENTH function for 'TEXT' Data Types  
The LEN function for non 'TEXT' Data Types
*****************************************/

SELECT
	TextField,
	DATALENGTH(TextField) AS character_count, -- YOU MUST USE THE DATALENGTH FUNCTION FOR A 'TEXT' DATA TYPE
	LEN(non_textfield) AS character_count -- YOU CAN USE THE REGULAR 'LEN' FUNCTION FOR NON 'TEXT' DATA TYPES
FROM [TableName]

/**********************************************************************
Updating DateTime from 00:00:00.000 Midnight & Reversing 3 Milliseconds
**********************************************************************/

UPDATE [TABLE]
SET
	ColumnDate = DATEADD(ms, -3, ColumnDate)

/*********************************************************************
Separate Multiple Values Within One Column Using Built-in SQL Function
*********************************************************************/

SELECT
	REVERSE(PARSENAME(REPLACE(REVERSE([ColumnWithMultipleValues]), '[Delimiter]', '.'), 1)) AS [ColumnForValue#1],
	REVERSE(PARSENAME(REPLACE(REVERSE([ColumnWithMultipleValues]), '[Delimiter]', '.'), 1)) AS [ColumnForValue#2]
FROM [TableName]

/***********************************************************************
The STUFF & REPLACE Functions Together (Example is specific to PlexData)
***********************************************************************/

SELECT
	FilePath = STUFF(REPLACE(FilePath, '/volume1/Kevin/Media/Movies/', ''), 1,
                                                                            (
                                                                                SELECT
                                                                                    LEN(FolderName)
                                                                            ), '')
FROM [TableName]

/************************
Unique Constraint Syntax 
************************/

ALTER TABLE [TableName]
ADD CONSTRAINT Unique_[TableName] UNIQUE([Unique_ColumnName])