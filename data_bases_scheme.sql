DROP SCHEMA IF EXISTS dbconnect4 CASCADE;
CREATE SCHEMA dbconnect4;
SET search_path='dbconnect4';


DROP TABLE IF EXISTS User CASCADE;
CREATE TABLE User(
	email varchar(56) NOT NULL PRIMARY KEY,
	firs_name varchar(56) DEFAULT NULL,
	last_name varchar(56) DEFAULT NULL
);

DROP TABLE IF EXISTS Cell CASCADE;
CREATE TABLE Cell(
	row int NOT NULL,
	column int NOT NULL,
	CONSTRAINT cellpk PRIMARY KEY(row,column)
);

DROP DOMAIN GameStatus IF EXISTS;
CREATE DOMAIN GameStatus AS varchar(20)
DEFAULT 'STAND_BY' NOT NULL CHECK('STAND_BY','FINISHED'); 

DROP DOMAIN Winner IF EXISTS;
CREATE DOMAIN Winner AS varchar(20)
DEFAULT 'NULL' CHECK('NULL', 'PLAYER1', 'PLAYER2', 'DRAW'); -- PREGUNBTAR AL CHENM

DROP TABLE IF EXISTS Game CASCADE;
CREATE TABLE Game(
	id int NOT NULL AUTOINCREMENT,
	d_init timestamp NOT NULL,
	d_end timestamp DEFAULT NULL,
	game_condition GameStatus,
	result Winner,
	email_player1 varchar(56) NOT NULL,
	email_player2 varchar(56) NOT NULL,
	column_size int NOT NULL DEFAULT 7, --VER DE CONTROLAR COLUMNA Y FIAL CON CHECK O TRIGGER
	row_size int NOT NULL DEFAULT 6,
	CONSTRAINT playe1fk FOREIGN KEY(email_player1),
	CONSTRAINT playe2fk FOREIGN KEY(email_player2) 
);

DROP TABLE Movement IF EXISTS;
CREATE TABLE Movement(
	cell_row int NOT NULL,
	cell_column int NOT NULL,
	game_id int NOT NULL,
	movement_number int NOT NULL,
	CONSTRAINT cellfk FOREIGN KEY(cell_row,cell_column),
	CONSTRAINT gamefk FOREIGN KEY(game_id),
	CONSTRAINT movementpk PRIMARY KEY(game_id,cell_row,cell_column)
);

/*	Los diferentes códigos deben ser generados automáticamente.
	No puede haber dos partidas de un mismo jugador que tengan solapamiento de fechas.
	Cuando se elimina un jugador debe eliminar las partidas que jugó. El resto de las especificaciones ON DELETE Y ON UPDATE en la definición de claves foráneas deben ser definidas por el grupo.
	La implementación de la base de datos deberá permitir generar información de auditoría automáticamente. Se deberá agregar información en una tabla sobre los eliminación de usuarios, está información deberá contener el usuario eliminado, fecha de eliminación y el usuario de la base de datos que la realizó.
	Se deberá controlar que según el tipo de tablero usado, los valores X,Y de sus celdas deben estar en el rango correcto.


*/