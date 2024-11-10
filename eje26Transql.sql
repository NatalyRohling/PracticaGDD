-- Ejercicio 26
/*Desarrolle el/los elementos de base de datos necesarios para que se cumpla 
automaticamente la regla de que una factura no puede contener productos que 
sean componentes de otros productos. En caso de que esto ocurra no debe 
grabarse esa factura y debe emitirse un error en pantalla.*/------------MI VERSION
CREATE TRIGGER ejercicio26 ON Item_Factura   INSTEAD OF INSERT
AS
BEGIN
	DECLARE @tipo char(1)
			,@sucursal char(4)
			,@numero char(8)
			,@producto char(8)
	DECLARE cursor_inserted CURSOR FOR SELECT item_numero,item_producto,item_sucursal, item_tipo
										FROM inserted
										--tal vez aca meto el join
	OPEN cursor_inserted
	FETCH NEXT FROM cursor_inserted
	INTO   @tipo 
			,@sucursal 
			,@numero 
			,@producto
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF EXISTS  (SELECT 1
						FROM Factura
						INNER JOIN Item_Factura it on  it.item_tipo+it.item_sucursal +it.item_numero= fact_tipo +fact_sucursal+ fact_numero
						INNER JOIN Composicion c on c.comp_componente = it.item_producto -- O sea que este produco es componente 
						INNER Join Producto p2 on c.comp_producto = p2.prod_codigo
						

					)
		BEGIN
			 RAISERROR('No se puede grabar la factura porque contiene productos que son componentes de otros productos.', 16, 1);
			ROLLBACK TRANSACTION
		END
		ELSE 
		BEGIN
			 INSERT INTO Item_Factura (item_tipo, item_sucursal, item_numero, item_producto)
        SELECT item_tipo, item_sucursal, item_numero, item_producto
        FROM inserted;
		END
		
	FETCH NEXT FROM cursor_inserted
	INTO  @tipo 
			,@sucursal 
			,@numero 
			,@producto
	END
	CLOSE cursor_inserted
	DEALLOCATE cursor_inserted
END
GO

		
	
	-----------------------MI VERSION MEJROADA-------------

CREATE TRIGGER ejercicio26 ON Item_Factura
INSTEAD OF INSERT
AS
BEGIN
    -- Verifica si hay algún producto en los datos a insertar que sea un componente
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN Factura f ON i.item_tipo = f.fact_tipo 
                              AND i.item_sucursal = f.fact_sucursal 
                              AND i.item_numero = f.fact_numero
        INNER JOIN Composicion c ON c.comp_componente = i.item_producto
		 INNER JOIN Producto p ON p.prod_codigo = c.comp_producto -- Aquí verificamos que el producto es un componente
    )
    BEGIN
        -- Lanza un error y no permite insertar
        RAISERROR('No se puede grabar la factura porque contiene productos que son componentes de otros productos.', 16, 1);
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        -- Si no hay problemas, realiza la inserción
        INSERT INTO Item_Factura (item_tipo, item_sucursal, item_numero, item_producto)
        SELECT item_tipo, item_sucursal, item_numero, item_producto
        FROM inserted;
    END
END;
GO
