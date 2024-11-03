-----------------------EJERCICIO 8 --------------------------------------
/*Mostrar para el o los artículos que tengan stock en todos los depósitos, 
nombre del artículo, stock del depósito que más stock tiene. */
SELECT p.prod_codigo, 
 MAX(s.stoc_cantidad ) as stock_deposito_maxi
FROM Producto p
JOIN STOCK s ON s.stoc_producto = p.prod_codigo
GROUP BY p.prod_codigo





