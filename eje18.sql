----------------------------------------------------Ejercicio 18----------------------------------------------------------------------
/*18. Escriba una consulta que retorne una estad�stica de ventas para todos los rubros. 
La consulta debe retornar:
DETALLE_RUBRO: Detalle del rubro 
VENTAS: Suma de las ventas en pesos de productos vendidos de dicho rubro
PROD1: C�digo del producto m�s vendido de dicho rubro 
PROD2: C�digo del segundo producto m�s vendido de dicho rubro 
CLIENTE: C�digo del cliente que compro m�s productos del rubro en los �ltimos 30 d�as
La consulta no puede mostrar NULL en ninguna de sus columnas y 
debe estar ordenada por cantidad de productos diferentes vendidos del rubro. */
SELECT r.rubr_detalle AS DETALLE_RUBRO,
SUM(i2.item_cantidad*i2.item_precio) as VENTAS,
(SELECT TOP 1 p2.prod_codigo
FROM producto p2 INNER JOIN rubro r2 ON p2.prod_rubro = r2.rubr_id 
INNER JOIN  Item_Factura i1 on p2.prod_codigo = i1.item_producto
WHERE r2.rubr_id = r.rubr_id -- Hay que mostrar que son el mismo rubro
GROUP BY p2.prod_codigo
ORDER BY  SUM(i1.item_cantidad) DESC) as producto_mas_vendido,
(SELECT TOP 1 f3.fact_cliente
FROM Factura f3
INNER JOIN Item_Factura i3 on i3.item_numero= f3.fact_numero AND i3.item_sucursal = f3.fact_sucursal AND i3.item_tipo = f3.fact_tipo
INNER JOIN Producto P on i3.item_producto = P.prod_codigo
WHERE DATEDIFF(DAY,f3.fact_fecha,getdate()) < 31 AND 
P.prod_rubro = R.rubr_id
GROUP BY f3.fact_cliente
ORDER BY COUNT(DISTINCT i3.item_producto)

)


FROM Rubro r
INNER JOIN  Producto p on p.prod_rubro = r.rubr_id
INNER JOIN Item_Factura i2 ON i2.item_producto = p.prod_codigo
--INNER JOIN Factura f2 on i2.item_numero= f2.fact_numero AND i2.item_sucursal = f2.fact_sucursal AND i2.item_tipo = f2.fact_tipo
GROUP BY  r.rubr_detalle
ORDER BY COUNT(DISTINCT i2.item_producto) ASC





SELECT r.rubr_detalle, SUM(i.item_precio * i.item_cantidad) AS Ventas,

(SELECT TOP 1 p2.prod_codigo 

FROM producto p2 INNER JOIN rubro r2 ON p2.prod_rubro = r2.rubr_id 

INNER JOIN Item_Factura i2 ON i2.item_producto = p2.prod_codigo 

WHERE r2.rubr_id = r.rubr_id

GROUP BY p2.prod_codigo, p2.prod_detalle

ORDER BY SUM(i2.item_cantidad) DESC) AS productoMasVendido,

-- PROD2: C�digo del segundo producto m�s vendido de dicho rubro 

ISNULL((SELECT VW.prod_codigo FROM 

(SELECT ROW_NUMBER() OVER (ORDER BY SUM(i2.item_cantidad) DESC) AS orden, p2.prod_codigo

FROM producto p2 INNER JOIN Item_Factura i2 ON i2.item_producto = p2.prod_codigo

WHERE p2.prod_rubro = r.rubr_id

GROUP BY p2.prod_codigo) VW

WHERE orden = 2),'00000000') AS SegundoVendido,

ISNULL((SELECT TOP 1 F.fact_cliente FROM Factura F 

INNER JOIN Item_Factura I ON F.fact_numero = I.item_numero AND F.fact_sucursal = I.item_sucursal AND F.fact_tipo = I.item_tipo 

INNER JOIN Producto P ON i.item_producto = p.prod_codigo 

WHERE DATEDIFF(DAY,F.fact_fecha,getdate()) < 31 AND 

P.prod_rubro = R.rubr_id

GROUP BY F.fact_cliente 

ORDER BY SUM(I.item_cantidad) DESC

),'000000') AS Cliente

FROM rubro r 

INNER JOIN producto p ON r.rubr_id = p.prod_rubro 

INNER JOIN Item_Factura i ON p.prod_codigo = i.item_producto

GROUP BY r.rubr_id, r.rubr_detalle

UNION

SELECT r.rubr_detalle, 0 AS Ventas, '00000000'  AS productoMasVendido, '00000000' AS SegundoVendido, '000000' AS Cliente

FROM rubro r 

WHERE NOT EXISTS (SELECT 1 FROM producto p2 INNER JOIN rubro r2 ON p2.prod_rubro = r2.rubr_id 

                  INNER JOIN Item_Factura i2 ON i2.item_producto = p2.prod_codigo 

				  WHERE r2.rubr_id = r.rubr_id )