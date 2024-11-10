 /*Desarrolle el/los elementos de base de datos necesarios para que se cumpla
automaticamente la regla de que en una factura no puede contener productos de 
diferentes familias. En caso de que esto ocurra no debe grabarse esa factura y 
debe emitirse un error en pantall*/

CREATE TRIGGER dbo.ejercicio19 ON Factura  FOR INSERT
AS
BEGIN
	DECLARE @numeroFactura numeric (6,0)
	DECLARE @cod_sucursal numeric(6,0),
	DECLARE @tipo numeric(6,0)

	DECLARE cursor_inserted CURSOR FOR 
	SELECT fact_numero, fact_sucursal, fact_tipo
										FROM inserted
	OPEN cursor_inserted
	FETCH NEXT FROM cursor_inserted
	INTO @numeroFactura,@cod_sucursal,@tipo
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF dbo.tieneProductosDiferentesFamiliar(@tipo,@cod_sucursal,@numeroFactura) =1
		BEGIN
			RAISEERROR ('Error, la factura contiene productos de diferentes familias ', 16, 1)
			ROLLBACK TRANSACTION
		END
		FETCH NEXT FROM cursor_inserted INTO @numeroFactura,@cod_sucursal,@tipo
		END
	
	CLOSE cursor_inserted
	DEALLOCATE cursor_inserted
END
CREATE FUNCTION dbo.tieneProductosDiferentesFamilias 
(@tipo numeric(6,0),
@cod_sucursal numeric(6,0),
@numeroFactura numeric(6,0))
RETURNS bit
AS
BEGIN
	DECLARE @booleano BIT
	if (SELECT COUNT(DISTINCT fa.fami_id) as cant_familias
FROM Factura f
INNER JOIN Item_Factura it on f.fact_tipo  = it.item_tipo and f.fact_sucursal= it.item_sucursal and f.fact_numero = it.item_numero 
INNER JOIN Producto p on it.item_producto = p.prod_codigo
INNER JOIN Familia fa on p.prod_familia = fa.fami_id
WHERE f.fact_sucursal =@cod_sucursal and  f.fact_numero=@numeroFactura and f.fact_tipo  = @tipo
GROUP BY p.prod_codigo)>1 
BEGIN 
SET @booleano = 1
END 
ELSE 
BEGIN 
SET @booleano = 0
END
RETURN @booleano
END GO

	RETURN @booleano
END
GO
SELECT COUNT(DISTINCT fa.fami_id) as cant_familias
FROM Factura f
INNER JOIN Item_Factura it on f.fact_tipo  = it.item_tipo and f.fact_sucursal= it.item_sucursal and f.fact_numero = it.item_numero 
INNER JOIN Producto p on it.item_producto = p.prod_codigo
INNER JOIN Familia fa on p.prod_familia = fa.fami_id
GROUP BY p.prod_codigo



