/*Ejercicio 23*/
/* Realizar una consulta SQL que para cada año muestre :
Año
 El producto con composición más vendido para ese año.
 Cantidad de productos que componen directamente al producto más vendido
 La cantidad de facturas en las cuales aparece ese producto.
 El código de cliente que más compro ese producto.
 El porcentaje que representa la venta de ese producto respecto al total de venta 
del año.
El resultado deberá ser ordenado por el total vendido por año en forma descendente*/
USE [GD2015C1]
GO
/*
23. Realizar una consulta SQL que para cada año muestre :
- Año
- El producto con composición más vendido para ese año.
- Cantidad de productos que componen directamente al producto más vendido
- La cantidad de facturas en las cuales aparece ese producto.
- El código de cliente que más compro ese producto.
- El porcentaje que representa la venta de ese producto respecto al total de venta
del año.
El resultado deberá ser ordenado por el total vendido por año en forma descendente.
*/


SELECT YEAR(f.fact_fecha), P.prod_detalle,
(SELECT SUM(c2.comp_cantidad)  FROM Composicion c2 WHERE c2.comp_producto = p.prod_codigo) as componentes,
COUNT(*) as facturas,
(SELECT TOP 1 f2.fact_cliente
        FROM factura f2
                 INNER JOIN Item_Factura i2
                            ON f2.fact_tipo = i2.item_tipo AND f2.fact_sucursal = i2.item_sucursal AND
                               f2.fact_numero = i2.item_numero
        WHERE i2.item_producto = p.prod_codigo
        GROUP BY f2.fact_cliente
        ORDER BY COUNT(DISTINCT f2.fact_tipo+f2.fact_sucursal+f2.fact_numero) DESC) as cliente,
       SUM(i.item_cantidad * i.item_precio) * 100 /
       (SELECT SUM(i2.item_cantidad * i2.item_precio)
        FROM factura f2
                 INNER JOIN Item_Factura i2
                            ON f2.fact_tipo = i2.item_tipo AND f2.fact_sucursal = i2.item_sucursal AND
                               f2.fact_numero = i2.item_numero
        WHERE YEAR(f.fact_fecha) = YEAR(f2.fact_fecha))                                           as porcentaje

FROM factura f 
INNER JOIN Item_Factura i ON f.fact_tipo = i.item_tipo AND f.fact_sucursal = i.item_sucursal AND f.fact_numero = i.item_numero
INNER JOIN producto p ON i.item_producto = p.prod_codigo 
INNER JOIN Composicion c ON p.prod_codigo = c.comp_producto 

GROUP BY YEAR(f.fact_fecha), p.prod_codigo, P.prod_detalle 

HAVING p.prod_codigo IN (
SELECT TOP 1 i2.item_producto
FROM factura f2 
INNER JOIN Item_Factura i2 ON f2.fact_tipo = i2.item_tipo AND f2.fact_sucursal = i2.item_sucursal AND f2.fact_numero = i2.item_numero
INNER JOIN Composicion c2 ON i2.item_producto = c2.comp_producto 
WHERE YEAR(f2.fact_fecha) = YEAR(f.fact_fecha)
GROUP BY i2.item_producto 
ORDER BY SUM(i2.item_cantidad) DESC)