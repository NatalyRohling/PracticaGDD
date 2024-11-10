
/*EJERCICIO 7*/
/* Hacer un procedimiento que dadas dos fechas complete la tabla Ventas. 
Debe insertar una línea por cada artículo con los movimientos de stock generados por las ventas entre esas fechas
. La tabla se encuentra creada y vacía*/
create table venta (
	codigo char(8),
	detalle char(50),
	cantidad_movimientos decimal(12, 2),--Cantidad de movimientos de ventas (Item factura) 
	precio decimal(12, 2),--Precio promedi o de venta 
	renglon char(8),-- ROW_NUMBER()--Nro. de línea de la tabla 
	ganancia decimal(12, 2)--Nro. de línea de la tabla 
)
go

USE GD2015C1
GO
CREATE PROCEDURE insertar_ventas @fecha1 datetime, @fecha2 datetime
AS
BEGIN
INSERT INTO venta (codigo,detalle ,cantidad_movimientos,precio,renglon ,ganancia )
SELECT p.prod_codigo,
p.prod_detalle,
SUM(i.item_cantidad),
AVG(i.item_cantidad*i.item_precio),
i.item_numero AS renglon,,
AVG(i.item_cantidad*i.item_precio)-i.item_cantidad*i.item_precio

FROM Producto p
INNER JOIN Item_Factura i on p.prod_codigo = i.item_producto	
INNER JOIN Factura f ON  f.fact_numero = i.item_numero and f.fact_sucursal=i.item_sucursal  and f.fact_tipo = i.item_tipo
WHERE @fecha1 <= f.fact_fecha and f.fact_fecha <= @fecha2
GROUP BY  p.prod_codigo,p.prod_detalle
END 
GO