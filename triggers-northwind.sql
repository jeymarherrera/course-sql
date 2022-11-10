--ejemplo TRIGGERS CON NORTHWIND
CREATE TRIGGER modificacion_Clientes
ON Customers 
FOR UPDATE AS
PRINT 'Han actualizado la tabla de Customers'

UPDATE Customers
SET ContactName = 'Maria Walters'
WHERE CustomerID = 'AROUT'

SELECT *
FROM Customers
WHERE CustomerID = 'AROUT'

/*1	Utilizando el ejemplo anterior. Escriba un  desencadenador que inserte una fila en la tabla pedidos (ORDERS) y envi� el   mensaje �Se ha actualizado la tabla�.    
�	Inserte una fila de datos y muestre los resultados obtenidos.*/
DROP TRIGGER insercion_ordenes

CREATE TRIGGER insercion_ordenes
ON Orders
FOR INSERT 
AS
	SELECT 'Se ha actualizado la tabla' AS Mensaje
	SELECT *
	FROM inserted

INSERT INTO Orders (CustomerID, EmployeeID, OrderDate, RequiredDate, ShipVia, Freight)
VALUES('RATTC', 4, '1990/06/06', '1990/08/07', 2, 9.53)

SELECT *
FROM Orders

--DELETE FROM Orders WHERE RequiredDate ='1990/08/07'

/*2	Ahora codifique otro trigger  para la tabla product (PRODUCTS) pero que se active cuando se actualiza alg�n producto.  El trigger debe actualizar  el dato y enviar el mensaje �Usted ha actualizado el Registro� y seguido listar el valor que tenia antes  y el nuevo valor.
�	Pruebe su trigger cambiando el nombre del producto con Productid=1  a 'Queso'*/
CREATE TRIGGER actualizacion_producto
ON Products
FOR UPDATE
AS
SELECT 'Usted ha actualizado el Registro' AS Mensaje
SELECT *
FROM inserted

UPDATE Products
	SET ProductName = 'Queso'
	WHERE ProductID = 1

/*3	Defina un desencadenador INSTEAD OF para la tabla [Order Details] que se disparare cuando se inserte o se actualice la tabla  Order Details y que verifique si la cantidad de productos a ordenar es mayor que la cantidad de productos en existencia (tabla product campo quantity).
�	Despues de crear el trigger, verifique la cantidad de productos (Unit in Stock) que tenemos del producto con ProductID=11 y ProductID=12  Tenga estos valores en mente para que compruebe si su trigger est� funcionando correctamente
�	Inserte ahora los  siguientes datos para comprobar el funcionamiento de su trigger.  Inicialmente inserte una cantidad (quantity) cuyo valor sea superior al ProductID=12

insert into [Order Details](OrderID,ProductID,UnitPrice,Quantity,Discount)
    values (10999,12,5,100,0)

�	Ahora inserte una cantidad (quantity) cuyo valor sea menor al ProductID=11 visualizado en la tabla Products

insert into [Order Details](OrderID,ProductID,UnitPrice,Quantity,Discount)
    values (10999,11,5,10,0)

�	Liste de la tabla orderDetail, el contenido de todos los orderID iguales a 10999. 
NOTA:  Observe que se registr� en la orden 10999 para el producto 11 un registro, sin embargo no se descontaron estas cantidades de la tabla producto */
CREATE TRIGGER t_orderDetails
ON [Order Details]
INSTEAD OF
INSERT,
UPDATE
AS
	DECLARE @cantidad_ordenada INT,
			@cantidad_existente INT

	SELECT @cantidad_ordenada = inserted.Quantity,
		   @cantidad_existente = Products.UnitsInStock
	FROM inserted
	JOIN Products ON Products.ProductID = inserted.ProductID

IF @cantidad_ordenada > @cantidad_existente
	SELECT 'Cantidad mayor que la que hay en existencia' AS Mensaje
ELSE
	SELECT 'Cantidad de productos disponibles' AS Mensaje

SELECT UnitsInStock
FROM Products
WHERE ProductID = 11 OR ProductID = 12

INSERT [Order Details] (OrderID, ProductID, UnitPrice, Quantity, Discount)
VALUES (10999,12,5,100,0)

INSERT INTO [Order Details](OrderID, ProductID, UnitPrice, Quantity, Discount)
VALUES (10999,11,5,10,0)

SELECT *
FROM [Order Details]
WHERE OrderID = 10999

/*4.   Ahora actualice el trigger realizado en el punto anterior, para que en caso de que existan cantidades para la venta, se proceda autom�ticamente a disminuir la cantidad insertada en la tabla productos.
�	Liste e imprima de la tabla product, todos los datos del ProducID=14   anote las cantidades en existencia (UnitsStock)
�	Para comprobar si funciona su trigger, introduzca los siguientes valores y vea en la tabla OrderDetails si los mismos fueron incluidos 

insert into [Order Details](OrderID,ProductID,UnitPrice,Quantity,Discount)
    values (10997,14,5,5,0)

�	Ahora liste en la tabla de productos cuanto producto tiene del identificado por el ProductID 14.  Verifique si efectivamente disminuyeron con la nueva inserci�n.*/
ALTER TRIGGER t_orderDetails
ON [Order Details]
INSTEAD OF
INSERT,
UPDATE
AS
	DECLARE @cantidad_ordenada INT,
			@cantidad_existente INT,
			@productoID INT

	SELECT @cantidad_ordenada = inserted.Quantity,
		   @cantidad_existente = Products.UnitsInStock,
		   @productoID = Products.ProductID
	FROM inserted
	JOIN Products ON Products.ProductID = inserted.ProductID

IF @cantidad_ordenada < @cantidad_existente
	
	BEGIN
	UPDATE Products
	SET UnitsInStock = UnitsInStock - @cantidad_ordenada
	WHERE @productoID = ProductID
	SELECT 'Cantidad de productos disponibles' AS Mensaje
	END

ELSE
	SELECT 'Cantidad mayor que la que hay en existencia' AS Mensaje

SELECT *
FROM Products
WHERE ProductID = 14

INSERT INTO[Order Details](OrderID, ProductID, UnitPrice, Quantity, Discount)
VALUES(10997,14,5,5,0)

SELECT *
FROM Products
WHERE ProductID = 14

--5.  Modifique el trigger que acaba de crear en el punto anterior y real�celo ahora del tipo FOR / AFTER.  Haga las pruebas necesarias para validar su trigger.
ALTER TRIGGER t_orderDetails
ON [Order Details]
AFTER
INSERT,
UPDATE
AS
	DECLARE @cantidad_ordenada INT,
			@cantidad_existente INT,
			@productoID INT

	SELECT @cantidad_ordenada = inserted.Quantity,
		   @cantidad_existente = Products.UnitsInStock,
		   @productoID = Products.ProductID
	FROM inserted
	JOIN Products ON Products.ProductID = inserted.ProductID

IF @cantidad_ordenada < @cantidad_existente
	
	BEGIN
	UPDATE Products
	SET UnitsInStock = UnitsInStock - @cantidad_ordenada
	WHERE @productoID = ProductID
	SELECT 'Cantidad de productos disponibles' AS Mensaje
	END

ELSE
	SELECT 'Cantidad mayor que la que hay en existencia' AS Mensaje

SELECT *
FROM Products
WHERE ProductID = 14

INSERT INTO[Order Details](OrderID, ProductID, UnitPrice, Quantity, Discount)
VALUES(10997,14,5,5,0)

SELECT *
FROM Products
WHERE ProductID = 14

/*6.  Ahora codifique un nuevo trigger del tipo Intead of insert , que se active cada vez que deseamos insertar en la tabla Order Detail, enviando el mensaje �UD. NO PUEDE MODIFICAR ESTA TABLA�
�	Despu�s de crear el trigger, proceda a insertar los siguientes datos a la tabla Order Detail

insert into [dbo].[Order Details]
 values (10997,4,8,10,0)

�	Qu� ocurre?  Se insert� o no se insert� el registro.  Liste la tabla OrderDetail con OrderID= 10997 y Explique  que paso?*/
CREATE TRIGGER insercion_orderDetails
ON [Order Details]
INSTEAD OF 
INSERT
AS
SELECT 'UD. NO PUEDE MODIFICAR ESTA TABLA' AS Mensaje

INSERT INTO [Order Details]
VALUES (10997,4,8,10,0)

SELECT *
FROM [Order Details]
WHERE OrderID = 10997

/*7.  Deshabilite el trigger que acaba de crear 
�	Despu�s de deshabilitar el  trigger, proceda a insertar nuevamente los mismos datos a la tabla Order Detail
insert into [dbo].[Order Details]
 values (10997,4,8,10,0)
�	Qu� ocurre?  Se insert� o no se insert� el registro.  Liste la tabla OrderDetail con OrderID= 10997 y explique  qu� paso?*/
ALTER TABLE [Order Details]
DISABLE TRIGGER insercion_orderDetails

INSERT INTO [Order Details]
VALUES (10997,4,8,10,0)

SELECT *
FROM [Order Details]
WHERE OrderID = 10997
/*8.  Por pol�tica institucional �Nunca eliminamos del todo un cliente�, por lo que deseamos que cada vez que se realice el borrado de un cliente de la tabla Customers (BD Northwind), el mismo debe ser almacenado en otra tabla llamada �Cliente_inactivo�, en la cual se mantendr�n todos los datos que inicialmente estuvieron en la tabla Customers y que fueron borrados de all�.
�	Pruebe su triggers, borrando el cliente identificado con customerId= ALFKI
�	Liste las tablas Customers y la tabla Cliente_inactivo*/


/*9.  Realice lo mismo que en el problema anterior, pero ahora en lugar de manejar dos tablas, adicione una columna a su tabla Customers y maneje dicha columna como una bandera, que le indica si el registro del cliente est� activo o inactivo.  Para ello inicialmente coloque como valor centinela todos los campos activos con el valor de �A� y al borrarlos cambie dicho valor de la columna a �I�.
�	Pruebe su triggers, borrando el cliente identificado con customerId= ANATR y tambi�n el cliente con coustomerid= ANTON ( uno a la vez)
�	Liste la tabla Customers*/