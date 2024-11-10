---------------------------------Ejercicio 16------------------------
/* Con el fin de lanzar una nueva campaña comercial para los clientes que menos compran en la empresa,
se pide una consulta SQL que retorne aquellos clientes cuyas ventas son inferiores a 1/3 
del promedio de ventas del producto que más se vendió en el 2012. 
Además mostrar  1. Nombre del Cliente
2. Cantidad de unidades totales vendidas en el 2012 para ese cliente.
3. Código de producto que mayor venta tuvo en el 2012 
(en caso de existir más de 1, mostrar solamente el de menor código) para ese cliente.  
Aclaraciones:  La composición es de 2 niveles, es decir, un producto compuesto solo se compone de productos no compuestos.
Los clientes deben ser ordenados por código de provincia ascendente.*/

--No hya codigo de provincia ???
SELECT fac.fact_cliente,
SUM(i.item_cantidad) as cant_unidad_vendidas,
(SELECT TOP 1 i.item_producto 
FROM  Factura fac2
INNER JOIN Item_Factura i ON i.item_numero = fac2.fact_numero AND i.item_sucursal = fac2.fact_sucursal AND i.item_tipo = fac2.fact_tipo
WHERE fac2.fact_cliente = fac.fact_cliente
GROUP BY i.item_producto-- no hace falta joinear con el producto
ORDER BY SUM(i.item_precio*item_cantidad) DESC ) as codigo_prod_may
FROM Factura fac
INNER JOIN Item_Factura i ON i.item_numero = fac.fact_numero AND i.item_sucursal = fac.fact_sucursal AND i.item_tipo = fac.fact_tipo
WHERE YEAR(fac.fact_fecha) = 2012
GROUP BY fac.fact_cliente
HAVING SUM(i.item_cantidad*i.item_precio)<1/3*(SELECT TOP 1 AVG(i.item_precio*i.item_cantidad)
FROM  Factura fac
INNER JOIN Item_Factura i ON i.item_numero = fac.fact_numero AND i.item_sucursal = fac.fact_sucursal AND i.item_tipo = fac.fact_tipo
--INNER JOIN Producto p ON i.item_producto = p.prod_codigo NO hace falta joinear
GROUP BY i.item_producto
ORDER BY SUM(i.item_precio*i.item_cantidad)DESC)



---Producto que mas se vendio en el 2012

SELECT TOP 1 AVG(i.item_precio*i.item_cantidad)
FROM  Factura fac
INNER JOIN Item_Factura i ON i.item_numero = fac.fact_numero AND i.item_sucursal = fac.fact_sucursal AND i.item_tipo = fac.fact_tipo
INNER JOIN Producto p ON i.item_producto = p.prod_codigo
GROUP BY p.prod_codigo
ORDER BY SUM(i.item_precio*i.item_cantidad)DESC
