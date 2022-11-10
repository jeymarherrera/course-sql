/*********************************************************/
 --            FUNCIONES PARA MANEJO DE CADENAS 

 /*********************************************************/
 
 /*substring:  Extrae de la cadena (1er argumento               
               la cantidad de caracteres (3er argumento)
			   partiendo de la posición del 2do argumento */
 
  select substring('Buenas tardes',8,6);   
 
 ------------------------                                   

  /*str:  Convierte número a caracter             
          (1) número a convertir  
		  (2) longitud resultado. Debe ser >= parte entera del numero, pto,  más signo, 
		       mas parte fraccionaria
		  (3) cantidad de decimales (redondea por 5
		  Segundo y tercer argumento opcionales*/
 
 select str(123.456,7,3);       
 select str(1234.456,6,3); 
 select str(-123.456,7,3);		-- cuenta signo, parte entera, punto y fracción                                                     
 select str(123.56);			-- Sólo muestra parte entera, pues no se especifica longitud ni decimales 
 select str(12345678.456);
 
 --Note como el 5 redondea al 4 en esta salida
 select str(123.456,5,1)

 --No se define parte fraccionaria
 select str(123.456,3);			-- Se define que se desea 3 cifras de salida.  
   	                                           
-- Si el segundo parámetro es menor a la parte entera del número, devuelve asteriscos (*).
-- En este caso devuelve 2 asteriscos pues eran dos cifras las solicitadas
 
 select str(123.456,2,3);    


--**************** STUFF  -RELLENAR(inserta y reemplaza)

  /* STUFF (cadena1, 2do, 3ro, cadena2 ) 

            Inserta cadena2 en cadena 1, 
		    a partir de la posición del 2do argumento (debe ser numérico)
			reemplazando la cantidad de caracteres del 3er argumento (numérico)
	
	El segundo argumento debe ser + y <= cadena1  sino, retorna null

	EL tercer argumento indica los caracteres que eliminamos de la 1ra cadena y es donde entra la cadena 2*/     		                      

select stuff('abcde',3,4,'opqrs'); 
select stuff ('por pandemia vivimos encerrados', 10,8, 'seguridad')

select stuff ('SQL SERVER',2, 14, 'My')

select stuff ('SQL SERVER', 14, 2, 'My')


--******************** LONGITUD (cadena) 		                        

select len('Hola'); 

select LEN(stuff ('SQL SERVER', 2, 14, 'My'))

 
select len(substring('Buenas tardes',8,6));

SELECT LEN (1234.67)

USE Northwind
SELECT CategoryName CATEGORIA, 
       LEN(CategoryName) LARGO_NOMBRE
    FROM Categories

USE EJEMPLO
drop table largo_campo

CREATE TABLE LARGO_CAMPO
(
CEDULA CHAR(13)
   CONSTRAINT LARGO_CAMPO_CEDULA_PK PRIMARY KEY
   CONSTRAINT LARGO_CAMPO_CEDULA_CK
         CHECK (CEDULA LIKE '[0][0-9][-][0-9][0-9][0-9][0-9][-][0-9][0-9][0-9][0-9][0-9]'
		    OR  CEDULA LIKE '[1][0-3][-][0-9][0-9][0-9][0-9][-][0-9][0-9][0-9][0-9][0-9]'),
NOMBRE  NVARCHAR(15)
    CONSTRAINT LARGO_CAMPO_NOMBRE_CK  
	    CHECK ((LEN(NOMBRE)>=2)),
APELLIDO NVARCHAR(20)
) 



INSERT INTO LARGO_CAMPO 
  VALUES  ('10-1010-11010', 'PEDRO','PICAPIEDRAS')
  --
SELECT * FROM lARGO_CAMPO

INSERT INTO LARGO_CAMPO 
  VALUES  ('11-1010-11010', 'V','PICAPIEDRAS')

DROP TABLE LARGO_CAMPO

--***************** CHAR(X)
 /*    char:	Devuelve caracter en codigo ASCII del 
			entero enviado como arguemento  */

  select char(64); 
  
 

--*******************LEFT (cadena, longitud)

/*left:	Devuelve la cantidad de caracteres especificado  
			como 2do argumento, partiendo del extremo izquierdo  */

 select left('buenas tardes',8); 
 select left('buenas tardes',4);  

/* ADICIONAMOS MAS DATOS A LA TABLA LARGO_CAMPO */

INSERT INTO LARGO_CAMPO 
  VALUES  ('04-1010-11010','Pebell', 'PICAPIEDRAS'),
          ('05-1010-11010', 'Bambam','MARMOL')
		  
SELECT * FROM LARGO_CAMPO

SELECT left(cedula,2) from largo_campo


SELECT	CEDULA = cedula,
		nombre as NOMBRE,
		apellido as APELLIDO,
	    PROVINCIA =(CASE 
		   WHEN LEFT(CEDULA,2) = '01'   THEN 'BOCAS DEL TORO'
		   WHEN LEFT(CEDULA,2) = '02'   THEN'COCLE'
		   WHEN LEFT(CEDULA,2) = '03'   THEN 'COLON'
		   WHEN LEFT(CEDULA,2) = '07'   THEN 'LOS SANTOS'
		   WHEN LEFT(CEDULA,2) = '08'   THEN 'PANAMÁ'
		   WHEN LEFT(CEDULA,2) = '10'   THEN 'PANAMÁ OESTE'
           ELSE 'PROVINCIA NO ESTA JUGANDO´'
		  end
		 ) 
  FROM LARGO_CAMPO
  
  


--*********************RIGTH  (cadena, longitud)
           --Devuelve la cantidad de caracteres especificado  
		   --como 2do argumento, partiendo del extremo derecho */
 select right('buenas tardes',8);    		                   
 select right('buenas tardes',4);
 ---------------
 

 /*************************lower	convierte a minúscula toda la cadena */

 select lower('HOLA ESTUDIAnte'); 



 ---
  /*upper	convierte a mayúscula toda la cadena */
           
 select upper('Hola Estudiante'); 

 SELECT * FROM LARGO_CAMPO

 INSERT INTO LARGO_CAMPO 
  VALUES  ('03-1010-11010',lower('EUgine'), upper('fitzherbert')),
          ('08-9999-99999', upper('Rapunzel'),'Reina del sol')
 ------
use northwind
 select [FirstName], 
	 lower([FirstName]),
	 upper([FirstName])
    from [dbo].[Employees]
 
 
 
 
 ---******************** LTRIM

/*ltrim:  retorna la cadena con los espacios de la izquierda eliminados*/  		                         
 select ltrim('     Hola     '); 
 select ltrim('Hola     ');  

-- Cuando lo usemos en programación, contenido de variables
   
   DECLARE @cadena VARCHAR(80);  
   SET @cadena = '                        Se han incluido 10 espacios adelante de esta cadena';
   
   SELECT 
      @cadena AS 'CADENA ORIGINAL',
      LTRIM(@cadena) AS 'CADENA SIN ESPACIOS';  





 --********************  RTRIM (CADENA)  		         
 /*rtrim:  retorna la cadena con los espacios de la derecha eliminados*/ 
 select rtrim('   Hola   '); 
  
  

  --********************REPLACE (CADENA1, CADENA2, CADENA3)
/* Replace:  Busca en cadena1, todas las ocurrencias
             de la 2da cadena y la reeplaza por la 3ra cadena */ 

  select replace('xxx.aprendiendosql.com','x','w');

  select replace('xxx.aprendiendosql.com','en','WAO');

 
 --******************* REVERSE  (CADENA)		                                   
 
 /* REVERSE:  devuelve la cadena invirtiendo el orden de los caracteres. */
 select reverse('covid')
  


--********************PATINDEX(PATRON, CADENA)	
 	
/*  PATINDEX  :   devuelve la posición de comienzo (de la primera ocurrencia)
                  del patrón especificado en la cadena enviada como segundo argumento. 
				  Si no la encuentra retorna 0    */
				                           
 select patindex('%Luis%', 'Jorge Luis Borges');     		                
 select patindex('%or%', 'Jorge Luis Borges');         		                 
 select patindex('%ar%', 'Jorge Luis Borges');        		                  




 --***********************CHARINDEX(subcadena,cadena,inicio)
 /*
 charindex(subcadena,cadena,inicio): 
                Devuelve la posición donde comienza la subcadena en la cadena, 
				comenzando la búsqueda desde la posición indicada por "inicio". 
				Si el tercer argumento no se coloca, la búsqueda se inicia desde 0. 
				Si no la encuentra, retorna 0.*/

 select charindex('or','Jorge Luis Borges',5);      --note que parte de la 5ta posic y cuenta la siguiente como 6ta    		                 
 select charindex('or','Jorge Luis Borges');            		                  
 select charindex('or','Jorge Luis Borges',14);       		                     
 select charindex('or', 'Jorge Luis Borges',20);     --20 es mas largo que la cadena 
 --------------



 /******************** REPLICATE(cadena,cantidad)
		 repite una cadena la cantidad de veces especificada en el segundo argumento.*/

 select replicate ('Hola',3);             			                        
 
 
 
 --******************* SPACE (CANTIDAD) 
  /*  Devuelve espacios en blanco (según cantidad definida
                      cantidad debe ser un valor positivo. */ 			                               
 
 select 'Hola'+space(15)+'que tal';         		                       



/*********************************************************/
--            FUNCIONES MATEMÁTICAS 
 /*********************************************************/
 

 /*****************  ABS(x)
            Retorna el valor absoluto del argumento "x". */

 
 select abs(-20);
 select abs(+20);
 
 
 --***************** CEILING (X)  
 
 /* CEILING(x): redondea hacia el entero superior.  
                El argumento x debe	tener parte fraccionaria */
 	                                         
 select ceiling(12.10);       
select ceiling(12.9);   
select ceiling(12);   
select ceiling(12.00001);   
 select ceiling(0.0000000000001); 
 

 --*****************FLOOR (X)

 /*floor(x): redondea hacia abajo el argumento "x".               
             es similar a eliminar la parte fraccionaria */
 		                              
 select floor(12.64); 
 select floor(12)
 select floor(12.64) 
 select floor(0.9999)


 --************************ MODULO RESTO %
 /*%: devuelve el resto de una división. 

      Es un operador que debe ir entre operandos.*/  
 select 10%3;      		                                         
 select 10%2;  
  
  
 --***********************POWER(x,y)
 /* POWER(x,y): retorna el valor de "x" elevado a la "y" potencia.*/

 select power(2,3);  	
 

 --*********************** ROUND (NUMERO,LONGITUD)
 
 /*round(numero,longitud): retorna un número redondeado a la longitud especificada
                           (1-decimas, 2-centésimas, 3- milesimas). 
                   "longitud" debe ser tinyint, smallint o int. 
				  
				  Si "longitud" es positivo, el número de decimales es redondeado según "longitud"; 
			      
				  Si es negativo, el número es redondeado desde la PARTE ENTERA según el valor de "longitud".*/


 select round(123.456,1);  
 select round(123.456,2);
 select round(123.452,2);
 select round(123.452,0);  -- Redondea a las unidades (pero el 4 no redondea)
 select round(123.752,0);  -- EL 7 redondea al 3
 select round(125.456,-1);      
 select round(163.456,-2); 

 *********************** CAST
 ***********************
     --Permite convertir un tipo de dato a otro 

--	 CAST ( campo_a_convertir AS tipo_dato [ ( longitud) ] )   
  
  select round(123.456,2);
  select ROUND(CAST(123.456 AS DECIMAL(10,2)), 2)


 use Northwind
 
 select [ProductName] 'NOMBRE PRODUCTO',
		[UnitPrice]  'PRECIO UNITARIO',
		[UnitPrice]*1.07 'PRECIO CON IMPUESTO'
	FROM [dbo].[Products]


select ProductName 'NOMBRE PRODUCTO',
	   UnitPrice  'PRECIO UNITARIO',
	   ROUND(CAST((UnitPrice*1.07) AS DECIMAL(10,2)),2) 'PRECIO CON IMPUESTO'
	FROM [dbo].[Products]		
 
 
 --******************SIGN(X)
 --  Evalúa a X
			si X es + , devuelve 1;
			si X es -, devuelve -1 y 
			si X es 0, devuelve 0.                           */

  select sign(3)
  select sign(-3)
  select sign(0)


  --****************** SQUARE (x)
 
 --square(x): retorna el cuadrado del argumento.  */
 
 select square(3); 
  

--********************** SQRT(X)
 
 --Devuelve la raiz cuadrada del valor enviado como argumento.*/
  
  select sqrt(9); 



  /*********************************************************/
 --            FUNCIONES  PARA EL USO DE FECHAS Y HORAS	
  /*********************************************************/


/* getdate(): retorna la fecha y hora del sistema. */
 
 select getdate();

 --------------

 /* DATEPART( partedefecha , fecha) 

     Retorna la parte específica de una fecha, el año, 
	 trimestre, día, hora, etc.
     Los valores para "partedefecha" pueden ser: 
	         year (año), 
			 quarter (cuarto), 
			 month (mes), 
			 day (dia), 
			 week (semana), 
			 hour (hora), 
			 minute (minuto), 
			 second (segundo) y 
			 millisecond (milisegundo). */
 
 select datepart(month,getdate())  -- retorna el número de mes actual;
 select datepart(day,getdate());   -- retorna el día actual;
 select datepart(hour,getdate());  -- retorna la hora actual;
 
 USE Northwind
 select [FirstName],
		[BirthDate],
		datepart(month,BirthDate)
	from Employees;
	   		              
 ---------------  
 /* datename(partedefecha,fecha): 
          Retorna el nombre de una parte específica de una fecha. 
		  Los valores para "partedefecha" son los mismos antes vistos */	           
 
 select datename(month,getdate()); -- Solo da nombre de los meses  		              
 
 select datename(day,getdate());  -- salida igual a datepart
 select datename(minute,getdate());



 --************************ DATEADD(partedelafecha, numero, fecha)
 
 /* dateadd ( partedelafecha, numero, fecha): 

            Agrega a la fecha especificada (3er argumento), 
			en partedelafecha(1er argumento) la cantidad especificada (2do arg*/
 
 select dateadd(day,3,'2020/5/02');    --agrega 3 dias a la fecha especificada  		      
 select dateadd(month, 5, getdate());   --agrega 5 meses a la fecha actual	   
 select dateadd(hour, 2,'2020/5/02');  
 select dateadd(minute, 16,'2020/5/02');  
 -----------------
 
 /******************* DATEDIFF (partedelafecha, fecha1 , fecha2): 
				
	Calcula el intervalo de tiempo (según el primer argumento) 
	entre las 2 fechas. 
		
	El resultado es un valor entero que corresponde a FECHA2 - FECHA1 .*/

 select datediff (day,'2021/1/1','2021/5/3');                       	
 select datediff(month,'2020/1/28','2020/8/29')	

 ---------          
 /* day (fecha): retorna el DIA de la fecha especificada */
 
 select day(getdate()); 
 select day(2020/10/2); 
 /* MONTH (fecha): retorna el MES de la fecha especificada */    
                        
 select month(getdate())
 
 /* YEAR (fecha): retorna el A?O de la fecha especificada */
 
 select year(getdate());  
 		                   
-----------------------------------------
--EJEMPLOS DE USOS DE FECHA
-----------------------------------------




use ejemplo

drop table funciones_fechas
create table funciones_fechas
(
fecha_cita  date        --tipo de dato que sólo permite almacenar la fecha
	  constraint ck_prueba_fecha_cita 
	    check (fecha_cita >= getdate()),

fecha_actual datetime    --tipo de dato que almacena Fecha y hora
	  constraint df_prueba_fechaactual default getdate()
)


--Probando los constraint
	
INSERT INTO funciones_fechas (FECHA_cita)  -- fecha_cita debe ser mayor que la fecha actual 
	VALUES	('2021-1-25')	

INSERT INTO funciones_fechas (FECHA_cita)
	VALUES	('2021/5/14')	

INSERT INTO funciones_fechas (FECHA_cita)
	VALUES	('2021-12-25')	


select * from funciones_fechas

INSERT INTO funciones_fechas (FECHA_cita)
	VALUES	(getdate())	                     ---Provoca error pues el valor que devuelve getdate es datetime y fecha_cita es date

select * from funciones_fechas   

------------
	
Probemos insertando al campo date, un valor fecha y hora 

delete funciones_fechas

INSERT INTO funciones_fechas 
	VALUES	('2020-10-07 11:55:25', '2020-12-25 11:55:25')	

INSERT INTO funciones_fechas 
	VALUES	('2021/10/07 11:55:25', getdate())

select * from funciones_fechas  -- Note que el campo date ignora la hora, solo almacena la fecha
-----------

	use Northwind
	
--Las búsquedas que incorporen fechas deben hacerse usando las funciones de fechas
	
	--incorrecto
	
	select lastname, HireDate 
	   from  employees
	   where  HireDate   = 1994     
	   
	--correcto  

	select lastname, 
	       HireDate 
	   from  employees
	   where   DATEPART (year, HireDate ) = 1994

--------------------------------
----------COLUMNA COMPUTADA-----
-------TOMA EL VALOR DE OTRA COLUMNA

drop table campo_resultado_campo

 CREATE TABLE campo_resultado_campo
 (
    llave_primaria int 
	      constraint crc_llave_primaria_pk primary key ,
    fecha datetime not null,
    fecha_computada as dateadd(year, 3, fecha)
)

insert into campo_resultado_campo   -- El tercer campo tiene valor desde la creacion por tanto no es necesario
 values (12,'2020-10-07 11:55:25')
 
 select * from campo_resultado_campo
 
 insert into campo_resultado_campo  (llave_primaria, fecha, fecha_computada) 
      values (15,'2020-10-07 11:55:25','2020-10-07 11:55:25')
 
 --------------------------
 --LA COLUMNA COMPUTADA NO PUEDE SER PK
 --------------------------
 use ejemplo

drop table vacuna

create table vacuna
(
nombre varchar (30) not null,
cod_vacuna as left (nombre,3)  
  -- constraint vacuna_cod_vacuna_uk unique (cod_vacuna)
)

ALTER TABLE VACUNA
ADD constraint vacuna_cod_vacuna_uk 
   PRIMARY KEY(cod_vacuna)   ---no deja usar campo calculado como PK
