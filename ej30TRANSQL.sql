--Ej 30-TRANS
--TRIGGERS
--EVENTO

--Tabla ->Item factura ->
-- Evento -> INSERT
-- MOMENTO ->AFTER->Te pide un mensaje de error 
-- Ante un error el instaed of, puede dar por valido 
-- Como te pide un mensaje especifico -♠2After 
--RAISE ERROR CON ROLLBAKC 
-- 
IF EXITS (SELECT 1)
BEGIN 
ROLLBACK
RAISEEEROR
END
-- Fecha actual
--MONTH(GETDATE) Y YEAR(GETDATE())-Fecha de factura del item
--Armar un dato de prueba para el 2024
--uno para que de okey yy otro para quede eror

INSERT INTO Item_Factura --sobre una factura que existe que purbea esto

insert into factura values ('A','0006','00000001',getdate(),null,3,0,'01648')insert into Item_Factura values ('A','0006','00000001','00000172',50,7.53)insert into Item_Factura values ('A','0006','00000001','00000173',200,6.50)--La tabla inserted o deleted o se hace un cursor-- Si no se hace con el cursor --Tener pre armado la sintaxis de cursores