--PROCEDIMIENTOS ALMACENADOS CON NORTHWIND
--1.	Realizar un procedimiento almacenado que devuelva los clientes (Customers) seg�n el pa�s (Country).
DROP PROC pa_clientes
CREATE PROCEDURE pa_clientes
	@Pais VARCHAR(20)
AS
	SELECT ContactName,Country
	FROM Customers 
	WHERE Country = @Pais

EXEC pa_clientes 'USA'

--2.	Crear un procedimiento que determine la cantidad de clientes cuyo identificador (o sea el c�digo) inicia con un determinado car�cter.
DROP PROC pa_cantidadClientes
CREATE PROCEDURE pa_cantidadClientes
	@ID varchar(10)
AS  
	DECLARE @Cantidad INT
	SELECT @Cantidad = COUNT(*)
	FROM Customers
	WHERE CustomerID LIKE @ID+'%';
RETURN @Cantidad

DECLARE @Cantidad INT 
Execute @Cantidad = pa_cantidadClientes 'E'
SELECT @Cantidad AS Cantidad;

--3.	Realizar un procedimiento que determine la cantidad de �rdenes que tiene registradas un cliente (tabla ORDERS.)
DROP PROC pa_cantidadOrdenes
CREATE PROCEDURE pa_cantidadOrdenes
	@CustomerID VARCHAR(20)
AS
	DECLARE @Cantidad INT
	SELECT @Cantidad = COUNT(*) 
	FROM  Orders 
	WHERE CustomerID = @CustomerID;
RETURN @Cantidad

DECLARE @Cantidad INT
EXECUTE @Cantidad = pa_cantidadOrdenes'BOTTM';
SELECT @Cantidad AS Cantidad

SELECT *
FROM Orders
WHERE CustomerID = 'BOTTM'

--4.	Realizar una base de datos similar a Northwind, pero que los nombres de tablas, campos y registros est�n en espa�ol (si ud. La tiene en espa�ol, h�galos en ingles)
DROP DATABASE vientodelnorte

CREATE DATABASE vientodelnorte;
GO
CREATE TABLE Categorias (
categoriaID INT PRIMARY KEY NOT NULL,
categoriaNombre NVARCHAR(15) NOT NULL,
descripcion NTEXT NOT NULL,
imagen image 
);

CREATE TABLE Proveedores (
proveedorID INT NOT NULL PRIMARY KEY,
nombreCompa�ia NVARCHAR(40) NOT NULL,
nombreContacto NVARCHAR(30) NULL,
tituloContacto NVARCHAR(30) NULL,
direccion NVARCHAR(60) NULL,
ciudad NVARCHAR(15) NULL,
region NVARCHAR(15) NULL,
codigoPostal NVARCHAR(15) NULL,
pais NVARCHAR(15) NULL,
telefono NVARCHAR(24) NULL,
fax NVARCHAR(24) NULL,
pagina NTEXT NULL 
);

CREATE TABLE Productos(
productoID INT NOT NULL PRIMARY KEY,
productoNombre NVARCHAR(40) NOT NULL,
proveedorID INT NULL,
categoriaID INT NULL,
cantidadPorUnidad NVARCHAR(20) NULL,
precioUnitario MONEY NULL,
unidadesEnStock SMALLINT NULL,
unidadesBajoPedido SMALLINT NULL,
reordenarNivel SMALLINT NULL,
descontinuado BIT NOT NULL,
FOREIGN KEY (proveedorID) REFERENCES Proveedores (proveedorID),
FOREIGN KEY (categoriaID) REFERENCES Categorias (categoriaID)
); 

CREATE TABLE Clientes(
clienteID NCHAR(5) NOT NULL PRIMARY KEY,
nombreCompania NVARCHAR(40) NOT NULL,
nombreContacto NVARCHAR(30) NULL,
tituloContacto NVARCHAR(30) NULL,
direccion NVARCHAR(30) NULL,
ciudad NVARCHAR(60) NULL,
region NVARCHAR(15) NULL,
codigoPostal NVARCHAR(10) NULL,
pais NVARCHAR(15) NULL,
telefono NVARCHAR(24) NULL,
fax NVARCHAR(24) NULL
);

CREATE TABLE DemografiaCliente(
tipoClienteID NCHAR(10) NOT NULL PRIMARY KEY,
clienteDesc NTEXT NULL
);

CREATE TABLE ClienteClienteDemo(
clienteID NCHAR(5) NOT NULL,
tipoClienteID NCHAR(10) NOT NULL,
PRIMARY KEY (clienteID, tipoClienteID), 
FOREIGN KEY (clienteID) REFERENCES Clientes (clienteID),
FOREIGN KEY (tipoClienteID) REFERENCES DemografiaCliente (tipoClienteID)
); 

CREATE TABLE Empleados (
empleadoID INT NOT NULL PRIMARY KEY,
apellido NVARCHAR(20) NOT NULL,
nombre NVARCHAR(10) NOT NULL,
titulo NVARCHAR(10) NOT NULL,
tituloDeCortesia NVARCHAR(25) NULL,
fechaCumplea�os DATETIME NULL,
fechaContratacion DATETIME NULL,
direccion NVARCHAR(60) NULL,
ciudad NVARCHAR(15) NULL,
region NVARCHAR(15) NULL,
codigoPostal NVARCHAR(10) NULL,
pais NVARCHAR(15) NULL,
telefonoCasa NVARCHAR(10) NULL,
extension NVARCHAR(4) NULL,
foto IMAGE NULL,
notas NTEXT NULL,
reportesA INT NULL,
direccionFoto NVARCHAR(255) NULL
FOREIGN KEY (reportesA) REFERENCES Empleados (empleadoID)
)

CREATE TABLE Region(
regionID INT NOT NULL PRIMARY KEY,
descripcionRegion NCHAR(50) NOT NULL
);

CREATE TABLE Territorios(
territorioID NVARCHAR(20) NOT NULL PRIMARY KEY,
descripcionTerritorio NCHAR(50) NOT NULL,
regionID INT NOT NULL,
FOREIGN KEY (regionID) REFERENCES Region (regionID)
);

CREATE TABLE TerritoriosEmpleados (
empleadoID INT NOT NULL,
territorioID NVARCHAR(20) NOT NULL, 
PRIMARY KEY (empleadoID, territorioID), 
FOREIGN KEY (empleadoID) REFERENCES Empleados (empleadoID),
FOREIGN KEY (territorioID) REFERENCES Territorios (territorioID)
); 

CREATE TABLE Transportistas(
transportistaID INT NOT NULL PRIMARY KEY,
nombreCompania NVARCHAR(40) NOT NULL,
telefono NVARCHAR(24) NULL
)

CREATE TABLE Ordenes(
ordenID INT NOT NULL PRIMARY KEY,
clienteID NCHAR(5) NULL,
empleadoID INT NULL,
fechaOrden DATETIME NULL,
fechaRequerida DATETIME NULL,
fechaEnviada DATETIME NULL,
viaDeEnvio INT NULL,
flete MONEY NULL,
nombreEnvio NVARCHAR(40) NULL,
direccionEnvio NVARCHAR(60) NULL,
ciudadEnvio NVARCHAR(15) NULL,
regionEnvio NVARCHAR(15) NULL,
codigoPostalEnvio NVARCHAR(10) NULL,
paisEnvio NVARCHAR(15) NULL,
FOREIGN KEY (clienteID) REFERENCES Clientes (clienteID),
FOREIGN KEY (empleadoID) REFERENCES Empleados (empleadoID),
FOREIGN KEY (viaDeEnvio) REFERENCES Transportistas (transportistaID)
);

CREATE TABLE DetallesOrden(
ordenID INT NOT NULL,
productoID INT NOT NULL,
precioUnitario MONEY NOT NULL,
cantidad SMALLINT NOT NULL,
descuento REAL NOT NULL,
PRIMARY KEY (ordenID, productoID), 
FOREIGN KEY (ordenID) REFERENCES Ordenes (ordenID),
FOREIGN KEY (productoID) REFERENCES Productos (productoID)
); 

SELECT *
FROM vientodelnorte

--5.	Realizar una Vista que contenga todos los registros de tabla de Productos y Categorias a la vez.
DROP VIEW registrosPC
CREATE VIEW registrosPC
AS
	SELECT p.*, c.CategoryName, c.Description, c.Picture
	FROM  Products AS p, Categories AS c
	WHERE p.CategoryID = c.CategoryID

SELECT *
FROM registrosPC

--6.	Realizar un procedimiento que seleccione todos los productos que no corresponde a la categor�a bebidas (1)
DROP PROC pa_CategoriasNB
CREATE PROCEDURE pa_CategoriasNB
AS
	SELECT p.*, c.CategoryName
	FROM Products AS p, Categories AS c
	WHERE c.CategoryID = p.CategoryID AND c.CategoryName != 'Beverages'

EXECUTE pa_CategoriasNB

--7.	Realizar un procedimiento que obtenga la cantidad de registros que no corresponde a condimentos
DROP PROC pa_RegistrosNC
CREATE PROCEDURE pa_RegistrosNC
AS
	DECLARE @Cantidad INT
	SELECT @Cantidad = COUNT(*) 
	FROM  Products 
	WHERE CategoryID != 2
RETURN  @Cantidad;

DECLARE @Cantidad INT
EXECUTE @Cantidad = pa_RegistrosNC;
SELECT  @Cantidad AS Cantidad

--8.	Realizar un procedimiento que seleccione todos los campos de los registros que no corresponden a categor�a mariscos de la tabla productos.
DROP PROC pa_RegistroNM
CREATE PROCEDURE pa_RegistroNM
	@CategoryID INT
AS
	SELECT * 
	FROM  Products 
	WHERE CategoryID != @CategoryID

EXECUTE pa_RegistroNM 8;


--9.	Realizar un procedimiento que seleccionar los campos nombre del producto y precio (�nicamente) de los  productos diferentes a c�rnicos.
DROP PROC pa_productosDC
CREATE PROCEDURE pa_productosDC
	@CategoryID INT
AS
	SELECT ProductName, UnitPrice 
	FROM  Products 
	WHERE CategoryID != @CategoryID

EXECUTE pa_productosDC 6;

--10.	Realizar un procedimiento que obtenga la cantidad de productos granos y cereales.
DROP PROC pa_cantidadGC
CREATE PROCEDURE pa_cantidadGC
	@CategoryID INT
AS
	DECLARE @Cantidad INT
	SELECT @Cantidad = COUNT(*) 
	FROM  Products 
    WHERE CategoryID = @CategoryID
RETURN  @Cantidad;

DECLARE @Cantidad INT
EXECUTE  @Cantidad = pa_cantidadGC 5;
SELECT  @Cantidad AS Cantidad

--11.	Realizar un procedimiento que seleccione los campos nombre del producto y precio (�nicamente) de los quesos y productos c�rnicos.
DROP PROC pa_camposQC
CREATE PROCEDURE pa_camposQC
AS
	SELECT ProductName, UnitPrice 
	FROM Products 
    WHERE CategoryID IN (4,5)

EXECUTE pa_camposQC

--12.	Realizar un procedimiento que seleccione los campos nombre del producto, precio y stock (�nicamente) de las frutas secas y mariscos.
DROP PROC pa_camposFSM
CREATE PROCEDURE pa_camposFSM
AS
  SELECT ProductName, UnitPrice, UnitsInStock 
  FROM Products 
  WHERE CategoryID IN (7,8)

EXECUTE pa_camposFSM;

--13.	Realizar un procedimiento que seleccionar el promedio de los precios de los confites.
DROP PROC pa_promedioPC
CREATE PROCEDURE pa_promedioPC
AS
	SELECT SUM(unitPrice)/COUNT(unitPrice) AS promedio 
	FROM Products 
	WHERE CategoryID = 3;

EXECUTE pa_promedioPC;

--14.	Realice un procedimiento que permita obtener cual fue el producto mas vendido en un a�o particular suministrado como entrada y cual fue el menos vendido.  
DROP PROC pa_productoMV
CREATE PROCEDURE pa_productoMV
	@A�O VARCHAR
--	@MASVENDIDO NVARCHAR(40) OUTPUT,
--	@MENOSVENDIDO NVARCHAR(40) OUTPUT,
AS	

SELECT MAX(CANTIDAD) AS MAXIMO
FROM 
(
SELECT p.ProductName as Nombre, SUM(od.Quantity) AS CANTIDAD FROM ORDERS o
INNER JOIN [ORDER DETAILS] od ON o.OrderID = od.OrderID
INNER JOIN PRODUCTS p ON p.ProductID = od.ProductID
WHERE YEAR(o.OrderDate) = 1996
GROUP BY p.ProductName) AS T


SELECT ProductName
FROM Products
WHERE CANTIDAD > ALL
(
	SELECT p.ProductID, SUM(od.Quantity)  CANTIDAD
	FROM Products AS p	
	JOIN [Order Details] AS od ON od.ProductID = p.ProductID
--	JOIN Orders AS o ON DATEPART(YEAR, o.OrderDate) = '1992'
--	WHERE p.ProductID = p.ProductID
	GROUP BY p.ProductID	
) 
RETURN 

DECLARE @A�O VARCHAR 
		--@MASVENDIDO NVARCHAR(40),
	--	@MENOSVENDIDO NVARCHAR(40),
	--	@CANTIDAD INT 
SELECT @A�O= '1992'
EXEC pa_productoMV  @A�O
					--@MASVENDIDO OUTPUT,
				--	@MENOSVENDIDO OUTPUT,
				--	@CANTIDAD OUTPUT
SELECT *
FROM Products

SELECT *
FROM [Order Details]
SELECT *
FROM Orders
--15.	Realice un procedimiento que encuentre los productos que no se llegaron a vender en un a�o particular, suministrado como valor de entrada.
DROP PROC pa_cantidadClientes

--16.	Escriba un procedimiento que reciba como par�metro de entrada el nombre de un producto o parte de este, como una frase y sea capaz de listar todos los productos que contengan en su nombre dicha frase,
DROP PROC pa_nombreP
CREATE PROCEDURE pa_nombreP
	@nombre VARCHAR(20)
AS
	SELECT ProductName
	FROM Products 
	WHERE ProductName LIKE '%'+@nombre+'%'

EXEC pa_nombreP 'eso'

--17.	Escriba un procedimiento que recibiendo un n�mero de orden, encuentre los d�as que han transcurrido desde que  se realiz�  dicha �rden.  Maneje este dato como un par�metro de salida.
DROP PROC pa_numerO
CREATE PROCEDURE pa_numerO
	@numOrden INT,
	@diasT INT OUTPUT 
AS
	SELECT @diasT = DATEDIFF(DAY, OrderDate, GETDATE()) 
	FROM Orders
	WHERE OrderID = @numOrden
	SELECT @diasT 
RETURN

DECLARE @numOrden INT,
		@diasT INT 
SELECT @numOrden= '10248'
EXEC pa_numerO @numOrden, @diasT OUTPUT    

--18.	Escriba un procedimiento que valide si tenemos registrado a un cliente.  Enviar mensajes indicando si existe o no el cliente.  Debe recibir el c�digo del cliente como dato de entrada.
DROP PROC pa_existenciaC
CREATE PROCEDURE pa_existenciaC
	@customerID NCHAR(5)
AS
IF EXISTS (
	SELECT CustomerID
	FROM Customers
	WHERE CustomerID = @customerID )
	PRINT 'EL CLIENTE EXISTE'
ELSE
	PRINT 'EL CLIENTE NO EXISTE'

EXEC pa_existenciaC 'JCHB'