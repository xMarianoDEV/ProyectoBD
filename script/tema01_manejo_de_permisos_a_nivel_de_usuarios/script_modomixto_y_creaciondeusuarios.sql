--Sentencias para Permisos a nivel de usuarios

--Script para configurar la base de datos como modo mixto (autenticación de windows y por usuario de sql server),
--esto permite crear inicios de sesión y autenticarlos mediante sql server.

USE [ProyectoBD]
GO
EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'LoginMode', REG_DWORD, 2
GO

--Se crean las credenciales para acceder al servidor del usuario que será administrador.
USE [master]
GO
CREATE LOGIN [UsuarioAdmin] WITH PASSWORD=N'123', DEFAULT_DATABASE=[ProyectoBD], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

--Se asigna el rol de administrador a las credenciales de login de UsuarioAdmin, sabiendo que ya
--tiene el rol de administrador, no es necesario ejecutar consultas para crear usuarios para bases de datos específicas
--ya que teniendo el rol de administrador puede acceder a todas las bases de datos.
ALTER SERVER ROLE [sysadmin] ADD MEMBER [UsuarioAdmin]
GO

/*
USE [ProyectoBD]
GO
CREATE USER [UsuarioAdmin] FOR LOGIN [UsuarioAdmin]
GO */

--Se crean las credenciales para acceder al servidor del usuario que solo tendrá permisos de lectura.
USE [master]
GO
CREATE LOGIN [UsuarioLectura] WITH PASSWORD=N'123', DEFAULT_DATABASE=[ProyectoBD], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

--Se crea el usuario UsuarioLectura utilizando las credenciales de inicio de sesión de UsuarioLectura,
--aunque este usuario aún no cuenta con permisos de lectura para la base de datos "ProyectoBD", solo puede visualizarla.
USE [ProyectoBD]
GO
CREATE USER [UsuarioLectura] FOR LOGIN [UsuarioLectura]
GO



-- Sentencias para permisos a nivel de roles del DBMS

--Se crean dos credenciales de login, una para el usuario que tendrá permiso sobre el rol de lectura, y otro para
--el usuario sin el rol de lectura.

USE [master]
GO
CREATE LOGIN [UsuarioRolLectura] WITH PASSWORD=N'123', DEFAULT_DATABASE=[ProyectoBD], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

USE [master]
GO
CREATE LOGIN [UsuarioSinRolLectura] WITH PASSWORD=N'123', DEFAULT_DATABASE=[ProyectoBD], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

--Se crean ambos usuarios para la base de datos utilizando las credenciales anteriormente registradas.
USE [ProyectoBD]
GO
CREATE USER [UsuarioRolLectura] FOR LOGIN [UsuarioRolLectura]
GO

USE [ProyectoBD]
GO
CREATE USER [UsuarioSinRolLectura] FOR LOGIN [UsuarioSinRolLectura]
GO

--Se crea el rol que permite leer los datos de la tabla cliente de la base de datos.
USE [ProyectoBD]
GO
CREATE ROLE [Lectura]
GO
GRANT SELECT ON [dbo].[cliente] TO [Lectura]
GO

--Se da permiso a UsuarioRolLectura sobre el rol creado anteriormente.
USE [ProyectoBD];
GO
ALTER ROLE [Lectura] ADD MEMBER [UsuarioRolLectura];
GO



