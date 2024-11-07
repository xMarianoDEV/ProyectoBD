--Se otorgan permisos de lectura a usuarioLectura, pero solo sobre la tabla "vendedor" de la base de datos.
/*
use ProyectoBD
go
GRANT SELECT ON vendedor TO usuarioLectura
go
*/

--Se otorgan permisos de lectura a usuarioLectura sobre todas las tablas de la base de datos.
use ProyectoBD
go
GRANT SELECT TO usuarioLectura
go

select * from vendedor

insert into vendedor values(30714562525, 'David Navarro', '2000-05-04', 'david.navarro@example.com')

--Se ejecuta el procedimiento almacenado para insertar un cliente
select * from cliente

EXEC InsertCliente 
    @dni = 45745123, 
    @nombre_apellido = 'Jorge Perez', 
    @domicilio = 'Lavalle 3506',
	@email = 'jorge.perez@email.com',
	@telefono = 3794848484,
	@id_ciudad = 1;
GO

--Se ejecuta el procedimiento almacenado para modificar un cliente.
EXEC UpdateCliente
	@dni = 45745123, 
    @nombre_apellido = 'Jorge Perez', 
    @domicilio = 'Lavalle 3106',
	@email = 'jorge.perez2020@email.com',
	@telefono = 3794848483,
	@id_ciudad = 1;
GO

--Se ejecuta el procedimiento almacenado para eliminar un cliente.
EXEC DeleteCliente
	@dni = 20202020
GO

--Se le da permiso de ejecución del procedimiento almacenado para insertar clientes al usuario
--con permisos de lectura.

GRANT EXECUTE on InsertCliente to usuarioLectura
go

/* Se le revocan los permisos de ejecución del procedimiento almacenado 
de insertar clientes al usuario de lectura.

REVOKE EXECUTE on InsertCliente to usuarioLectura
go
*/

--Se realiza un Insert sobre la tabla clientes.
INSERT INTO cliente (dni, nombre_apellido, domicilio, email, telefono, id_ciudad)
VALUES (45845516, 'Gonzalo Romero', 'Calle Falsa 321', 'gonzalo.romero@gmail.com', 3794326584, 1)
go

/*
DELETE FROM CLIENTE where dni = 45845516
*/



