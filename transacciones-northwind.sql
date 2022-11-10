--TRANSACCIONES CON NORTHWIND
/*
BEGIN TRY                   
   EXPRESIONES_SQL     
END TRY 

BEGIN CATCH 
  EXPRESIONES_SQL 
END CATCH 
*/

BEGIN TRY 
	DECLARE @DIVISOR INT, @DIVIDENDO INT, @RESULTADO INT
	SET @DIVIDENDO = 100
	SET @DIVISOR = 0
	SET @RESULTADO = @DIVIDENDO/@DIVISOR
	PRINT 'NO HAY ERROR'
END TRY

BEGIN CATCH
	PRINT 'SE HA PRODUCIDO UN ERROR'
	PRINT ERROR_NUMBER() --numero del error
	PRINT ERROR_SEVERITY() --severidad del error
	PRINT ERROR_STATE() --estado del error
	PRINT ERROR_PROCEDURE() --nombre del procedimiento almacenado que ha provocado el error
	PRINT ERROR_LINE() -- devuelve el numero de linea en la que se ha producido el error
	PRINT ERROR_MESSAGE() --devuelve el mensaje de error
END CATCH
--try catch no se detecta cuando: la gravedad es 10 o inferior, gravedad 20 o superior
--catch error de compilacion, sintaxis

CREATE PROCEDURE usp_ejemplo
AS
	SELECT*
	FROM Tablaexistente
GO

BEGIN TRY
    EXECUTE usp_ejemplo
END TRY

BEGIN CATCH
	SELECT
	ERROR_NUMBER() AS ERRORNUMBER
	ERROR_MESSAGE() AS ERRORMESSAGE
END CATCH

--Variable @@error para transact, si devuelve 0 es que no encontro error, si es 0 hubo error
--errores en vista de catalogo sys.sysmessages.error, contendra el error

SELECT TerritoryID, TerritoryDescription
FROM Territories
ORDER BY 2 ASC, 0 DESC

SELECT *
FROM sys.sysmessages

--detectar un error
UPDATE Employees
	SET BirthDate = '12-11-2016'
	WHERE EmployeeID = 1
IF @@ERROR = 547
	PRINT 'La actualizacion viola el check del cumplea�os'

SELECT *
FROM sys.sysmessages


--para salir condicionalmente de un error
CREATE PROCEDURE proc_borrar_empleado 
        @CandidateID INT
    AS
-- Ejecuta el borrado
DELETE FROM JobCandidate
    WHERE JobCandidateID = @CandidateID

-- Inmediatamente eval�a la variable @@error para verificar si hubo error
IF @@ERROR <> 0 
    BEGIN
 	-- Devuelve el valor 99 al prog princ para indicar 	que hubo error en el procedimiento.
        PRINT  �Ocurrio un error al borrar el empleado'
        RETURN 99
    END
ELSE
    BEGIN
	-- Devuelve  al prog princ  el valor 0 para indicar 	que se realiz� con �xito el borrado 

       PRINT  �El registro del empleado fu� borrado'
        RETURN 0
    END

--combina @@error con try catch
BEGIN TRY
	UPDATE Employees
		SET BirthDate = '12-11-2016'
		WHERE EmployeeID = 1
END TRY

BEGIN CATCH
	IF @@ERROR = 547
		PRINT 'La actualizacion viola el check del cumplea�os'

END CATCH

SELECT *
FROM sys.sysmessages

--RAISERROR, bandera para situaciones particulares
--ejemplo paname�o con cedula incorrecta, no hay departamento de construccion indicar error, pedidos fuera de rango
--RAISERROR(MENSAJE, SEVERIDAD(1 A 127, GENERALMENTE 1), ESTADO(0 A 25, SOLO DE 0 A 18. ERROR DE 20 A 25 SON FATALES Y DE 19 A 25 SON ASIGNADOS POR EL ADMIN))

--Ejemplo de dos variables provocando un error si la variable tipo = 1 y la variable clasificacion = 3
DECLARE @TIPO INT, @CLASIFICACION INT
	SET @TIPO = 1
		SET @CLASIFICACION = 3
		IF (@TIPO = 1 AND @CLASIFICACION = 3)
			BEGIN 
				RAISERROR ('EL TIPO NO PUEDE VALER UNO Y LA CLSIFICACION TRES', 16, 1)
			END