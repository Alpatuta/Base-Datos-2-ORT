--1

ALTER function fn_PrecioDeOrden
(
	@OrderId int
)
returns decimal(10,2)
as
BEGIN
    DECLARE @total DECIMAL(10,2)

    SELECT 
        @total = 
        ISNULL(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 0) + 
        ISNULL(o.Freight, 0)
    FROM [Order Details] od, Orders o
    WHERE od.OrderID = @OrderID and o.OrderID = od.OrderID
	group by o.Freight
    RETURN @total
END
declare
@OrderID int,
@Resultado money

set @OrderID = 1
set @Resultado = dbo.fn_PrecioDeOrden(@OrderID);
print @Resultado

---2
alter function fn_ProductoMasAntiguo
(
	@ProductID int
)
returns money
as
begin
	declare @precio money, @return money
	select top 1 @precio = od.UnitPrice
	from Orders o, [Order Details] od
	where @ProductID = od.ProductID and od.OrderID = o.OrderID	
	order by o.OrderDate asc
	set @return = @precio
	return @return
end

select ProductID, ProductName, UnitPrice, dbo.fn_ProductoMasAntiguo(ProductID) as PrecioMasAntiguo
from Products

--3
alter function fn_ObtenerCodigoPais (@OrderID int)
returns int
as
begin
	declare @codigoPais int
	select @codigoPais = c.CountryID
	from Countries c, Orders o
	where o.OrderID = @OrderID and o.ShipCountry = c.CountryName
	return @codigoPais
end

select OrderID, ShipCountry, dbo.fn_ObtenerCodigoPais(OrderID) as codigoPais
from Orders

--5
create function fn_SumaDePrecios(@EmployeeID int)
returns money
as
begin
	declare @SumaDePrecio money
	select top 1 @SumaDePrecio = sum(od.UnitPrice * od.Quantity)
	from [Order Details] od, Orders o
	where o.EmployeeID = @EmployeeID and o.OrderID = od.OrderID
	order by sum(od.UnitPrice * od.Quantity) asc
	return @SumaDePrecio
end

declare
@CodigoEmpleado int,
@retorno money
set @CodigoEmpleado= 2
set @retorno = dbo.fn_SumaDePrecios(@CodigoEmpleado)
print @retorno

SELECT SUM(od.UnitPrice * od.Quantity) AS Total
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE o.EmployeeID = 2

--6
create function fn_ProductoConMayorQuantity(@ProductID int)
returns int
as
begin
	declare @cantidadDeLaOrden int
	select top 1 @cantidadDeLaOrden = od.Quantity
	from [Order Details] od
	where od.ProductID = @ProductID 
	order by od.Quantity asc
	return @cantidadDeLaOrden
end

declare
@ProductID int,
@retorno int
set @ProductID = 1
set @retorno = dbo.fn_ProductoConMayorQuantity(@ProductID)
print @retorno

select ProductID, ProductName, UnitsInStock, dbo.fn_ProductoConMayorQuantity(ProductID) as MayorCantidad
from Products

--7
create function fn_CantidadDeOrdenes(@EmployeeID int)
returns int
as
begin
	declare @cantidad int
	select @cantidad = count(distinct o.OrderID)
	from Orders o, Employees e
	where o.EmployeeID = @EmployeeID and e.Country = o.ShipCountry
	return @cantidad
end

select EmployeeID, FirstName, dbo.fn_CantidadDeOrdenes(EmployeeID) as cantidadDeOrdenes
from Employees