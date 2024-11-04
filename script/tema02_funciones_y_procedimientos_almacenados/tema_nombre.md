# Tema 2 - Procedimientos y funciones almacenadas.

En SQL, los procedimientos almacenados y las funciones almacenadas son conjuntos de instrucciones que se almacenan en el servidor de la Base de datos y pueden ser utilizados. Sin embargo, tienen varias diferencias entre sí:
1) Proposito general:
    - Procedimiento Almacenado (Stored Procedure): El propósito es ejecutar una serie de instrucciones que pueden realizar diversas operaciones, tales como insertar, actualizar o eliminar datos, sin necesidad de retornar un valor en específico.
    - Función almacenada  (Stored function): Su propósito principal es devolver un solo valor (o tabla en algunos casos) después de realizar algún cálculo o procesamiento. Las funciones son principalmente para operaciones que devuelven un resultado.
2) TIpo de retorno:
    - Procedimiento: Puede devolver múltiples valores mediante parámetros de salida, pero no tiene un valor de retorno en sí.
    - Función: Siempre devuelve un valor, que puede ser un número, texto, fecha u otro tipo de dato específico.
3) Uso de consultas en SQL
Un procedimiento almacenado no se puede usar directamente en una consulta SELECT o WHERE, a diferencia de las funciones almacenadas que pueden ser utilizadas en consultas ya que devuelven un valor que se puede evaluar.
4) Entradas y salidas
En el caso de los procedimientos almacenados estos pueden tener parámetros tanto de entrada, de salida, y de entrada/salida. Las funciones almacenadas por otra parte solo permiten parámetros de entrada.
5) Capacidad de modificar datos
    - Procedimiento: Puede realizar modificaciones en los datos (INSERT, UPDATE, DELETE).
    - Función: En general, no debería poder modificar los datos (aunque en algunas bases de datos se puede hacer, no es una práctica recomendada).
6) Ejecución
    - Procedimiento: Se ejecuta con el comando EXEC o CALL.
    - Función: Se invoca como parte de una expresión o dentro de una consulta:
## Conclusiones:
Los procedimientos almacenados en SQL son mucho más faciles de crear y las funciones tienen una estructura más rígida y admiten menos cláusulas y funcionalidades. 
En una funcion escalar, puede devolver solo una variable y en un procedimiento almacenado múltiples variables. Sin embargo, para llamar a las variables de salida en un procedimiento almacenado, es necesario el declarar variables fuera del procedimiento para poder invocarlo.
Asimismo, no se pueden invocar procedimientos dentro de una función. Pero, por otro lado, en un procedimiento se puede invocar funciones y procedimientos almacenados.

Finalmente, es muy importante mencionar que según el trabajo que vayamos a desempeñar, va a resultar más conveniente utilizar una función almacenada o un procedimiento almacenado según las necesidades a solventar en nuestro proyecto, seleccionando el esquema más conveniente en base a las diferencias mencionadas entre ambas dentro de este informe.

