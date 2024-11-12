/*Ejercicio 23*/

--Te piden ls datos año, producto, y leugo todo en torno a producto y año
/*
WHERE COND TOMAR EL PRODUCOT MAS VENEDIDO
GROUP BY AÑO, PRODUCTO*/
-- Tengo los dos datos para que con eso pueda hacer los otros subsleects





SELECT YEAR(f.fact_fecha), P.prod_detalle,(SELECT SUM(c2.comp_cantidad)  FROM Composicion c2 WHERE c2.comp_producto = p.prod_codigo) as componentesFROM factura f INNER JOIN Item_Factura i ON f.fact_tipo = i.item_tipo AND f.fact_sucursal = i.item_sucursal AND f.fact_numero = i.item_numeroINNER JOIN producto p ON i.item_producto = p.prod_codigo INNER JOIN Composicion c ON p.prod_codigo = c.comp_producto GROUP BY YEAR(f.fact_fecha), p.prod_codigo, P.prod_detalle HAVING p.prod_codigo IN (SELECT TOP 1 i2.item_productoFROM factura f2 INNER JOIN Item_Factura i2 ON f2.fact_tipo = i2.item_tipo AND f2.fact_sucursal = i2.item_sucursal AND f2.fact_numero = i2.item_numeroINNER JOIN Composicion c2 ON i2.item_producto = c2.comp_producto WHERE YEAR(f2.fact_fecha) = YEAR(f.fact_fecha)GROUP BY i2.item_producto ORDER BY SUM(i2.item_cantidad) DESC)--Top 1 agrupo por cliente --Porcentaje total del anioSELECT YEAR(f.fact_fecha), P.prod_detalle,(SELECT SUM(c2.comp_cantidad)  FROM Composicion c2 WHERE c2.comp_producto = p.prod_codigo) as componentes,COUNT(*) as facturas,(SELECT TOP 1 f2.fact_cliente        FROM factura f2                 INNER JOIN Item_Factura i2                            ON f2.fact_tipo = i2.item_tipo AND f2.fact_sucursal = i2.item_sucursal AND                               f2.fact_numero = i2.item_numero        WHERE i2.item_producto = p.prod_codigo        GROUP BY f2.fact_cliente        ORDER BY COUNT(DISTINCT f2.fact_tipo+f2.fact_sucursal+f2.fact_numero) DESC) as cliente,
SUM(i.item_cantidad * i.item_precio) * 100 /       (SELECT SUM(i2.item_cantidad * i2.item_precio)        FROM factura f2                 INNER JOIN Item_Factura i2                            ON f2.fact_tipo = i2.item_tipo AND f2.fact_sucursal = i2.item_sucursal AND                               f2.fact_numero = i2.item_numero        WHERE YEAR(f.fact_fecha) = YEAR(f2.fact_fecha))                                           as porcentaje
FROM factura f INNER JOIN Item_Factura i ON f.fact_tipo = i.item_tipo AND f.fact_sucursal = i.item_sucursal AND f.fact_numero = i.item_numeroINNER JOIN producto p ON i.item_producto = p.prod_codigo INNER JOIN Composicion c ON p.prod_codigo = c.comp_producto GROUP BY YEAR(f.fact_fecha), p.prod_codigo, P.prod_detalle HAVING p.prod_codigo IN (SELECT TOP 1 i2.item_productoFROM factura f2 INNER JOIN Item_Factura i2 ON f2.fact_tipo = i2.item_tipo AND f2.fact_sucursal = i2.item_sucursal AND f2.fact_numero = i2.item_numeroINNER JOIN Composicion c2 ON i2.item_producto = c2.comp_producto WHERE YEAR(f2.fact_fecha) = YEAR(f.fact_fecha)GROUP BY i2.item_producto ORDER BY SUM(i2.item_cantidad) DESC)



























SELECT  YEAR(f.fact_fecha),p.prod_detalle,

(SELECT SUM(c2.comp_cantidad)
From  Composicion c2 
--Pensamos que te pide la des
WHERE c2.comp_producto = '00001718'
),(SELECT TOP 1 f2.fact_cliente        FROM factura f2                 INNER JOIN Item_Factura i2                            ON f2.fact_tipo = i2.item_tipo AND f2.fact_sucursal = i2.item_sucursal AND                               f2.fact_numero = i2.item_numero        WHERE i2.item_producto = p.prod_codigo        GROUP BY f2.fact_cliente        ORDER BY COUNT(DISTINCT f2.fact_sucursal+f2.fact_tipo+f2.fact_numero) DESC)                                            as cliente,       SUM(i.item_cantidad * i.item_precio) * 100 /       (SELECT SUM(i.item_cantidad * i.item_precio)        FROM factura f                 INNER JOIN Item_Factura i                            ON f.fact_tipo = i.item_tipo AND f.fact_sucursal = i.item_sucursal AND                               f.fact_numero = i.item_numero        WHERE YEAR(f.fact_fecha) = YEAR(f.fact_fecha))                                           as porcentaje



		--dentto del selectdel sleect puedo pone rf2

FROM Factura f INNER JOIN Item_Factura i on f.fact_tipo = i.item_tipo and f.fact_sucursal = i.item_sucursal
--Produco con composicion 
INNER JOIN Producto p ON i.item_producto = p.prod_codigo
INNER JOIN Composicion c on p.prod_codigo = c.comp_producto
--Pensamos que te pide la descipcion de producto , sino podrias saltear eso
WHERE  p.prod_codigo IN(
SELECT TOP 1 i2.item_producto
FROM Factura f2 INNER JOIN Item_Factura i2 on f2.fact_tipo = i2.item_tipo and f2.fact_sucursal = i2.item_sucursal
INNER JOIN Composicion c2 on i2.item_producto = c2.comp_producto
--Pensamos que te pide la des
WHERE YEAR(f2.fact_fecha) = YEAR(f.fact_fecha)--tenga la misma fecha
GROUP BY i2.item_producto
ORDER by SUM(i2.item_cantidad) DESC)

GROUP BY p.prod_codigo, YEAR(f.fact_fecha),p.prod_detalle

go


--Parte producto con composicion mas venedido para ese año
SELECT TOP 1 i2.item_producto
FROM Factura f2 INNER JOIN Item_Factura i2 on f2.fact_tipo = i2.item_tipo and f2.fact_sucursal = i2.item_sucursal
INNER JOIN Composicion c2 on i2.item_producto = c2.comp_producto
--Pensamos que te pide la des
WHERE YEAR(f2.fact_fecha) = 2012
GROUP BY i2.item_producto
ORDER by SUM(i2.item_cantidad) DESC

--- La cantidad de elementos

SELECT SUM(c2.comp_cantidad)
From  Composicion c2 
--Pensamos que te pide la des
WHERE c2.comp_producto = '00001718'

--el codigo que pones en el where, es el de la agrupacion en la agrup



SELECT YEAR(f.fact_fecha), P.prod_detalle,(SELECT SUM(c2.comp_cantidad)  FROM Composicion c2 WHERE c2.comp_producto = p.prod_codigo) as componentesFROM factura f INNER JOIN Item_Factura i ON f.fact_tipo = i.item_tipo AND f.fact_sucursal = i.item_sucursal AND f.fact_numero = i.item_numeroINNER JOIN producto p ON i.item_producto = p.prod_codigo INNER JOIN Composicion c ON p.prod_codigo = c.comp_producto GROUP BY YEAR(f.fact_fecha), p.prod_codigo, P.prod_detalle HAVING p.prod_codigo IN (SELECT TOP 1 i2.item_productoFROM factura f2 INNER JOIN Item_Factura i2 ON f2.fact_tipo = i2.item_tipo AND f2.fact_sucursal = i2.item_sucursal AND f2.fact_numero = i2.item_numeroINNER JOIN Composicion c2 ON i2.item_producto = c2.comp_producto WHERE YEAR(f2.fact_fecha) = YEAR(f.fact_fecha)GROUP BY i2.item_producto ORDER BY SUM(i2.item_cantidad) DESC)--Top 1 agrupo por cliente --Porcentaje total del anioSELECT YEAR(f.fact_fecha), P.prod_detalle,(SELECT SUM(c2.comp_cantidad)  FROM Composicion c2 WHERE c2.comp_producto = p.prod_codigo) as componentes,COUNT(*) as facturas,(SELECT TOP 1 f2.fact_cliente        FROM factura f2                 INNER JOIN Item_Factura i2                            ON f2.fact_tipo = i2.item_tipo AND f2.fact_sucursal = i2.item_sucursal AND                               f2.fact_numero = i2.item_numero        WHERE i2.item_producto = p.prod_codigo        GROUP BY f2.fact_cliente        ORDER BY COUNT(DISTINCT f2.fact_tipo+f2.fact_sucursal+f2.fact_numero) DESC) as cliente,
SUM(i.item_cantidad * i.item_precio) * 100 /       (SELECT SUM(i2.item_cantidad * i2.item_precio)        FROM factura f2                 INNER JOIN Item_Factura i2                            ON f2.fact_tipo = i2.item_tipo AND f2.fact_sucursal = i2.item_sucursal AND                               f2.fact_numero = i2.item_numero        WHERE YEAR(f.fact_fecha) = YEAR(f2.fact_fecha))                                           as porcentaje
FROM factura f INNER JOIN Item_Factura i ON f.fact_tipo = i.item_tipo AND f.fact_sucursal = i.item_sucursal AND f.fact_numero = i.item_numeroINNER JOIN producto p ON i.item_producto = p.prod_codigo INNER JOIN Composicion c ON p.prod_codigo = c.comp_producto GROUP BY YEAR(f.fact_fecha), p.prod_codigo, P.prod_detalle HAVING p.prod_codigo IN (SELECT TOP 1 i2.item_productoFROM factura f2 INNER JOIN Item_Factura i2 ON f2.fact_tipo = i2.item_tipo AND f2.fact_sucursal = i2.item_sucursal AND f2.fact_numero = i2.item_numeroINNER JOIN Composicion c2 ON i2.item_producto = c2.comp_producto WHERE YEAR(f2.fact_fecha) = YEAR(f.fact_fecha)GROUP BY i2.item_producto ORDER BY SUM(i2.item_cantidad) DESC)