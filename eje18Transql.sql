/*Ejercicio 18
Sabiendo que el limite de credito de un cliente es el monto maximo que se le 
puede facturar mensualmente, cree el/los objetos de base de datos necesarios 
para que dicha regla de negocio se cumpla automaticamente. No se conoce la 
forma de acceso a los datos ni el procedimiento por el cual se emiten las facturas*/


CREATE TRIGGER dbo.ejercicio19 ON Factura  FOR INSERT
AS
BEGIN
	DECLARE @clie_codigo numeric (6,0)
	DECLARE @cod_sucursal numeric(6,0),
	DECLARE @tipo numeric(6,0),
	DECLARE  @numeroFactura numeric(6,0),
	DECLARE @total  numeric(6,0)

	DECLARE cursor_inserted CURSOR FOR 
	SELECT fact_numero, fact_sucursal, fact_tipo,fact_cliente, fact_total
										FROM inserted
	OPEN cursor_inserted
	FETCH NEXT FROM cursor_inserted
	INTO @numeroFactura,@cod_sucursal,@tipo,@numeroFactura, @total
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @total <(SELECT clie_limite_credito From Cliente WHERE clie_codigo = @clie_codigo)
		BEGIN
			RAISEERROR ('Error, el limite credito supera el total', 16, 1)
			ROLLBACK TRANSACTION
		END
		ELSE @total >(SELECT clie_limite_credito From Cliente WHERE clie_codigo = @clie_codigo)
		BEGIN
		SET UPDATE Cliente SET clie_limite_credito -= @total
			 WHERE clie_codigo = @clie_codigo

			
		END

		FETCH NEXT FROM cursor_inserted INTO @numeroFactura,@cod_sucursal,@tipo,@numeroFactura, @total
		END
	
	CLOSE cursor_inserted
	DEALLOCATE cursor_inserted
END
		
	