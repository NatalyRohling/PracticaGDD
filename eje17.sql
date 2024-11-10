--------------------------------------------------Ejercicio 17 ---------------------------------------------------
/*Escriba una consulta que retorne una estadística de ventas por año y mes para cada producto. 
La consulta debe retornar:  PERIODO: Año y mes de la estadística con el formato 
YYYYMM PROD: Código de producto 
DETALLE: Detalle del producto
CANTIDAD_VENDIDA= Cantidad vendida del producto en el periodo 
VENTAS_AÑO_ANT= Cantidad vendida del producto en el mismo mes del periodo pero del año anterior 
CANT_FACTURAS= Cantidad de facturas en las que se vendió el producto en el periodo 
La consulta no puede mostrar NULL en ninguna de sus columnas y debe estar ordenada por periodo y código de producto*/
SELECT 
 CONCAT(YEAR(fact_fecha), RIGHT('00' + CAST(MONTH(fact_fecha) AS VARCHAR(2)), 2)) AS PERIODO 
,
p.prod_codigo AS PROD
, p.prod_detalle AS DETALLE,
SUM(i.item_cantidad) as cant_vendida_producto,
(SELECT ISNULL(SUM(i2.item_cantidad))
FROM  Item_Factura i2 
INNER JOIN Factura f2 on i2.item_numero= f2.fact_numero AND i2.item_sucursal = f2.fact_sucursal AND i2.item_tipo = f2.fact_tipo
WHERE YEAR(f2.fact_fecha) =YEAR(fac.fact_fecha)-1 AND  MONTH(f2.fact_fecha)= MONTH(fac.fact_fecha) and i2.item_producto =p.prod_codigo --mismo producto
GROUP BY i2.item_producto,YEAR(f2.fact_fecha), MONTH(f2.fact_fecha)
) as ventas_anio_ant,
COUNT(DISTINCT fac.fact_numero) as canti_facturas

FROM Producto p
INNER JOIN Item_Factura i ON i.item_producto = p.prod_codigo
LEFT  JOIN Factura fac on i.item_numero= fac.fact_numero AND i.item_sucursal = fac.fact_sucursal AND i.item_tipo = fac.fact_tipo
GROUP BY p.prod_codigo, p.prod_detalle,YEAR(fact_fecha), MONTH(fact_fecha)

