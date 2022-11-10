/*   PRACTICA 1  RESTRICCIONES

1-	Se tiene el siguiente modelo relacional.

EMPLEADO (cod_empl (PK), nombre, sexo, fecha_ingreso, salario, cant_hijos, cod_depto(FK)

DEPARTAMENTO ( cod_depto (PK) , nombre_depto

Cree las tablas arriba descritas, considerando las siguientes restricciones:
a.	El c?digo del empleado est? compuesto por cuatro d?gitos, los dos primeros caracteres y los dos ?ltimos n?meros
b.	El campo sexo  solo puede contener los valores F y M, pero en caso de no definirse, se debe almacenar M
c.	La fecha de ingreso no debe ser antes del 2000
d.	El salario debe ser un valor comprendido entre 600 y 2000
e.	Cantidad de hijos debe ser un valor comprendido entre 0 y 15
f.	El c?digo de departamento solo puede ser 1, 2 o 3
g.	Los nombres v?lidos para el campo  departamento son: "Sistemas", "Administraci?n" y "Contabilidad"  */

--DEPARTAMENTO ( cod_depto (PK) , nombre_depto

Create database Practica1_Restricciones

Use Practica1_Restricciones

create table Departamento 
(
	cod_depto char(1) 
		constraint Departamento_cod_depto_PK  primary key
		constraint Departamento_cod_depto_ck check (cod_depto in('1','2','3')),    --o- check (cod_depto like'[1-3]'),
	nombre_depto varchar(14)
		constraint Departamento_nombre_depto_ck check (nombre_depto in ('Administraci?n','Sistemas', 'Contabilidad'))
)

 --EMPLEADO (cod_empl (PK), nombre, sexo, fecha_ingreso, salario, cant_hijos, cod_depto(FK)

create table Empleado
(
	cod_Emp  char(4)
		constraint Empleado_cod_emp_pk primary key
		constraint Empleado_cod_emp_ck check ( cod_emp like '[a-z][a-z][0-9][0-9]'),
	nombre varchar(25),
	sexo char(1)
		constraint Empleado_sexo_ck check (sexo in ('F','M'))
		constraint Empleado_sexo_df default 'M',
	fecha_ingreso date
		constraint Empleado_fecha_ingreso_ck check (year(fecha_ingreso)>=2020),
	salario money
		constraint Empleado_salario_ck check (salario between 600 and 2000),
	cant_hijos int
		constraint Empleado_cant_hijos_ck check (cant_hijos between 0 and 15),
	cod_depto char
		constraint Empleado_cod_depto_fk foreign key
		     references Departamento (cod_depto)
			 on delete   set null
			 on update  cascade 
		constraint Empleado_cod_depto_ck  check (cod_depto like'[1-3]')
)


--DEPARTAMENTO ( cod_depto (PK) , nombre_depto

insert into Departamento
  values ('1', 'SISTEMAS')

insert into Departamento
  values ('2', 'contabilidad')

insert into Departamento
  values ('3', 'SISTEMA')  

insert into Departamento
   values ('3', 'Administraci?n')

insert into Departamento
   values ('3', 'Contabilidad')


   select * from Departamento
-------------

alter table Empleado
    drop constraint Empleado_fecha_ingreso_ck

alter table Empleado
	add constraint Empleado_fecha_ingreso_ck check (year(fecha_ingreso)>=2000)


--EMPLEADO (cod_empl (PK), nombre, sexo, fecha_ingreso, salario, cant_hijos, cod_depto(FK)
 
insert into Empleado
    values ('PA34', 'Julio','m', '2001',800,2,1)

--Bloque para activar restricciones
insert into Empleado
    values ('9999', 'Julio','m', '2001',800,2,3)

insert into Empleado
    values ('PA35', 'Julio','d', '1999',800,2,2)

insert into Empleado
    values ('ap45', 'Julio','m', '2020',5000,2,1)

insert into Empleado
    values ('ap45', 'Julio','f', '2020',2000,12,4)

--------------
insert into Empleado
    values ('ee99', 'Pedro','m', '2001',1000,2,2)

insert into Empleado
    values ('PA35', 'Julio','d', '1999',800,2,1)

insert into Empleado
    values ('ap45', 'Julio','m', '2020',700,2,1)

insert into Empleado
    values ('ap95', 'Julio','f', '2020',2000,2,3)

	select * from Departamento
	select * from Empleado

	---Se defini? que si hago lo primero al padre, el hijo hace la segunda parte
	---- on delete   set null
	---- on update  cascade 

	delete Departamento
	where cod_depto =1

	update Departamento
	   set cod_depto = 1
	   where cod_depto =2


------------

	   delete Departamento
	   Delete Empleado