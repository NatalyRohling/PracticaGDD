---------------------------------------------------------------Ejercicio 5-----------------------------------------------
/*Mostrar para todos los rubros de art�culos c�digo, detalle, cantidad de art�culos de ese rubro y stock total de ese rubro de art�culos. 
Solo tener en cuenta aquellos art�culos que tengan un stock mayor al del art�culo �00000000� en el dep�sito �00��*/

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
