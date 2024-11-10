--Ejercicio 4
/*4. Cree el/los objetos de base de datos necesarios para actualizar la columna de
empleado empl_comision con la sumatoria del total de lo vendido por ese
empleado a lo largo del último año. Se deberá retornar el código del vendedor 
que más vendió (en monto) a lo largo del último año.*/

CREATE PROCEDURE actualizar_columna_empl_comision
AS 
BEGIN
  DECLARE @codigo_vendedor_mas_vendio numeric(6);

 UPDATE Empleado
 --Creo que deberia poner el cursor e ir iterando y actualizanod este porcentae
 set empl_comision = (SELECT  ISNULL(SUM(f.fact_total),0)
 FROM Factura f
 --INNER JOIN Factura f ON f.fact_vendedor = Empleado.empl_codigo
 WHERE f.fact_vendedor = Empleado.empl_codigo and YEAR(f.fact_fecha) = 2012
 GROUP BY f.fact_vendedor)


 -- Lo que no me cierra es que debe saber el 

 SELECT TOP 1  @codigo_vendedor_mas_vendio = e.empl_codigo
 FROM Empleado e
 INNER JOIN Factura f ON f.fact_vendedor = e.empl_codigo
 WHERE YEAR(f.fact_fecha) = 2024 
 GROUP BY e.empl_codigo
 ORDER BY SUM(f.fact_total)DESC --orderno por el que mas tiene en total
 PRINT @codigo_vendedor_mas_vendio;

 end
 go
 BEGIN TRANSACTION
 EXEC actualizar_columna_empl_comision
 COMMIT TRANSACTION
 GO
 DROP PROCEDURE  actualizar_columna_empl_comision
 GO

 --Notita no hace falta usar un cursor, proque en este caso se esta actualizando todo del misma forma 

 DROP PROCEDURE actualizar_columna_empl_comision
 GO
