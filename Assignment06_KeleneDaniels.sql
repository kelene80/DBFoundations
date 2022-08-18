--*************************************************************************--
-- Title: Assignment06
-- Author: KKDaniels
-- Desc: This file demonstrates how to use Views
-- Change Log: When,Who,What
-- 2017-01-01,KKDaniels,Created File
--**************************************************************************--
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'Assignment06DB_KKDaniels')
	 Begin 
	  Alter Database [Assignment06DB_KKDaniels] set Single_user With Rollback Immediate;
	  Drop Database Assignment06DB_KKDaniels;
	 End
	Create Database Assignment06DB_KKDaniels;
End Try
Begin Catch
	Print Error_Number();
End Catch
go
Use Assignment06DB_KKDaniels;

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
,[UnitPrice] [mOney] NOT NULL
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
,[EmployeeID] [int] NOT NULL -- New Column
,[ProductID] [int] NOT NULL
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
(InventoryDate, EmployeeID, ProductID, [Count])
Select '20170101' as InventoryDate, 5 as EmployeeID, ProductID, UnitsInStock
From Northwind.dbo.Products
UNIOn
Select '20170201' as InventoryDate, 7 as EmployeeID, ProductID, UnitsInStock + 10 -- Using this is to create a made up value
From Northwind.dbo.Products
UNIOn
Select '20170301' as InventoryDate, 9 as EmployeeID, ProductID, UnitsInStock + 20 -- Using this is to create a made up value
From Northwind.dbo.Products
Order By 1, 2
go

-- Show the Current data in the Categories, Products, and Inventories Tables
Select * From Categories;
go
Select * From Products;
go
Select * From Employees;
go
Select * From Inventories;
go

/********************************* Questions and Answers *********************************/
print 
'NOTES------------------------------------------------------------------------------------ 
 1) You can use any name you like for you views, but be descriptive and consistent
 2) You can use your working code from assignment 5 for much of this assignment
 3) You must use the BASIC views for each table after they are created in Question 1
------------------------------------------------------------------------------------------'

-- Question 1 (5% pts): How can you create BACIC views to show data from each table in the database.
-- NOTES: 1) Do not use a *, list out each column!
--        2) Create one view per table!
--		  3) Use SchemaBinding to protect the views from being orphaned!


-- Show the Current data in the Categories, Products, and Inventories Tables to determine columns for view

--Select * From Categories;
--go
--Select * From Products;
--go
--Select * From Employees;
--go
--Select * From Inventories;


--- Final Script To Run

Create View vCategories
With SchemaBinding
 AS
	Select CategoryId, CategoryName
		From dbo.Categories;
Go
Create View vProducts
With SchemaBinding
 AS
	Select ProductId, ProductName, CategoryID, UnitPrice
		From dbo.Products;
Go
Create View vEmployees
With Schemabinding
 AS
	Select EmployeeID, EmployeeFirstName, EmployeeLastName, ManagerID	
		From dbo.Employees;
Go
Create View vInventories
With Schemabinding
 AS
	Select InventoryID, InventoryDate, EmployeeID, ProductID, [Count]
		From dbo.Inventories
  

-- Question 2 (5% pts): How can you set permissions, so that the public group CANNOT select data 
-- from each table, but can select data from each view?


--Create View vCategories
--With SchemaBinding
--	AS
--	Select CategoryId, CategoryName
--		From dbo.Categories;
--Go
--Create View vProducts
--With SchemaBinding
--	AS
--	Select ProductId, ProductName, CategoryID, UnitPrice
--		From dbo.Products;
--Go
--Create View vEmployees
--With Schemabinding
--	AS
--	Select EmployeeID, EmployeeFirstName, EmployeeLastName, ManagerID	
--		From dbo.Employees;
--Go
--Create View vInventories
--With Schemabinding
--	AS
--	Select InventoryID, InventoryDate, EmployeeID, ProductID, [Count]
--		From dbo.Inventories



-- Question 3 (10% pts): How can you create a view to show a list of Category and Product names, 
-- and the price of each product?
-- Order the result by the Category and Product!

-- Here is an example of some rows selected from the view:
-- CategoryName ProductName       UnitPrice
-- Beverages    Chai              18.00
-- Beverages    Chang             19.00
-- Beverages    Chartreuse verte  18.00


---- Look at all data from Categories and Products

--Select * From Categories;
--Go
--Select * From Products;

---- Look at specific data needed

--Select CategoryName From Categories;
--Go
--Select ProductName, UnitPrice From Products;

---Combine the results through join and order by

--Select C.CategoryName, P.ProductName, P.UnitPrice
--From Categories as C
--Join Products as P 
--	On Categories.CategoryID = Products.CategoryID
--Order By 1, 2, 3


---- Final Script Create View 

Create View vProductsByCategories
AS
 Select Top 1000000
	C.CategoryName,
	P.ProductName,
	P.UnitPrice
 From vCategories as C
	Join vProducts as P
		On C.CategoryId = P.CategoryID
 Order By 1, 2, 3;

 -----Verify Final Scrip Above Works

 Select * From vProductsByCategories



-- Question 4 (10% pts): How can you create a view to show a list of Product names 
-- and Inventory Counts on each Inventory Date?
-- Order the results by the Product, Date, and Count!

-- Here is an example of some rows selected from the view:
-- ProductName	  InventoryDate	Count
-- Alice Mutton	  2017-01-01	  0
-- Alice Mutton	  2017-02-01	  10
-- Alice Mutton	  2017-03-01	  20
-- Aniseed Syrup	2017-01-01	  13
-- Aniseed Syrup	2017-02-01	  23
-- Aniseed Syrup	2017-03-01	  33

---- Look at all data

--Select * From Categories;
--go
--Select * From Products;
--go
--Select * From Inventories;
--go

------ Look at specific data needed using Aliases

--Select CategoryName From Categories As C;
--Go
--Select ProductName From Products As P;
--Go
--Select InventoryDate, Count From Inventories As I;

----- Combine the results using Aliases

--Select CategoryName, ProductName, InventoryDate,Count
--From Categories as C
--Join Products as P
--On P.CategoryID = C.CategoryID
--Join Inventories as I
--On P.ProductId = I.ProductID;

------ Order the results

--Select CategoryName, ProductName, InventoryDate,Count
--From Categories as C
--Join Products as P
--On P.CategoryID = C.CategoryID
--Join Inventories as I
--On P.ProductId = I.ProductID
--Order By CategoryName, ProductName, InventoryDate, Count;

---- Final Script Create View 

Create View vInventoriesByProductsByDates
As
 Select Top 1000000
	P.ProductName,
	I.InventoryDate,
	I.Count
 From vProducts as P
	Join vInventories as I
	On P.ProductId = I.ProductID
 Order By 2,1,3;
	
 -----Verify Final Scrip Above Works

Select * From vInventoriesByProductsByDates


-- Question 5 (10% pts): How can you create a view to show a list of Inventory Dates 
-- and the Employee that took the count?
-- Order the results by the Date and return only one row per date!

-- Here is are the rows selected from the view:

-- InventoryDate	EmployeeName
-- 2017-01-01	    Steven Buchanan
-- 2017-02-01	    Robert King
-- 2017-03-01	    Anne Dodsworth

---- Look at all data

--Select * From Inventories;
--Go
--Select * From Employees;

---- Look at specific data needed

--Select InventoryDate From Inventories;
--Go
--Select EmployeeFirstName, EmployeeLastName From Employees;

--- Combine the results using Aliases

--Select InventoryDate, [EmployeeName] = E.EmployeeFirstName + ' ' + E.EmployeeLastName
--From Inventories as I
--Join Employees as E
--On I.EmployeeId = E.EmployeeId;

---- Order the results

--Select Distinct
--InventoryDate, [EmployeeName] = E.EmployeeFirstName + ' ' + E.EmployeeLastName
--From Inventories as I
--Join Employees as E
--On I.EmployeeId = E.EmployeeId
--Order By InventoryDate, EmployeeName

---- Final Script Create View 

Create View vInventoriesByEmployeesByDates
AS
 Select Distinct Top 1000000
	I.InventoryDate,
	[EmployeeName] = E.EmployeeFirstName + ' ' + E.EmployeeLastName 
 From vInventories as I
	Join vEmployees as E
	On I.EmployeeId = E.EmployeeId
 Order By 1,2;

 -----Verify Final Scrip Above Works

Select * From vInventoriesByEmployeesByDates


-- Question 6 (10% pts): How can you create a view show a list of Categories, Products, 
-- and the Inventory Date and Count of each product?
-- Order the results by the Category, Product, Date, and Count!

-- Here is an example of some rows selected from the view:
-- CategoryName,ProductName,InventoryDate,Count
-- CategoryName	ProductName	InventoryDate	Count
-- Beverages	  Chai	      2017-01-01	  39
-- Beverages	  Chai	      2017-02-01	  49
-- Beverages	  Chai	      2017-03-01	  59
-- Beverages	  Chang	      2017-01-01	  17
-- Beverages	  Chang	      2017-02-01	  27
-- Beverages	  Chang	      2017-03-01	  37

------ Look at all data

--Select * From Categories;
--go
--Select * From Products;
--go
--Select * From Inventories;
--go

------ Look at specific data needed using Aliases

--Select CategoryName From Categories As C;
--Go
--Select ProductName From Products As P;
--Go
--Select InventoryDate, Count From Inventories As I;

----- Combine the results using Aliases

--Select CategoryName, ProductName, InventoryDate,Count
--From Categories as C
--Join Products as P
--On P.CategoryID = C.CategoryID
--Join Inventories as I
--On P.ProductId = I.ProductID;

------ Order the results

--Select CategoryName, ProductName, InventoryDate,Count
--From Categories as C
--Join Products as P
--On P.CategoryID = C.CategoryID
--Join Inventories as I
--On P.ProductId = I.ProductID
--Order By CategoryName, ProductName, InventoryDate, Count;

---- Final Script Create View 

Create View vInventoriesByProductsByCategories
AS
 Select Top 1000000
	C.CategoryName,
	P.ProductName,
	I.InventoryDate,
	I.Count
 From vInventories as I
	Join vEmployees as E
		On I.EmployeeID = E.EmployeeID
	Join vProducts as P
		On I.ProductID = P.ProductId
	Join vCategories as C
		On P.CategoryID = C.CategoryId
 Order By CategoryName, ProductName, InventoryDate, Count;

  -----Verify Final Scrip Above Works

Select * From vInventoriesByProductsByCategories

-- Question 7 (10% pts): How can you create a view to show a list of Categories, Products, 
-- the Inventory Date and Count of each product, and the EMPLOYEE who took the count?
-- Order the results by the Inventory Date, Category, Product and Employee!

-- Here is an example of some rows selected from the view:
-- CategoryName	ProductName	        InventoryDate	Count	EmployeeName
-- Beverages	  Chai	              2017-01-01	  39	  Steven Buchanan
-- Beverages	  Chang	              2017-01-01	  17	  Steven Buchanan
-- Beverages	  Chartreuse verte	  2017-01-01	  69	  Steven Buchanan
-- Beverages	  Côte de Blaye	      2017-01-01	  17	  Steven Buchanan
-- Beverages	  Guaraná Fantástica	2017-01-01	  20	  Steven Buchanan
-- Beverages	  Ipoh Coffee	        2017-01-01	  17	  Steven Buchanan
-- Beverages	  Lakkalikööri	      2017-01-01	  57	  Steven Buchanan

------ Look at all data

--Select * From Categories;
--go
--Select * From Products;
--go
--Select * From Inventories;
--go
--Select * From Employees;

------ Look at specific data needed using Aliases

--Select CategoryName From Categories As C;
--Go
--Select ProductName From Products As P;
--Go
--Select InventoryDate, Count From Inventories As I
--Go
--Select EmployeeFirstName, EmployeeLastName From Employees;

----- Combine the results using Aliases with a join

--Select CategoryName, ProductName, InventoryDate,Count, [EmployeeName] = E.EmployeeFirstName + ' ' + E.EmployeeLastName
--From Categories as C
--Join Products as P
--On P.CategoryID = C.CategoryID
--Join Inventories as I
--On P.ProductId = I.ProductID
--Join Employees as E
--On I.EmployeeId = E.EmployeeId;

-------Order the results

--Select CategoryName, ProductName, InventoryDate,Count, [EmployeeName] = E.EmployeeFirstName + ' ' + E.EmployeeLastName
--From Categories as C
--Join Products as P
--On P.CategoryID = C.CategoryID
--Join Inventories as I
--On P.ProductId = I.ProductID
--Join Employees as E
--On I.EmployeeId = E.EmployeeId
--Order By 3,1,2,4;

---- Final Script Create View 

Create View vInventoriesByProductsByEmployees
AS
 Select Top 1000000
	C.CategoryName,
	P.ProductName,
	I.InventoryDate,
	I.Count,
	[EmployeeName] = E.EmployeeFirstName + ' ' + E.EmployeeLastName
 From vInventories as I
	Join vEmployees as E
		On I.EmployeeID = E.EmployeeID
	Join vProducts as P
		On I.ProductID = P.ProductId
	Join vCategories as C
		On P.CategoryID = C.CategoryId
 Order By 3,1,2,4;

  -----Verify Final Scrip Above Works

Select * From vInventoriesByProductsByEmployees

-- Question 8 (10% pts): How can you create a view to show a list of Categories, Products, 
-- the Inventory Date and Count of each product, and the Employee who took the count
-- for the Products 'Chai' and 'Chang'? 

-- Here are the rows selected from the view:

-- CategoryName	ProductName	InventoryDate	Count	EmployeeName
-- Beverages	  Chai	      2017-01-01	  39	  Steven Buchanan
-- Beverages	  Chang	      2017-01-01	  17	  Steven Buchanan
-- Beverages	  Chai	      2017-02-01	  49	  Robert King
-- Beverages	  Chang	      2017-02-01	  27	  Robert King
-- Beverages	  Chai	      2017-03-01	  59	  Anne Dodsworth
-- Beverages	  Chang	      2017-03-01	  37	  Anne Dodsworth

------ Look at all data

--Select * From Categories;
--go
--Select * From Products;
--go
--Select * From Inventories;
--go
--Select * From Employees;

------ Look at specific data needed using Aliases

--Select CategoryName From Categories As C;
--Go
--Select ProductName From Products As P Where ProductName In ('Chai','Chang')
--Go
--Select InventoryDate, Count From Inventories As I
--Go
--Select EmployeeFirstName, EmployeeLastName From Employees;

----- Combine the results using Aliases with a join

--Select CategoryName, ProductName, InventoryDate,Count, [EmployeeName] = E.EmployeeFirstName + ' ' + E.EmployeeLastName
--From Inventories as I
--Join Employees as E
--On I.EmployeeID = E.EmployeeID
--Join Products as P
--On I.ProductID = P.ProductID
--Join Categories as C
--On P.CategoryID = C.CategoryID;


------Use a Subquery to get the ProductID based on the Product Names 


--Select CategoryName, ProductName, InventoryDate,Count, [EmployeeName] = E.EmployeeFirstName + ' ' + E.EmployeeLastName
--From Inventories as I
--Join Employees as E
--On I.EmployeeID = E.EmployeeID
--Join Products as P
--On I.ProductID = P.ProductID
--Join Categories as C
--On P.CategoryID = C.CategoryID
--Where I.ProductId in (Select ProductID From Products Where ProductName In ('Chai','Chang'));

------Order the results

--Select CategoryName, ProductName, InventoryDate,Count, [EmployeeName] = E.EmployeeFirstName + ' ' + E.EmployeeLastName
--From Inventories as I
--Join Employees as E
--On I.EmployeeID = E.EmployeeID
--Join Products as P
--On I.ProductID = P.ProductID
--Join Categories as C
--On P.CategoryID = C.CategoryID
--Where I.ProductId in (Select ProductID From Products Where ProductName In ('Chai','Chang'))
--Order By InventoryDate, CategoryName,ProductName

---- Final Script Create View

Create View vInventoriesForChaiAndChangByEmployees
AS
 Select Top 1000000
	C.CategoryName,
	P.ProductName,
	I.InventoryDate,
	I.Count,
	[EmployeeName] = E.EmployeeFirstName + ' ' + E.EmployeeLastName
 From Inventories as I
	Join Employees as E
		On I.EmployeeID = E.EmployeeID
	Join Products as P
		On I.ProductID = P.ProductID
	Join Categories as C
		On P.CategoryID = C.CategoryID
 Where I.ProductId in (Select ProductID From Products Where ProductName In ('Chai','Chang'))
 Order By InventoryDate, CategoryName,ProductName


  -----Verify Final Scrip Above Works

Select * From vInventoriesForChaiAndChangByEmployees


-- Question 9 (10% pts): How can you create a view to show a list of Employees and the Manager who manages them?
-- Order the results by the Manager's name!

-- Here are teh rows selected from the view:
-- Manager	        Employee
-- Andrew Fuller	  Andrew Fuller
-- Andrew Fuller	  Janet Leverling
-- Andrew Fuller	  Laura Callahan
-- Andrew Fuller	  Margaret Peacock
-- Andrew Fuller	  Nancy Davolio
-- Andrew Fuller	  Steven Buchanan
-- Steven Buchanan	Anne Dodsworth
-- Steven Buchanan	Michael Suyama
-- Steven Buchanan	Robert King

------ Look at all data
--go
--Select * From Employees;

----- Combine the results using Aliases

--Select
--[Manager] = M.EmployeeFirstName + ' ' + M.EmployeeLastName,
--[Employee] = E.EmployeeFirstName + ' ' + E.EmployeeLastName
--From Employees as E
--Join Employees as M
--On E.ManagerID = M.EmployeeID;

------Order the results
--Select
--[Manager] = M.EmployeeFirstName + ' ' + M.EmployeeLastName,
--[Employee] = E.EmployeeFirstName + ' ' + E.EmployeeLastName
--From Employees as E
--Join Employees as M
--On E.ManagerID = M.EmployeeID
--Order By Manager;

---- Final Script Create View

Create View vEmployeesByManager
AS
 Select Top 1000000
	M.EmployeeFirstName + ' ' + M.EmployeeLastName as Manager,
	E.EmployeeFirstName + ' ' + E.EmployeeLastName as Employee
 From vEmployees as E
	Join vEmployees as M
		On E.ManagerID = M.EmployeeID
 Order By Manager;

   -----Verify Final Scrip Above Works

Select * From vEmployeesByManager


-- Question 10 (20% pts): How can you create one view to show all the data from all four 
-- BASIC Views? Also show the Employee's Manager Name and order the data by 
-- Category, Product, InventoryID, and Employee.

-- Here is an example of some rows selected from the view:
-- CategoryID	  CategoryName	ProductID	ProductName	        UnitPrice	InventoryID	InventoryDate	Count	EmployeeID	Employee
-- 1	          Beverages	    1	        Chai	              18.00	    1	          2017-01-01	  39	  5	          Steven Buchanan
-- 1	          Beverages	    1	        Chai	              18.00	    78	        2017-02-01	  49	  7	          Robert King
-- 1	          Beverages	    1	        Chai	              18.00	    155	        2017-03-01	  59	  9	          Anne Dodsworth
-- 1	          Beverages	    2	        Chang	              19.00	    2	          2017-01-01	  17	  5	          Steven Buchanan
-- 1	          Beverages	    2	        Chang	              19.00	    79	        2017-02-01	  27	  7	          Robert King
-- 1	          Beverages	    2	        Chang	              19.00	    156	        2017-03-01	  37	  9	          Anne Dodsworth
-- 1	          Beverages	    24	      Guaraná Fantástica	4.50	    24	        2017-01-01	  20	  5	          Steven Buchanan
-- 1	          Beverages	    24	      Guaraná Fantástica	4.50	    101	        2017-02-01	  30	  7	          Robert King
-- 1	          Beverages	    24	      Guaraná Fantástica	4.50	    178	        2017-03-01	  40	  9	          Anne Dodsworth
-- 1	          Beverages	    34	      Sasquatch Ale	      14.00	    34	        2017-01-01	  111	  5	          Steven Buchanan
-- 1	          Beverages	    34	      Sasquatch Ale	      14.00	    111	        2017-02-01	  121	  7	          Robert King
-- 1	          Beverages	    34	      Sasquatch Ale	      14.00	    188	        2017-03-01	  131	  9	          Anne Dodsworth

------ Look at all data

--Select * From Categories;
--go
--Select * From Products;
--go
--Select * From Inventories;
--go
--Select * From Employees;


----- Combine/Join the results using Aliases and order by

 --Select
	--C.CategoryId,
	--C.CategoryName,
	--P.ProductID,
	--P.ProductName,
	--P.UnitPrice,
	--I.InventoryID,
	--I.InventoryDate,
	--I.[Count],
	--E.EmployeeID,
	--[Manager] = M.EmployeeFirstName + ' ' + M.EmployeeLastName,
	--[Employee] = E.EmployeeFirstName + ' ' + E.EmployeeLastName
 --From Categories as C
	--Join Products as P
	--	On P.CategoryID = C.CategoryId
	--Join Inventories as I
	--	On P.ProductId = I.ProductID
	--Join Employees as E
	--	On I.EmployeeID = E.EmployeeID
	--Join Employees as M
	--	On E.ManagerID = M.ManagerID
 --Order By 1,3,6,9;

------Order the results
--Select
--[Manager] = M.EmployeeFirstName + ' ' + M.EmployeeLastName,
--[Employee] = E.EmployeeFirstName + ' ' + E.EmployeeLastName
--From Employees as E
--Join Employees as M
--On E.ManagerID = M.EmployeeID
--Order By Manager;

---- Final Script Create View


Create View vInventoriesByProductsByCategoriesByEmployees
AS
 Select Top 1000000
	C.CategoryId,
	C.CategoryName,
	P.ProductID,
	P.ProductName,
	P.UnitPrice,
	I.InventoryID,
	I.InventoryDate,
	I.[Count],
	E.EmployeeID,
	[Manager] = M.EmployeeFirstName + ' ' + M.EmployeeLastName,
	[Employee] = E.EmployeeFirstName + ' ' + E.EmployeeLastName
 From vCategories as C
	Join vProducts as P
		On P.CategoryID = C.CategoryId
	Join vInventories as I
		On P.ProductId = I.ProductID
	Join vEmployees as E
		On I.EmployeeID = E.EmployeeID
	Join vEmployees as M
		On E.ManagerID = M.ManagerID
 Order By 1,3,6,9;
	
	
   -----Verify Final Scrip Above Works

Select * From vInventoriesByProductsByCategoriesByEmployees


-- Test your Views (NOTE: You must change the names to match yours as needed!)
Print 'Note: You will get an error until the views are created!'
Select * From [dbo].[vCategories]
Select * From [dbo].[vProducts]
Select * From [dbo].[vInventories]
Select * From [dbo].[vEmployees]

Select * From [dbo].[vProductsByCategories]
Select * From [dbo].[vInventoriesByProductsByDates]
Select * From [dbo].[vInventoriesByEmployeesByDates]
Select * From [dbo].[vInventoriesByProductsByCategories]
Select * From [dbo].[vInventoriesByProductsByEmployees]
Select * From [dbo].[vInventoriesForChaiAndChangByEmployees]
Select * From [dbo].[vEmployeesByManager]
Select * From [dbo].[vInventoriesByProductsByCategoriesByEmployees]

/***************************************************************************************/