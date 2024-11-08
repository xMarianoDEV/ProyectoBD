-- Utilizamos la db
use ProyectoBD

-- Seteamos el modelo de recuperacion a Full.
ALTER DATABASE ProyectoBD
SET RECOVERY FULL;
go

--Se crea un procedimiento almacenado para realizar un backup full de la base de datos guardando la fecha y la hora
CREATE PROCEDURE BackupConFecha
AS
BEGIN
    DECLARE @fecha VARCHAR(MAX) = REPLACE(CONVERT(VARCHAR(19), GETDATE(), 120), ':', '-');
    DECLARE @ruta VARCHAR(MAX) = 'C:\ProyectoBD\FULL\BackUpFull-' + @fecha + '.bak';

    BACKUP DATABASE ProyectoBD 
    TO DISK = @ruta
    WITH NOFORMAT,
    NAME = 'BackUps';
END;
go

EXEC BackupConFecha
go

-- Generamos 10 inserts sobre una misma tabla de referencia

select * from material order by id_material

INSERT INTO material (nombre)
VALUES ('Plastico');

INSERT INTO material (nombre)
VALUES ('Fibra de Carbono');

INSERT INTO material (nombre)
VALUES ('Metal');

INSERT INTO material (nombre)
VALUES ('Carton');

INSERT INTO material (nombre)
VALUES ('Agua');

INSERT INTO material (nombre)
VALUES ('Bronce');

INSERT INTO material (nombre)
VALUES ('Plata');

INSERT INTO material (nombre)
VALUES ('Aluminio');

INSERT INTO material (nombre)
VALUES ('Hierro');

INSERT INTO material (nombre)
VALUES ('Madera');
go

--Se crea un procedimiento almacenado para realizar un backup full del archivo log guardando la fecha y hora.
CREATE PROCEDURE BackUpLog
@nombreArchivo varchar(50)
AS
BEGIN
    DECLARE @fechaHoraLog VARCHAR(MAX) = REPLACE(CONVERT(VARCHAR(19), GETDATE(), 120), ':', '-');
	DECLARE @rutaLog VARCHAR(MAX) = 'C:\ProyectoBD\LOG\'+ @nombreArchivo + '-' + @fechaHoraLog + '.trn';

	BACKUP LOG ProyectoBD 
	TO DISK = @rutaLog
	WITH NOFORMAT, NOINIT,  NAME = N'LogBackUp-1', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
END;

--Se hace un backup del archivo log con ese nombre.
EXEC BackUpLog 'LogBackup1'

-- Ingresamos otros 10 registros mas en la misma tabla
INSERT INTO material (nombre)
VALUES ('Plasticos');

INSERT INTO material (nombre)
VALUES ('Fibra de Carbonos');

INSERT INTO material (nombre)
VALUES ('Metales');

INSERT INTO material (nombre)
VALUES ('Cartones');

INSERT INTO material (nombre)
VALUES ('Aguas');

INSERT INTO material (nombre)
VALUES ('Bronces');

INSERT INTO material (nombre)
VALUES ('Platas');

INSERT INTO material (nombre)
VALUES ('Aluminios');

INSERT INTO material (nombre)
VALUES ('Hierros');

INSERT INTO material (nombre)
VALUES ('Maderas');

--Se hace otro backup del archivo log con ese nombre.
EXEC BackUpLog 'LogBackup2'
go

--PRIMERA RESTAURACION
----------------------------------------------------------------------
--Primero, se hace un restore de la base de datos usando el archivo .bak del primer backup full.
--Se pone en la base de datos en modo NORECOVERY para poner añadir archivos log al restore.
--Se debe cambiar la ruta del archivo manualmente y poner la extension .bak.
USE [master]
ALTER DATABASE [ProyectoBD] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
RESTORE DATABASE [ProyectoBD] FROM  DISK = N'C:\ProyectoBD\FULL\BackUpFull-2024-11-08 12-50-52.bak' WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  REPLACE,  STATS = 5
GO

--Luego, se restaura el primer y solo el primer archivo log del que se hizo backup,
--Y se pone la base de datos en modo RECOVERY para poder verificar si el restore se realizo correctamente.
--Se debe cambiar la ruta del archivo manualmente y poner la extension .trn.
RESTORE LOG [ProyectoBD] FROM  DISK = N'C:\ProyectoBD\LOG\LogBackup1-2024-11-08 12-51-20.trn' WITH  FILE = 1,  NOUNLOAD,  STATS = 10
GO

--Se vuelve a poner la base de datos en modo de multiples usuarios
USE [master]
ALTER DATABASE [ProyectoBD] SET MULTI_USER

--Se validan los datos.
use ProyectoBD
select * from material 
order by id_material asc


--------------------------------------------------------------------------------
--Segunda restauración.

--Primero, se hace un restore de la base de datos usando el archivo .bak del primer backup full.
--Se pone en la base de datos en modo NORECOVERY para poner añadir archivos log al restore.
--Se debe cambiar la ruta del archivo manualmente y poner la extension .bak.
USE [master]
ALTER DATABASE [ProyectoBD] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
RESTORE DATABASE [ProyectoBD] FROM  DISK = N'C:\ProyectoBD\FULL\BackUpFull-2024-11-08 12-50-52.bak' WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  REPLACE,  STATS = 5
GO

--Luego, se restaura el primer archivo log del que se hizo backup,
--Y se pone la base de datos en modo NORECOVERY para poder añadir el segundo archivo log al restore.
--Se debe cambiar la ruta del archivo manualmente y poner la extension .trn.
RESTORE LOG [ProyectoBD] FROM  DISK = N'C:\ProyectoBD\LOG\LogBackup1-2024-11-08 12-51-20.trn' WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  STATS = 10
GO

--Por ultimo se restaura el segundo archivo log del que se hizo backup,
--Y se pone la base de datos en modo RECOVERY para poder verificar los datos.
--Se debe cambiar la ruta del archivo manualmente y poner la extension .trn.
RESTORE LOG [ProyectoBD] FROM  DISK = N'C:\ProyectoBD\LOG\LogBackup2-2024-11-08 12-51-30.trn' WITH  FILE = 1,  NOUNLOAD,  STATS = 10
GO

--Se vuelve a poner la base de datos en modo de multiples usuarios.
USE [master]
ALTER DATABASE [ProyectoBD] SET MULTI_USER

--Se validan los datos.
use ProyectoBD
select * from material 
order by id_material asc
