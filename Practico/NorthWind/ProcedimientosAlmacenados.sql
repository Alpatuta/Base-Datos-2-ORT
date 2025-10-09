--1)

create procedure proc_primero
as
begin 
	declare @fecha_minima date, @fecha_maxima date

	select @fecha_minima = min(OrderDate), @fecha_maxima = max(OrderDate) from Orders

	insert into PriceList values (@fecha_minima, @fecha_maxima)

	--print 'identity: ' + cast(@@identity as varchar)

	insert into PriceListDetail select @@identity, ProductID, UnitPrice from Products
	select* from PriceListDetail;
end

exec proc_primero;

--2)

create procedure proc_ej2
as 
begin 
	insert into Countries (CountryName) 
		select distinct o.ShipCountry from Orders o, Countries c
			where o.ShipCountry  = c.CountryName;

	insert into Cities (CityName, CountryID)
		select distinct o.ShipCountry, c.CountryID from Orders o inner join Countries c 
			on o.ShipCountry = c.CountryName;
end

exec proc_ej2;

--3)

create procedure ejercicio32
@desde datetime, @hasta datetime, @cntClientes int output, @cntProductos int output
as
begin 
	
select @cntClientes = (COUNT(distinct o.CustomerID)), @cntProductos = (COUNT(distinct od.ProductID))
	from Orders o, [Order Details] od where o.OrderID = od.OrderID 
		and o.OrderDate >= @desde
		and o.OrderDate <= @hasta;

print @cntClientes;
print @cntProductos;
end

exec ejercicio32 '01/01/1990', '31/12/1997', 1, 1;

--4)

alter procedure ejercicio4

@desde datetime, @hasta datetime, @cntEmpleados int output, @cntProductosDiscontinued int output
as 
begin

select @cntEmpleados = (count(distinct o.EmployeeID)), @cntProductosDiscontinued = (count(distinct od.ProductID))
	from Orders o, [Order Details] od, Products p 
		where o.OrderID = od.OrderID 
		and od.ProductID = p.ProductID
		and o.OrderDate <= @desde 
		and o.OrderDate >= @hasta
		and p.Discontinued = 0;

print @cntempleados;
print @cntProductosDiscontinued;

end

exec ejercicio4 '01/01/1990', '31/12/1997', 1, 1;

--5)

create procedure ejercicio5 
@desde datetime, @hasta datetime, @importe int output
as 
begin
declare @total money, @flete money

select @total = sum(Quantity * UnitPrice) * (1 - Discount)
from Orders o, [Order Details] od 
	where o.OrderID = od.OrderID
	and o.OrderDate between @desde and @hasta

select @flete = sum(o.Freight)
	from Orders o
		where o.OrderDate between @desde and @hasta

set @importe = @total + @flete;

end

exec ejercicio5 '01/01/1990', '01/01/2025', @importe output;


--6)

create procedure ejercicio6
@desde datetime, @hasta datetime, @nombreCliente varchar(255) output, @totalOrdenes money output

as
begin
select top 1 @nombreCliente = c.CompanyName, @totalOrdenes = sum(od.Quantity * od.UnitPrice)
from Orders o, [Order Details] od, Customers c 
	where o.OrderID = od.OrderID
	and o.CustomerID = c.CustomerID
	and o.OrderDate between @desde and @hasta
	group by o.ShipCountry, c.CompanyName
		order by sum(od.Quantity * od.UnitPrice) desc

end

--7)

create procedure ejercicio7
@porcentaje int, @cntProductos int output

as
begin
update Products
	set UnitPrice = UnitPrice - (UnitPrice * @porcentaje/100)
	where not exists (select * from [Order Details] od where od.ProductID = Products.ProductID)

	select @cntProductos = count(*)
		from Products where not exists (select * from [Order Details] od where od.ProductID = Products.ProductID);

end

--8)

create procedure ejercicio8
@nombrePais varchar(40) output, @nombreEmpresaEnvios varchar(40) output

as 
begin

select @nombrePais = o.ShipCountry 
	from Orders o
		group by o.ShipCountry, o.OrderDate
			having o.OrderDate = max(o.OrderDate)

select @nombreEmpresaEnvios = s.CompanyName
	from Shippers s, Orders o
		where o.ShipVia = s.ShipperID
			group by s.CompanyName, o.Freight
				having o.Freight = min(o.Freight)
end		

--9)

create procedure ejercicio9
@cntOrdenes int output, @ordenMasAntigua datetime output, @ordenMasReciente datetime output

as 
begin
	if @cntOrdenes = 0
	begin
		print 'No hay ordenes'
	end
	select @cntOrdenes = count(o.OrderID), @ordenMasAntigua = min(o.OrderDate), @ordenMasReciente = max(o.OrderDate)
		from Orders o, Customers c
			where o.CustomerID = c.CustomerID

	
end



