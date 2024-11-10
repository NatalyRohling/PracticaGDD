---------------------------------------Ejercicio 13---------------------------------------------
/*Realizar una consulta que retorne para cada producto que posea composición  nombre del producto, precio del producto, 
precio de la sumatoria de los precios por la cantidad de los productos que lo componen. 
Solo se deberán mostrar los productos que estén compuestos por más de 2 productos 
y deben ser ordenados de mayor a menor por cantidad de productos que lo componen. */
SELECT  p_compuesto.prod_codigo, p_compuesto.prod_precio,
SUM(prod_componente.prod_precio *c.comp_cantidad)-- los precios de los productos componentes por la cantidad
FROM Producto p_compuesto
INNER JOIN Composicion c ON c.comp_producto = p_compuesto.prod_codigo
INNER JOIN Producto prod_componente ON  c.comp_componente = prod_componente.prod_codigo
GROUP BY  p_compuesto.prod_codigo, p_compuesto.prod_precio
HAVING COUNT( DISTINCT c.comp_componente)> 2
ORDER BY COUNT( DISTINCT c.comp_componente)

select p_compuesto.prod_detalle,
	p_compuesto.prod_precio,
	sum(p_componente.prod_precio * comp_cantidad) 'Sumatoria de precios por la cantidad de los productos que lo componen'
from producto p_compuesto
	join composicion on comp_producto = prod_codigo
	join producto p_componente on p_componente.prod_codigo = comp_componente
group by p_compuesto.prod_detalle, p_compuesto.prod_precio
having count(*) > 2
order by count(*) desc
-- Puede ser count(*), pues el segundo join no aumenta la atomicidad, ya que es de muchos a uno.