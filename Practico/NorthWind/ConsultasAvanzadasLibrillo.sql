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
