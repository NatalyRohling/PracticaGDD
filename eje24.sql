USE GD2015C1
GO
--- Ejercicio 24
/*. Escriba una consulta que considerando solamente las facturas correspondientes a los 
dos vendedores con mayores comisiones, retorne los productos con composición 
facturados al menos en cinco facturas,
La consulta debe retornar las siguientes columnas:
 Código de Producto
 Nombre del Producto
 Unidades facturadas
El resultado deberá ser ordenado por las unidades facturadas descendente*/


use GD2015C1
go



-------------Version de joaco
select prod_codigo,
	prod_detalle,
	sum(item_cantidad)
from producto
	join item_factura on item_producto = prod_codigo
	join factura on fact_sucursal+fact_tipo+fact_numero = item_sucursal+item_tipo+item_numero
where prod_codigo in (select comp_producto from composicion) and
	 fact_vendedor in (select top 2 empl_codigo from empleado order by empl_comision desc)
group by prod_codigo, prod_detalle
having count(distinct item_sucursal+item_tipo+item_numero) >= 5
order by sum(item_cantidad) desc

---Esta parte esta perfecta porque sino sin la subquery no lo podrias hacer 
fact_vendedor in (select top 2 empl_codigo from empleado order by empl_comision desc)
group by prod_codigo, prod_detalle



SELECT  TOP 2 
p.prod_codigo, 
p.prod_detalle,
SUM(i.item_cantidad)as unidades_facturadas
FROM Factura f
INNER JOIN Item_factura i on f.fact_tipo = i.item_tipo and f.fact_sucursal = i.item_sucursal and f.fact_numero =i.item_numero
INNER JOIN Empleado e on f.fact_vendedor = e.empl_codigo
INNER JOIN Producto p on i.item_producto = p.prod_codigo
INNER JOIN Composicion c on c.comp_producto = p.prod_codigo
GROUP BY p.prod_codigo, p.prod_detalle
HAVING COUNT(f.fact_numero)>5 and SUM(c.comp_cantidad)>1
ORDER BY (SELECT e.empl_comision
FROM Factura f2
INNER JOIN Empleado e on f.fact_vendedor = e.empl_codigo
WHERE f2.fact_numero= f.fact_tipo and f2.fact_sucursal = f.fact_sucursal and f2.fact_tipo = f.fact_tipo)DESC

-- Me pide una funcion agreadada
--
SELECT e.empl_comision
FROM Factura f
INNER JOIN Empleado e on f.fact_vendedor = e.empl_codigo

