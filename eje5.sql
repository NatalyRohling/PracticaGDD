-------------------------------------------------Ejercicio 4------------------------------
/*Realizar una consulta que muestre código de artículo, detalle y cantidad de egresos de stock que se realizaron 
para ese artículo en el año 2012
(egresan los productos que fueron vendidos). Mostrar solo aquellos que hayan tenido más egresos que en el 2011. */

SELECT p.prod_detalle,p.prod_codigo,SUM(i.item_cantidad) as Egresos2012
FROM Producto p
JOIN Item_Factura i  ON   p.prod_codigo = i.item_producto
JOIN Factura f ON i.item_numero = f.fact_numero AND i.item_sucursal = f.fact_sucursal AND i.item_tipo = f.fact_tipo
WHERE YEAR(f.fact_fecha )= 2012
GROUP BY p.prod_detalle,p.prod_codigo
HAVING SUM(i.item_cantidad) > (SELECT SUM(i.item_cantidad) as Egresos2011
From  Item_Factura i  
JOIN Factura f ON i.item_numero = f.fact_numero AND i.item_sucursal = f.fact_sucursal AND i.item_tipo = f.fact_tipo
WHERE YEAR(f.fact_fecha)=2011   AND  p.prod_codigo = i.item_producto-- esto es
)
--Agrupame por producto y de ese producto sumamte el total de stock
-- Subquery retorna mas de un valor no se puede
SELECT *
FROM Producto p
INNER JOIN STOCK s ON p.prod_codigo = s.stoc_producto

--Para que no me devuelva un conjunto de filas y vaya una por una, tengo que poner p.prod_codigo = i.item:prodcuto
--