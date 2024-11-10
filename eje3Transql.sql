/*Ejercicio 3
Cree el/los objetos de base de datos necesarios para corregir la tabla empleado 
en caso que sea necesario. Se sabe que deber�a existir un �nico gerente general 
(deber�a ser el �nico empleado sin jefe). Si detecta que hay m�s de un empleado 
sin jefe deber� elegir entre ellos el gerente general, el cual ser� seleccionado por 
mayor salario. Si hay m�s de uno se seleccionara el de mayor antig�edad en la 
empresa. Al finalizar la ejecuci�n del objeto la tabla deber� cumplir con la regla 
de un �nico empleado sin jefe (el gerente general) y deber� retornar la cantidad 
de empleados que hab�a sin jefe antes de la ejecuci�n.

**/


USE GD2015C1
GO

CREATE PROCEDURE corregir_tabla_empleado
AS 
BEGIN
 DECLARE @gerente_general numeric(6)
 SELECT TOP 1  @gerente_general = empl_codigo
 FROM Empleado
 WHERE empl_jefe is null -- o sea que no tiene jefe porque es gerente
 ORDER BY empl_salario DESC

 UPDATE Empleado
 set empl_jefe = @gerente_general
 WHERE empl_jefe is null and empl_codigo !=@gerente_general

 declare @cantidad_sin_jefes int
 select @cantidad_sin_jefes = count(*) from Empleado
 where empl_jefe is null
 print 'La cantidad de empleados sin jefe es '+str(@cantidad_sin_jefes,6)

 end
 go

 EXEC corregir_tabla_empleado
 DROP PROCEDURE corregir_tabla_empleado

 SELECT TOP 1 empl_codigo
 FROM Empleado
 WHERE empl_jefe is null -- o sea que no tiene jefe porque es gerente
 ORDER BY empl_salario DESC