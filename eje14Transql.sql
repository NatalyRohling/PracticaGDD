/*
Ejercicio 14
Agregar el/los objetos necesarios para que si un cliente compra un producto 
compuesto a un precio menor que la suma de los precios de sus componentes 
que imprima la fecha, que cliente, que productos y a qué precio se realizó la 
compra. No se deberá permitir que dicho precio sea menor a la mitad de la suma 
de los componentes.*/
CREATE TRIGGER eje10
ON  Producto AFTER  INSERT
AS 
BEGIN 

     SELECT (i.prod_precio)<select (SUM(prod_componente.prod_precio *c.comp_cantidad) from inserted i
		join Item_Factura it on it.item_producto = i.prod_codigo
		JOIN Factura f on f
		INNER JOIN Composicion c ON c.comp_producto = i.prod_codigo
        INNER JOIN Producto prod_componente ON  c.comp_componente = prod_componente.prod_codigo
GROUP BY  i.prod_codigo)





END
GO

select () from inserted i
		join Item_Factura it on it.item_producto = t.prod_codigo
		INNER JOIN Composicion c ON c.comp_producto = i.prod_codigo
        INNER JOIN Producto prod_componente ON  c.comp_componente = prod_componente.prod_codigo
GROUP BY  i.prod_codigo)
select (SUM(prod_componente.prod_precio *c.comp_cantidad) from inserted i
		join Item_Factura it on it.item_producto = t.prod_codigo
		INNER JOIN Composicion c ON c.comp_producto = i.prod_codigo
        INNER JOIN Producto prod_componente ON  c.comp_componente = prod_componente.prod_codigo
GROUP BY  i.prod_codigo)






CREATE TRIGGER eje9
ON  Item_Factura INSTEAD OF UPDATE
AS 
BEGIN 
UPDATE STOCK set stoc_cantidad =
      (select c.comp_cantidad * (i.item_cantidad - d.item_cantidad) from inserted i
	    Join  deleted d on i.item_sucursal =d.item_sucursal and i.item_tipo = d.item_tipo and d.item_numero = i.item_numero
		join Producto  p on i. item_producto = p.prod_codigo
		Join Composicion c ON p.prod_codigo = c.comp_producto
		where c.comp_cantidad > 2 and stoc_producto = p.prod_codigo) 

END
GO