-----------------------Ejercicio 4----------------------
/*Realizar una consulta que muestre para todos los artículos código, detalle y cantidad de artículos que lo componen. 
Mostrar solo aquellos artículos para los cuales el stock promedio por depósito sea mayor a 100. */
SELECT p.prod_codigo,p.prod_detalle, COUNT(c.comp_componente) as CantidadArticulos
FROM Producto p
JOIN Composicion c ON p.prod_codigo = c.comp_producto
JOIN STOCK S on s.stoc_producto = p.prod_codigo
GROUP BY p.prod_codigo,p.prod_detalle
HAVING(AVG(s.stoc_cantidad)>100)

SELECT *
FROM Producto p WHERE p.prod_codigo =   '00001104'
SELECT *
FROM Producto p WHERE p.prod_codigo =   '00001109'
SELECT *
FROM Producto p WHERE p.prod_codigo =   '00001123'

SELECT *
FROM Composicion c WHERE c.comp_producto = '00001104'