-----------------------EJERCICIO 8 --------------------------------------
/*Mostrar para el o los art�culos que tengan stock en todos los dep�sitos, 
nombre del art�culo, stock del dep�sito que m�s stock tiene. */
SELECT p.prod_codigo, 
 MAX(s.stoc_cantidad ) as stock_deposito_maxi
FROM Producto p
JOIN STOCK s ON s.stoc_producto = p.prod_codigo
GROUP BY p.prod_codigo





