/*Escriba una consulta sql que retorne un ranking de los mejores 3 empleados del 2012 
Se debera retornar legajo, nombre y apellido, anio de ingreso, puntaje 2011, puntaje 2012. 
El puntaje de cada empleado se calculara de la siguiente manera:
para los que hayan vendido al menos 50 facturas el puntaje se calculara como la cantidad de facturas que superen los 100 pesos que haya vendido en el año,
para los que tengan me
nos de 50 facturas en el año el calculo del puntaje sera el 50% de cantidad de facturas realizadas por sus subordinados directos en dicho año. */
select 
rtrim(empl_nombre)+' '+	rtrim(empl_apellido) 'Nombre y apellido',
	empl_ingreso,
    case
		when (select count(*) from factura where fact_vendedor = empl_codigo) >= 50
			then (select count(*) from factura where fact_vendedor = empl_codigo and fact_total > 100 
                    and year(fact_fecha) = 2011)
	    else
		    (select count(*) from factura join empleado e2 on e2.empl_codigo = fact_vendedor
						where year(fact_fecha) = 2011 and e2.empl_jefe = e1.empl_codigo)/2
    end 'puntaje 2011',
    case 
		when (select count(*) from factura where fact_vendedor = empl_codigo) >= 50
			then (select count(*) from factura where fact_vendedor = empl_codigo and fact_total > 100 
                    and year(fact_fecha) = 2012)
	    else
			(select count(*) from factura join empleado e2 on e2.empl_codigo = fact_vendedor
						where year(fact_fecha) = 2012 and e2.empl_jefe = e1.empl_codigo)/2
    end 'puntaje 2012'
from empleado e1
order by 5 desc

