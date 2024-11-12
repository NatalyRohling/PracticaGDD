----------------------------------------------------Ejercicio 18----------------------------------------------------------------------
/*18. Escriba una consulta que retorne una estadística de ventas para todos los rubros. 
La consulta debe retornar:
DETALLE_RUBRO: Detalle del rubro 
VENTAS: Suma de las ventas en pesos de productos vendidos de dicho rubro
PROD1: Código del producto más vendido de dicho rubro 
PROD2: Código del segundo producto más vendido de dicho rubro 
CLIENTE: Código del cliente que compro más productos del rubro en los últimos 30 días
La consulta no puede mostrar NULL en ninguna de sus columnas y 
debe estar ordenada por cantidad de productos diferentes vendidos del rubro. */




---MI VERSION
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



----------------------------------------VERSION EL PROFE

SELECT r.rubr_detalle, SUM(i.item_precio * i.item_cantidad) AS Ventas,

(SELECT TOP 1 p2.prod_codigo 

FROM producto p2 INNER JOIN rubro r2 ON p2.prod_rubro = r2.rubr_id 

INNER JOIN Item_Factura i2 ON i2.item_producto = p2.prod_codigo 

WHERE r2.rubr_id = r.rubr_id

GROUP BY p2.prod_codigo, p2.prod_detalle

ORDER BY SUM(i2.item_cantidad) DESC) AS productoMasVendido,

-- PROD2: Código del segundo producto más vendido de dicho rubro 

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



				  --------------------VERSION JOACO

				  use GD2015C1select rubr_detalle 'Rubro',	sum(item_cantidad * item_precio) 'Suma de todas las ventas',	
				  (select top 1 prod_codigo from producto	
				  join item_factura on item_producto = prod_codigo	where prod_rubro = rubr_id	
				  group by prod_codigo	order by sum(item_cantidad) desc) 'Producto más vendido',	
				  (select top 1 prod_codigo 
				  from producto	
				  join item_factura on item_producto = prod_codigo	
				  where prod_rubro = rubr_id and		prod_codigo !=
				  (select top 1 prod_codigo from producto			j
				  oin item_factura on item_producto = prod_codigo		
				  where prod_rubro = rubr_id		
				  group by prod_codigo	
				  order by sum(item_cantidad) desc)	
				  group by prod_codigo	order by sum(item_cantidad) desc) 'Segundo producto más vendido',
				  (select top 1 fact_cliente from factura f1	
				  join item_factura on item_sucursal+item_tipo+item_numero = fact_sucursal+fact_tipo+fact_numero	
				  join producto on prod_codigo = item_producto	where prod_rubro = rubr_id and
		       datediff(day, fact_fecha, ( -- Esto va si último año = último año en el que hizo una compra. Sino sería getdate().
			    select top 1 fact_fecha from factura f2
			   where f1.fact_cliente = f2.fact_cliente
			  order by 1 desc
		)) < 30) 'Cliente que más compró en los últimos 30 días'from rubro	left join producto on prod_rubro = rubr_id	left join item_factura on item_producto = prod_codigogroup by rubr_detalle, rubr_idorder by count(distinct item_producto)