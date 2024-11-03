----------------------------------------------Ejercicio 3-----------------------------------
/* Realizar una consulta que muestre código de producto, nombre de producto y el stock total, 
sin importar en que deposito se encuentre, 
los datos deben ser ordenados por nombre del artículo de menor a mayor. */
SELECT p.prod_detalle,p.prod_codigo,SUM(s.stoc_cantidad) as StockTotal
FROM Producto p
INNER JOIN STOCK s ON p.prod_codigo = s.stoc_producto
GROUP BY p.prod_detalle,p.prod_codigo
--Agrupame por producto y de ese producto sumamte el total de stock
SELECT *
FROM Producto p
INNER JOIN STOCK s ON p.prod_codigo = s.stoc_producto

