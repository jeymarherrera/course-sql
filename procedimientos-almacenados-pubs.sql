--PROCEDIMIENTOS ALMACENADOS CON PUBS
/*Problema 1.Realice un procedimiento que reciba como par�metro de entrada el nombre de un libro de la tabla Titles (BD PUBS) 
e imprima la cantidad de autores de dicho libro.   
Por Ejemplo:  Si recibe el nombre  �The Busy Executive's Database Guide� debe devolver el valor 2, ya que este libro tiene 2 autores.  
En cambio, si se recibe el nombre �You Can Combat Computer Stress!�, el valor que debe devolverse es 1, 
ya que dicho libro fue escrito por un solo autor. */
USE pubs
CREATE PROCEDURE Cant_Auutor
@numAutore VARCHAR(400)
AS

DECLARE @num INT
     
SELECT @num = count(au_id)  
FROM [PUBS].[dbo].[titleauthor] a,[PUBS].[dbo].[titles] b
WHERE b.[title] = @numAutore AND a.[title_id] = b.[title_id]

PRINT'El libro '+ cast(@numAutore AS VARCHAR) +' tiene '
 PRINT + cast(@num AS VARCHAR)+ ' autores'

RETURN
--EJECUCION CON LA CADENA ( 'Is Anger the Enemy? ')
 Cant_Auutor'Is Anger the Enemy? '

--EJECUCION CON LA CADENA ( 'Cant_Auutor'Emotional Security: A New Algorithm')
 Cant_Auutor'Emotional Security: A New Algorithm'

/*Problema 2 - Cree una vista que permita listar el nombre de los productos, el nombre de la compa��a (CompanyName) que lo suple 
y el nombre de la categoria a la que pertenece dicho producto */
USE Northwind

DROP VIEW vistaProductos

CREATE VIEW vistaProductos
AS
	SELECT p.ProductName, s.CompanyName, c.CategoryName
	FROM  Products p INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID
			INNER JOIN Categories c ON p.CategoryID = c.CategoryID

SELECT *
FROM vistaProductos

/*Problema 3. Se desea que usted controle la inserci�n de datos de la tabla Categories (BD Northwind), 
de tal forma que no se permita la inserci�n repetida del campo que contiene el nombre de las categor�as (CategoryName). */
DROP TRIGGER insercionCategorias

CREATE TRIGGER insercionCategorias
ON Categories
INSTEAD OF 
INSERT 
AS
	DECLARE @nomCategory1 VARCHAR,
			@nomCategory2 VARCHAR

	SELECT @nomCategory1 = inserted.CategoryName,
		   @nomCategory2 = Categories.CategoryName
	FROM inserted
	JOIN Categories ON Categories.CategoryName = inserted.CategoryName

IF @nomCategory1 = @nomCategory2
	SELECT 'El dato ya existe, por lo que no podr� ser insertado' AS MENSAJE
ELSE
	SELECT 'inserci�n realizada' AS MENSAJE 

--prueba 1
INSERT INTO Categories(CategoryName)
VALUES('Seafood')

/*prueba 2
INSERT INTO Categories(CategoryName)
VALUES('Refresco')*/

SELECT *
FROM Categories

/*Problema 4.	Realice un cursor que liste para cada empleado  (BD Northwind) los territorios a los que han sido asignados a trabajar.  
Se desea que la salida presente el nombre del empleado y seguido el c�digo del territorio y el nombre del territorio */

declare @nombre varchar(50),
    @Q int,@cantidad int,
	@TOTAL int,
	@nombreTeritories varchar(50),
	@IDTeritories int
	set @TOTAL = 0 
  
--Declaro cursor
declare MI_CURSOR cursor for
 
select   FirstName   , count(*) as cantidad
		 from [Northwind].[dbo].[Employees] cu  , [Northwind].[dbo].[EmployeeTerritories] A 
		 where  A.EmployeeID = cu.EmployeeID  
		 group by  FirstName 
		 
--Abrir CURSOR

declare MI_CURSOR2 cursor for
select  TerritoryDescription ,cu.TerritoryID-- , count(*)
		 from [Northwind].[dbo].[Territories] cu  , [Northwind].[dbo].[EmployeeTerritories] A ,[Northwind].[dbo].[Employees] B
		      where  A.TerritoryID = cu.TerritoryID and A.EmployeeID = B.EmployeeID order by B.FirstName 
	--	 group by [FirstName]


open MI_CURSOR
open MI_CURSOR2
--Leer el primer registro

fetch MI_CURSOR into @nombre ,@Q
fetch MI_CURSOR2 into @nombreTeritories , @IDTeritories
--mientras existan mas registros
while @@FETCH_STATUS=0
begin 
set @cantidad =@Q
--imprimir el registro
print @nombre +','
             while @cantidad!=0
                  begin 
                --imprimir el registro @cantidad
                  print cast(@cantidad as varchar)+' '+cast(@nombreTeritories as varchar)+cast(@IDTeritories as varchar)

               fetch MI_CURSOR2 into @nombreTeritories ,@IDTeritories
	           --leer el registro siguiente 
                  set @cantidad= @cantidad-1
	            
	              end
     
    
	--acumular
	set @TOTAL+=@Q
	--leer el registro siguiente 
	fetch MI_CURSOR into @nombre ,@Q
	

	end

close MI_CURSOR 
close MI_CURSOR2 
deallocate MI_CURSOR 
deallocate MI_CURSOR2 

