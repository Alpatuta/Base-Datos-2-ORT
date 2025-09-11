--4)

select top 1 with ties p.Nombre from Personajes p where p.Nombre in 
	(select p.Nombre. max(count(cp.Codigo) as maxCantCap) 
		from Personajes p, Capitulos_Personajes cp, Capitulos c 
			where p.Nombre = cp. Nombre and cp.Codigo = c.Codigo 
			and c.Rating > 3000000 and cp.Minutos >= 2
				group by p.Nombre);

--5)
select top 1 with ties d.Alias from Dibujante d where d.Alias in 
    (select d.Alias, max(sum(c.Rating)) from Dibujante d, Personaje p, Capitulo_Personajes cp, Capitulos c 
		where d.Alias = p.Dibujante and p.Nombre = cp.Nombre and cp.Codigo = c.Codigo 
			group by d.Alias);
