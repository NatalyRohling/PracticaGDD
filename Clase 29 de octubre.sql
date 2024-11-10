CREATE PROCEDURE MueveProductoRubro
    @RubroOrigen INT,
    @RubroDestino INT,
-- aca pongo cuantos faltaron reasignar y se lo devuelvo a la funcion que lo llamo
    @Restantes INT OUTPUT
AS
BEGIN
-- veo cuanto espacio tengo disponible en el rubro destino
    DECLARE @EspacioRubro INT = 20 - (SELECT COUNT(*) FROM Producto WHERE prod_rubro = @RubroDestino);
-- si la cantidad a mover es menor a el espacio uso ese valor en caso contrario muevo solo el espacio disponible
    DECLARE @CantidadMover INT = CASE WHEN @EspacioRubro < @Restantes THEN @EspacioRubro ELSE @Restantes END;

    -- Muevo la cantidad calculada en el paso anterior
    UPDATE TOP (@CantidadMover) Producto
    SET prod_rubro = @RubroDestino
    WHERE prod_rubro = @RubroOrigen;

    -- Actualizo la variable que usare como retorno, con cuantos productos quedaron por mover
    SET @Restantes = @Restantes - @CantidadMover;
END;
GO

CREATE PROCEDURE ReasignarProductos
AS
BEGIN
    DECLARE @IdRubro INT;
DECLARE @NuevoRubro INT;
    DECLARE @Cantidad INT;
DECLARE @Reasignar INT;

    -- Ejecuto el while mientras hayan rubros con mas de 20 productos
    WHILE EXISTS  (
        SELECT 1
        FROM Rubro AS r
        WHERE (SELECT COUNT(*) FROM Producto WHERE prod_rubro = r.rubr_id) > 20
    )
    BEGIN
   SELECT TOP 1
        @IdRubro = r.rubr_id,
        @Cantidad = (SELECT COUNT(*) FROM Producto WHERE prod_rubro = r.rubr_id)
        FROM Rubro AS r
        WHERE (SELECT COUNT(*) FROM Producto WHERE prod_rubro = r.rubr_id) > 20;

-- Aca calculo cuantos productos debo reasignar para dejar solo 20 en este rubro
SET @Reasignar = @Cantidad - 20;

-- Continuo mientras me queden productos a reasignar
        WHILE @Reasignar > 0
        BEGIN
            -- Busco un nuevo rubro con menos de 20 productos
            SET @NuevoRubro = (
                SELECT TOP 1 r.rubr_id
                FROM Rubro AS r
                WHERE r.rubr_id != @IdRubro
                AND (SELECT COUNT(*) FROM Producto WHERE prod_rubro = r.rubr_id) < 20
                ORDER BY NEWID()
            );

-- Si encuentro un rubro con espacio llamo al SP que mueve el producto
IF @NuevoRubro IS NOT NULL
BEGIN
-- llamo al SP que mueve los productos, pasandole rubro origen y destino,
-- y me quedo con la variable de retorno para seguir moviendo si no alcanzo el espacio
EXEC MueveProductoRubro @IdRubro, @NuevoRubro, @Reasignar OUTPUT;
END
            ELSE
BEGIN
-- si no hay espacio creo un nuevo rubro
INSERT INTO Rubro (rubr_id, rubr_detalle)
VALUES ((SELECT ISNULL(MAX(rubr_id), 0) + 1 FROM Rubro), 'RUBRO REASIGNADO');

SET @NuevoRubro = (SELECT MAX(rubr_id) FROM Rubro);

-- Reasignar productos al nuevo rubro creado
EXEC MueveProductoRubro @IdRubro, @NuevoRubro, @Reasignar OUTPUT;
END
END
END
END;
GO

CREATE TRIGGER chequearLimiteRubroON ProductoAFTER INSERT, UPDATEAS    IF EXISTS (        SELECT 1 FROM Producto 		WHERE prod_rubro IN (SELECT DISTINCT prod_rubro FROM INSERTED)        GROUP BY prod_rubro          HAVING COUNT(*) > 20    )        ROLLBACK TRANSACTIONGO