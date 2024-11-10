
/*EJERCICIO 8*/

/*. Realizar un procedimiento que complete la tabla Diferencias de precios,
para los productos facturados que tengan composición y 
en los cuales el precio de facturación sea diferente al precio del cálculo de los precios unitarios 
por cantidad de sus componentes
, se aclara que un producto que compone a otro, también puede estar compuesto por otros y así sucesivamente,
la tabla se debe crear y está formada por las siguientes columnas: */


create table Diferencia (
	codigo char(8),
	detalle char(50),
	cantidad decimal(12, 2),--cant de prod que conforman el combo 
	precio_generado decimal(12, 2),-- precio que se compone a traves de sus componetes
	precio_facturado decimal(12,2)--precio del producto
)
GO


CREATE PROCEDURE insertar_diferencia_precios
AS
BEGIN
INSERT INTO venta (codigo,detalle ,cantidad, precio_generado, precio_facturado)
SELECT p.prod_codigo,
p.prod_detalle,
COUNT(c.comp_componente),--cant de compontes no se si eso o
SUM(p_componente.prod_precio * c.comp_cantidad),--es el precio de ese compoente y la cantidad de ese componente
p.prod_precio --deberia ser solo eso
FROM Producto p
INNER JOIN Composicion c ON c.comp_producto = p.prod_codigo
INNER JOIN  producto p_componente on p_componente.prod_codigo = c.comp_componente
WHERE (SUM(p_componente.prod_precio * c.comp_cantidad)!=p.prod_precio)
GROUP BY  p.prod_codigo,p.prod_detalle
HAVING c.comp_cantidad>2
END 
GO
/* el precio de facturación sea diferente al precio del cálculo de los precios unitarios 
por cantidad de sus componentes*/
