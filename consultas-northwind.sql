--CONSULTAS EN NORTHWIND
--1.	Liste  de la tabla Employees  la columna country y la logitud (largo)del contenido de esta columna country .  --
USE Northwind

SELECT Country, 
	   LEN(Country) 'Longitud del Contenido'
FROM Employees

--2.	Liste el nombre del empleado, la longitud del mismo y los tres �ltimos caracteres del nombre.  Etiquete cada columna tal cual se muestra
 SELECT FirstName AS 'NOMBRE',
		LEN(FirstName) AS 'LARGO',
		RIGHT(FirstName, 3) AS 'TRES ULTIMOS'
 FROM Employees

/*3.	Liste de la tabla Employees  la columna FIRSTNAME:
-	 Primero desplegada  tal cual se encuentra  almacenada, 
-	 Luego en may�scula cerrada 
-	 Finalmente en min�scula
Etiquete cada una de las columna como:
NOMBRE, 
MAY�SCULA, 
MIN�SCULA */
SELECT FirstName AS NOMBRE,
	   UPPER(FirstName) AS MAYUSCULA,
	   LOWER(FirstName) AS MINUSCULA
FROM Employees

/*4.	De la tabla Employees liste la columna FIRSTNAME (en may�scula cerrada) y a la columna LASTNAME (en minuscula cerrada) como una sola columna titulada Nombre del Empleado. 
Garantice  que entre ambos campos exista una separacion de 20 espacios.  Utilice la funci�n space vista en clases.  (formato space(cantidad_espacios)) */
SELECT UPPER(FirstName) + SPACE(20) + LOWER(LastName) AS 'Nombre del Empleado'
FROM Employees

/*5.	Liste de la tabla employees  el Titulo de cortes�a (TitleOfCourtesy), el Apellido(lastname) y la inicial del nombre (firstname)con un punto al lado de la letra inicial.  Todos estos campos deben desplegarse como uno solo bajo la etiqueta �EMPLEADO�.  
Adem�s liste las 4 primeras letras del campo city como una columna adicional*/
SELECT TitleOfCourtesy + LastName + SPACE(1) + LEFT(FirstName, 1) + '.' AS EMPLEADO,
	   LEFT(City, 4) AS CIUDAD
FROM Employees

/*6.	Usando la funci�n STR, visualice como  car�cter el campo  de la tabla orders llamado Freight  que es de tipo money.   Necesitamos sea mostrado de la siguiente manera:
	el campo freight tal cual se encuentra almacenado,
	 el campo freight como una cadena de  longitud 6 con dos decimales, 
	el mismo campo como cadena, con una longitud de 4 y un decimal y
   finalmente el mismo campo como cadena,  con una longitud total de 2 y 1 decimal.  
   Analice los resultados obtenidos y  explique  para cada STR aplicado, el  resultado obtenido. */
SELECT Freight, 
	   STR(Freight, 6, 2) 'Longitud 6', 
	   STR(Freight, 4, 1) 'Longitud 4',
	   STR(Freight, 2, 1) 'Longitud 2'
FROM Orders

/*7.	Usando la funci�n ROUND, realice una sola consulta a la tabla orders, listando el campo freight tal cual se encuentra almacenado, el campo freight redondeado  seg�n las siguientes longitudes: 0, 1, 2, -1 y  -2  
Analice los resultados obtenidos y  explique  para cada round aplicado, el  resultado obtenido. */
SELECT Freight, 
	   ROUND(Freight, 0) 'Longitud 0', 
	   ROUND(Freight, 1) 'Longitud 1',
	   ROUND(Freight, 2) 'Longitud 2',
	   ROUND(Freight, -1) 'Longitud -1',
	   ROUND(Freight, -2) 'Longitud -2'
FROM Orders

--8.	De la tabla orders, muestre el OrderID ,OrderDate y ShipName de todas las �rdenes recibidas en el mes 1 del a�o 1998 y que fueron enviadas en la embarcaci�n llamada �LINO-Delicateses�
SELECT OrderID, OrderDate, ShipName 
FROM Orders
WHERE MONTH(ShippedDate) = 1 AND YEAR(ShippedDate) = 1998 AND ShipName ='LINO-Delicateses'

--9.	Realice una consulta para obtener la fecha y hora del sistema.  Utilice la funci�n sysdatetime y tambien la funci�n getdate.
SELECT SYSDATETIME()
SELECT GETDATE()

/*10.	Por politica, la empresa tiene 5 d�as para entregar los pedidos.  Conociendo que OrderDate es la fecha en que se hizo la orden, calcule la fecha exacta en que deber� estar listo cada pedido.  
Muestre el c�digo de la orden, la fecha de la orden y la fecha en que debe estar listo el mismo. */
SELECT OrderID 'Orden ID', 
	   OrderDate 'Fecha de Orden', 
	   DATEADD(day, 5, OrderDate) 'Fecha de Entrega'
FROM Orders
--11.	Calcule cuantos a�os tiene un empleado.  Para tal fin, utilice la fecha de cumplea�os que se encuentra en la tabla employees.  Liste el nombre del empleado, la fecha de nacimiento y la edad.
SELECT  FirstName AS Nombre,
		BirthDate AS 'Fecha de Nacimiento',
		DATEDIFF(YEAR, BirthDate,GETDATE()) AS Edad
FROM Employees

--12.	La alta gerencia le ha solicitado un listado de todos los  nombres de los empleados  y el d�a de cumplea�os, de los cumplea�eros del mes de septiembre.
SELECT FirstName AS Nombre,
	   DAY(BirthDate) AS 'Dia del Mes'
FROM Employees
WHERE DATEPART(MONTH,BirthDate) = 9

--13.	Muestre cuantos d�as faltan para llegar a navidad
SELECT DATEDIFF(DAY, GETDATE(), '2021/12/25') 'D�AS PARA NAVIDAD'

--14.	Muestre el registro de cuantos d�as transcurrieron desde que se hizo la orden (orderdate) y la fecha en que se embarc� la misma (shippedDate).
SELECT OrderID, 
	   DATEDIFF(DAY, OrderDate, ShippedDate) AS 'Dias Transcurridos'
FROM Orders

/*15.	Cree una tabla llamada  REGISTRO que contenga los tres campos siguientes:
Usuario  char (10)
Contrase�a  char(8)
Fecha_acceso  datetime  
------
Se desea que el campo fecha tome por default la fecha del sistema.  
El campo contrase�a debe contener en cualquier posici�n,  alguno de  estos tres caracteres especiales (�  @  �).
(Muestre la creaci�n de la tabla)
------
Una vez creada la tabla, Inserte un registro con los siguientes valores:
User = Jeannette
Pass= ABCD   (muestre el insert)
------
Ahora liste los datos usando un select */
CREATE TABLE REGISTRO (
	ID_usuario INT NOT NULL,
	contrase�a CHAR(8) NULL,
		CONSTRAINT LARGO_CAMPO_ID
			CHECK
)

--16.	Liste todas las �rdenes de abril, mayo y junio del a�o 1997.  Presente el n�mero de orden y la fecha
SELECT OrderID, OrderDate 
FROM Orders 
WHERE DATEPART (year, OrderDate) = 1997 AND (MONTH(OrderDate)= 4 OR MONTH(OrderDate)= 5 OR MONTH(OrderDate)= 6)

--17.	Muestre (sin duplicar) el nombre de todos los productos que fueron ordenados en agosto de 1997. Para su consulta utilice un join. 
SELECT DISTINCT a.ProductName
FROM Products a
INNER JOIN [Order Details] b ON a.ProductID = b.ProductID
INNER JOIN Orders c ON b.OrderID = c.OrderID AND (YEAR(c.OrderDate)= 1997)