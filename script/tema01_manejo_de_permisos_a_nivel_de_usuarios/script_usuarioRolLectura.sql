--Si se ingresa con el usuario que tiene permisos sobre el rol para leer los datos de la tabla cliente
--efectivamente le permitir� ver los datos, sin embargo, los �nicos datos que podr� ver
--en la base de datos, seran solo de esa tabla..

--Si se ingresa con el usuario sin permisos sobre el rol, no podr� ver los datos de la tabla.
select * from cliente

--Si se intenta leer los datos de otra tabla, no podr� ver sus datos.
select * from vendedor