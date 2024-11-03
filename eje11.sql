
------------------------------------------------------Ejercicio 11----------------------------------------------------
/*Realizar una consulta que retorne el detalle de la familia, 
la cantidad diferentes de productos vendidos y el monto de dichas ventas sin impuestos. 
Los datos se deberán ordenar de mayor a menor,
por la familia que más productos diferentes vendidos tenga, 
solo se deberán mostrar las familias que tengan una venta superior a 20000 pesos para el año 2012. */

SELECT f.fami_detalle,f.fami_id, COUNT(DISTINCT p.prod_codigo)as cantidad_productos , SUM(i.item_cantidad*i.item_precio) as monto
FROM Familia f
INNER JOIN Producto p ON  p.prod_familia = f.fami_id 
INNER JOIN Item_Factura i on p.prod_codigo = i.item_producto
INNER JOIN  Factura fac ON i.item_numero = fac.fact_numero AND i.item_sucursal = fac.fact_sucursal AND i.item_tipo = fac.fact_tipo
WHERE YEAR(fac.fact_fecha) = 2012
GROUP BY  f.fami_detalle,f.fami_id
HAVING SUM(i.item_cantidad*i.item_precio) >20000
ORDER BY 3 DESC
SELECT * FROM Familia
SELECT * FROM Producto WHERE prod_familia = '999'

SELECT f.fami_detalle,f.fami_id, COUNT(DISTINCT p.prod_codigo)as cantidad_productos , SUM(i.item_cantidad*i.item_precio) as monto
FROM Familia f
INNER JOIN Producto p ON  p.prod_familia = f.fami_id 
INNER JOIN Item_Factura i on p.prod_codigo = i.item_producto
INNER JOIN  Factura fac ON i.item_numero = fac.fact_numero AND i.item_sucursal = fac.fact_sucursal AND i.item_tipo = fac.fact_tipo
WHERE YEAR(fac.fact_fecha) = 2012 and f.fami_id = '999'
GROUP BY  f.fami_detalle,f.fami_id

