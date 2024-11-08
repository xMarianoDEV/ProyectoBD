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
**TEMA 1: Manejo de permisos a nivel de usuarios de base de datos** <br>
Los permisos a nivel de usuario de base de datos definen las acciones que pueden realizar los usuarios sobre las tablas, vistas, procedimientos almacenados, entre otros, de una base de datos, garantizando seguridad e integridad de los datos. Para comenzar, la base de datos debe encontrarse configurada en modo mixto, para que se permita ingresar mediante un usuario de SQL Server y que se los autentique correctamente, esto se logra con la siguiente sentencia:<br> **EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'LoginMode', REG_DWORD, 2** <br>
Antes de crear un usuario de base de datos se deben crear sus credenciales para ingresar al servidor, esto se conoce como Inicio de Sesión (Login) y el mismo puede estar asociado a uno o varios usuarios diferentes, siempre que sean de diferentes bases de datos.
Los mismos se crean con la sentencia:<br> **CREATE LOGIN [UsuarioAdmin] WITH PASSWORD=N'123', DEFAULT_DATABASE=[ProyectoBD], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF**, donde "UsuarioAdmin" seria el nombre de usuario y "123" su contraseña para ingresar al servidor, esta sentencia siempre se debe ejecutar en la base de datos master.
<br> Luego, para crear un usuario se usa:<br> **CREATE USER [Usuario] FOR LOGIN [UsuarioAdmin]**, donde "Usuario" es el nombre que tendrá el usuario en la base de datos y "UsuarioAdmin" el login al que hace referencia, esta sentencia se debe ejecutar en la base de datos en la que se quiera añadir al usuario.
Para asignar permisos a un usuario, primero se deben tener los permisos suficientes para hacerlo. Pueden asignar permisos aquellos usuarios con roles como **db_owner**, **db_securityadmin**, o el rol de servidor **sysadmin**. Estos permisos incluyen operaciones como **SELECT, INSERT, UPDATE, DELETE, EXECUTE**, y pueden ser concedidos con la sentencia **GRANT**, denegados con **DENY**, y revocados con 
**REVOKE** por ejemplo: **GRANT SELECT ON vendedor TO usuarioLectura** Se conceden permisos de lectura a usuarioLectura solo sobre la tabla vendedor.
Por último, también se pueden crear roles, que son una manera eficiente de distribuir permisos si se tiene una gran cantidad de usuarios, para crear un permiso se utiliza la sentencia: <br>
**CREATE ROLE [Lectura]
GRANT SELECT ON [dbo].[cliente] TO [Lectura]**, donde se esta creando un rol llamado lectura que permitirá la lectura solo de la tabla cliente a los usuarios con ese rol. Para añadir usuarios que tengan ese rol se usa:<br> **ALTER ROLE [Lectura] ADD MEMBER [UsuarioRolLectura]** donde al usuario llamado UsuarioRolLectura se le está asignando el rol Lectura junto con todos sus permisos.

**TEMA 2:** Procedimientos y funciones almacenadas <br>

**TEMA 3:** Optimización de consultas a través de índices <br>

**TEMA 4:** Backup y restore. Backup en línea <br>

## CAPÍTULO III: METODOLOGÍA SEGUIDA

## CAPÍTULO IV: DESARROLLO DEL TEMA / PRESENTACIÓN DE RESULTADOS

### Diagrama relacional
![diagrama_relacional](https://github.com/xMarianoDEV/ProyectoBD/blob/main/doc/image_relational.png)

### Diccionario de datos

Acceso al documento [PDF](doc/diccionario_datos.pdf) del diccionario de datos.

## CAPÍTULO V: CONCLUSIONES
