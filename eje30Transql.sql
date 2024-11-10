/* Ejercicio 30
gregar el/los objetos necesarios para crear una regla por la cual un cliente no 
pueda comprar más de 100 unidades en el mes de ningún producto, si esto 
ocurre no se deberá ingresar la operación y se deberá emitir un mensaje “Se ha 
superado el límite máximo de compra de un producto”. Se sabe que esta regla se 
cumple y que las facturas no pueden ser modificadas.
*/

CREATE TRIGGER ejercicio30 ON FACTURA INSTEAD OF INSERT
AS
BEGIN
	DECLARE @tipo char(1)
			,@sucursal char(4)
			,@numero char(8)
			,@fecha SMALLDATETIME
			,@total decimal(12,2)
			,@cliente char(6)
	DECLARE cursor_inserted CURSOR FOR SELECT fact_tipo,fact_sucursal,fact_fecha fact_numero,fact_total,fact_cliente
										FROM inserted
										--tal vez aca meto el join
	OPEN cursor_inserted
	FETCH NEXT FROM cursor_inserted
	INTO @tipo,@sucursal,@numero,@vendedor,@total,@cliente
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF EXISTS  (SELECT 1
						FROM Factura
						INNER JOIN Item_Factura it on  it.item_tipo+it.item_sucursal +it.item_numero= fact_tipo +fact_sucursal+ fact_numero
						WHERE MONTH(fact_fecha )= MONTH(@fecha) AND fact_cliente = @cliene

						GROUP BY it.item_producto,MONTH(fact_fecha)
						HAVING SUM(it.item_cantidad)>100
						

					)
		BEGIN
			RAISEERROR('Se ha 
superado el límite máximo de compra de un producto',16,1);
			ROLLBACK TRANSACTION
		END
		
	FETCH NEXT FROM cursor_inserted
	INTO @tipo,@sucursal,@numero,@fecha,@vendedor,@total,@cliente
	END
	CLOSE cursor_inserted
	DEALLOCATE cursor_inserted
END
CLOSE
		
	