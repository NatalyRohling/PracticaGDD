/*Escriba una consulta que retorne una estadística de ventas para todos los rubros.
La consulta debe retornar: DETALLE_RUBRO: Detalle del rubro VENTAS:
Suma de las ventas en pesos de productos vendidos de dicho rubro
PROD1: Código del producto más vendido de dicho rubro 
PROD2: Código del segundo producto más vendido de dicho rubro 
CLIENTE: Código del cliente que compro más productos del rubro en los últimos 30 días 
La consulta no puede mostrar NULL en ninguna de sus columnas y debe estar ordenada por cantidad de productos diferentes vendidos del rubro. */
SELECT r.rubr_detalle,rubr_id
 SUM(i.item_cantidad*i.item_precio) as ventas,
 (SELECT  SELECT TOP 1 p2.prod_codigo, p.prod_detalle,SUM(i2.item_cantidad)
 FROM Producto p2 INNER JOIN rubro r2 ON p2.prod_rubro = r2.rubr_id) AS producto_mas_vendido,,


INNER JOIN Item_Factura i ON p.prod_codigo = i.item_producto
WHERE r2.rubr_detalle = '0013'
GROUP BY p2.prod_codigo, p.prod_detalle
ORDER BY SUM(i2.item_cantidad)DESC) AS producto_mas_vendido, 
FROM rubro r 
INNER JOIN producto p ON r.rubr_id = p.prod_rubro INNER JOIN Item_Factura i ON p.prod_codigo = i.item_producto
GROUP BY r.rubr_id, r.rubr_detalle
-- esto es paea ue el rubruo se vea 0 
UNION 
SELECT r.rubr_detalle,0
FROM rubro r
WHERE NOT EXISTS (SELECT 1 FROM Producto p2 INNER JOIN Rubro r2 ON p2.prod_rubro = r2.rubr_id
INNER JOIN Item_Factura i ON p.prod_codigo = i.item_producto
WHERE r2.rubr_detalle = r.rubr_id)

--No hace falta el item porque el preco esta en item
-- Suma de ventas en item cantidad * item_precio
 -- como te pide todos los rpoductos, los que no matcheen hay que ponerle 0 
 -- se podria hacer con un left outer join 


 --- agrupo pro rubruo, y luego por producto 
 --Ejemplo con pastillas 0013
 --Los mas vendddos 000000102 Y 00001303

 --el mas vendido
 SELECT TOP 1 p2.prod_codigo, p.prod_detalle,SUM(i2.item_cantidad)
 FROM Producto p2 INNER JOIN rubro r2 ON p2.prod_rubro = r2.rubr_id
INNER JOIN Item_Factura i ON p.prod_codigo = i.item_producto
WHERE r2.rubr_detalle = '0013'
GROUP BY p2.prod_codigo, p.prod_detalle
ORDER BY SUM(i2.item_cantidad)DESC




-- COMO HACER EL SEGUNDO MAS VENDIDO
--

SELECT * FROM (
SELECT ROW_NUMBER () OVER (ORDER BY p.prod_
)


/*Para los ultimos 30 dias hay que tomar la fecha del sistema
Funcion de diferecia de dias*/

SELECT r.rubr_detalle, 0 AS Ventas, '00000000'  AS productoMasVendido, '00000000' AS SegundoVendido, '000000' AS ClienteFROM rubro r WHERE NOT EXISTS (SELECT 1 FROM producto p2 INNER JOIN rubro r2 ON p2.prod_rubro = r2.rubr_id                   INNER JOIN Item_Factura i2 ON i2.item_producto = p2.prod_codigo 				  WHERE r2.rubr_id = r.rubr_id )