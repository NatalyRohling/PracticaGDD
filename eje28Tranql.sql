---Ejercicio 29
/*Se requiere reasignar los vendedores a los clientes. Para ello se solicita que 
realice el o los objetos de base de datos necesarios para asignar a cada uno de los 
clientes el vendedor que le corresponda, entendiendo que el vendedor que le 
corresponde es aquel que le vendió más facturas a ese cliente, si en particular un 
cliente no tiene facturas compradas se le deberá asignar el vendedor con más 
venta de la empresa, o sea, el que en monto haya vendido más*/
CREATE PROCEDURE reasignar_vendedore_clientes
AS 
BEGIN
 DECLARE @tipo CHAR(1),
            @sucursal CHAR(4),
            @numero CHAR(8),
            @vendedor CHAR(6),
            @cliente CHAR(6),
            @total DECIMAL(12, 2);
 
 DECLARE cursor_factura CURSOR FOR SELECT fact_tipo,fact_sucursal ,fact_numero,fact_vendedor,fact_cliente, fact_total
										FROM Factura
										--tal vez aca meto el join
	OPEN cursor_factura
	FETCH NEXT FROM cursor_factura
	INTO @tipo,@sucursal,@numero,@vendedor ,@cliente,@total
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF EXISTS 
		( SELECT TOP 1 f.fact_vendedor
		 FROM Factura f
		 WHERE f.fact_cliente = @cliente and f.fact_vendedor = @vendedor 
		 GROUP BY fact_cliente,f.fact_vendedor
		 ORDER BY (COUNT(f.fact_numero+f.fact_tipo+f.fact_sucursal))DESC)
					BEGIN
					UPDATE Cliente set clie_vendedor=
					( SELECT TOP 1 f.fact_vendedor 
					FROM Factura f
					WHERE fact_cliente = @cliente
					GROUP BY fact_cliente,f.fact_vendedor
					ORDER BY (COUNT(f.fact_numero+f.fact_tipo+f.fact_sucursal))DESC)

		
		
		END
					
		ELSE 
		BEGIN
		/* si en particular un 
cliente no tiene facturas compradas se le deberá asignar el vendedor con más 
venta de la empresa, o sea, el que en monto haya vendido más.*/
		UPDATE Cliente set clie_vendedor =(SELECT TOP 1 f.fact_vendedor 
 FROM Factura f
 WHERE  f.fact_vendedor = @vendedor
 GROUP BY f.fact_vendedor
 ORDER BY (SUM(f.fact_total))DESC)END
		
	FETCH NEXT FROM cursor_factura
	INTO @tipo,@sucursal,@numero,@vendedor,@total,@cliente
	END
	CLOSE cursor_factura
	DEALLOCATE cursor_factura
END
GO

EXEC reasignar_vendedore_clientes


-- esta es la de chatgpt
CREATE PROCEDURE reasignar_vendedore_clientes
AS
BEGIN
    DECLARE @tipo CHAR(1),
            @sucursal CHAR(4),
            @numero CHAR(8),
            @vendedor CHAR(6),
            @cliente CHAR(6),
            @total DECIMAL(12, 2);

    DECLARE cursor_factura CURSOR FOR
    SELECT fact_tipo, fact_sucursal, fact_numero, fact_vendedor, fact_cliente, fact_total
    FROM Factura;

    OPEN cursor_factura;
    FETCH NEXT FROM cursor_factura
    INTO @tipo, @sucursal, @numero, @vendedor, @cliente, @total;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Verifica si el cliente tiene un vendedor con más facturas
        IF EXISTS (
            SELECT TOP 1 f.fact_vendedor
            FROM Factura f
            WHERE f.fact_cliente = @cliente
            GROUP BY f.fact_vendedor
            ORDER BY COUNT(*) DESC
        )
        BEGIN
            -- Actualiza el vendedor del cliente con el que más facturas tiene
            UPDATE Cliente
            SET clie_vendedor = (
                SELECT TOP 1 f.fact_vendedor
                FROM Factura f
                WHERE f.fact_cliente = @cliente
                GROUP BY f.fact_vendedor
                ORDER BY COUNT(*) DESC
            )
            WHERE clie_codigo = @cliente;
        END
        ELSE
        BEGIN
            -- Si el cliente no tiene facturas, asigna el vendedor con más ventas en monto
            UPDATE Cliente
            SET clie_vendedor = (
                SELECT TOP 1 f.fact_vendedor
                FROM Factura f
                GROUP BY f.fact_vendedor
                ORDER BY SUM(f.fact_total) DESC
            )
            WHERE clie_codigo = @cliente;
        END

        FETCH NEXT FROM cursor_factura
        INTO @tipo, @sucursal, @numero, @vendedor, @total, @cliente;
    END

    CLOSE cursor_factura;
    DEALLOCATE cursor_factura;
END;
GO
