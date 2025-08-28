--Practico 3

--1

INSERT INTO Shippers values('Apple', '099999888');

INSERT INTO Employees (LastName, FirstName) values ('Diego', 'Marquez');

INSERT INTO Products (ProductName, Discontinued) values ('Celu', 1);

INSERT INTO Customers (CustomerID, CompanyName) values('12345', 'Cosos');

--2
INSERT INTO Shippers values('Apple', '099999888'), ('aNDRIOD', '13131313'), ('hOLAAAAAA','1313131312');

INSERT INTO Employees (LastName, FirstName) values ('Diego', 'Marquez'), ('Federico', 'Oteiza'), ('Alfredo', 'Vartabedian');

INSERT INTO Products (ProductName, Discontinued) values ('Celu', 1), ('Celu2', 2), ('Celu3', 3);

INSERT INTO Customers (CustomerID, CompanyName) values('1235', 'Cosos'), ('12345', 'Coso'), ('123445', 'Cos');

--3 
INSERT INTO Orders (OrderDate, CustomerID, EmployeeID, ShipVia) values (GETDATE(), '12345', 1, 1);

select * from Orders order by OrderDate desc;

--4
INSERT INTO OrderDetails values (11078, 1, 300, 1, 0), (11078, 2, 350, 100, 1), (11078, 50, 32220, 10, 1), (11078, 3, 50, 75, 0.70), (11078, 5, 900, 43, 0.30); 

--5

CREATE TABLE OrdersTemp(
	[OrderID] [int] NOT NULL,
	[CustomerID] [nchar](5) NULL,
	[EmployeeID] [int] NULL,
	[OrderDate] [datetime] NULL,
	[RequiredDate] [datetime] NULL,
	[ShippedDate] [datetime] NULL,
	[ShipVia] [int] NULL,
	[Freight] [money] NULL,
	[ShipName] [nvarchar](40) NULL,
	[ShipAddress] [nvarchar](60) NULL,
	[ShipCity] [nvarchar](15) NULL,
	[ShipRegion] [nvarchar](15) NULL,
	[ShipPostalCode] [nvarchar](10) NULL,
	[ShipCountry] [nvarchar](15) NULL,
);

CREATE TABLE OrderTempDetails(
	[OrderID] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
	[UnitPrice] [money] NOT NULL,
	[Quantity] [smallint] NOT NULL,
	[Discount] [real] NOT NULL,
);

INSERT INTO OrdersTemp SELECT * FROM Orders;

INSERT INTO OrderTempDetails SELECT * FROM OrderDetails;

--6
INSERT INTO Shippers values ('ORT','111222333');

INSERT INTO  Orders (OrderDate, CustomerID, EmployeeID, ShipVia) values (GETDATE(), '12345', 1, 10);

--7
CREATE TABLE ShippersTemp(
	[ShipperID] [int] NOT NULL,
	[CompanyName] [nvarchar](40) NOT NULL,
	[Phone] [nvarchar](24) NULL,
);

INSERT INTO ShippersTemp SELECT * FROM Shippers;

--8
INSERT INTO Categories (CategoryName) values ('Juguete');

INSERT INTO Products (ProductName, CategoryID, Discontinued) values ('Nerf', (select Categories.CategoryID from Categories where Categories.CategoryName = 'Juguete'), 1);

select * from Products;
