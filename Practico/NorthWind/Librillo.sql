--Cosultas basicas

--1)

UPDATE Customers set PostalCode = '28010' where lower(City) = 'madrid';

--2)

UPDATE Suppliers SET HomePage = 'No tiene' WHERE HomePage is null;

--3)

UPDATE Products SET	Discontinued = 1 WHERE UnitsInStock = 0 and UnitPrice <= 15;

--4)

INSERT INTO Shippers values('Apple', '099999888'), ('Samsung', '092000999'), ('Ferrari','099803003');

--5)

DELETE from Shippers where CompanyName in ('Apple' ,'Samsung');

--6)

SELECT CustomerId, CompanyName from Customers where Country like 'Spain';

--7)

SELECT CustomerId, CompanyName, ContactTitle from Customers where ContactTitle like '%RepresentaTive';

--8)

SELECT c.CustomerID, c.CompanyName, c.Address from Customers c where c.Address like 'Rua%' and Region like 'SP';

--9)

SELECT OrderID, CustomerID, OrderDate, Freight, ShipCountry, ShipCity from Orders where Freight < 10 or ShipCountry like 'France' and ShipCity like 'Reims';

--10)

SELECT * FROM Orders where YEAR(OrderDate) like '1997' and ShipCountry like 'USA';

--11)

SELECT o.OrderID, c.CustomerID, c.CompanyName, c.Country, o.ShipCountry 
	from Orders o inner join Customers c on o.CustomerID = c.CustomerID 
		where MONTH(OrderDate) like '7' and YEAR(OrderDate) like '1997';


--12)

SELECT o.OrderID, o.CustomerID, o.OrderDate, o.Freight, o.ShipCountry, o.ShipCity, c.CompanyName, c.ContactName 
	from Orders o inner join Customers c on o.CustomerID = c.CustomerID 
		where Freight < 10 or ShipCountry like 'France' and ShipCity like 'Reims';

--13) 

SELECT  distinct c.CustomerID, c.CompanyName, p.ProductID, p.ProductName 
	from Customers c inner join Orders o on c.CustomerID = o.CustomerID inner join OrderDetails od on o.OrderID = od.OrderID inner join Products p on od.ProductID = p.ProductID
		where year(o.OrderDate) like '1996';

--14)

SELECT p.ProductID, p.ProductName, c.CategoryName from Products p inner join Categories c on p.CategoryID = c.CategoryID where p.UnitsInStock > 0;

--15)

SELECT p.ProductID, p.ProductName, c.CategoryName from Products p inner join Categories c on p.CategoryID = c.CategoryID where p.ProductName LIKE '%queso%';

--16)

SELECT o.OrderID, o.OrderDate, c.CustomerID, c.CompanyName, o.ShipVia, s.CompanyName as EmpresaEnvio, e.EmployeeID, e.FirstName, e.LastName
	FROM Orders o inner join Customers c on o.CustomerID = c.CustomerID inner join Shippers s on o.ShipVia = s.ShipperID inner join Employees e on o.EmployeeID = e.EmployeeID
		WHERE o.ShipCountry like 'UK';

--17)

SELECT distinct c.CustomerID, c.CompanyName, p.ProductID, p.ProductName, s.CompanyName as NombreProveedor 
	FROM Customers c inner join Orders o on c.CustomerID = o.CustomerID 
		inner join OrderDetails od on o.OrderID = od.OrderID 
		inner join Products p on od.ProductID = p.ProductID 
		inner join Shippers s on o.ShipVia = s.ShipperID
			WHERE o.ShipCountry like 'Argentina'; 


--18) 

SELECT p.* 
	FROM Products p inner join Categories c on p.CategoryID = c.CategoryID 
		WHERE c.Description like '%cereal%' and p.UnitsInStock > 10;

--19)

SELECT DISTINCT p.ProductID, p.ProductName, p.UnitPrice as PrecioLista, od.UnitPrice FROM Products p inner join OrderDetails od on p.ProductID = od.ProductID where od.UnitPrice != p.UnitPrice;

--20)

SELECT e.EmployeeID, e.FirstName, e.LastName, e.ReportsTo, j.FirstName, j.LastName from Employees e inner join Employees j on e.ReportsTo = j.EmployeeID;

--21)

SELECT count(OrderID) as TotalOrdenes From Orders where YEAR(OrderDate) like '1996';

--22)

SELECT MIN(OrderDate) as fechaMin, MAX(OrderDate) as fechaMax from Orders;

--23)

SELECT count(Freight) as cantFletes from Orders where YEAR(OrderDate) like '1998';

--24)

select distinct count(od.ProductID) cantProductos from Orders o inner join OrderDetails od on o.OrderID = od.OrderID where o.ShipCountry like 'USA';

--25)

select distinct count(o.ShipCity) as ciudadesDistintas from Orders o;

--26)

select sum(p.UnitsInStock) as sumaDeUnidades
	from Products p inner join Categories c on p.CategoryID = c.CategoryID
		inner join OrderDetails od on od.ProductID = p.ProductID
		inner join Orders o on o.OrderID = od.OrderID 
			where o.ShipCity like 'Paris';

--27)

select count(o.OrderID) as totalOrdenes, AVG(o.Freight) as promedioFlete, Min(o.ShippedDate) as fechaAntigua, MAX(o.Freight) as fleteMasCaro 
	from Orders o inner join Customers c on o.CustomerID = c.CustomerID where c.Country like 'UK';

--28)

select count(distinct od.OrderID) as cantOrdenes, AVG(od.Quantity) as promedioUnidades, MIN(od.UnitPrice) as menorPrecio, MAX(od.Discount) as mayorDescuento 
	from Products p inner join OrderDetails od on p.ProductID = od.ProductID
		where p.ProductName like 'Queso Cabrales';

--29)

select count(distinct o.ShipRegion) as regionesDiferentes 
	from Orders o inner join Customers c on o.CustomerID = c.CustomerID
		where c.Country like 'Canada';

--30)

select min(o.Freight) as minimoFlete 
	from Orders o inner join Employees e on o.EmployeeID = e.EmployeeID
		where e.ReportsTo is null;

--31)

select c.CustomerID, c.CompanyName, count(o.OrderID) as cantOrdenes from Customers c inner join Orders o on c.CustomerID = o.CustomerID group by c.CustomerID, c.CompanyName;

--32)

select e.FirstName, e.LastName, count(o.OrderID) as cantOrdenes, sum(o.Freight) as totalFletes from Employees e inner join Orders o on e.EmployeeID = o.EmployeeID
	group by e.FirstName, e.LastName;

--33)

select s.ShipperID, s.CompanyName, s.Phone, count(o.OrderID) as cantOrdenes, max(o.OrderDate) as fechaNueva, min(o.OrderDate) as fechaVieja
	from Shippers s inner join Orders o on s.ShipperID = o.ShipVia 
		where o.ShipCountry like 'USA' group by s.ShipperID, s.CompanyName, s.Phone;

--34)

select o.ShipCountry, count(o.OrderID)as cantOrdenes, avg(o.Freight) as promedioFlete 
	from Orders o group by o.ShipCountry;

--35)

select p.ProductID, p.ProductName, sum(od.Quantity) as totalCantidad, sum(p.UnitPrice) as totalPrecio 
	from Products p inner join OrderDetails od on p.ProductID = od.ProductID
		group by p.ProductID, p.ProductName order by totalCantidad desc;

--36)

select c.CategoryID, c.CategoryName, count(p.ProductID) as cantProductos 
	from Categories c inner join Products p on c.CategoryID = p.CategoryID
		group by c.CategoryID, c.CategoryName;

--37)

select avg(p.UnitPrice) as promedioVenta, s.SupplierID, s.CompanyName 
	from Products p inner join Suppliers s on p.SupplierID = s.SupplierID
		group by s.SupplierID, s.CompanyName;

--38)

select e.FirstName, e.LastName, count(distinct o.ShipCountry) as diferentesPaises, count(s.ShipperID) as cantEmpresas
	from Employees e inner join Orders o on e.EmployeeID = o.EmployeeID
	inner join Shippers s on o.ShipVia = s.ShipperID
		group by e.FirstName, e.LastName; 

