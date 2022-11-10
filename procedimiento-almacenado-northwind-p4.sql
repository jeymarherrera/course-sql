--1.	Realizar un procedimiento almacenado que devuelva los clientes (Customers) según el país (Country).
--- Solución A. usando LIKE (como, parecido)
CREATE PROCEDURE usp_Clientes_Pais_LIKE
  @Pais VARCHAR(20)
AS
SELECT CompanyName,
ContactName,
Country 
FROM Customers 
WHERE Country LIKE @Pais;

EXECUTE usp_Clientes_Pais_LIKE 'USA';

--- Solución B. usando = (igual)(exactamente igual)
CREATE PROCEDURE usp_Clientes_Pais_igual
  @Pais VARCHAR(20)
AS
SELECT CompanyName,
ContactName,
Country 
FROM Customers 
WHERE Country = @Pais;

EXECUTE usp_Clientes_Pais_igual 'Austria';

--2.	Crear un procedimiento que determine la cantidad de clientes cuyo identificador (o sea el código) inicia con un determinado carácter.
---2.1 Solución A (usando parámetro de salida)
CREATE PROCEDURE usp_Cantidad_Clientes
	@ID varchar(10),
	@Cantidad int output
AS
    SELECT @Cantidad = COUNT(*)
    FROM Customers
	WHERE CustomerID LIKE @ID+'%';

declare @Cantidad int 
Execute usp_Cantidad_Clientes 'A', @cantidad output
SELECT @Cantidad AS Cantidad;

---2.1 Solución B (usando variable de retorno)
CREATE PROCEDURE usp_Cantidad_Clientes_B
	@ID varchar(10)
AS
	DECLARE @Cantidad int
	SELECT @Cantidad = COUNT(*)
	  FROM Customers
	  WHERE CustomerID LIKE @ID+'%';
	RETURN 	@Cantidad

declare @Cantidad int 
Execute @Cantidad = usp_Cantidad_Clientes_B 'A'
SELECT @Cantidad AS Cantidad;

--3.	Realizar un procedimiento que determine la cantidad de registros que un cliente está en la tabla ORDERS.
--Ejemplo cliente con código ALFKI
-- Con parámetro de salida
CREATE PROCEDURE usp_Clientes_ordenes
  @CustomerID VARCHAR(20),
  @Cantidad int output
AS
SELECT @Cantidad = COUNT(*) 
FROM  Orders 
WHERE CustomerID = @CustomerID;

DECLARE @Cant int
EXECUTE usp_Clientes_ordenes 'ALFKI', @Cant output;
SELECT @Cant AS Cantidad

-- Con valor de retorno
CREATE PROCEDURE usp_Clientes_ordenes_B
  @CustomerID VARCHAR(20)
AS
DECLARE   @Cantidad int 
SELECT @Cantidad = COUNT(*) 
FROM  Orders WHERE CustomerID = @CustomerID;
RETURN @Cantidad

DECLARE @Cant int
EXECUTE @Cant = usp_Clientes_ordenes_B 'ALFKI';
SELECT @Cant AS Cantidad

--4.	Realizar una base de datos similar a Northwind, pero que los nombre de tablas, campos y registros estén en castellano.
CREATE DATABASE vientonorte;

CREATE TABLE categoria (
cat_id int PRIMARY KEY,
cat_nombre VARCHAR(30) NOT NULL,
cat_descripcion VARCHAR(50) NOT NULL,
cat_imagen image );

CREATE TABLE proveedor (
pro_id int PRIMARY KEY,
pro_cia VARCHAR(30) NOT NULL,
pro_titulo VARCHAR(50),
pro_dir VARCHAR(50),
pro_ciudad VARCHAR(40),
pro_region VARCHAR(30),
pro_codigoPostal VARCHAR(10),
pro_pais VARCHAR(30),
pro_tlf VARCHAR(60),
pro_fax VARCHAR(40),
pro_pagina VARCHAR(100) );

CREATE TABLE articulo (
art_id int PRIMARY KEY,
art_nombre VARCHAR(30) NOT NULL,
pro_id int NOT NULL,
cat_id int NOT NULL,
art_cant_por_und int,
art_pu money NOT NULL,
art_stock int,
art_und_en_ordenes int,
art_nivel_para_ordenar int,
art_descontinuado bit,
FOREIGN KEY (pro_id) REFERENCES proveedor (pro_id),
FOREIGN KEY (cat_id) REFERENCES categoria (cat_id)); 

--5.	Realizar un procedimiento que seleccione todos los registros de tabla Productos y Categories a la vez.
DROP PROCEDURE usp_Productos_Categorias
CREATE PROCEDURE usp_Productos_Categorias
AS
SELECT c.CategoryName, c.Description, p.* 
FROM  Categories AS c, Products AS p 
WHERE c.CategoryID = p.CategoryID;

EXECUTE usp_Productos_Categorias


