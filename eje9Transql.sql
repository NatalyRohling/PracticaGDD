/*
Ejercicio 9
Crear el/los objetos de base de datos que ante alguna modificación de un ítem de 
factura de un artículo con composición realice el movimiento de sus 
correspondientes componentes*/

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
