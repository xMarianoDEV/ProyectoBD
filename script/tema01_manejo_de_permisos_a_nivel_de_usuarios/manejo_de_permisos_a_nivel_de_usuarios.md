## Manejo de permisos a nivel de usuario de base de datos

En SQL Server, el manejo de permisos a nivel de usuarios es un conjunto de configuraciones que permiten controlar las acciones que realizan los usuarios en una base de datos, asegura que solo algunos usuarios seleccionados puedan realizar ciertas acciones sobre la base de datos, manteniendo así una mejor seguridad e integridad de los datos.

Los permisos se pueden asignar en diferentes niveles de la base de datos, hasta a objetos específicos de la misma, así como tablas, procedimientos almacenados, funciones, etc. Se incluyen operaciones como **SELECT, INSERT, UPDATE, DELETE**, etc. Pero antes, se deben crear credenciales para ingresar al servidor, o mejor conocido como **Logins**, luego de eso, se deben crear los usuarios, que permitirán ingresar a la base de datos de preferencia y estarán asociadas a un **Login**.

Estos permisos son asignados mediante otro usuario administrador o uno que cuenta con los permisos para asignar permisos, a través de la sentencia **GRANT**. Y si se quieren quitar permisos o privilegios se utiliza la sentencia **REVOKE**.

>*Ejemplo*: **GRANT SELECT ON vendedor TO usuarioLectura**
En este ejemplo se otorgan permisos de lectura sobre la tabla vendedor al usuario llamado usuarioLectura.

> *Ejemplo*: **REVOKE EXECUTE on InsertCliente to usuarioLectura**
En este ejemplo se revocan los permisos de ejecutar el procedimiento almacenado "InsertCliente" al usuario llamado usuarioLectura.

Al poder asignar permisos a ejecutar solo procedimientos almacenados se puede lograr que el usuario no tenga acceso directo a las tablas y se controla el acceso a los datos mediante la lógica y funcionalidad definida del procedimiento.

## Manejo de permisos a nivel de roles del sistema gestor de base de datos

En SQL Server, también se pueden asignar roles a los usuarios, roles personalizados o roles que vienen por defecto en el motor de base de datos. Los cuales permiten agrupar los permisos y asignarlos a distintos usuarios, simplificando y optimizando la administración de permisos con el objeto de no estar configurandolos de manera individual.

Existen dos tipos de roles:
- **Roles de servidor:** Son aquellos que controlan los permisos a nivel del servidor completo, afectando todas las bases de datos del servidor. Por ejemplo: sysadmin, otorga permisos completos sobre todo el servidor y sus bases de datos.
- **Roles de base de datos:** Son aquellos que otorgan permisos sobre objetos específicos de una base de datos. Por ejemplo: db_datareader, que permite leer los datos de todas las tablas de una base de datos.

Los roles personalizados o definidos por el usuario se configuran con permisos específicos y pueden ser asignados a varios usuarios.
> *Ejemplo:* **CREATE ROLE [Lectura]
		GRANT SELECT ON [dbo].[cliente] TO [Lectura]**
En este ejemplo se está creando un rol llamado Lectura y se le agrega el permiso de leer los datos de la tabla cliente.

Además cabe recalcar que no se pueden crear roles de servidor personalizados, solo roles de base de datos.

**Conclusión:**
Al trabajar con permisos a nivel de usuario se tiene un control más detallado ya que se asignan permisos específicos a cada usuario sin afectar a otros, pero al trabajar con muchos usuarios se puede volver difícil de manejar y lo recomendable sería utilizar permisos a nivel de roles, evitando también así asignar permisos no deseados.
