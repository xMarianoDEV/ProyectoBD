# Proyecto de Estudio!

# PRESENTACIÓN (Marketplace)

**Asignatura**: Bases de Datos I (FaCENA-UNNE)

**Integrantes**:<br>
- Duete, Facundo<br>
- López, Maximiliano<br>
- Maidana, Matias<br>
- Stemberg, Mariano<br>

**Año**: 2024

## CAPÍTULO I: INTRODUCCIÓN

### Caso de estudio

**Desarrollo y Gestión de una Base de Datos Relacional para un Marketplace en Línea**
### Definición o planteamiento del problema

El problema principal que aborda este trabajo práctico es cómo diseñar una base de datos que permita gestionar eficientemente un mercado en línea, donde se registran diferentes tipos de actores (vendedores, clientes, productos, materiales, medios de pago, etc.) y operaciones relacionadas (ventas, pagos, reseñas, etc.). La problemática se centra en garantizar que la información almacenada sea coherente, íntegra y permita realizar consultas rápidas y seguras.

## CAPÍTULO II: MARCO CONCEPTUAL O REFERENCIAL
## TEMA 1: Manejo de permisos a nivel de usuarios de base de datos

Los permisos a nivel de usuario de base de datos definen las acciones que pueden realizar los usuarios sobre las tablas, vistas, procedimientos almacenados, entre otros, de una base de datos, garantizando seguridad e integridad de los datos. Para comenzar, la base de datos debe encontrarse configurada en modo mixto, para que se permita ingresar mediante un usuario de SQL Server y que se los autentique correctamente, esto se logra con la siguiente sentencia:  

    EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'LoginMode', REG_DWORD, 2
    

**Permisos a nivel de usuarios**

Antes de crear un usuario de base de datos se deben crear sus credenciales para ingresar al servidor, esto se conoce como Inicio de Sesión (Login) y el mismo puede estar asociado a uno o varios usuarios diferentes, siempre que sean de diferentes bases de datos. Los mismos se crean con la sentencia:  

`CREATE LOGIN [UsuarioAdmin] WITH PASSWORD=N'123', DEFAULT_DATABASE=[ProyectoBD], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF`

donde "UsuarioAdmin" seria el nombre de usuario y "123" su contraseña para ingresar al servidor, esta sentencia siempre se debe ejecutar en la base de datos master.  

Luego, para crear un usuario se usa:  

`CREATE USER [Usuario] FOR LOGIN [UsuarioAdmin]`

 donde "Usuario" es el nombre que tendrá el usuario en la base de datos y "UsuarioAdmin" el login al que hace referencia, esta sentencia se debe ejecutar en la base de datos en la que se quiera añadir al usuario. Para asignar permisos a un usuario, primero se deben tener los permisos suficientes para hacerlo. Pueden asignar permisos aquellos usuarios con roles como **db_owner**, **db_securityadmin**, o el rol de servidor **sysadmin**. Estos permisos incluyen operaciones como **SELECT, INSERT, UPDATE, DELETE, EXECUTE**, y pueden ser concedidos con la sentencia **GRANT**, denegados con **DENY**, y revocados con **REVOKE** por ejemplo:
 
 `GRANT SELECT ON vendedor TO usuarioLectura`
 
  Se conceden permisos de lectura a usuarioLectura solo sobre la tabla vendedor. 
  
**Permisos a nivel de roles**

Por último, también se pueden crear roles, que son una manera eficiente de distribuir permisos si se tiene una gran cantidad de usuarios, para crear un permiso se utiliza la sentencia:  

    CREATE ROLE [Lectura] GRANT SELECT ON [dbo].[cliente] TO [Lectura]

donde se esta creando un rol llamado lectura que permitirá la lectura solo de la tabla cliente a los usuarios con ese rol. Para añadir usuarios que tengan ese rol se usa:  

    ALTER ROLE [Lectura] ADD MEMBER [UsuarioRolLectura]

donde al usuario llamado UsuarioRolLectura se le está asignando el rol Lectura junto con todos sus permisos.

##
## TEMA 2: Procedimientos y funciones almacenadas <br>

Los procedimientos y funciones almacenadas en una base de datos permiten encapsular lógica y operaciones, optimizando el rendimiento y la seguridad al ejecutar comandos en el servidor. A diferencia de las consultas directas, los procedimientos almacenados son bloques de código que realizan acciones específicas sobre la base de datos, como operaciones de inserción, actualización, eliminación o consultas complejas. 

**Para crear un procedimiento almacenado, se utiliza la siguiente sintaxis:**

    `CREATE PROCEDURE nombre_procedimiento  
        AS  
        BEGIN  
       -- Código SQL  
        END`

- Por ejemplo, un procedimiento para insertar un nuevo cliente podría escribirse así:

    `EXEC InsertarCliente 'Juan', 'Perez', '123456789';`

Por otro lado, las funciones almacenadas permiten realizar cálculos y devolver un valor, aunque no pueden modificar datos directamente como los procedimientos. Estas pueden ser escalar, retornando un solo valor, o de tabla, devolviendo un conjunto de filas. 

**Un ejemplo de función escalar sería:**

    `CREATE FUNCTION CalcularEdad (@FechaNacimiento DATE)  
        RETURNS INT  
        AS  
         BEGIN  
           DECLARE @Edad INT;  
           SET @Edad = DATEDIFF(YEAR, @FechaNacimiento, GETDATE());  
           RETURN @Edad;  
        END`

Esta función calcula la edad a partir de la fecha de nacimiento proporcionada y retorna el valor. Las funciones se pueden utilizar dentro de consultas, por ejemplo:

    `SELECT Nombre, Apellido, dbo.CalcularEdad(FechaNacimiento) AS Edad  
      FROM Clientes;`


##
## TEMA 3: Optimización de consultas a través de índices <br>

Los índices en bases de datos son estructuras de datos que mejoran la velocidad de las operaciones de recuperación de datos en una tabla a costa de espacio adicional y tiempos de actualización más largos. Utilizar índices correctamente puede hacer que las consultas se ejecuten mucho más rápido, mejorando así el rendimiento general de la base de datos.

**¿Qué es un Índice?**
Un índice es similar a un índice en un libro: permite localizar rápidamente la información sin necesidad de escanear toda la tabla. Los índices pueden ser creados en una o más columnas de una tabla y se utilizan principalmente para acelerar las consultas  `SELECT ` y para aplicar restricciones de unicidad.

**Tipos de Índices**
Índice Clustered: Reordena las filas de la tabla física para que coincidan con el orden del índice. Cada tabla puede tener solo un índice clustered, ya que define la estructura de almacenamiento de los datos de la tabla.

**Índice Non-Clustered:** Crea una estructura separada de la tabla donde se almacena el valor de la clave de índice y un puntero a la fila de datos física. Una tabla puede tener múltiples índices non-clustered.

**Índices Únicos:** Garantizan que los valores en el índice sean únicos, previniendo duplicados.

**Creación de Índices**
Para crear un índice en SQL Server, se utiliza la sentencia  `CREATE INDEX `. A continuación, algunos ejemplos de cómo crear índices:

**Índice Clustered**
-- Crear un índice clustered en la columna 'id_cliente' de la tabla 'cliente':

      `CREATE CLUSTERED INDEX IX_Cliente_ID ON cliente (id_cliente); `

**Índice Non-Clustered**
-- Crear un índice non-clustered en la columna 'apellido' de la tabla 'cliente':

      `CREATE NONCLUSTERED INDEX IX_Cliente_Apellido ON cliente (apellido); `

**Índice Único**
-- Crear un índice único en la columna 'email' de la tabla 'cliente':

      `CREATE UNIQUE INDEX IX_Cliente_Email ON cliente (email); `

**Optimización de Consultas**
El uso de índices puede mejorar significativamente el rendimiento de las consultas. A continuación, se muestran algunos ejemplos de cómo las consultas pueden beneficiarse de los índices:

**Consulta Sin Índice**
-- Consulta sin índice en la columna 'apellido':

     `SELECT * FROM cliente WHERE apellido = 'García'; `

Esta consulta requerirá un escaneo completo de la tabla si no existe un índice en la columna apellido.

**Consulta Con Índice**
-- Consulta optimizada utilizando un índice en la columna 'apellido':

     `CREATE NONCLUSTERED INDEX IX_Cliente_Apellido ON cliente (apellido);
      SELECT * FROM cliente WHERE apellido = 'García';  `

Con el índice  `IX_Cliente_Apellido `, SQL Server puede localizar rápidamente las filas donde apellido es 'García', evitando un escaneo completo de la tabla.

**Mantenimiento de Índices**
Los índices deben mantenerse para garantizar un rendimiento óptimo. Algunas operaciones de mantenimiento incluyen:

**Reorganización de Índices:** Reorganiza las páginas del índice en orden lógico. Esto es menos intensivo que la reconstrucción completa y puede realizarse más frecuentemente.

**Reconstrucción de Índices:** Reconstruye completamente el índice, eliminando la fragmentación. Esto es más intensivo pero puede ser necesario para índices altamente fragmentados.

**Reorganización de Índices**
-- Reorganizar un índice específico:

      `ALTER INDEX IX_Cliente_Apellido ON cliente REORGANIZE; `

**Reconstrucción de Índices**
-- Reconstruir un índice específico:

      `ALTER INDEX IX_Cliente_Apellido ON cliente REBUILD; `

La optimización de consultas a través de índices es esencial para mantener una base de datos eficiente y de alto rendimiento. Al entender y utilizar correctamente los índices, se puede mejorar significativamente el tiempo de respuesta de las consultas, asegurando que las aplicaciones que dependen de la base de datos funcionen de manera rápida y eficiente.

##
## TEMA 4: Backup y restore. Backup en línea <br>

Un **backup** (o copia de seguridad) es una duplicación de los datos de una base de datos u otro sistema, almacenada en un medio de almacenamiento separado para proteger la información contra pérdidas accidentales, fallos del sistema, corrupción de datos o desastres. Los backups permiten restaurar los datos a un estado anterior, asegurando la continuidad de las operaciones y minimizando la pérdida de información.

Para realizar un backup, primero debemos establecer el modelo de recuperación en **"Full"** para registrar todas las transacciones y permitir restauraciones detalladas.

    ` USE ProyectoBD ALTER DATABASE ProyectoBD SET RECOVERY FULL;  `

A continuación, se realiza un backup completo de la base de datos. En este caso, creamos un procedimiento almacenado que incluye la fecha y hora en el nombre del archivo, para registrar cuándo se ejecuta el procedimiento.

    ` CREATE PROCEDURE BackupConFecha AS BEGIN DECLARE @fecha VARCHAR(MAX) = REPLACE(CONVERT(VARCHAR(19), GETDATE(), 120), ':', '-'); DECLARE @ruta VARCHAR(MAX) = 'C:\ProyectoBD\FULL\BackUpFull-' + @fecha +             '.bak'; BACKUP DATABASE ProyectoBD TO DISK = @ruta WITH NOFORMAT, NAME = 'BackUps'; END; `

Con el backup completo realizado, se pueden ejecutar diversas operaciones y registrar los cambios en archivos de logs. Para ello, creamos otro procedimiento almacenado que guarda los logs de manera similar al backup completo.


    ` CREATE PROCEDURE BackUpLog @nombreArchivo varchar(50) AS BEGIN DECLARE @fechaHoraLog VARCHAR(MAX) = REPLACE(CONVERT(VARCHAR(19), GETDATE(), 120), ':', '-'); DECLARE @rutaLog VARCHAR(MAX) =                         'C:\ProyectoBD\LOG\'+ @nombreArchivo + '-' + @fechaHoraLog + '.trn'; `

    ` BACKUP LOG ProyectoBD TO DISK = @rutaLog WITH NOFORMAT, NOINIT,  NAME = N'LogBackUp-1', SKIP, NOREWIND, NOUNLOAD,  STATS = 10 END; `<br>

**NOFORMAT** = Indica que el backup se agrega sin eliminar los backups anteriores.

**NOINIT** = El backup se agrega al final de cualquier contenido existente en el medio, lo que permite mantener múltiples backups en un mismo archivo o dispositivo.

**SKIP** = Permite que el backup se escriba sin importar si el contenido existente en el medio coincide con el nuevo backup.

**NOREWIND** = Indica que después de que el backup se complete, el dispositivo (si es un dispositivo de cinta) no debe rebobinarse.

**NOUNLOAD** = Evita que el dispositivo de backup se expulse o descargue después de que finalice el backup.

**STATS 10** = Muestra mensajes de progreso en intervalos de cada 10% completado. 	

Una vez realizado el backup y los archivos de logs, es posible restaurarlos para recuperar datos que puedan haberse corrompido o perdido.

Para realizar la restauración, primero cambiamos el contexto de la base de datos al sistema (master) para evitar conflictos durante el proceso. Utilizaremos el archivo de backup completo (.bak) y pondremos la base de datos en modo **NORECOVERY** para permitir la adición de logs posteriormente.

    ` USE [master] ALTER DATABASE [ProyectoBD] SET SINGLE_USER WITH ROLLBACK IMMEDIATE RESTORE DATABASE [ProyectoBD] FROM  DISK = N'C:\ProyectoBD\FULL\BackUpFull-2024-11-08 12-50-52.bak' WITH  FILE = 1,                  NORECOVERY,  NOUNLOAD,  REPLACE,  STATS = 5 ` <br>

En este caso utilizamos el modo **NORECOVERY** para indicar que pueden añadirse logs. Ademas, dejamos la base de datos en modo de un unico usuario y con rollback inmediato, que libera la base de datos de posibles bloqueos o accesos que impidan la restauración.

Ahora, se restaura el primer log backup y se coloca en modo **RECOVERY** para hacer la base de datos accesible y verificar los datos.

    ` RESTORE LOG [ProyectoBD] FROM  DISK = N'C:\ProyectoBD\LOG\LogBackup1-2024-11-08 12-51-20.trn' WITH  FILE = 1,  NOUNLOAD,  STATS = 10 ` 

Se vuelve a poner la base de datos en modo de multiples usuarios y luego, ya estaria finalizado el proceso de **Restore**.

    ` USE [master] ALTER DATABASE [ProyectoBD] SET MULTI_USER `
##

## CAPÍTULO III: METODOLOGÍA SEGUIDA

**a) Cómo se realizó el Trabajo Práctico:** 	Como se menciona en el capitulo I decidimos por realizar el caso de estudio sobre una base de datos relacional para un Marketplace en línea. Para organizarnos decidimos por dividir los temas de investigación y asignar uno a cada integrante. Aunque acordamos que, en caso de que haya dudas, nos consultaríamos entre nosotros para asegurar una comprensión clara y un mejor desarrollo del trabajo.
Al finalizar los scripts SQL de los temas se realizaron varias pruebas y validaciones, ya sea con inserciones y consultas específicas, con el objeto de verificar que estén desarrollados de la manera correcta.
Por último, se hizo la documentación de cada tema, incluyendo explicaciones detalladas del proceso de desarrollo, junto con ejemplos y demás para que sea lo más entendible posible.

**b) Herramientas (Instrumentos y procedimientos):** 
 - **ERD Plus:** esta herramienta nos permitió crear y editar el modelo relacional de la base de datos, además de brindar la opción de exportar el mismo modelo.
 - **SQL Server:** esta herramienta nos permitió crear la base de datos, sus restricciones, índices, procedimientos almacenados, etc. Además de desarrollar y ejecutar los scripts del proyecto
 - **WhatsApp:** esta herramienta permitió mantener una comunicación constante entre los integrantes del grupo, permitiendo compartir ideas y resolver dudas acerca del proyecto.

## CAPÍTULO IV: DESARROLLO DEL TEMA / PRESENTACIÓN DE RESULTADOS

### TEMA 1: Manejo de permisos a nivel de usuarios de base de datos

**Descripción:**
El manejo de permisos en bases de datos es fundamental para controlar el acceso de los usuarios y sus capacidades dentro de la base de datos. Esto asegura que solo los usuarios autorizados puedan realizar ciertas acciones, como leer, escribir o modificar datos.

**Ejemplo 1:** Creación de un Usuario y Asignación de Permisos
**1- Creación de un Login y Usuario:**

    `CREATE LOGIN [UsuarioAdmin] WITH PASSWORD=N'123', DEFAULT_DATABASE=[ProyectoBD], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF;`

-- Crear un usuario en la base de datos

     `CREATE USER [Usuario] FOR LOGIN [UsuarioAdmin];`

**2- Asignación de Permisos:**
-- Conceder permisos de lectura en la tabla 'Titles'

    `GRANT SELECT ON Titles TO [Usuario];`

-- Conceder permisos de inserción en la tabla 'Directors'

    `GRANT INSERT ON Directors TO [Usuario];`
 **Resultado:** El usuario Usuario ahora tiene permisos para realizar consultas (SELECT) sobre la tabla Titles y para insertar datos en la tabla Directors, pero no podrá modificar ni eliminar registros.

 **Ejemplo 2: Uso de Roles**
 -- Crear un rol llamado 'Lectura' que tendrá permisos de selección sobre la tabla 'Titles'
 
    `CREATE ROLE [Lectura];
        GRANT SELECT ON Titles TO [Lectura];`

-- Asignar el rol 'Lectura' al usuario 'Usuario'

    `ALTER ROLE [Lectura] ADD MEMBER [Usuario];`
**Resultado:** El rol Lectura garantiza que cualquier usuario que sea miembro de este rol solo pueda leer los datos de la tabla Titles, lo que facilita la gestión de permisos para múltiples usuarios.



### TEMA 2: Procedimientos y funciones almacenadas

**Descripción:**
Los procedimientos y funciones almacenadas son bloques de código SQL que se almacenan y ejecutan en el servidor de base de datos. Permiten encapsular lógica y reutilizarla de manera eficiente, mejorando el rendimiento y la seguridad al evitar la repetición de código en las aplicaciones.

**Ejemplo 1:** Procedimiento Almacenado para Insertar un Director

     `CREATE PROCEDURE InsertarDirector
        @director_name VARCHAR(255)
            AS
            BEGIN
         INSERT INTO Directors (director_name)
        VALUES (@director_name);
    END; `
 **Resultado:** El procedimiento almacenado InsertarDirector permite agregar un nuevo director a la tabla Directors sin necesidad de escribir el código repetidamente en cada parte de la aplicación.

**Ejemplo 2:** Función Almacenada para Contar el Número de Shows por Tipo

    `CREATE FUNCTION ContarShowsPorTipo (@tipo_id INT)
        RETURNS INT
            AS
            BEGIN
        DECLARE @total_shows INT;
        SELECT @total_shows = COUNT(*)
        FROM Titles
        WHERE tipo_id = @tipo_id;
        RETURN @total_shows;
    END;`
    **Resultado:** La función ContarShowsPorTipo devuelve el número total de shows de un tipo específico en la base de datos. Esto es útil para obtener estadísticas rápidamente sobre el contenido disponible según su tipo.

**Ejemplo 3:** Llamada a la Función para Mostrar el Conteo de Shows por Tipo

    `SELECT tipo_id, dbo.ContarShowsPorTipo(tipo_id) AS TotalShows
        FROM tipo;`
**Resultado:** Esta consulta devuelve el número de shows por cada tipo de contenido, usando la función ContarShowsPorTipo. El resultado podría ser algo así:



### TEMA 3: Optimización de consultas a través de índices

**Descripción:**
Los índices son estructuras que mejoran la velocidad de las operaciones de búsqueda en las tablas. Crear índices adecuados en las columnas que se utilizan con frecuencia en las consultas puede mejorar significativamente el rendimiento de la base de datos.

**Ejemplo 1:** Creación de un Índice Clustered en la Columna show_id de la Tabla Titles

    `CREATE CLUSTERED INDEX IX_Titles_ShowID ON Titles (show_id);`
**Resultado:** La creación de un índice clustered en la columna show_id mejora el rendimiento de las consultas que busquen por este campo, ya que la tabla se organiza físicamente según esta columna.

**Ejemplo 2:** Creación de un Índice Non-Clustered en la Columna title de la Tabla Titles

    `CREATE NONCLUSTERED INDEX IX_Titles_Title ON Titles (title);`
**Resultado:** El índice non-clustered sobre la columna title optimiza las consultas que filtran o buscan por el nombre del show, sin reorganizar físicamente la tabla.

**Ejemplo 3:** Consulta con y sin Índice

**1- Consulta sin Índice:**

    `SELECT * FROM Titles WHERE title = 'Inception';`

**2- Consulta con Índice:**

    `CREATE NONCLUSTERED INDEX IX_Titles_Title ON Titles (title);
        SELECT * FROM Titles WHERE title = 'Inception';`
**Resultado:** Al usar el índice IX_Titles_Title, las consultas sobre la columna title se vuelven más rápidas, ya que el índice proporciona un acceso más eficiente a los datos.



### TEMA 4: Backup y restore. Backup en línea

**Descripción:**
Los backups son esenciales para proteger los datos en caso de fallos del sistema o corrupción de la base de datos. Realizar backups de manera regular asegura que se pueda recuperar la información en caso de desastres. Los backups en línea permiten realizar respaldos sin interrumpir el servicio de la base de datos.

**Ejemplo 1:** Procedimiento para Realizar un Backup Completo de la Base de Datos

     `CREATE PROCEDURE BackupCompleto
        AS
        BEGIN
        DECLARE @fecha VARCHAR(MAX) = REPLACE(CONVERT(VARCHAR(19), GETDATE(), 120), ':', '-');
        DECLARE @ruta VARCHAR(MAX) = 'C:\Backups\ProyectoBD\BackUpFull-' + @fecha + '.bak';
        BACKUP DATABASE ProyectoBD TO DISK = @ruta WITH NOFORMAT, INIT, NAME = 'Full Backup';
    END; `
**Resultado:** El procedimiento BackupCompleto realiza un backup completo de la base de datos y guarda el archivo con un nombre que incluye la fecha y hora, lo que facilita la organización y recuperación de las copias de seguridad.

**Ejemplo 2:** Realizar un Restore de la Base de Datos

    `RESTORE DATABASE ProyectoBD
    FROM DISK = 'C:\Backups\ProyectoBD\BackUpFull-2024-11-11-12-34-56.bak'
    WITH REPLACE;`
**Resultado:** El comando RESTORE DATABASE recupera la base de datos desde el archivo de backup especificado, restaurando todos los datos a su estado en el momento en que se realizó el backup. El parámetro WITH REPLACE permite sobrescribir la base de datos actual.

##

### Diagrama relacional
![diagrama_relacional](https://github.com/xMarianoDEV/ProyectoBD/blob/main/doc/image_relational.png)

### Diccionario de datos

Acceso al documento [PDF](doc/diccionario_datos.pdf) del diccionario de datos.

### Desarrollo TEMA 1 "Manejo de permisos a nivel de usuario de Base de datos"

Fusce auctor finibus lectus, in aliquam orci fermentum id. Fusce sagittis lacus ante, et sodales eros porta interdum. Donec sed lacus et eros condimentum posuere.

> Acceder a la siguiente carpeta para la descripción completa del tema
[scripts-> tema_1](https://github.com/xMarianoDEV/ProyectoBD/tree/main/script/tema01_manejo_de_permisos_a_nivel_de_usuarios)

## CAPÍTULO V: CONCLUSIONES

A lo largo de este trabajo de investigación sobre índices, manejo de permisos a nivel de usuario, procedimientos almacenados, y backup y restore en SQL Server, comprendimos cómo cada uno de estos elementos contribuye a la robustez y eficiencia de una base de datos. Los índices optimizan el acceso a datos y mejoran el rendimiento de consultas, mientras que el manejo de permisos garantiza la seguridad y control sobre los accesos. Los procedimientos almacenados permiten automatizar y simplificar operaciones complejas, promoviendo consistencia y eficiencia en el manejo de datos. Finalmente, el backup y restore son esenciales para la recuperación y protección de la información, ofreciendo una capa de seguridad ante posibles pérdidas de datos.  No obstante, estos temas no son los únicos que garantizan una base de datos sólida y eficiente. Otros aspectos, como los índices columnares, los triggers, y el manejo de transacciones, también juegan un papel fundamental. 
En conjunto, todos estos elementos permiten una administración completa y efectiva, asegurando un sistema confiable y de alto rendimiento.
