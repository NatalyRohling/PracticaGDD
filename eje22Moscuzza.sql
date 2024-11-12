--Eje 22
--Tengo que agrupar con la funcion  hay que hacer join con factuera
/*-- EJ 22--DATEPART(QUARTER, fecha)

—Funciin para calcular el trimestre del 1 al 4*/
SELECT r.rubr_detalle,DATEPART(QUARTER,f.fact_fecha) AS trimetre,
COUNT (DISTINCT f.fact_tipo + f.fact_sucursal + f.fact_numero ) as cantidadFacturas,
COUNT(DISTINCT p.prod_codigo) AS cantidadProductos
FROM rubro r 
INNER JOIN producto p ON r.rubr_id = p.prod_codigo
INNER JOIN Item_Factura i ON p.prod_codigo = i.item_producto
INNER JOIN Factura f ON f.fact_tipo = i.item_tipo AND f.fact_sucursal = i.item_sucursal and f.fact_numero = i.item_numero
WHERE NOT EXISTS (SELECT 1 FROM Composicion c2 WHERE c2.comp_componete = p.prod_codigo)
GROUP BY rubr_id,rubr_detalle, DATEPART(QUARTER,f.fact_fecha)
HAVING ( COUNT (DISTINCT  f.fact_tipo + f.fact_sucursal + f.fact_numero ))>100--no podemos poner alias sino la expresion
ORDER BY 1,3 DESC

--
--Having -> restriccion a la funcion humanizada
--me pide informacion por rubro o sea de cada rubruo

-- cantidad de facturas emititiras en el trimstres que se haya vendido al menos un procuto del rubru

--para podes contar la cantidad de facturas tengo que concatenar COUNT (DISTINCT f.fact_tipo + f.fact_sucursal + f.fact_numero )

/*SELECT r.rubr_detalle, DATEPART(QUARTER, f.fact_fecha) AS Trimestre,
COUNT(DISTINCT f.fact_tipo+f.fact_sucursal+f.fact_numero) AS cantidadFacturas,
COUNT(DISTINCT p.prod_codigo) AS cantidadProductos
FROM rubro r 
INNER JOIN producto p ON r.rubr_id = p.prod_rubro 
INNER JOIN Item_Factura i ON p.prod_codigo = i.item_producto
INNER JOIN factura f ON f.fact_tipo = i.item_tipo AND f.fact_sucursal = i.item_sucursal AND f.fact_numero = i.item_numero
WHERE NOT EXISTS (SELECT 1 FROM composicion c2 WHERE c2.comp_producto = p.prod_codigo OR c2.comp_componente = p.prod_codigo)
GROUP BY r.rubr_id, r.rubr_detalle, DATEPART(QUARTER, f.fact_fecha) 
HAVING COUNT(DISTINCT f.fact_tipo+f.fact_sucursal+f.fact_numero) > 100
ORDER BY 1, 3 DESC*/

-- Ser preciso en join prinicipal