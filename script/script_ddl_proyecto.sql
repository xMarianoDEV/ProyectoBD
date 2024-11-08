--DEFINICION DEL MODELO DE DATOS

CREATE DATABASE ProyectoBD

go

USE ProyectoBD

go

-- Tabla vendedor
CREATE TABLE vendedor
(
  cuit_vendedor BIGINT NOT NULL,
  nombre_apellido VARCHAR(100) NOT NULL,
  fecha_nacimiento DATE NOT NULL,
  email VARCHAR(100),
  CONSTRAINT UQ_vendedor_id UNIQUE (cuit_vendedor),
  CONSTRAINT UQ_vendedor_email UNIQUE (email),
  CONSTRAINT CK_vendedor_fecha_nacimiento CHECK ((DATEDIFF(YEAR, fecha_nacimiento, GETDATE()) >= 18) and (DATEDIFF(YEAR, fecha_nacimiento, GETDATE()) <= 100))
);
go

-- Tabla categoria
CREATE TABLE categoria
(
  id_categoria INT IDENTITY NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  CONSTRAINT PK_categoria_id PRIMARY KEY (id_categoria),
  CONSTRAINT UQ_categoria_nombre UNIQUE (nombre)
);
go

-- Tabla material
CREATE TABLE material
(
  id_material INT IDENTITY NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  CONSTRAINT PK_material PRIMARY KEY (id_material),
  CONSTRAINT UQ_material_nombre UNIQUE (nombre)
);
go

-- Tabla metodo_pago
CREATE TABLE metodo_pago
(
  id_pago INT IDENTITY NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  CONSTRAINT PK_metodo_pago_id PRIMARY KEY (id_pago),
  CONSTRAINT UQ_metodo_pago_nombre UNIQUE (nombre)
);
go

-- Tabla ciudad
CREATE TABLE ciudad
(
  id_ciudad INT IDENTITY NOT NULL,
  nombre VARCHAR(200) NOT NULL,
  CONSTRAINT PK_ciudad_id PRIMARY KEY (id_ciudad),
  CONSTRAINT UQ_ciudad_nombre UNIQUE (nombre)
);
go

-- Tabla producto
CREATE TABLE producto
(
  id_producto INT IDENTITY NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  descripcion VARCHAR(200),
  precio FLOAT NOT NULL,  
  status_publicacion VARCHAR(10) NOT NULL,  
  fecha_publicación DATE CONSTRAINT DF_producto_fecha_publicacion DEFAULT getdate() not null, 
  id_categoria INT NOT NULL,
  cuit_vendedor BIGINT NOT NULL,
  CONSTRAINT PK_producto_id PRIMARY KEY (id_producto),
  CONSTRAINT FK_producto_vendedor FOREIGN KEY (cuit_vendedor) REFERENCES vendedor(cuit_vendedor),
  CONSTRAINT FK_producto_categoria FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria),
  CONSTRAINT CK_producto_status CHECK (status_publicacion IN ('activa', 'pausada')),
  CONSTRAINT CK_producto_precio CHECK (precio > 0)
);
go

-- Tabla cliente
CREATE TABLE cliente
(
  dni INT NOT NULL,
  nombre_apellido VARCHAR(100) NOT NULL,
  domicilio VARCHAR(200) NOT NULL,
  email VARCHAR(100) NOT NULL,
  telefono BIGINT,
  id_ciudad INT NOT NULL,
  CONSTRAINT PK_cliente_id PRIMARY KEY (dni),
  CONSTRAINT FK_cliente_ciudad FOREIGN KEY (id_ciudad) REFERENCES ciudad(id_ciudad),
  CONSTRAINT UQ_cliente_email UNIQUE (email),
  CONSTRAINT UQ_cliente_telefono UNIQUE (telefono)
);
go

-- Tabla venta
CREATE TABLE venta
(
  nro_venta INT NOT NULL,
  nro_factura INT NOT NULL,
  fecha_venta DATE NOT NULL,
  dni INT NOT NULL,
  CONSTRAINT PK_venta_id PRIMARY KEY (nro_venta),
  CONSTRAINT UQ_venta_nro_factura UNIQUE (nro_factura),
  CONSTRAINT FK_venta_cliente FOREIGN KEY (dni) REFERENCES cliente(dni)
);
go

-- Tabla venta_detalle
CREATE TABLE venta_detalle(
  cantidad INT NOT NULL,  
  precio_venta FLOAT NOT NULL,  
  nro_venta INT NOT NULL,
  id_producto INT NOT NULL,
  CONSTRAINT PK_venta_detalle PRIMARY KEY (nro_venta, id_producto),
  CONSTRAINT FK_venta_detalle_venta FOREIGN KEY (nro_venta) REFERENCES venta(nro_venta),
  CONSTRAINT FK_venta_detalle_producto FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
  CONSTRAINT CK_cantidad_venta_detalle CHECK (cantidad > 0),
  CONSTRAINT CK_precio_venta_venta_detalle CHECK (precio_venta > 0)
);
go

-- Tabla resena
CREATE TABLE resena
(
  id_resena INT IDENTITY NOT NULL,
  calificacion INT NOT NULL,  
  comentario VARCHAR(200) NOT NULL,
  nro_venta INT NOT NULL,
  id_producto INT NOT NULL,
  CONSTRAINT PK_resena PRIMARY KEY (id_resena, nro_venta, id_producto),
  CONSTRAINT FK_resena_venta_detalle FOREIGN KEY (nro_venta, id_producto) REFERENCES venta_detalle(nro_venta, id_producto),
  CONSTRAINT CK_calificacion_resena CHECK (calificacion BETWEEN 1 AND 10)
);
go

-- Tabla producto_material
CREATE TABLE producto_material
(
  porcentaje INT NOT NULL,
  id_producto INT NOT NULL,
  id_material INT NOT NULL,
  CONSTRAINT PK_producto_material PRIMARY KEY (id_producto, id_material),
  CONSTRAINT FK_producto_material_producto FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
  CONSTRAINT FK_producto_material_material FOREIGN KEY (id_material) REFERENCES material(id_material),
  CONSTRAINT CK_porcentaje_producto_material CHECK (porcentaje > 0 AND porcentaje <= 100)
);
go

-- Tabla pago
CREATE TABLE pago
(
  importe FLOAT NOT NULL,
  nro_venta INT NOT NULL,
  id_pago INT NOT NULL,
  CONSTRAINT PK_pago PRIMARY KEY (nro_venta, id_pago),
  CONSTRAINT FK_pago_venta FOREIGN KEY (nro_venta) REFERENCES venta(nro_venta),
  CONSTRAINT FK_pago_metodo_pago FOREIGN KEY (id_pago) REFERENCES metodo_pago(id_pago),
  CONSTRAINT CK_importe_pago CHECK (importe > 0) -- Restricción CHECK para importe positivo
);
go

--Restricciones adicionales

--Restriccion para CUIT valido de vendedores
ALTER TABLE VENDEDOR
ADD CONSTRAINT CK_vendedor_cuit
CHECK (cuit_vendedor > 999999999);
go

--Restriccion para correo electronico valido de vendedores
ALTER TABLE VENDEDOR
ADD CONSTRAINT CK_vendedor_email
CHECK (
    email LIKE '%_@__%.__%' 
    AND email NOT LIKE '%[^A-Za-z0-9@._-]%' 
    AND CHARINDEX(' ', email) = 0
);
go

--Restriccion para documentos validos de clientes
ALTER TABLE CLIENTE
ADD CONSTRAINT CK_cliente_dni
CHECK (dni > 999999);
go

--Restricción para nombres completos validos de clientes
ALTER TABLE CLIENTE
ADD CONSTRAINT CK_Cliente_NombreApellido
CHECK (nombre_apellido LIKE '%[A-Za-zÑñÁÉÍÓÚáéíóú ]%' and nombre_apellido NOT LIKE '%[^A-Za-zÑñÁÉÍÓÚáéíóú ]%')
go

--Restriccion para correo electronico valido de clientes
ALTER TABLE CLIENTE
ADD CONSTRAINT CK_cliente_email
CHECK (
    email LIKE '%_@__%.__%' 
    AND email NOT LIKE '%[^A-Za-z0-9@._-]%' 
    AND CHARINDEX(' ', email) = 0
);
go

--Restriccion para telefonos validos de clientes
ALTER TABLE CLIENTE
ADD CONSTRAINT CK_cliente_telefono
CHECK (telefono > 9999999);
go
