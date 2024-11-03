----------------------------------------------Ejercicio 12 ------------------------------------------
/* Mostrar nombre de producto, cantidad de clientes distintos que lo compraron importe promedio pagado por el producto, 
cantidad de depósitos en los cuales hay stock del producto y stock actual del producto en todos los depósitos. 
Se deberán mostrar aquellos productos que hayan tenido operaciones en el año 2012 y los datos deberán ordenarse de mayor a menor por monto vendido del producto*/
SELECT p.prod_detalle,COUNT(DISTINCT fac.fact_cliente) as can_clientes, AVG(i.item_cantidad*i.item_precio) as importe_promedio,
COUNT( DISTINCT s.stoc_deposito) as depositos_con_stock,
	(select sum(stoc_cantidad) from stock
	where stoc_producto = prod_codigo) 'Stock actual en todos los depósitos'

FROM Producto p
INNER JOIN Item_Factura i on p.prod_codigo = i.item_producto
INNER JOIN  Factura fac ON i.item_numero = fac.fact_numero AND i.item_sucursal = fac.fact_sucursal AND i.item_tipo = fac.fact_tipo
LEFT JOIN STOCK s on s.stoc_producto = p.prod_codigo
WHERE p.prod_codigo IN (select item_producto from item_factura
		join factura on fact_tipo + fact_sucursal + fact_numero = item_tipo + item_sucursal + item_numero
		where year(fact_fecha) = 2012 )-- el codigo de este producto debe estar dentro de los item factura que hubo en 2012
GROUP BY p.prod_detalle,p.prod_codigo
ORDER BY 2
--Tener operaciones es que pertenezca a la lista de facturaa de 2012
select item_producto from item_factura
		join factura on fact_tipo + fact_sucursal + fact_numero = item_tipo + item_sucursal + item_numero
		where year(fact_fecha) = 2012


SELECT COUNT(DISTINCT s.stoc_deposito)
FROM Producto p
INNER JOIN  STOCK s on s.stoc_producto = p.prod_codigo
WHERE s.stoc_cantidad>0

select prod_detalle,
	count(distinct fact_cliente) 'Clientes que lo compraron',
	avg(item_precio) 'Importe promedio pagado por el producto',
	count(distinct stoc_deposito) 'Depósitos con stock',
	(select sum(stoc_cantidad) from stock
	where stoc_producto = prod_codigo) 'Stock actual en todos los depósitos'
from producto
	join item_factura on item_producto = prod_codigo
	join factura on fact_tipo + fact_sucursal + fact_numero = item_tipo + item_sucursal + item_numero
	join stock on stoc_producto = prod_codigo
where stoc_cantidad > 0 and --stoc_cantidad > 0 porque tengo que traer los que tenga stock
	prod_codigo in (
		select item_producto from item_factura
		join factura on fact_tipo + fact_sucursal + fact_numero = item_tipo + item_sucursal + item_numero
		where year(fact_fecha) = 2012
	)
group by prod_detalle, prod_codigo --Tiene que ir prod_codigo para vincular a la subconsulta
order by sum(item_precio * item_cantidad) desc
