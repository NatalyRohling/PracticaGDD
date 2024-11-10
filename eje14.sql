------------------------------------------------------Ejercicio 14---------------------------------------------------
/*Escriba una consulta que retorne una estadística de ventas por cliente.
Los campos que debe retornar son:  Código del cliente,
Cantidad de veces que compro en el último año,
Promedio por compra en el último año ,
Cantidad de productos diferentes que compro en el último año
Monto de la mayor compra que realizo en el último año*/
/*Se deberán retornar todos los clientes ordenados por la cantidad de veces que compro en el último año.
No se deberán visualizar NULLs en ninguna columna 44*/
USE GD2015C1
GO
SELECT fac.fact_cliente,
COUNT(fac.fact_cliente) as cant_veces_compras,
AVG(fac.fact_total) as promedio_por_comprea,
(select count(distinct item_producto) from factura f2
	join item_factura on item_tipo+item_sucursal+item_numero = f2.fact_tipo+f2.fact_sucursal+f2.fact_numero
	where fac.fact_cliente = f2.fact_cliente) 'Productos diferentes que compró el último año',
MAX(fac.fact_total) as monto_max
FROM Factura fac
INNER JOIN Item_Factura i ON i.item_numero = fac.fact_numero AND i.item_sucursal = fac.fact_sucursal AND i.item_tipo = fac.fact_tipo
WHERE YEAR(fac.fact_fecha) = 2012
GROUP BY fac.fact_cliente

--Dame la cantidad de productos diferenes ->DISTINCT item_producto
--  Son el mismo cliente


/*
select count(distinct item_producto) from factura f2
	join item_factura on item_tipo+item_sucursal+item_numero = f2.fact_tipo+f2.fact_sucursal+f2.fact_numero
	where f1.fact_cliente = f2.fact_cliente) 'Productos diferentes que compró el último año'*/


