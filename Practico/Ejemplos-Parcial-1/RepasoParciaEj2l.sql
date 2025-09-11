create database RepasoParcial;

--4)

select avg(a.autonomia) as PromedioAutonomia 
	from Aviones a where a.ID_avion in (select a.ID_avion 
		from Aviones a inner join Viajes v on a.ID_avion = v.ID_avion
		inner join Pasajes p on v.Codigo = p.Codigo 
			group by a.ID_avion having count(p.Codigo) > a.capacidad);

--5)

select max(a.Fecha_fabricacion) as FechaFabricacion 
	from Aviones a where a.ID_avion in (select a.ID_avion
		from Aviones a inner join Viajes v on a.ID_avion = v.ID_avion
		inner join Ciudades c on v.Ciudad_llegada = c.Cod_ciudad
		inner join Paises p on c.Cod_pais = p.Cod_pais 
			where year(v.Fecha) = year(GETDATE) and p.Nombre like 'Espania' 
				group by a.ID_avion having count(*) = 3)
				
	and a.ID_avion in (select a.ID_avion
			from Aviones a inner join Viajes v on a.ID_avion = v.ID_avion
			inner join Ciudades c on v.Ciudad_llegada = c.Cod_ciudad
			inner join Paises p on c.Cod_pais = p.Cod_pais 
				where year(v.Fecha) = year(GETDATE) and p.Nombre like 'Franica' 
					group by a.ID_avion having count(*) = 4 );

--6)

Select av.*
	from viajes v1, viajes v2, aviones av
	where av.id_avion = v1.id_avion and av.id_avion = v2.id_avion
	and v1.fecha = v2.fecha
	and v1.ciudad_salida = v2.ciudad_llegada
	and v1.ciudad_llegada = v2.ciudad_salida
	and v1.distancia + v2.distancia < av.autonomia
	and v1.ciudad_salida IN (Select c.cod_ciudad from ciudades c, paises p where c.cod_pais =
p.cod_pais and UPPER(p.nombre) = 'ESPAÑA')
	and v1.ciudad_llegada IN (Select c.cod_ciudad from ciudades c, paises p where c.cod_pais =
p.cod_pais and UPPER(p.nombre) = 'ESPAÑA');

--7)

select pj.* from Pasajeros pj where pj.Pasaporte in 
	(select v.Codigo from  Viajes v, Pasajes ps, Pasajeros pj
		where pj.Pasaporte = ps.Pasaporte and ps.Codigo = v.Codigo and pj.Apellido like 'Smith'  
			group by v.Codigo having count(pj.Pasaporte) >= 1)
	
	and pj.Pasaporte in (select v.Codigo from  Viajes v, Pasajes ps, Pasajeros pj
		where pj.Pasaporte = ps.Pasaporte and ps.Codigo = v.Codigo and pj.Apellido like 'Thompson'  
			group by v.Codigo having count(pj.Pasaporte) >= 1)
