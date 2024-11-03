---------------------------------------------------------------Ejercicio 5-----------------------------------------------
/*Mostrar para todos los rubros de artículos código, detalle, cantidad de artículos de ese rubro y stock total de ese rubro de artículos. 
Solo tener en cuenta aquellos artículos que tengan un stock mayor al del artículo ‘00000000’ en el depósito ‘00’´*/

SELECT r.rubr_detalle,r.rubr_id, COUNT(p.prod_rubro) as cantidad_articulos,SUM(s.stoc_cantidad)  as cantidad_stock_rubro
FROM Rubro r
JOIN Producto p ON r.rubr_id= p.prod_rubro
JOIN STOCK s ON s.stoc_producto = p.prod_codigo
GROUP BY  r.rubr_detalle,r.rubr_id
HAVING(SUM(s.stoc_cantidad)> (SELECT SUM(s.stoc_cantidad) 
FROM Rubro r
JOIN Producto p ON r.rubr_id= p.prod_rubro
JOIN STOCK s ON s.stoc_producto = p.prod_codigo
WHERE p.prod_codigo = '00000000' AND s.stoc_deposito = '00'))
