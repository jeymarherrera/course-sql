--CONSULTAS EN NORTHWIND
USE Northwind

--1.	Declare una variable llamada "@nombre" de tipo "varchar(20)" y as�gnele su nombre; luego liste el contenido de la variable ( vea su contenido).

DECLARE @nombre VARCHAR(20)
	SET @nombre = 'Jeymar'

SELECT @nombre

/*2.	Usando la tabla Products, encuentre cual es el mayor y menor precio y luego liste los mismos, usando los siguientes formatos:
PRECIO MAYOR =  99999             PRECIO MENOR = 99999

		PRECIO MAYOR             PRECIO MENOR 
           99999                    99999*/
--formato 1
DECLARE @preciomayor MONEY, 
        @preciomenor MONEY
		
SELECT @preciomayor = MAX(UnitPrice),
	   @preciomenor = MIN(UnitPrice)
FROM Products

SELECT 'Precio Mayor ='+  STR (@preciomayor,7,2),
       'Precio Menor =' + STR(@preciomenor,7,2)

--formato2 
DECLARE @preciomayor MONEY, 
        @preciomenor MONEY
		
SELECT @preciomayor = MAX(UnitPrice),
	   @preciomenor = MIN(UnitPrice)
FROM Products

SELECT @preciomayor as 'Precio Mayor',
       @preciomenor as'Precio Menor'

--3. Se desea que usted liste todos los empleados  que trabajan en la empresa (BD Northwind, tabla employees), colocando primero el nombre completo de su t�tulo de cortes�a (ejemplo en lugar de Mrs.  Colocar Se�ora, en lugar de Mr.  Colocar Se�or, en lugar de Ms. Colocar se�orita, seguido de su primer nombre y luego su apellido, todo esto en una sola columna.

DECLARE @nombre VARCHAR(20),
		@apellido VARCHAR(20),
		@titulo VARCHAR(10)

SELECT @nombre = FirstName,
	   @apellido = LastName,
	   @titulo = TitleOfCourtesy
FROM Employees

SELECT Nombre = (CASE
					WHEN TitleOfCourtesy = 'Ms.' THEN 'Se�orita'
					WHEN TitleOfCourtesy = 'Mrs.' THEN 'Se�ora'
					WHEN TitleOfCourtesy = 'Mr.' THEN 'Se�or'
					WHEN TitleOfCourtesy = 'Dr.' THEN 'Doctor'
ELSE '_'
END) + ' ' + FirstName + ' ' + LastName
FROM Employees

--Modifique el problema anterior de tal forma que en una segunda columna se despliegue una etiqueta  que diga CUMPLEA�ERO y en la columna se despliegue el nombre del mes.    Realice el problema utilizando una variable a la cual se le asigne un mes en particular y el problema despliegue el mensaje, solo para el que cumple en el mes especificado.  Debe listarse en una  segunda columna, tal cual se ilustra. Colocando el literal �mes� y el nombre del mes; todo en may�scula cerrada
DECLARE @nombre VARCHAR(20),
		@apellido VARCHAR(20),
		@titulo VARCHAR(10),
		@cumplea�os INT

SELECT @nombre = FirstName,
	   @apellido = LastName,
	   @titulo = TitleOfCourtesy,
	   @cumplea�os = 1
FROM Employees

SELECT Nombre = (CASE
					WHEN TitleOfCourtesy = 'Ms.' THEN 'Se�orita'
					WHEN TitleOfCourtesy = 'Mrs.' THEN 'Se�ora'
					WHEN TitleOfCourtesy = 'Mr.' THEN 'Se�or'
					WHEN TitleOfCourtesy = 'Dr.' THEN 'Doctor'
ELSE ' '
END) + ' ' + FirstName + ' ' + LastName,
	Cumplea�ero = (CASE
					WHEN MONTH(BirthDate) = @cumplea�os THEN 'MES' + ' ' + UPPER(DATENAME(MONTH, BirthDate))
	ELSE ' '
END)
FROM Employees

/*5.	Cree el scrip que permita verificar si existe en la tabla �Region� la regi�n con id =4.  
Si existe debe actualizar el nombre de la regi�n por �� Norte�; si no existe, debe insertar este nombre como un registro nuevo. 
Utilice variables que le permitan modificar los valores de los campos de comparaci�n (regi�n y nombre de regi�n)
Corra su scrip y muestre sus resultados*/

DECLARE @region VARCHAR(10)
IF EXISTS (
	SELECT * 
	FROM Region
	WHERE RegionID = 4)
		BEGIN
			UPDATE Region
			SET RegionDescription = 'Norte'
			WHERE RegionID = 4
		END
ELSE
	INSERT INTO Region
	VALUES(4, 'Norte')

SELECT *
FROM Region

--6.	Ahora cambie  el  valor de la regi�n por 100 y vea que ocurre.  Muestre sus resultados.
DECLARE @region VARCHAR(10)
IF EXISTS (
	SELECT * 
	FROM Region
	WHERE RegionID = 100)
		BEGIN
			UPDATE Region
			SET RegionDescription = 'Norte'
			WHERE RegionID = 4
		END
ELSE
	INSERT INTO Region
	VALUES(4, 'Norte')

SELECT *
FROM Region 


--7.	Realizar un procedimiento almacenado que recibiendo como par�metro de entrada la categor�a, devuelva el precio mayor y el precio menor de los productos.  Liste el nombre de la categor�a y los los precios solicitados.  (Obs. Ambas tablas est�n relacionadas por el campo CategoryID, BD Northwind)
DROP PROC Precios

CREATE PROC Precios (@categoria VARCHAR(20)) AS

BEGIN
DECLARE @preciomayor MONEY,
		@preciomenor MONEY,
		@ID INT

SELECT @ID = CategoryID
FROM Categories
WHERE CategoryName = @categoria

SELECT @preciomayor = MAX(UnitPrice),
	   @preciomenor = MIN(UnitPrice) 
FROM Products AS p 
	INNER JOIN Categories ON @ID = p.CategoryID

SELECT @categoria AS 'Categoria',
	   @preciomayor AS 'Precio Mayor',
	   @preciomenor AS 'Precio Menor'
END

EXEC Precios 'Beverages'



/*8.	Realice un procedimiento que permita eliminar  de la tabla (Customers), un cliente particular, si �ste no tiene �rdenes (no aparece en la tabla orders).  El procedimiento deber� recibir como par�metro de entrada el (CustomerID). 
Si existe el cliente en la tabla ORDERS, el procedimiento debe devolver el  valor 1 (No se puede eliminar, pues tiene ordenes pendientes de entrega) caso contrario devuelve 0 (que indica que se elimin�).  
El programa principal debe recibir este indicador (1 � 0) e imprimir si se elimin� o no el cliente.
Pruebe su procedimiento 
�	con el valor �Lilas� y luego 
�	con el valor �Pedro� */
CREATE PROC eliminarCliente(@ID VARCHAR(10),
							@indicador INT OUTPUT) AS
IF EXISTS (
	SELECT *
	FROM Orders
	WHERE CustomerID = @ID)
		SET @indicador = 1
ELSE
	BEGIN
		SET @indicador = 0
			DELETE FROM Customers
			WHERE CustomerID = @ID
END

--forma1
DECLARE @ID VARCHAR(10), 
		@mensaje INT
SET @ID = 'Lilas'

EXEC eliminarCliente
	@ID, @mensaje OUTPUT

IF @mensaje = 1
	SELECT 'S� se elimin� al cliente' AS Mensaje
ELSE
	SELECT 'No se elimin� al cliente' AS Mensaje

--formar2
DECLARE @ID VARCHAR(10), 
		@mensaje INT

SELECT @ID = CustomerID
FROM Customers
WHERE ContactName LIKE '%Pedro%'

EXEC eliminarCliente
	@ID, @mensaje OUTPUT

IF @mensaje = 1
	SELECT 'S� se elimin� al cliente' AS Mensaje
ELSE
	SELECT 'No se elimin� al cliente' AS Mensaje