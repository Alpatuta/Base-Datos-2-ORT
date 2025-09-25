--Consultas avanzadas

--1)

select p.ProductID, p.ProductName, o.ShippedDate 
	from Products p, OrderDetails od, Orders o where p.ProductID = od.ProductID 
	and od.OrderID = o.OrderID order by o.ShippedDate desc;
	
--2)

select c.CustomerID, c.CompanyName 
	from Customers c, Orders o, Shippers s
		where c.CustomerID = o.CustomerID and o.ShipVia = s.ShipperID
			group by c.CustomerID, c.CompanyName having count(distinct s.ShipperID) = 3;

--3)

select s.ShipperID, s.CompanyName, count(o.ShipVia) as cantShipps 
	from Shippers s, Orders o 
		where s.ShipperID = o.ShipVia group by s.ShipperID, s.CompanyName
			having count(o.ShipVia) < 100;

--4)

select p.ProductID, p.ProductName, count(c.CustomerID) as cantClientes 
	from Products p inner join OrderDetails od on p.ProductID = od.ProductID
	inner join Orders o on od.OrderID = o.OrderID 
	inner join Customers c on o.CustomerID = c.CustomerID
		group by p.ProductID, p.ProductName 
			having count(c.CustomerID) >= 0 or count(c.CustomerID) is null;

--5)

select top 1 with ties e.FirstName, e.LastName, min(o.OrderDate) as fecha
	from Employees e inner join Orders o on e.EmployeeID = o.EmployeeID
		group by e.FirstName, e.LastName order by fecha;

--6)

select c.CategoryID, c.CategoryName from Categories c inner join Products p
	on c.CategoryID = p.CategoryID group by c.CategoryID, c.CategoryName
		having count(p.CategoryID) < 10;

--7)

select cu.CustomerId, cu.CompanyName from Customers cu 
	where cu.CustomerID in 
		(select top 50 cu.CustomerID from Customers cu, Orders o, OrderDetails od, Products p
			where cu.CustomerID = o.CustomerID and
				  o.OrderID = od.OrderID and
				  od.ProductID = p.ProductID and
				  p.CategoryID = 1 and
				  o.OrderDate between '1998/01/01' and '1998/06/01' 
					group by cu.CustomerID having count(o.OrderID) >= 1
					order by count(o.OrderID));

--8)

SELECT 
    c.CustomerID,
    c.CompanyName,
    (
        SELECT COUNT(*)
        FROM Orders o1
        WHERE o1.CustomerID = c.CustomerID
          AND o1.ShipCountry = 'USA'
    ) AS OrdersToUSA,
    (
        SELECT SUM(o2.Freight)
        FROM Orders o2
        WHERE o2.CustomerID = c.CustomerID
          AND o2.ShipVia = 1
    ) AS TotalFreightVia1
FROM Customers c
ORDER BY TotalFreightVia1 DESC;

--9)

select e.EmployeeID, e.FirstName, e.LastName,
	case 
		when count(o.OrderID) > 20 then 'Premium'
		when count(o.OrderID) between 10 and 20 then 'Medium'
		when count(o.OrderID) < 10 then 'Beginner'
	end as TypeEmployee
from Employees e, Orders o
	where e.EmployeeID = o.EmployeeID
	and year(o.OrderDate) = 1997
		group by e.EmployeeID, e.FirstName, e.LastName;	

--10)

select distinct cu.CustomerID, cu.CompanyName
	from Customers cu inner join Orders o on cu.CustomerID = o.CustomerID
	inner join OrderDetails od on o.OrderID = od.OrderID
	inner join Products p on od.ProductID = p.ProductID
	inner join Categories c on p.CategoryID = c.CategoryID
		where lower(c.CategoryName) like 'seafood' 
		group by  cu.CustomerID, cu.CompanyName, o.OrderDate
		having o.OrderDate = min(o.OrderDate);

--11)

select distinct s.SupplierID, s.CompanyName 
	from Suppliers s, Products p, OrderDetails od, Orders o
		where s.SupplierID = p.SupplierID
		and p.ProductID = od.ProductID
		and od.OrderID = o.OrderID
		and o.OrderID in (select o.OrderID from Orders o where o.ShipCountry like 'Atgentina')
		and o.OrderID not in (select o.OrderID from Orders o where o.ShipCountry like 'France');

--14)

select p.ProductName, (UnitPrice - (select avg(UnitPrice) from Products)) as Diferencia
	from Products p
		group by p.ProductName, p.UnitPrice;

--15)

select p.ProductName
	from Products p
		where exists
			(select o.* 
				from Orders o, OrderDetails od
					where o.OrderID = od.OrderID
					and od.ProductID = p.ProductID
					and o.OrderDate <= '1996/12/10');

--16)

select e.EmployeeID, e.FirstName, e.LastName,
	(select count(o.OrderID) from Orders o where o.ShipCountry like 'France') as cantFrance,
	(select count(o.OrderID) from Orders o where o.ShipCountry like 'USA')  as cantUsa,
	(select avg(o.Freight) from Orders o inner join Suppliers s on o.ShipVia = s.SupplierID
		where s.CompanyName like 'Ups') as promedios
		from Employees e
			group by e.EmployeeID, e.FirstName, e.LastName;

--17)

select p.ProductID, p.ProductName,
	case 
		when sum(od.Quantity) > 100 then 'Alto'
		when sum(od.Quantity) between 50 and 100 then 'Medio'
		when sum(od.Quantity) < 50 then 'Bajo'
	end as unidadesVendidas
		from Products p, OrderDetails od
			where p.ProductID = od.ProductID
				group by p.ProductID, p.ProductName;

--18)

select c.CustomerID, c.CompanyName,
	case 
		when sum(od.Quantity * od.UnitPrice) < 5000 then 'Baja'
		when sum(od.Quantity * od.UnitPrice) between 5000 and 25000 then 'Media'
		when sum(od.Quantity * od.UnitPrice) > 25000 then 'Alto'
	end as Importe
from Customers c, Orders o, OrderDetails od
	where c.CustomerID = o.CustomerID
	and od.OrderID = o.OrderID
		group by c.CustomerID, c.CompanyName;

--20)

select e.EmployeeID, e.FirstName, e.LastName 
	from Employees e, Orders o, Customers c
		where e.EmployeeID = o.EmployeeID
		and o.CustomerID = c.CustomerID
			group by e.EmployeeID, e.FirstName, e.LastName
				having count(distinct (c.Country)) > 5;


