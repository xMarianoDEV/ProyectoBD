-- INSERCIÓN DEL LOTE DE DATOS

-- Lote de datos representativo

-- tabla vendedor
INSERT INTO vendedor (cuit_vendedor, nombre_apellido, fecha_nacimiento, email) 
VALUES 
(30714091059, 'Juan Perez', '1980-05-20', 'juan.perez@example.com'),
(30714064319, 'Ana Lopez', '1995-03-15', 'ana.lopez@example.com'),
(30714052752, 'Martin Gomez', '2000-04-25', 'martin.gomez@example.com');

-- tabla categoria
INSERT INTO categoria (nombre) 
VALUES 
('Construcción'),
('Decoración');


-- tabla material
INSERT INTO material (nombre) 
VALUES 
('Cemento'),
('Piedra'),
('Vidrio');

-- tabla metodo_pago
INSERT INTO metodo_pago (nombre) 
VALUES 
('Tarjeta de Crédito'),
('Tarjeta de Débito'),
('Efectivo');


-- tabla ciudad
INSERT INTO ciudad (nombre) 
VALUES 
('Corrientes Capital'),
('Buenos Aires'),
('Rosario');

-- tabla producto
INSERT INTO producto (nombre, descripcion, precio, status_publicacion, id_categoria, cuit_vendedor) 
VALUES 
('Ladrillo', 'Ladrillo rojo de alta calidad', 10.50, 'activa', 1, 30714091059),
('Pintura', 'Pintura blanca para interiores', 25.00, 'pausada', 2, 30714052752),
('Vaso', null, 35.00, 'activa', 2, 30714064319);

-- tabla cliente
INSERT INTO cliente (dni, nombre_apellido, domicilio, email, telefono, id_ciudad) 
VALUES 
(41583200, 'Maria Garcia', 'Calle Falsa 123', 'maria.garcia@example.com', 3794620313, 1),
(43754259, 'Juan Lopez', 'Av. Independencia 1900', 'juanlopez@example.com', 3795624850, 1),
(31689576, 'Carlos Gutierrez', 'Av. Siempre Viva 742', 'carlos.gutierrez@example.com', NULL, 2);

-- tabla venta
INSERT INTO venta (nro_venta, nro_factura, fecha_venta, dni) 
VALUES 
(1, 1001, '2024-09-10', 41583200),
(2, 1002, '2024-09-11', 31689576);


-- tabla venta_detalle
INSERT INTO venta_detalle (cantidad, precio_venta, nro_venta, id_producto) 
VALUES 
(3, 10.50, 1, 1),
(5, 35.00, 2, 3);


-- tabla resena
INSERT INTO resena (calificacion, comentario, nro_venta, id_producto) 
VALUES 
(8, 'Buen producto, recomendado', 1, 1),
(7, 'Cumple su función', 2, 3);

-- tabla producto_material
INSERT INTO producto_material (porcentaje, id_producto, id_material) 
VALUES 
(60, 1, 1),  -- Ladrillo con Cemento
(40, 1, 2);  -- Ladrillo con Piedra

-- tabla pago
INSERT INTO pago (importe, nro_venta, id_pago) 
VALUES 
(105.00, 1, 1),  -- Pago con Tarjeta de Crédito
(125.00, 2, 3);  -- Pago en Efectivo


