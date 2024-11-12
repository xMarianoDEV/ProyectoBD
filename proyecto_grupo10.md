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

**TEMA 2:** Procedimientos y funciones almacenadas <br>

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


**TEMA 4:** Backup y restore. Backup en línea <br>

## CAPÍTULO III: METODOLOGÍA SEGUIDA

## CAPÍTULO IV: DESARROLLO DEL TEMA / PRESENTACIÓN DE RESULTADOS

### Diagrama relacional
![diagrama_relacional](https://github.com/xMarianoDEV/ProyectoBD/blob/main/doc/image_relational.png)

### Diccionario de datos

Acceso al documento [PDF](doc/diccionario_datos.pdf) del diccionario de datos.

## CAPÍTULO V: CONCLUSIONES
