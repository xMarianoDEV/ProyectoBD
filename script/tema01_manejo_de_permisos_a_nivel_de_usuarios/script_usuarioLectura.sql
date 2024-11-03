--Se comprueba que el usuario con permisos de lectura solo pueda utilizar sentencias select
use ProyectoBD
select * from vendedor

--Se comprueba que el usuario con permisos de lectura no pueda utilizar sentencias dml.
insert into vendedor values(30714562525, 'David Navarro', '2000-05-04', 'david.navarro@example.com')
go

update vendedor
set nombre_apellido = 'Martin Perez'
where nombre_apellido = 'Martin Gomez'
go

delete from producto
go

--Tampoco tiene permisos para hacer un drop de alguna tabla
drop table cliente
go

--Se intenta ejecutar el procedimiento almacenado para insertar un cliente.
select * from cliente

EXEC InsertCliente 
    @dni = 34567890, 
    @nombre_apellido = 'Laura Martinez', 
    @domicilio = 'Av. Independencia 1100',
	@email = 'laura.martinez@gmail.com',
	@telefono = 3794035847,
	@id_ciudad = 1;
GO

EXEC DeleteCliente
	@dni = 34567890
go

--Se realiza un Insert sobre la tabla clientes.
--El usuario de lectura no cuenta con permisos de insert sobre la tabla cliente, por lo que no podrá ejecutar esta sentencia
INSERT INTO cliente (dni, nombre_apellido, domicilio, email, telefono, id_ciudad)
VALUES (45845516, 'Gonzalo Romero', 'Calle Falsa 321', 'gonzalo.romero@gmail.com', 3794326584, 1)
go

--Aunque si cuenta con permisos para ejecutar este procedimiento si podrá insertar clientes
--en su respectiva tabla.
EXEC InsertCliente 
    @dni = 45845516, 
    @nombre_apellido = 'Gonzalo Romero', 
    @domicilio = 'Calle Falsa 321',
	@email = 'gonzalo.romero@gmail.com',
	@telefono = 3794326584,
	@id_ciudad = 1;
GO



