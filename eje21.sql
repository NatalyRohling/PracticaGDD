------------------------------------------Ejercicio 21
/*Escriba una consulta sql que retorne para todos los años, en los cuales se haya hecho al menos una factura, 
la cantidad de clientes a los que se les facturo de manera incorrecta al menos una factura y
que cantidad de facturas se realizaron de manera incorrecta. Se considera que una factura es
incorrecta cuando la diferencia entre el total de la factura menos el total de impuesto tiene una diferencia mayor a 
$ 1 respecto a la sumatoria de los costos de cada uno de los items de dicha factura. Las columnas que se deben mostrar son: */

SELECT SUM(f.fact_total)- SUM(f.fact_total_impuestos) as diferencia
FROM Factura f
GROUP BY  f.fact_numero


SELECT SUM(i1.item_cantidad*i1.item_precio)
FROM Factura f1
INNER JOIN Item_Factura i1 ON f1.fact_tipo = i1.item_tipo AND f1.fact_sucursal = i1.item_sucursal AND f1.fact_numero = f1.fact_numero
GROUP BY  f1.fact_numero


/* Anio 
Clientes a los que se les facturo mal en ese año 
Facturas mal realizadas en ese año */


SELECT YEAR(f.fact_fecha),
(SELECT 
COUNT(DISTINCT f.fact_cliente)
FROM Factura WHERE f.fact_numero+f.fact_sucursal+f.fact_fecha IN (
SELECT FM.item_tipo+FM.item_sucursal+FM.item_numero FROM Item_Factura FM
			group by FM.item_tipo+FM.item_sucursal+FM.item_numero
			having sum(FM.item_precio*FM.item_cantidad) <> (select FMH.fact_total-FMH.fact_total_impuestos from Factura FMH 
			where FMH.fact_tipo+FMH.fact_sucursal+FMH.fact_numero = FM.item_tipo+FM.item_sucursal+FM.item_numero))


FROM Factura f
GROUP BY f.fact_cliente
HAVING 