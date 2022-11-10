--PROCEDIMIENTOS ALMACENADO CON NORTHWIND
--1.	Todos los productos que inicien con un car�cter (o varios) en especial
CREATE PROCEDURE  pa_Producs_x_Name
				@ProductName varchar(50)
AS
  SELECT  *  
  FROM Products
  WHERE Productname  LIKE  @ProductName+'%'

execute pa_Producs_x_Name 'A'

--2. Seleccionar el nombre del producto y su precio localizado por su campo c�digo (ProductID). Este procedimiento utiliza 3 par�metros: 1 tipo INPUT  (ProductID) y dos de salida OUTPUT (ProductName y UnitPrice). Dentro del procedimiento, los campos del registro seleccionado son guardados en los par�metros de salida y luego, fuera del procedimiento,  se los transfieren a variables de memoria las que se visualizan con SELECT d�ndoles un ALIAS para visualizaci�n.
CREATE PROCEDURE pa_Producs_Traer_Nombre_Precio
	@ProductID int,
	@ProductName  varchar(50) output,
	@UnitPrice  Money output
AS
       SELECT @ProductName = ProductName,
		@UnitPrice = UnitPrice
       FROM Products
	WHERE ProductID = @ProductID

declare @Nombre varchar(50), @Precio Money
Execute pa_Producs_Traer_Nombre_Precio
		10, @Nombre OUTPUT, @Precio OUTPUT
SELECT @Nombre AS Nombre,  @Precio AS Precio

--3. Procedimiento almacenado que cuente los productos que empiezan con un determinado character ( o caracteres)
CREATE PROCEDURE pa_Product_cantidad
  @ProductName varchar(50)
AS
  DECLARE @Cantidad int
  SELECT @Cantidad = COUNT(*)
     FROM Products 
     WHERE productName  LIKE  @ProductName+'%'
  RETURN @Cantidad

DECLARE @R int
EXECUTE @R = pa_Product_cantidad 'A'
SELECT @R AS Cantidad

--4. Modifique el procedimiento anterior, de tal forma que en lugar de seleccionar por el campo (ProductName) se realice de acuerdo al c�digo de la categor�a (CategoryID).  Haga los ajustes necesarios.
CREATE PROCEDURE pa_Product_cantidad2
  @categoryID varchar(50)
AS
  DECLARE @Cantidad int
  SELECT @Cantidad = COUNT(*)
     FROM Products 
     WHERE CategoryID  LIKE  @categoryID +'%'
  RETURN @Cantidad

DECLARE @R int
EXECUTE @R = pa_Product_cantidad 'A'
SELECT @R AS Cantidad

--5.  Corra los siguientes ejemplos y vea que 
--ejemplo 1
Create procedure pa_Products_Todos
AS
   SELECT *  
     FROM Products

pa_Products_Todos     
exec pa_Products_Todos
execute pa_Products_Todos

--ejemplo 2
DROP PROCEDURE pa_Producs_PrecioMayor
CREATE PROCEDURE pa_Producs_PrecioMayor
  @Precio money OUTPUT
AS
  SELECT @precio = MAX(unitPrice) FROM Products

DECLARE @p money
execute pa_Producs_PrecioMayor @p OUTPUT
SELECT @p
-----Nota
--ALTER PROCEDURE para modificar el procedimiento

--Ejemplo 3
CREATE PROCEDURE pa_Products_cantidad
AS  
  DECLARE @cantidad int
  SELECT @cantidad = COUNT(*) FROM Products
  RETURN @cantidad

DECLARE @r int
execute @r = pa_Products_cantidad
select @r

--Ejemplo 4
CREATE PROCEDURE pa_Producs_PrecioMayor_PrecioMenor
  @categoriaName varchar(40),
  @PrecioMayor money OUTPUT,
  @PrecioMenor money OUTPUT
AS
  SELECT @PrecioMayor = MAX(p.unitPrice),
         @PrecioMenor = MIN(p.unitPrice)
     FROM Products AS p INNER JOIN categories AS c
       ON  p.CategoryID = c.CategoryID
      WHERE c.CategoryName LIKE @CategoriaName + '%'

DECLARE @p money
DECLARE @q money
exec pa_Producs_PrecioMayor_PrecioMenor 'Confections', @p OUTPUT, @q OUTPUT
SELECT @p, @q
SELECT @p AS PRECIO_MAYOR , @q AS PRECIO_MENOR

--ejemplo 5
DROP PROCEDURE pa_Clientes_Eliminar
CREATE  PROCEDURE pa_Clientes_Eliminar
  @CustomerID varchar(50)
AS
  DECLARE @r int
  IF EXISTS (SELECT * FROM orders WHERE CustomerID =  @CustomerID )
    RETURN 1
  ELSE
    DELETE FROM Customers WHERE CustomerID = @CustomerID
    RETURN 0
RETURN @r 

DECLARE @r int
execute @r = pa_Clientes_Eliminar 'PEDRO'
SELECT @r AS Valor_de_retorno 

DECLARE @r int
execute @r = pa_Clientes_Eliminar 'LILAS'
SELECT @r AS Valor_de_retorno 
