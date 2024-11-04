--USE ProyectoBD;
GO

-- Procedimiento para insertar un registro en una tabla de ejemplo `Clientes`
CREATE PROCEDURE InsertCliente
    @dni INT,
    @nombre_apellido VARCHAR(200),
    @domicilio VARCHAR(200),
	@email VARCHAR(100),
	@telefono BIGINT,
	@id_ciudad INT
AS
BEGIN
    INSERT INTO Cliente(dni, nombre_apellido, domicilio, email, telefono, id_ciudad)
    VALUES (@dni, @nombre_apellido, @domicilio, @email, @telefono, @id_ciudad);
END;
GO

-- Procedimiento para actualizar
CREATE PROCEDURE UpdateCliente
    @dni INT,
    @nombre_apellido VARCHAR(200),
    @domicilio VARCHAR(200),
	@email VARCHAR(100),
	@telefono BIGINT,
	@id_ciudad INT
AS
BEGIN
    UPDATE Cliente
    SET nombre_apellido = @nombre_apellido, domicilio = @domicilio, email = @email, telefono = @telefono, id_ciudad = @id_ciudad
    WHERE dni = @dni;
END;
GO

-- Procedimiento para borrar
CREATE PROCEDURE DeleteCliente
    @dni INT
AS
BEGIN
    DELETE FROM Cliente
    WHERE dni = @dni;
END;
GO

--Ejecuciones
SELECT * FROM cliente;
Go

--Insertar cliente
EXEC InsertCliente 
    @dni = 20202020, 
    @nombre_apellido = 'Jorge Rivera', 
    @domicilio = 'Mburucuya 202013',
	@email = 'jorge.rivera@email.com',
	@telefono = 3794848484,
	@id_ciudad = 1;
GO

--Actualizar cliente
EXEC UpdateCliente
	@dni = 20202020, 
    @nombre_apellido = 'Jorge Riveras', 
    @domicilio = 'Mburucuya 202013',
	@email = 'jorge.rivera30@email.com',
	@telefono = 3794848484,
	@id_ciudad = 1;
GO

--Eliminar cliente
EXEC DeleteCliente
	@dni = 20202020
GO


--Funciones almacenadas
--Calcular edad de un vendedor
CREATE FUNCTION CalcularEdad (@FechaNacimiento DATE)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(YEAR, @FechaNacimiento, GETDATE()) -
           CASE WHEN MONTH(@FechaNacimiento) > MONTH(GETDATE()) OR
                     (MONTH(@FechaNacimiento) = MONTH(GETDATE()) AND DAY(@FechaNacimiento) > DAY(GETDATE()))
                THEN 1 ELSE 0 END;
END;
GO

--Ejecucion
SELECT nombre_apellido, fecha_nacimiento, dbo.CalcularEdad(fecha_nacimiento) AS Edad
FROM vendedor;
GO

SELECT * FROM vendedor;
Go

--Funcion almacenada encargada de verificar la disponibilidad de un proveedor
CREATE FUNCTION VerificarEmailVendedor (@email VARCHAR(100))
RETURNS BIT
AS
BEGIN
    DECLARE @existe BIT;
    SET @existe = (SELECT CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END
                   FROM vendedor
                   WHERE email = @email);
    
    RETURN @existe;
END;
GO

--Ejecucion
--Verificar si el email de un vendedor existe
--Si existe retorna 1 sino retorna 0
SELECT dbo.VerificarEmailVendedor('juan.perez@example.com') AS EmailExiste;
GO

--Funcion encargada de contar la cantidad de productos que posee un proveedor
CREATE FUNCTION ContarProductosPorVendedor (@cuit_vendedor BIGINT)
RETURNS INT
AS
BEGIN
    DECLARE @totalProductos INT;

    SELECT @totalProductos = COUNT(*)
    FROM producto
    WHERE cuit_vendedor = @cuit_vendedor;

    RETURN @totalProductos;
END;
GO

--Ejecucion
SELECT dbo.ContarProductosPorVendedor(30506070809) AS TotalProductos;
GO


--Comparacion de tiempo de ejecucion
--Funcion almacenada

-- Habilitar estadísticas de tiempo
SET STATISTICS TIME ON;

-- Ejecutar la función o el procedimiento almacenado
SELECT dbo.ContarProductosPorVendedor(30506070809);   -- para funciones

-- Deshabilitar estadísticas de tiempo
SET STATISTICS TIME OFF;

--Procedimiento Almacenado
-- Habilitar estadísticas de tiempo
SET STATISTICS TIME ON;

-- Ejecutar la función o el procedimiento almacenado
EXEC UpdateCliente
    @dni = 20202020, 
    @nombre_apellido = 'Jorge Riveras', 
    @domicilio = 'Mburucuya 202013',
	@email = 'jorge.rivera3030@email.com',
	@telefono = 3794848874,
	@id_ciudad = 1;    -- para procedimientos

-- Deshabilitar estadísticas de tiempo
SET STATISTICS TIME OFF;