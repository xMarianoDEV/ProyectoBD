# Optimización de Consultas a través de Índices
## Introducción
En SQL, los índices son estructuras de datos que mejoran la velocidad de las operaciones de consulta en una base de datos. Los índices se crean en columnas específicas de las tablas para permitir un acceso rápido y eficiente a las filas. 

Índices Agrupados (Clustered Index): Organizan físicamente los datos de la tabla en el orden del índice. Cada tabla sólo puede tener un índice agrupado, ya que define el orden físico de los datos. Son ideales para consultas que involucran rangos de datos.  Tambien se realizan consultas que devuelven un rango de datos debido a que los datos están almacenados en un orden específico.

## Aplicación:
- Consultas que implican rangos de fechas o rangos de números.
- Consultas que requieren ordenar datos.


Índices No Agrupados (Non-Clustered Index): Mantienen una estructura separada del orden físico de los datos. Una tabla puede tener múltiples índices no agrupados. Son útiles para búsquedas específicas y consultas que no necesariamente involucran un rango continuo de datos por lo tanto se crea una estructura separada de los datos de la tabla. Incluye punteros que referencian la ubicación física de los datos.

## Aplicación:
- Consultas que buscan datos específicos.
- Consultas que necesitan acceder rápidamente a una o pocas filas.


El impacto de los índices en el rendimiento de las consultas son:

- Comparar tiempos de respuesta antes y después de aplicar índices.
- Analizar los planes de ejecución de las consultas para entender cómo los índices afectan el rendimiento.
  
## Conclusiones

El uso de índices, tanto agrupados como no agrupados, puede mejorar drásticamente el rendimiento de las consultas en bases de datos. Los índices agrupados son particularmente eficaces para consultas que requieren rangos de datos, mientras que los índices no agrupados son útiles para búsquedas específicas. La correcta elección y aplicación de índices reduce considerablemente los tiempos de respuesta y optimiza el rendimiento general del sistema.

Las pruebas realizadas demostraron que:

- Índices Agrupados: Son más adecuados para consultas que requieren ordenación y rangos de datos.

- Índices No Agrupados: Son útiles para búsquedas rápidas y consultas que necesitan acceder a datos específicos.
  
La elección del tipo de índice depende de las necesidades específicas de las consultas y el tipo de datos que se manejan. Implementar índices de manera estratégica puede resultar en una mejora significativa en el rendimiento de las operaciones de consulta en una base de datos.

