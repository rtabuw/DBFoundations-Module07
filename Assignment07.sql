--*************************************************************************--
-- Title: Assignment07
-- Author: RaulTabile
-- Desc: This file demonstrates how to use Functions
-- Change Log: When,Who,What
-- 2022-06-03,RaulTabile,Created File
--**************************************************************************--
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'Assignment07DB_RaulTabile')
	 Begin 
	  Alter Database [Assignment07DB_RaulTabile] set Single_user With Rollback Immediate;
	  Drop Database Assignment07DB_RaulTabile;
	 End
	Create Database Assignment07DB_RaulTabile;
End Try
Begin Catch
	Print Error_Number();
End Catch
go
Use Assignment07DB_RaulTabile;

-- Create Tables (Module 01)-- 
Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL 
,[CategoryName] [nvarchar](100) NOT NULL
);
go

Create Table Products
([ProductID] [int] IDENTITY(1,1) NOT NULL 
,[ProductName] [nvarchar](100) NOT NULL 
,[CategoryID] [int] NULL  
,[UnitPrice] [money] NOT NULL
);
go

Create Table Employees -- New Table
([EmployeeID] [int] IDENTITY(1,1) NOT NULL 
,[EmployeeFirstName] [nvarchar](100) NOT NULL
,[EmployeeLastName] [nvarchar](100) NOT NULL 
,[ManagerID] [int] NULL  
);
go

Create Table Inventories
([InventoryID] [int] IDENTITY(1,1) NOT NULL
,[InventoryDate] [Date] NOT NULL
,[EmployeeID] [int] NOT NULL
,[ProductID] [int] NOT NULL
,[ReorderLevel] int NOT NULL -- New Column 
,[Count] [int] NOT NULL
);
go

-- Add Constraints (Module 02) -- 
Begin  -- Categories
	Alter Table Categories 
	 Add Constraint pkCategories 
	  Primary Key (CategoryId);

	Alter Table Categories 
	 Add Constraint ukCategories 
	  Unique (CategoryName);
End
go 

Begin -- Products
	Alter Table Products 
	 Add Constraint pkProducts 
	  Primary Key (ProductId);

	Alter Table Products 
	 Add Constraint ukProducts 
	  Unique (ProductName);

	Alter Table Products 
	 Add Constraint fkProductsToCategories 
	  Foreign Key (CategoryId) References Categories(CategoryId);

	Alter Table Products 
	 Add Constraint ckProductUnitPriceZeroOrHigher 
	  Check (UnitPrice >= 0);
End
go

Begin -- Employees
	Alter Table Employees
	 Add Constraint pkEmployees 
	  Primary Key (EmployeeId);

	Alter Table Employees 
	 Add Constraint fkEmployeesToEmployeesManager 
	  Foreign Key (ManagerId) References Employees(EmployeeId);
End
go

Begin -- Inventories
	Alter Table Inventories 
	 Add Constraint pkInventories 
	  Primary Key (InventoryId);

	Alter Table Inventories
	 Add Constraint dfInventoryDate
	  Default GetDate() For InventoryDate;

	Alter Table Inventories
	 Add Constraint fkInventoriesToProducts
	  Foreign Key (ProductId) References Products(ProductId);

	Alter Table Inventories 
	 Add Constraint ckInventoryCountZeroOrHigher 
	  Check ([Count] >= 0);

	Alter Table Inventories
	 Add Constraint fkInventoriesToEmployees
	  Foreign Key (EmployeeId) References Employees(EmployeeId);
End 
go

-- Adding Data (Module 04) -- 
Insert Into Categories 
(CategoryName)
Select CategoryName 
 From Northwind.dbo.Categories
 Order By CategoryID;
go

Insert Into Products
(ProductName, CategoryID, UnitPrice)
Select ProductName,CategoryID, UnitPrice 
 From Northwind.dbo.Products
  Order By ProductID;
go

Insert Into Employees
(EmployeeFirstName, EmployeeLastName, ManagerID)
Select E.FirstName, E.LastName, IsNull(E.ReportsTo, E.EmployeeID) 
 From Northwind.dbo.Employees as E
  Order By E.EmployeeID;
go

Insert Into Inventories
(InventoryDate, EmployeeID, ProductID, [Count], [ReorderLevel]) -- New column added this week
Select '20170101' as InventoryDate, 5 as EmployeeID, ProductID, UnitsInStock, ReorderLevel
From Northwind.dbo.Products
UNIOn
Select '20170201' as InventoryDate, 7 as EmployeeID, ProductID, UnitsInStock + 10, ReorderLevel -- Using this is to create a made up value
From Northwind.dbo.Products
UNIOn
Select '20170301' as InventoryDate, 9 as EmployeeID, ProductID, abs(UnitsInStock - 10), ReorderLevel -- Using this is to create a made up value
From Northwind.dbo.Products
Order By 1, 2
go


-- Adding Views (Module 06) -- 
Create View vCategories With SchemaBinding
 AS
  Select CategoryID, CategoryName From dbo.Categories;
go
Create View vProducts With SchemaBinding
 AS
  Select ProductID, ProductName, CategoryID, UnitPrice From dbo.Products;
go
Create View vEmployees With SchemaBinding
 AS
  Select EmployeeID, EmployeeFirstName, EmployeeLastName, ManagerID From dbo.Employees;
go
Create View vInventories With SchemaBinding 
 AS
  Select InventoryID, InventoryDate, EmployeeID, ProductID, ReorderLevel, [Count] From dbo.Inventories;
go

-- Show the Current data in the Categories, Products, and Inventories Tables
Select * From vCategories;
go
Select * From vProducts;
go
Select * From vEmployees;
go
Select * From vInventories;
go

/********************************* Questions and Answers *********************************/
Print
'NOTES------------------------------------------------------------------------------------ 
 1) You must use the BASIC views for each table.
 2) Remember that Inventory Counts are Randomly Generated. So, your counts may not match mine
 3) To make sure the Dates are sorted correctly, you can use Functions in the Order By clause!
------------------------------------------------------------------------------------------'
-- Question 1 (5% of pts):
-- Show a list of Product names and the price of each product.
-- Use a function to format the price as US dollars.
-- Order the result by the product name.

-- Used SELECT * FROM vProducts to view columns. From the Module07Notes.docx document I used the
--  Format function for the USA date format. 

SELECT
    ProductName
    ,UnitPrice = Format(UnitPrice, 'C', 'en-us') 
  FROM vProducts
  ORDER BY ProductName;
Go



-- Question 2 (10% of pts): 
-- Show a list of Category and Product names, and the price of each product.
-- Use a function to format the price as US dollars.
-- Order the result by the Category and Product.

-- Used SELECT statements to view columns in vCategories and vProducts. Used the Format function 
--  in Question 1 and joined vCategories and vProducts. Sorted by CategoryName,ProductName.

SELECT
    C.CategoryName
    ,P.ProductName
    ,UnitPrice = Format(P.UnitPrice, 'C', 'en-us') 
  FROM vCategories AS C
    INNER JOIN vProducts AS P
    ON C.CategoryID = P.CategoryID
  ORDER BY CategoryName,ProductName;
Go



-- Question 3 (10% of pts): 
-- Use functions to show a list of Product names, each Inventory Date, and the Inventory Count.
-- Format the date like 'January, 2017'.
-- Order the results by the Product and Date.

-- Used SELECT statements to view columns in vProducts and vInventories. Used the DateName function 
--  for the InventoryDate Month and Year information, joined vProducts and vInventories, and used the
--  Cast function to sort by calendar month. Sorted by ProductName and InventoryDate.

SELECT
    P.ProductName
    ,InventoryDate = DateName(MM, I.InventoryDate) + ', ' + DateName(YY, I.InventoryDate)
    ,InventoryCount = I.[Count] 
  FROM vProducts AS P
    INNER JOIN vInventories AS I
    ON P.ProductID = I.ProductID
  ORDER BY ProductName, CAST (InventoryDate AS DATE);
Go



-- Question 4 (10% of pts): 
-- CREATE A VIEW called vProductInventories. 
-- Shows a list of Product names, each Inventory Date, and the Inventory Count. 
-- Format the date like 'January, 2017'.
-- Order the results by the Product and Date.

-- Created the vProductInventories View using the code from Question 3. Had to remember to use TOP 
--  with ORDER BY. Sorted by ProductName and InventoryDate.

CREATE VIEW vProductInventories AS
  SELECT TOP 100000
    P.ProductName
    ,InventoryDate = DateName(MM, I.InventoryDate) + ', ' + DateName(YY, I.InventoryDate)
    ,InventoryCount = I.[Count] 
  FROM vProducts AS P
    INNER JOIN vInventories AS I
    ON P.ProductID = I.ProductID
  ORDER BY ProductName, CAST (InventoryDate AS DATE);
Go

-- Check that it works: Select * From vProductInventories;
go



-- Question 5 (10% of pts): 
-- CREATE A VIEW called vCategoryInventories. 
-- Shows a list of Category names, Inventory Dates, and a TOTAL Inventory Count BY CATEGORY
-- Format the date like 'January, 2017'.
-- Order the results by the Product and Date.

-- Created the vCategoryInventories View using the code from Questions 3 and 4 for hints. 
--  Used the SUM function for InventoryCountByCategory. Joined vCategories, vProducts, and
--  vInventories. Sorted by CategoryName, InventoryDate, and InventoryCountByCategory.

CREATE VIEW vCategoryInventories AS
  SELECT TOP 100000
    C.CategoryName
    ,InventoryDate = DateName(MM, I.InventoryDate) + ', ' + DateName(YY, I.InventoryDate)
    ,InventoryCountByCategory = SUM(I.[Count]) 
  FROM vCategories AS C
    INNER JOIN vProducts AS P
    ON C.CategoryID = P.CategoryID
    INNER JOIN vInventories AS I
    ON P.ProductID = I.ProductID
  GROUP BY C.CategoryName, I.InventoryDate
  ORDER BY CategoryName, CAST (InventoryDate AS DATE),InventoryCountByCategory;
Go

-- Check that it works: Select * From vCategoryInventories;
go



-- Question 6 (10% of pts): 
-- CREATE ANOTHER VIEW called vProductInventoriesWithPreviouMonthCounts. 
-- Show a list of Product names, Inventory Dates, Inventory Count, AND the Previous Month Count.
-- Use functions to set any January NULL counts to zero. 
-- Order the results by the Product and Date. 
-- This new view must use your vProductInventories view.

-- Created the vProductInventoriesWithPreviouMonthCounts View using the code from Questions 3-5
--  for hints. I had to ask my worker for help with this question. He said to use IsNull and
--  the Lag function for the PreviousMonthCount. Any Joins were accomplished by using the
--  vProductInventories view. Sorted by ProductName and InventoryDate.

CREATE VIEW vProductInventoriesWithPreviousMonthCounts AS
  SELECT TOP 100000
    ProductName
    ,InventoryDate
    ,InventoryCount
    ,PreviousMonthCount = ISNULL(LAG(InventoryCount) OVER (ORDER BY ProductName,Year(InventoryDate)),0) 
  FROM vProductInventories
  ORDER BY ProductName, CAST (InventoryDate AS DATE);
Go

-- Check that it works: Select * From vProductInventoriesWithPreviousMonthCounts;
go



-- Question 7 (15% of pts): 
-- CREATE a VIEW called vProductInventoriesWithPreviousMonthCountsWithKPIs.
-- Show columns for the Product names, Inventory Dates, Inventory Count, Previous Month Count. 
-- The Previous Month Count is a KPI. The result can show only KPIs with a value of either 1, 0, or -1. 
-- Display months with increased counts as 1, same counts as 0, and decreased counts as -1. 
-- Varify that the results are ordered by the Product and Date.

-- Created the vProductInventoriesWithPreviousMonthCountsWithKPIs View using Questions 6 
--  for hints. Case function was discussed in the Module07Notes.docx document. Sorted by
--  ProductName and InventoryDate.

CREATE VIEW vProductInventoriesWithPreviousMonthCountsWithKPIs AS
  SELECT TOP 100000
    ProductName
    ,InventoryDate
    ,InventoryCount
    ,PreviousMonthCount
    ,CountVsPreviousCountKPI = Case
      When InventoryCount > PreviousMonthCount Then 1
      When InventoryCount = PreviousMonthCount Then 0
      When InventoryCount < PreviousMonthCount Then -1
      End
    FROM vProductInventoriesWithPreviousMonthCounts
  ORDER BY ProductName, CAST (InventoryDate AS DATE);
Go

-- Important: This new view must use your vProductInventoriesWithPreviousMonthCounts view!
-- Check that it works: Select * From vProductInventoriesWithPreviousMonthCountsWithKPIs;
go



-- Question 8 (25% of pts): 
-- CREATE a User Defined Function (UDF) called fProductInventoriesWithPreviousMonthCountsWithKPIs.
-- Show columns for the Product names, Inventory Dates, Inventory Count, the Previous Month Count. 
-- The Previous Month Count is a KPI. The result can show only KPIs with a value of either 1, 0, or -1. 
-- Display months with increased counts as 1, same counts as 0, and decreased counts as -1. 
-- The function must use the ProductInventoriesWithPreviousMonthCountsWithKPIs view.
-- Varify that the results are ordered by the Product and Date.

-- Created the UDF fProductInventoriesWithPreviousMonthCountsWithKPIs with help from my coworker. 
--  From the Module07Notes.docx document we got the basic structure for the code. My initial code
--  didn't work because I left out the (@Value1 int) in the first and last lines of the code. My
--  coworker caught that error.

CREATE FUNCTION dbo.fProductInventoriesWithPreviousMonthCountsWithKPIs (@Value1 int)
  RETURNS TABLE AS
    RETURN SELECT      
      ProductName
      ,InventoryDate
      ,InventoryCount
      ,PreviousMonthCount
      ,CountVsPreviousCountKPI
    FROM vProductInventoriesWithPreviousMonthCountsWithKPIs
    WHERE CountVsPreviousCountKPI = @Value1;
Go


/* Check that it works:
Select * From fProductInventoriesWithPreviousMonthCountsWithKPIs(1);
Select * From fProductInventoriesWithPreviousMonthCountsWithKPIs(0);
Select * From fProductInventoriesWithPreviousMonthCountsWithKPIs(-1);
*/
go

/***************************************************************************************/