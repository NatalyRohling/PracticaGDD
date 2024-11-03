-----------------------------------------------------------Ejercicio 2-----------------------------------------------------------
USE GD2015C1
GO
/*Mostrar el código, detalle de todos los artículos vendidos en el año 2012 ordenados por cantidad vendida.*/
SELECT p.prod_codigo,p.prod_detalle
FROM Item_Factura i
JOIN Producto p ON   p.prod_codigo = i.item_producto
JOIN Factura f ON i.item_numero = f.fact_numero AND i.item_sucursal = f.fact_sucursal AND i.item_tipo = f.fact_tipo
WHERE YEAR(f.fact_fecha) = 2012
GROUP BY p.prod_codigo,p.prod_detalle
ORDER BY SUM(i.item_cantidad) ASC
-- Me faltaba poner que si pide año es YEAR(fact_fecha) Sino todo rompe!!!
