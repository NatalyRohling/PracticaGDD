-------------------------------------------------- Ejercicio 1-----------------------------------------------------------
--Mostrar el c�digo, raz�n social de todos los clientes cuyo l�mite de cr�dito sea mayor o igual
--a $ 1000 ordenado por c�digo de cliente. 
USE GD2015C1
GO
SELECT c.clie_codigo, c.clie_razon_social
FROM Cliente c
WHERE c.clie_limite_credito >1000
ORDER BY 1 ASC