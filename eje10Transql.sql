/*Ejercicio 10
. Crear el/los objetos de base de datos que ante el intento de borrar un artículo 
verifique que no exista stock y si es así lo borre en caso contrario que emita un 
mensaje de error
*/
CREATE TRIGGER eje10
ON  Producto INSTEAD OF DELETE
AS 
BEGIN 
     if(select * from deleted
		join STOCK on prod_codigo = stoc_producto
		where stoc_cantidad > 0) > 0
		print 'Error: no se puede borrar productos que tienen stock'
	else
		delete from producto
			where prod_codigo in (select prod_codigo from deleted)




END
GO