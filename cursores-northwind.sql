--CURSORES CON NORTHWIND
/*1.Utilizando cursor, imprima todas las ordenes realizadas por a�o y el monto al que asciende cada una.

	Los datos aparecen en la base de datos Northwind en las tablas Orders y Order Details.

	Como muestran las im�genes, las ordenes deben listarse clasificadas por a�o.  Se listar� el n�mero de la orden (orderID) 
	y el monto de dicha orden (usar campo cantidad y precio unitario para calcular este monto).  

	Al final de cada a�o, colocar a cu�nto asciende el monto anual.

	Se desea que despu�s de listar todas las �rdenes del primer a�o, se listen las del segundo a�o y as� sucesivamente.

Muestre el scrip realizado y los resultados obtenidos. */

		
SELECT *
FROM Orders
WHERE Year(OrderDate) = '1996'
--OrderID =10248
/* ATRIBUTOS A USAR
-OrderID
-OrderDate - (year) */

SELECT *
FROM [Order Details]
--WHERE OrderID =10248
/* ATRIBUTOS A USAR
-OrderID
-UnitPrice
-Quantity*/


DECLARE @tabla TABLE 
(
orderID  INT,
monto FLOAT
)

DECLARE  @ORDERID AS INT, 
		 @MONTO AS FLOAT, 
		 @YEAR AS INT,
		 @TOTAL AS FLOAT
 
 SET @YEAR = 1996
--SELECT @YEAR = YEAR(o.OrderDate)
--FROM Orders AS o
--GROUP BY YEAR(o.OrderDate)

DECLARE Ordenes CURSOR 
FOR 
SELECT o.OrderID, 
	SUM(od.Quantity*od.UnitPrice) 
	FROM Orders AS o	
	JOIN [Order Details] AS od ON od.OrderID = o.OrderID
	WHERE YEAR(o.OrderDate) =  @YEAR
	GROUP BY o.OrderID	

OPEN Ordenes

FETCH NEXT FROM Ordenes 
INTO @ORDERID, @MONTO

WHILE @@fetch_status = 0
BEGIN
	

	INSERT INTO @tabla 
	values (@ORDERID,@MONTO)

	SELECT @TOTAL= SUM(@MONTO)
	FROM @tabla

	FETCH NEXT from Ordenes INTO @ORDERID, @MONTO

END

PRINT 'A�O: ' + CAST(@YEAR AS VARCHAR)
SELECT *  
FROM @tabla
PRINT 'A�O: ' + CAST(@YEAR AS VARCHAR) + '  IMPORTE: ' + STR(@TOTAL)
CLOSE Ordenes
DEALLOCATE Ordenes

/*Ahora modifique su cursor para que liste las �rdenes realizadas anualmente, pero un empleado en particular.  
El c�digo del empleado es recibido como par�metro de entrada en un procedimiento.  
(El procedimiento que crear� maneja los datos a trav�s del cursor, por lo que el cursor es parte del cuerpo del procedimiento)
Una vez creado su procedimiento, pruebe el mismo enviando el c�digo de empleado 5.
*/
SELECT *
FROM Orders
WHERE Year(OrderDate) = '1996' AND EmployeeID = 5
--OrderID =10248
/* ATRIBUTOS A USAR
-OrderID
-OrderDate - (year) 
-EmployeeID */

SELECT *
FROM [Order Details]
--WHERE OrderID =10248
/* ATRIBUTOS A USAR
-OrderID
-UnitPrice
-Quantity*/
DROP PROCEDURE pa_empleadoC
CREATE PROCEDURE pa_empleadoC
	@empleadoID NCHAR(5)
AS
IF EXISTS (
	SELECT EmployeeID
	FROM Orders
	WHERE EmployeeID = @empleadoID )
	
	BEGIN

	DECLARE @tabla TABLE 
	(
	orderID  INT,
	monto FLOAT
	)

	DECLARE  @ORDERID AS INT, 
			 @MONTO AS FLOAT, 
			 @YEAR AS INT,
			 @TOTAL AS FLOAT
 
	 SET @YEAR = 1996
	--SELECT @YEAR = YEAR(o.OrderDate)
	--FROM Orders AS o
	--GROUP BY YEAR(o.OrderDate)

	DECLARE Ordenes2 CURSOR 
	FOR 
	SELECT o.OrderID, 
		SUM(od.Quantity*od.UnitPrice) 
		FROM Orders AS o	
		JOIN [Order Details] AS od ON od.OrderID = o.OrderID
		WHERE YEAR(o.OrderDate) =  @YEAR AND o.EmployeeID = @empleadoID
		GROUP BY o.OrderID	

	OPEN Ordenes2

	FETCH NEXT FROM Ordenes2 
	INTO @ORDERID, @MONTO

	WHILE @@fetch_status = 0
	BEGIN
	

		INSERT INTO @tabla 
		values (@ORDERID,@MONTO)

		SELECT @TOTAL= SUM(@MONTO)
		FROM @tabla

		FETCH NEXT from Ordenes INTO @ORDERID, @MONTO

	END

	PRINT 'A�O: ' + CAST(@YEAR AS VARCHAR)
	SELECT *  
	FROM @tabla
	PRINT 'A�O: ' + CAST(@YEAR AS VARCHAR) + '  IMPORTE: ' + STR(@TOTAL);
	END
ELSE
	PRINT 'EL EMPLEADO NO EXISTE'

CLOSE Ordenes2
DEALLOCATE Ordenes2

EXEC pa_empleadoC 5

