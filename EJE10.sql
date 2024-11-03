------------------------------------Ejercicio 10------------------------------
/* Mostrar los 10 productos más vendidos en la historia y también los 10 productos menos vendidos en la historia.
Además mostrar de esos productos, quien fue el cliente que mayor compra realizo. */
SELECT (SELECT TOP 10 p.prod_codigo 
FROM Item_Factura i
INNER JOIN Producto p ON i.item_producto = p.prod_codigo
GROUP BY p.prod_codigo 
ORDER BY SUM(i.item_cantidad) ASC) as productos_mas_vendidos,
(
SELECT TOP 10 p.prod_codigo
FROM Item_Factura i
INNER JOIN Producto p ON i.item_producto = p.prod_codigo
GROUP BY p.prod_codigo --Quiero que me agrupes por producto
ORDER BY SUM(i.item_cantidad) DESC ) as productos_menos_vendidos


SELECT TOP 1 f.fact_cliente
FROM Item_Factura i
INNER JOIN Producto p ON i.item_producto = p.prod_codigo
INNER JOIN Factura f ON f.fact_numero = i.item_numero and i.item_tipo= f.fact_tipo AND f.fact_sucursal = i.item_sucursal
GROUP BY prod_codigo,f.fact_cliente
ORDER BY SUM(f.fact_total) DESC
