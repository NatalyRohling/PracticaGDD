USE [GD2015C1]
GO
/*
23. Realizar una consulta SQL que para cada a�o muestre :
- A�o
- El producto con composici�n m�s vendido para ese a�o.
- Cantidad de productos que componen directamente al producto m�s vendido
- La cantidad de facturas en las cuales aparece ese producto.
- El c�digo de cliente que m�s compro ese producto.
- El porcentaje que representa la venta de ese producto respecto al total de venta
del a�o.
El resultado deber� ser ordenado por el total vendido por a�o en forma descendente.
*/


SELECT YEAR(f.fact_fecha), P.prod_detalle,
(SELECT SUM(c2.comp_cantidad)  FROM Composicion c2 WHERE c2.comp_producto = p.prod_codigo) as componentes,
COUNT(*) as facturas,
(SELECT TOP 1 f2.fact_cliente        FROM factura f2                 INNER JOIN Item_Factura i2                            ON f2.fact_tipo = i2.item_tipo AND f2.fact_sucursal = i2.item_sucursal AND                               f2.fact_numero = i2.item_numero        WHERE i2.item_producto = p.prod_codigo        GROUP BY f2.fact_cliente        ORDER BY COUNT(DISTINCT f2.fact_tipo+f2.fact_sucursal+f2.fact_numero) DESC) as cliente,       SUM(i.item_cantidad * i.item_precio) * 100 /       (SELECT SUM(i2.item_cantidad * i2.item_precio)        FROM factura f2                 INNER JOIN Item_Factura i2                            ON f2.fact_tipo = i2.item_tipo AND f2.fact_sucursal = i2.item_sucursal AND                               f2.fact_numero = i2.item_numero        WHERE YEAR(f.fact_fecha) = YEAR(f2.fact_fecha))                                           as porcentaje

FROM factura f 
INNER JOIN Item_Factura i ON f.fact_tipo = i.item_tipo AND f.fact_sucursal = i.item_sucursal AND f.fact_numero = i.item_numero
INNER JOIN producto p ON i.item_producto = p.prod_codigo 
INNER JOIN Composicion c ON p.prod_codigo = c.comp_producto 

GROUP BY YEAR(f.fact_fecha), p.prod_codigo, P.prod_detalle 

HAVING p.prod_codigo IN (
SELECT TOP 1 i2.item_producto
FROM factura f2 
INNER JOIN Item_Factura i2 ON f2.fact_tipo = i2.item_tipo AND f2.fact_sucursal = i2.item_sucursal AND f2.fact_numero = i2.item_numero
INNER JOIN Composicion c2 ON i2.item_producto = c2.comp_producto 
WHERE YEAR(f2.fact_fecha) = YEAR(f.fact_fecha)
GROUP BY i2.item_producto 
ORDER BY SUM(i2.item_cantidad) DESC)

-- agregar cursor
CREATE TRIGGER t_compramaxima -- t-sql ej 30
ON dbo.Item_Factura
AFTER INSERT
AS
BEGIN
    DECLARE @ClienteCod CHAR(6)
    DECLARE @ProductoCod CHAR(8)
    DECLARE @Cantidad DECIMAL(12, 2)

    -- me traigo el cliente, producto y cantidad insertados
    SELECT
        @ClienteCod = f.fact_cliente,
        @ProductoCod = i.item_producto,
        @Cantidad = i.item_cantidad
    FROM inserted as i
INNER JOIN Factura as f
ON i.item_numero = f.fact_numero AND i.item_sucursal = f.fact_sucursal AND i.item_tipo = f.fact_tipo

    -- aca le sumo lo insertado a lo existente y veo si alguno sobrepasa las 100 unidades
    IF EXISTS (
        SELECT 1
        FROM dbo.Item_Factura as i
INNER JOIN Factura as f
ON i.item_numero = f.fact_numero AND i.item_sucursal = f.fact_sucursal AND i.item_tipo = f.fact_tipo
        WHERE f.fact_cliente = @ClienteCod
        AND item_producto = @ProductoCod
        AND MONTH(f.fact_fecha) = MONTH(GETDATE()) AND YEAR(f.fact_fecha) = YEAR(GETDATE())
        GROUP BY f.fact_cliente, item_producto
        HAVING SUM(i.item_cantidad) + @Cantidad > 100
    )
    BEGIN
        -- si se sobrepaso el limite tiro el error
        ROLLBACK TRANSACTION
        RAISERROR('Limite de compra superado', 10, 1)
    END
END



