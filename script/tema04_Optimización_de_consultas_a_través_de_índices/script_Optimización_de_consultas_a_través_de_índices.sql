use ProyectoBD
go

--Se realizar� la carga masiva de datos sobre la tabla vendedor

DECLARE @contador INT = 1;
WHILE @contador <= 1000000
BEGIN
    INSERT INTO vendedor (cuit_vendedor, nombre_apellido, fecha_nacimiento, email)
    VALUES (
        1000000000 + @contador, -- cuit_vendedor, un valor �nico para cada registro
        'Vendedor ' + CAST(@contador AS VARCHAR(10)), -- nombre_apellido
        DATEADD(YEAR, -20 - (RAND() * 50), GETDATE()), -- fecha_nacimiento, fecha aleatoria entre 20 y 70 a�os atr�s
        CONCAT('vendedor', @contador, '@ejemplo.com') -- email, correo �nico para cada registro
    );

    SET @contador = @contador + 1;
END;
go

select * from vendedor

--Se realiza la busqueda por periodo sin indice;
-- Consulta sin �ndice
SET STATISTICS TIME ON;
SELECT * FROM vendedor WHERE fecha_nacimiento BETWEEN '1980-01-01' AND '1990-12-31';
SET STATISTICS TIME OFF;


-- Plan de ejecuci�n
SET SHOWPLAN_TEXT ON;
GO
SELECT * FROM vendedor WHERE fecha_nacimiento BETWEEN '1990-01-01' AND '1990-12-31';
GO
SET SHOWPLAN_TEXT OFF;

--se consultan los indices de la tabla vendedor.
execute sp_helpindex 'vendedor'

--Se crea el indice agrupado sobre la columna fecha_nacimiento y se ejecuta la misma consulta.
CREATE CLUSTERED INDEX idx_fecha_nacimiento ON vendedor(fecha_nacimiento);

-- Consulta con �ndice agrupado
SET STATISTICS TIME ON;
SELECT * FROM vendedor WHERE fecha_nacimiento BETWEEN '1990-01-01' AND '1990-12-31';
SET STATISTICS TIME OFF;


-- Plan de ejecuci�n con �ndice agrupado
SET SHOWPLAN_TEXT ON;
GO
SELECT * FROM vendedor WHERE fecha_nacimiento BETWEEN '1990-01-01' AND '1990-12-31';
GO
SET SHOWPLAN_TEXT OFF;

--Se borra el indice creado
DROP INDEX idx_fecha_nacimiento ON vendedor;

--Se crea el indice agrupado compuesto en la tabla vendedor con todas sus columnas incluidas
CREATE CLUSTERED INDEX idx_fecha_nacimiento_comp ON vendedor (fecha_nacimiento, cuit_vendedor, nombre_apellido, email);

-- Consulta con �ndice agrupado compuesto
SET STATISTICS TIME ON;
SELECT * FROM vendedor WHERE fecha_nacimiento BETWEEN '1990-01-01' AND '1990-12-31';
SET STATISTICS TIME OFF;


-- Plan de ejecuci�n con �ndice agrupado compuesto
SET SHOWPLAN_TEXT ON;
GO
SELECT * FROM vendedor WHERE fecha_nacimiento BETWEEN '1990-01-01' AND '1990-12-31';
GO
SET SHOWPLAN_TEXT OFF;

--Se elimina el indice agrupado compuesto
DROP INDEX idx_fecha_nacimiento_comp ON vendedor;

--Se crea un indice no agrupado sobre la columna fecha_nacimiento que incluye a las demas columnas de la tabla vendedor
CREATE NONCLUSTERED INDEX idx_fecha_nacimiento_incl ON vendedor (fecha_nacimiento)
INCLUDE (cuit_vendedor, nombre_apellido, email);

-- Consulta con �ndice no agrupado que incluye a las dem�s columnas
SET STATISTICS TIME ON;
SELECT * FROM vendedor WHERE fecha_nacimiento BETWEEN '1990-01-01' AND '1990-12-31';
SET STATISTICS TIME OFF;


-- Plan de ejecuci�n con �ndice no agrupado que incluye a las dem�s columnas
SET SHOWPLAN_TEXT ON;
GO
SELECT * FROM vendedor WHERE fecha_nacimiento BETWEEN '1990-01-01' AND '1990-12-31';
GO
SET SHOWPLAN_TEXT OFF;

--Se elimina el indice no agrupado
DROP INDEX idx_fecha_nacimiento_incl ON vendedor;



