-----------------------------------Ejercicio 9----------------------------------
/*Mostrar el código del jefe, código del empleado que lo tiene c
omo jefe, nombre del mismo y la cantidad de depósitos que ambos tienen asignados*/
SELECT e.empl_codigo as empleado,e.empl_apellido as apellido_empleado, jefe.empl_codigo as codigo_jefe, jefe.empl_apellido as apellido_jefe, COUNT(d.depo_encargado) as cantidad_depositos_ecargadora
FROM Empleado e
LEFT JOIN Empleado jefe on e.empl_jefe = jefe.empl_codigo -- Si pongo el left me muestra Perez que no tiene jefes
LEFT  JOIN DEPOSITO d ON d.depo_encargado = e.empl_codigo-- SI PONGO EL EFT ESdepoitos me muestra los empleados que no tienen depositos
GROUP BY e.empl_codigo,e.empl_apellido, jefe.empl_codigo, jefe.empl_apellido
SELECT* FROM Empleado
SELECT * FROM DEPOSITO
--me muestra los empleados que no tiene depositos
--Tengo que poner los dos lefts o va a haber menos informacio