
# Tema 3 - Backup y restore. Backup en línea.
## Backup
Un **backup** (copia de seguridad) en SQL, es un proceso de copia de los datos almacenados en una base de datos. La finalidad principal es proteger los datos en caso de fallos, errores de usuario, corrupción de datos o pérdida de información.

#### Existen varios tipos de backup en SQL, los que utilizamos en los scripts son:

- **Backup completo:** Es una copia completa de toda la base de datos, incluyendo datos y registros de transacciones. Se recomienda hacer backups completos regularmente, ya que permite restaurar la base de datos a un estado específico.
- **Backup de log de transacciones:** Este backup registra todas las transacciones que ocurrieron desde el último backup de log o completo, permitiendo restaurar la base de datos hasta un momento específico.

## Restore 
El **restore** (restauración) es el proceso de devolver una base de datos a un estado anterior utilizando un archivo de backup. SQL Server permite restaurar una base de datos completa, aplicar backups diferenciales o restaurar un backup de log de transacciones para recuperar la base de datos hasta un momento específico.

#### Los modos de restauración incluyen:

- **WITH RECOVERY:** Finaliza el proceso de restauración y pone la base de datos en modo operativo.
- **WITH NORECOVERY:** Deja la base de datos en un estado no operativo, permitiendo aplicar múltiples backups (diferenciales o de log) en secuencia.

Si se aplican varios backups en secuencia (por ejemplo, un backup completo seguido de un diferencial y un backup de log), el uso de **NORECOVERY** en los pasos intermedios permite restaurar **todos** los archivos antes de finalizar el proceso.

## Backup en Línea
Un **backup en línea** es un **backup** que se realiza mientras la base de datos está en funcionamiento y accesible para los usuarios. En SQL Server, los backups en línea son posibles gracias al **modelo de recuperación Full** o Bulk-Logged. Esto permite capturar los datos y registros de transacciones mientras se siguen registrando y realizando transacciones en la base de datos.

#### En un entorno transaccional, el backup en línea es esencial para minimizar el tiempo de inactividad, ya que permite:

- Realizar backups completos sin interrumpir la actividad de los usuarios.
- Mantener la base de datos accesible durante los backups de log, lo que permite restaurar hasta el punto de falla en caso de desastres.
- Fundamento de backups en línea: Los backups en línea son fundamentales en escenarios de alta disponibilidad, como sistemas de banca, comercio electrónico, y cualquier aplicación de misión crítica donde se requiere disponibilidad continua.

## En conclusion
Podriamos decir que el **backup en línea** es Ideal para entornos de alta disponibilidad o producción, donde el acceso continuo es esencial. 
Por otro lado, el **backup común** es mayormente enfocado en escenarios donde se pueden programar mantenimientos, como entornos de desarrollo o pruebas.
