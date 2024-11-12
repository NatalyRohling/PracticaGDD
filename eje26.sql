/* Ejercicio 26
Empleado
 Depósitos que tiene a cargo
 Monto total facturado en el año corriente
 Codigo de Cliente al que mas le vendió
 Producto más vendido
 Porcentaje de la venta de ese empleado sobre el total vendido ese año.
Los datos deberan ser ordenados por venta del empleado de mayor a menor.*/
SELECT e.empl_codigo,
(SELECT  COUNT(*)FROM DEPOSITO d WHERE d.depo_encargado = e.empl_apellido) as depositos_a_cargo,
(SELECT SUM(f.fact_total) FROM Factura f WHERE f.fact_vendedor = e.empl_codigo and YEAR(f.fact_fecha) = 2012 ) as monto_total_facturado,
(SELECT TOP 1 p.prod_codigo FROM Factura f
INNER JOIN Item_Factura i   ON f.fact_tipo = i.item_tipo AND f.fact_sucursal = i.item_sucursal AND f.fact_numero = i.item_numero
INNER JOIN Producto p on p.prod_codigo = i.item_producto
WHERE f.fact_vendedor = e.empl_codigo
GROUP BY i.item_producto 
ORDER BY SUM(i.item_cantidad*i.item_precio)) AS prod_mas_vendido,
(SELECT TOP 1 c.clie_vendedor FROM Factura f2
INNER JOIN Item_Factura i2   ON f2.fact_tipo = i2.item_tipo AND f2.fact_sucursal = i2.item_sucursal AND f2.fact_numero = i2.item_numero
INNER JOIN Cliente c on f.fact_cliente = c.clie_codigo
WHERE c.clie_vendedor = e.empl_codigo
GROUP BY c.clie_codigo
ORDER BY SUM(i2.item_cantidad*i2.item_precio) )as cod_cliente,
SUM(i.item_cantidad * i.item_precio) * 100 /       (SELECT SUM(i2.item_cantidad * i2.item_precio)        FROM factura f2                 INNER JOIN Item_Factura i2                            ON f2.fact_tipo = i2.item_tipo AND f2.fact_sucursal = i2.item_sucursal AND                               f2.fact_numero = i2.item_numero        WHERE YEAR(f2.fact_fecha) = 2012                                        as porcentaje


FROM Empleado e
INNER JOIN  Factura f on e.empl_codigo =f.fact_vendedor 
INNER JOIN Item_Factura i  ON f.fact_tipo = i.item_tipo AND f.fact_sucursal = i.item_sucursal AND f.fact_numero = i.item_numero
GROUP BY e.empl_codigo
ORDER BY (SELECT e.empl_codigo 
From Empleado e
INNER JOIN  Factura f on e.empl_codigo =f.fact_vendedor 
INNER JOIN Item_Factura i  ON f.fact_tipo = i.item_tipo AND f.fact_sucursal = i.item_sucursal AND f.fact_numero = i.item_numero
ORDER BY SUM(i.item_cantidad*i.item_precio) DESC)

SELECT e.empl_codigo 
From Empleado e
INNER JOIN  Factura f on e.empl_codigo =f.fact_vendedor 
INNER JOIN Item_Factura i  ON f.fact_tipo = i.item_tipo AND f.fact_sucursal = i.item_sucursal AND f.fact_numero = i.item_numero
ORDER BY SUM(i.item_cantidad*i.item_precio) DESC


----------------------------------VERSION CORREGIDA-----------------------------------


SELECT 
    e.empl_codigo,

    -- Número de depósitos a cargo
    (SELECT COUNT(*) 
     FROM DEPOSITO d 
     WHERE d.depo_encargado = e.empl_codigo) AS depositos_a_cargo,

    -- Monto total facturado en el año 2012
    (SELECT SUM(f.fact_total) 
     FROM Factura f 
     WHERE f.fact_vendedor = e.empl_codigo AND YEAR(f.fact_fecha) = 2012) AS monto_total_facturado,

    -- Código de producto más vendido
    (SELECT TOP 1 p.prod_codigo 
     FROM Factura f
     INNER JOIN Item_Factura i ON f.fact_tipo = i.item_tipo 
         AND f.fact_sucursal = i.item_sucursal 
         AND f.fact_numero = i.item_numero
     INNER JOIN Producto p ON p.prod_codigo = i.item_producto
     WHERE f.fact_vendedor = e.empl_codigo
     GROUP BY p.prod_codigo
     ORDER BY SUM(i.item_cantidad * i.item_precio) DESC) AS prod_mas_vendido,

    -- Código del cliente al que más le vendió
    (SELECT TOP 1 f.fact_cliente 
     FROM Factura f2
     INNER JOIN Item_Factura i2 ON f2.fact_tipo = i2.item_tipo 
         AND f2.fact_sucursal = i2.item_sucursal 
         AND f2.fact_numero = i2.item_numero
     INNER JOIN Cliente c ON f2.fact_cliente = c.clie_codigo
     WHERE f2.fact_vendedor = e.empl_codigo
     GROUP BY f2.fact_cliente
     ORDER BY SUM(i2.item_cantidad * i2.item_precio) DESC) AS cod_cliente,

    -- Porcentaje de ventas del empleado sobre el total del año
    SUM(i.item_cantidad * i.item_precio) * 100.0 / 
    (SELECT SUM(i2.item_cantidad * i2.item_precio) 
     FROM Factura f2
     INNER JOIN Item_Factura i2 ON f2.fact_tipo = i2.item_tipo 
         AND f2.fact_sucursal = i2.item_sucursal 
         AND f2.fact_numero = i2.item_numero
     WHERE YEAR(f2.fact_fecha) = 2012) AS porcentaje_venta

FROM Empleado e
INNER JOIN Factura f ON e.empl_codigo = f.fact_vendedor
INNER JOIN Item_Factura i ON f.fact_tipo = i.item_tipo 
    AND f.fact_sucursal = i.item_sucursal 
    AND f.fact_numero = i.item_numero

GROUP BY e.empl_codigo

-- Ordenar por el monto total facturado de mayor a menor
ORDER BY monto_total_facturado DESC;
