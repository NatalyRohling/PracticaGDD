/*25. Realizar una consulta SQL que para cada año y familia muestre :
a. Año
b. El código de la familia más vendida en ese año.
c. Cantidad de Rubros que componen esa familia.
d. Cantidad de productos que componen directamente al producto más vendido de 
esa familia.
e. La cantidad de facturas en las cuales aparecen productos pertenecientes a esa 
familia.
f. El código de cliente que más compro productos de esa familia.
g. El porcentaje que representa la venta de esa familia respecto al total de venta 
del año.
El resultado deberá ser ordenado por el total vendido por año y familia en forma 
descendente.*/

-- COMO TE PIDE FAMILIA TODO HACE CON WHERE DE FAMILIA


--En resumen en el having pongo la familia mas vendida de ese anio para ahorrar trabajo
--Luego en todas las consultas hago las que hagan falta, y conecto el id de familia , siempre prod_familia = fa.fami_id
SELECT YEAR(f.fact_fecha) as anio, fa.fami_id ,(SELECT COUNT(*) FROM Rubro  r INNER JOIN Producto p on p.prod_rubro = r.rubr_idWHERE p.prod_familia = fa.fami_id) as cant_rubros_que_componen,COUNT(*) as facturas,(SELECT TOP 1 f2.fact_cliente        FROM factura f2                 INNER JOIN Item_Factura i2                            ON f2.fact_tipo = i2.item_tipo AND f2.fact_sucursal = i2.item_sucursal AND                               f2.fact_numero = i2.item_numero			  INNER JOIN Producto p2 on  i2.item_producto = p2.prod_codigo        WHERE  p2.prod_familia = fa.fami_id		-- o no se si hacer un join com producto p2 y poner p2.prod_familia = fa.fami_id        GROUP BY f2.fact_cliente        ORDER BY COUNT(DISTINCT f2.fact_tipo+f2.fact_sucursal+f2.fact_numero) DESC) as cod_cliente,
		(SELECT SUM(c2.comp_cantidad)  FROM Composicion c2 WHERE c2.comp_producto IN( SELECT TOP 1 p.prod_codigo
         FROM Producto p
         INNER JOIN Item_Factura i ON i.item_producto = p.prod_codigo
         WHERE p.prod_familia = fa.fami_id AND YEAR(f.fact_fecha) = YEAR(f.fact_fecha)
         GROUP BY p.prod_codigo
         ORDER BY SUM(i.item_cantidad) DESC)) as componentes,
        SUM(i.item_cantidad * i.item_precio) * 100 /       (SELECT SUM(i2.item_cantidad * i2.item_precio)        FROM factura f2                 INNER JOIN Item_Factura i2                            ON f2.fact_tipo = i2.item_tipo AND f2.fact_sucursal = i2.item_sucursal AND                               f2.fact_numero = i2.item_numero        AND  YEAR(f.fact_fecha) = YEAR(f2.fact_fecha))     -- Te dice del anio                                      as porcentaje_venta
FROM factura f INNER JOIN Item_Factura i ON f.fact_tipo = i.item_tipo AND f.fact_sucursal = i.item_sucursal AND f.fact_numero = i.item_numeroINNER JOIN producto p ON i.item_producto = p.prod_codigo INNER JOIN Familia fa on p.prod_familia = fa.fami_id--INNER JOIN Composicion c ON p.prod_codigo = c.comp_producto GROUP BY YEAR(f.fact_fecha),fa.fami_idHAVING fa.fami_id in (
    SELECT TOP 1 fa2.fami_id
    FROM Factura f2
    INNER JOIN Item_Factura i2 ON f2.fact_tipo = i2.item_tipo AND f2.fact_sucursal = i2.item_sucursal AND f2.fact_numero = i2.item_numero
    INNER JOIN Producto p2 ON i2.item_producto = p2.prod_codigo
    INNER JOIN Familia fa2 ON p2.prod_familia = fa2.fami_id
    WHERE YEAR(f2.fact_fecha) = YEAR(f.fact_fecha)
    GROUP BY fa2.fami_id
    ORDER BY SUM(i2.item_cantidad) DESC)--Esta parte es para ver la familia mas vendidoORDER BY SUM(i. item_cantidad*i.item_precio)DESC,fa.fami_id ASC