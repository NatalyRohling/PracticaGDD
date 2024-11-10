-----Ejercicio 5
/*
/*EJERCICO 5*/
/*5. 
Realizar un procedimiento que complete con los datos existentes en el modelo provisto la tabla de hechos denominada 
Fact_table tiene las siguiente definición: 
Create table Fact_table ( anio char(4), mes char(2), familia char(3), rubro char(4), zona char(3), cliente char(6), producto char(8), 
cantidad decimal(12,2), monto decimal(12,2) ) 
Alter table Fact_table Add constraint primary key(anio,mes,familia,rubro,zona,cliente,producto) */
*/
CREATE TABLE Fact_table 
(
    anio CHAR(4) NOT NULL,
    mes CHAR(2) NOT NULL, 
    familia CHAR(3) NOT NULL,
    rubro CHAR(4) NOT NULL,
    zona CHAR(3) NOT NULL,
    cliente CHAR(6) NOT NULL,
    producto CHAR(8) NOT NULL, 
    cantidad DECIMAL(12,2),
    monto DECIMAL(12,2)
);

DROP TABLE Fact_table
GO

ALTER TABLE Fact_table 
ADD CONSTRAINT pk_fact_table 
PRIMARY KEY (anio, mes, familia, rubro, zona, cliente, producto);

CREATE PROCEDURE migrar_fact_table 
AS
BEGIN 
INSERT INTO Fact_table(anio,mes,familia,rubro,zona,cliente,producto,cantidad,monto)
SELECT YEAR(f.fact_fecha),MONTH(f.fact_fecha),p.prod_familia,p.prod_rubro,d.depa_zona,f.fact_cliente, p.prod_codigo,sum(item_cantidad), sum(i.item_cantidad * i.item_precio)
FROM Factura f
INNER JOIN Item_Factura i on f.fact_numero = i.item_numero and f.fact_sucursal=i.item_sucursal  and f.fact_tipo = i.item_tipo
INNER JOIN Producto p on p.prod_codigo = i.item_producto
INNER JOIN Empleado e on f.fact_vendedor = e.empl_codigo		
INNER JOIN Departamento d on d.depa_codigo = e.empl_departamento	
GROUP BY YEAR(f.fact_fecha),MONTH(f.fact_fecha),p.prod_familia,p.prod_rubro,d.depa_zona,f.fact_cliente, p.prod_codigo
END
GO
EXEC migrar_fact_table 

