/*	PROYECTO DE BASE DE DATOS CONNECT 4
 *	Año: 2015
 * 	Materia: Base de Datos
 *	Codigo de la materia: 1959
 *	Profesores :	Fabio Zorzan.
 *					Guillermo Fraschetti.
 *					Mariana Frutos.
 *					
 *	Integrantes : 	Buttignol, Leandro
 *					Lòpez,Martìn
 * 	
 *	En el presente documento se encuentra el script que permite cargar
 *	los datos en la base de datos correspondiente al proyecto CONNECT 4 
 *	del ano 2015.
 */

set search_path='dbconnect4';

-- Insertamos daots correctos en la base de datos.
insert into dbconnect4.user values
	('postgres','d','d'),
	('martin@gmail.com','Martin','Lopez'),
	('leandro@hotmail.com','Leandro','Buttignol'),
	('franco@exa.unrc.edu.ar','Franco','Magnago'),
	('mariano@gmail.com','Mariano','Coria'),
	('pcastro@exa.unrc.edu.ar','Pablo','Castro'),
	('agustina@gmail.com','Agustina','Rodriguez'),
	('andi@gmail.com','Andi','Vilanova'),
	('tery@gmail.com','Tery','Langer'),
	('m_corvata@gmail.com','Marcelo','Corvalan'),
	('teja@hotmail.com','Franco Ariel','Tejada'),
	('ecerda@exa.unrc.edu.ar','Ernesto','Cerda');

insert into dbconnect4.game(D_INIT,D_END,GAME_CONDITION,RESULT,EMAIL_PLAYER1,EMAIL_PLAYER2,COL_SIZE,ROW_SIZE) values 
	('1970-01-01 00:00:01','1975-01-01 00:00:01','STAND_BY','TIE','martin@gmail.com','leandro@hotmail.com',8,8), 
	('1976-01-01 00:00:01',NULL,'STAND_BY',NULL,'martin@gmail.com','leandro@hotmail.com',8,8),
	('2010-12-10 00:00:01',NULL,'STAND_BY',NULL,'franco@exa.unrc.edu.ar','mariano@gmail.com',7,6),
	('2010-12-10 00:00:01','2010-12-11 00:00:01','FINISHED','PLAYER1','pcastro@exa.unrc.edu.ar','agustina@gmail.com',7,8),
	('2011-12-10 00:00:01','2011-12-11 00:00:01','FINISHED','PLAYER2','pcastro@exa.unrc.edu.ar','agustina@gmail.com',7,8),
	('2012-10-10 00:00:01','2012-12-11 00:00:01','FINISHED','TIE','pcastro@exa.unrc.edu.ar','agustina@gmail.com',7,8);

insert into dbconnect4.movement(COL_CELL, ROW_CELL, GAME_ID, MOVEMENT_NUMBER) values
	(1,1,1,0),(1,2,1,1),(1,3,1,2),(1,4,1,3),(1,5,1,4),(1,6,1,5),(1,7,1,6) ,(1,8,1,7),
	(2,1,1,8),(2,2,1,9),(2,3,1,10),(2,4,1,11),(2,5,1,12),(2,6,1,13),(2,7,1,14),(2,8,1,15),
	(3,1,1,16),(3,2,1,17),(3,3,1,18),(3,4,1,19),(3,5,1,20),(3,6,1,21),(3,7,1,22),(3,8,1,23),
	(4,8,1,24),(4,7,1,25),(4,6,1,26),(4,5,1,27),(4,4,1,28),(4,3,1,29),(4,2,1,30),(4,1,1,31),
	(5,8,1,32),(5,7,1,33),(5,6,1,34),(5,5,1,35),(5,4,1,36),(5,3,1,37),(5,2,1,38),(5,1,1,39),
	(6,8,1,40),(6,7,1,41),(6,6,1,42),(6,5,1,43),(6,4,1,44),(6,3,1,45),(6,2,1,46),(6,1,1,47),
	(7,1,1,48),(7,2,1,49),(7,3,1,50),(7,4,1,51),(7,5,1,52),(7,6,1,53),(7,7,1,54),(7,8,1,55),
	(8,1,1,56),(8,2,1,57),(8,3,1,58),(8,4,1,59),(8,5,1,60),(8,6,1,61),(8,7,1,62),(8,8,1,63),

	(1,1,6,1),(1,2,6,2),(1,3,6,3),(1,4,6,4),(1,5,6,5),(1,6,6,6),(1,7,6,7),(1,8,6,8),
	(2,1,6,9),(2,2,6,10),(2,3,6,11),(2,4,6,12),(2,5,6,13),(2,6,6,14),(2,7,6,15),(2,8,6,16),
	(3,1,6,17),(3,2,6,18),(3,3,6,19),(3,4,6,20),(3,5,6,21),(3,6,6,22),(3,7,6,23),(3,8,6,24),
	(4,8,6,25),(4,7,6,26),(4,6,6,27),(4,5,6,28),(4,4,6,29),(4,3,6,30),(4,2,6,31),(4,1,6,32),
	(5,8,6,33),(5,7,6,34),(5,6,6,35),(5,5,6,36),(5,4,6,37),(5,3,6,38),(5,2,6,39),(5,1,6,40),
	(6,8,6,41),(6,7,6,42),(6,6,6,43),(6,5,6,44),(6,4,6,45),(6,3,6,46),(6,2,6,47),(6,1,6,48),
	(7,1,6,49),(7,2,6,50),(7,3,6,51),(7,4,6,52),(7,5,6,53),(7,6,6,54),(7,7,6,55),(7,8,6,56),	

	(1,4,2,1),

	(1,3,3,1),(1,2,3,2),(2,3,3,3),

	(1,1,4,1),(1,6,4,2),(1,2,4,3),(1,7,4,4),(1,3,4,5),(1,8,4,6),(1,4,4,7),

	(1,1,5,1),(1,6,5,2),(1,2,5,3),(1,7,5,4),(1,3,5,5),(1,8,5,6),(1,4,5,7);	

SELECT * FROM dbconnect4.movement;

