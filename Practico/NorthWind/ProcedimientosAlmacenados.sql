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

--create procedure proc_ej2
--as 
--begin 
	
--end