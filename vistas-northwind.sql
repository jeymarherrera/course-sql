--VISTAS CON NORTHWIND
--Utilice la Base de datos Nothwind
--1.	Codifique una vista que contenga el nombre, el apellido y la fecha de cumplea�os de los empleados (Employees)
CREATE VIEW vista_empleados
AS
	SELECT FirstName, LastName, BirthDate
	FROM Employees

SELECT *
FROM vista_empleados

--2.	Modifique la vista del punto 1, de tal forma  que contenga el nombre, el apellido y el d�a de cumplea�os de los empleados del mes de enero (1).
ALTER VIEW vista_empleados
AS
	SELECT FirstName, LastName, DATEPART(DAY, BirthDate) 'D�a de cumplea�os'
	FROM Employees
	WHERE DATEPART(MONTH, BirthDate) = '01'

SELECT *
FROM vista_empleados

--3.	Cree una vista que  contenga las �rdenes de cada empleado, incluyendo el n�mero del empleado, su nombre y apellido, el n�mero de cada orden y su fecha.
CREATE VIEW vista_ordenes_empleados
AS
	SELECT Employees.EmployeeID, Employees.FirstName, Employees.LastName, Orders.OrderId, Orders.OrderDate
	FROM Orders
	JOIN Employees ON Orders.EmployeeID = Employees.EmployeeID

SELECT *
FROM vista_ordenes_empleados

--4.	Realice otra vista que contenga todas las columnas de la pregunta 3 y  el nombre de la compa��a que hizo la orden (tabla customer).  S�lo  se requieren las �rdenes que fueron embarcadas (ShippedDate) despu�s de la fecha en que eran requeridas. (RequiredDate).
CREATE VIEW vista_ordenes_empleados_cia
AS
	SELECT Employees.EmployeeID, Employees.FirstName, Employees.LastName, Orders.OrderId, Orders.OrderDate, Customers.CustomerID, Customers.CompanyName
	FROM Orders
	JOIN Employees ON Orders.EmployeeID = Employees.EmployeeID
	JOIN Customers ON Orders.CustomerID = Customers.CustomerID
	WHERE Orders.ShippedDate > Orders.RequiredDate

SELECT *
FROM vista_ordenes_empleados_cia

--5.	 Frecuentemente se requiere los productos y el nombre de la categor�a a la que pertenecen, por lo cual se le ha solicitado crear una vista que contenga estos campos.
CREATE VIEW vista_productos
AS
	SELECT Products.ProductName, Categories.CategoryName
	FROM Categories
	JOIN Products ON Categories.CategoryID = Products.CategoryID

SELECT *
FROM vista_productos

/*6.	 Una vez listado la vista ordenes_empleado_cia del punto 4, notamos que existe un error en los datos:  el vendedor que realiz� la orden 10280 fue  Michael Suyama y no Andrew Fuller como aparece.  Actualice los datos del vendedor a trav�s de la vista.  
Liste el contenido de la vista y el contenido de la tabla �madre� de estos campos.  Que Observa.*/
UPDATE vista_ordenes_empleados_cia
SET FirstName = 'Michael',
	LastName='Suyama'
WHERE FirstName = 'Andrew' AND
	  LastName = 'Fuller'

SELECT *
FROM vista_ordenes_empleados_cia

SELECT *
FROM Orders

--7.	 Ahora inserte un registro nuevo, que contenga su nombre,  su apellido y la fecha de su cumplea�os en la vista definida en el punto 1.   Liste la vista y liste la tabla.  Que observa.  
INSERT INTO Employees (FirstName, LastName, BirthDate)
VALUES('Jeymar', 'Herrera', '2001/09/03')

SELECT *
FROM vista_empleados

SELECT *
FROM Employees

--8.	Repita la misma inserci�n pero ahora a la vista del punto 2.   Liste la vista.  Que ocurre?
INSERT INTO Employees (FirstName, LastName, BirthDate)
VALUES('Jeymar', 'Herrera', '2001/01/03')

SELECT *
FROM vista_empleados

/*9-  Con los conceptos vistos de Transact  SQL codifique el scrip que permita obtener la siguiente informaci�n del sistema de base de datos 
Se desea entregar a todos los empleados que fueron contratados en el a�o 1992 un obsequio por su dedicaci�n y esfuerzo durante tantos a�os de servicio.  Por lo anterior, la secretaria del gerente le ha solicitado elaborar un informe que permita obtener la cantidad total de empleados que fueron contratados en el a�o 1992,  Adem�s, requiere que el mismo se entregue categorizado por titulo de cortes�a, ya que asi puede saber si el regalo es para dama (Ms, Mrs ) o para caballrero (Dr., Mr) */
CREATE VIEW vista_obsequiosEmpleados
AS
	SELECT TitleOfCourtesy, FirstName, LastName
	FROM Employees
	WHERE DATEPART(YEAR, HireDate) = '1992'

SELECT *
FROM vista_obsequiosEmpleados