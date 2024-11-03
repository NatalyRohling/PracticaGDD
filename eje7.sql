---------------------------------Ejercicoo 7-------------------------------------
/*Generar una consulta que muestre para cada artículo código, detalle, mayor precio menor precio y % de la diferencia de precios 
(respecto del menor Ej.: menor precio = 10, mayor precio =12 => mostrar 20 %). Mostrar solo aquellos artículos que posean stock. */


SELECT  p.prod_codigo,p.prod_detalle, MIN(i.item_precio) as menor_precio,MAX(i.item_precio) as mayor_precio,
 MAX(i.item_precio)- MIN(i.item_precio)  as diferencia_precio
FROM Producto p
INNER JOIN Item_Factura i on p.prod_codigo = i.item_producto
GROUP BY p.prod_codigo,p.prod_detalle