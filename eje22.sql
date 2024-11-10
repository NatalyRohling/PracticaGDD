--ejercicoo 22
/* Escriba una consulta sql que retorne una estadistica de venta para todos los rubros por  trimestre contabilizando todos los años. 
Se mostraran como maximo 4 filas por rubro (1 por cada trimestre). Se deben mostrar 4 columnas:
 Detalle del rubro  Numero de trimestre del año (1 a 4) 
 Cantidad de facturas emitidas en el trimestre en las que se haya vendido al menos un producto del rubro 
 Cantidad de productos diferentes del rubro vendidos en el trimestre 
 El resultado debe ser ordenado alfabeticamente por el detalle del rubro y dentro de cada rubro primero el trimestre en el que mas facturas se emitieron. 
No se deberan mostrar aquellos rubros y trimestres para los cuales las facturas emitiadas no superen las 100.*/
SELECT r.rubr_detalle, 
DATEPART(QUARTER, f.fact_fecha) AS Trimestre,

COUNT(DISTINCT f.fact_tipo+f.fact_sucursal+f.fact_numero) AS cantidadFacturas,

COUNT(DISTINCT p.prod_codigo) AS cantidadProductos -- cantidad de  productos diferentes del rubro vendedios

FROM rubro r 

INNER JOIN producto p ON r.rubr_id = p.prod_rubro 

INNER JOIN Item_Factura i ON p.prod_codigo = i.item_producto

INNER JOIN factura f ON f.fact_tipo = i.item_tipo AND f.fact_sucursal = i.item_sucursal AND f.fact_numero = i.item_numero

WHERE NOT EXISTS (SELECT 1 FROM composicion c2 WHERE c2.comp_producto = p.prod_codigo OR c2.comp_componente = p.prod_codigo)

GROUP BY r.rubr_id, r.rubr_detalle, DATEPART(QUARTER, f.fact_fecha) 

HAVING COUNT(DISTINCT f.fact_tipo+f.fact_sucursal+f.fact_numero) > 100

ORDER BY 1, 3 DESC