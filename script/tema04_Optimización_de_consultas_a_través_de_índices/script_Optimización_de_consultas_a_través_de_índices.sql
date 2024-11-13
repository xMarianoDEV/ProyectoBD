USE ProyectoBD;
GO

-- 1 Se realizará la carga masiva de datos sobre la tabla producto

DECLARE @contador INT = 1;
WHILE @contador <= 1000000
BEGIN
    INSERT INTO producto (nombre, descripcion, precio, status_publicacion, id_categoria, cuit_vendedor)
    VALUES (
        'Producto ' + CAST(@contador AS VARCHAR(10)),  -- nombre
        'Descripción del Producto ' + CAST(@contador AS VARCHAR(10)), -- descripción
        ROUND(RAND() * 1000, 2), -- precio aleatorio entre 0 y 1000
        CASE WHEN @contador % 2 = 0 THEN 'activa' ELSE 'pausada' END, -- status_publicacion alternando entre 'activa' y 'pausada'
        @contador % 10 + 1, -- id_categoria (tomando valores entre 1 y 10)
        1000000000 + @contador -- cuit_vendedor (valor único)
    );

    SET @contador = @contador + 1;
END;
GO

-- Verificación de los datos cargados
SELECT * FROM producto;
GO

    -- 2 Consulta sin índice
SET STATISTICS TIME ON;
SELECT * FROM producto WHERE precio BETWEEN 100 AND 500;
SET STATISTICS TIME OFF;
GO


-- Crear un índice agrupado sobre la columna 'precio'
CREATE CLUSTERED INDEX idx_precio ON producto(precio);
GO

-- Consulta con índice agrupado
SET STATISTICS TIME ON;
SELECT * FROM producto WHERE precio BETWEEN 100 AND 500;
SET STATISTICS TIME OFF;
GO

-- Plan de ejecución con índice agrupado
SET SHOWPLAN_TEXT ON;
GO
SELECT * FROM producto WHERE precio BETWEEN 100 AND 500;
GO
SET SHOWPLAN_TEXT OFF;
GO

-- Eliminar el índice agrupado
DROP INDEX idx_precio ON producto;
GO

--3 Creación de índices no agrupados
    
-- Crear un índice no agrupado sobre la columna 'status_publicacion'
CREATE NONCLUSTERED INDEX idx_status_publicacion ON producto(status_publicacion)
INCLUDE (nombre, descripcion);
GO

-- Consulta con índice no agrupado
SET STATISTICS TIME ON;
SELECT * FROM producto WHERE status_publicacion = 'activa';
SET STATISTICS TIME OFF;
GO

-- Plan de ejecución con índice no agrupado
SET SHOWPLAN_TEXT ON;
GO
SELECT * FROM producto WHERE status_publicacion = 'activa';
GO
SET SHOWPLAN_TEXT OFF;
GO


-- Eliminar el índice no agrupado
DROP INDEX idx_status_publicacion ON producto;
GO


--4: Consultas con múltiples restricciones y claves foráneas
-- Insertar datos en la tabla 'venta'
INSERT INTO venta (nro_venta, nro_factura, fecha_venta, dni)
VALUES (1001, 5001, '2024-11-01', 12345678);
GO

-- Consultar los datos insertados
SELECT * FROM venta WHERE nro_venta = 1001;
GO

-- Insertar datos en la tabla 'venta_detalle'
INSERT INTO venta_detalle (cantidad, precio_venta, nro_venta, id_producto)
VALUES (2, 150.00, 1001, 1);
GO

-- Consultar los datos insertados en 'venta_detalle'
SELECT * FROM venta_detalle WHERE nro_venta = 1001;
GO

--5: Restricciones en las tablas
-- Intentar insertar un producto con un precio negativo
INSERT INTO producto (nombre, descripcion, precio, status_publicacion, id_categoria, cuit_vendedor)
VALUES ('Producto Test', 'Producto con precio negativo', -10, 'activa', 1, 1000000001);
GO


--6: Validación de restricciones con expresiones regulares

-- Intentar insertar un cliente con un correo electrónico inválido
INSERT INTO cliente (dni, nombre_apellido, domicilio, email, telefono, id_ciudad)
VALUES (98765432, 'Juan Perez', 'Calle Ficticia 123', 'juanperez@', 123456789, 1);
GO

