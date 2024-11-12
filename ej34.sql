SELECT r.rubr_id, Meses.Mes,

(SELECT COUNT(DISTINCT f2.fact_tipo+f2.fact_sucursal+f2.fact_numero) FROM 

factura f2 INNER JOIN Item_Factura i2 ON 

f2.fact_tipo = i2.item_tipo AND f2.fact_sucursal = i2.item_sucursal AND f2.fact_numero = f2.fact_numero

INNER JOIN producto p2 ON i2.item_producto = p2.prod_codigo 

WHERE YEAR(f2.fact_fecha) = 2011 AND MONTH(f2.fact_fecha) = Meses.Mes 

AND p2.prod_rubro = r.rubr_id 

AND EXISTS (SELECT 1 FROM producto p3 WHERE p3.prod_rubro != p2.prod_rubro)

) facturasErroneas 

FROM

(SELECT 1 as Mes 

UNION SELECT 2 AS Mes

UNION SELECT 3 AS Mes

UNION SELECT 4 AS Mes

UNION SELECT 5 AS Mes

UNION SELECT 6 AS Mes

UNION SELECT 7 AS Mes

UNION SELECT 8 AS Mes

UNION SELECT 9 AS Mes

UNION SELECT 10 AS Mes

UNION SELECT 11 AS Mes

UNION SELECT 12 AS Mes) AS Meses, rubro r

