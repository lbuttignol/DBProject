/*	PROYECTO DE BASE DE DATOS CONNECT 4
 *	Año: 2015
 * 	Materia: Base de Datos
 *	Codigo de la materia: 1959
 *	Profesores :	Fabio Zorzan.
 *			Guillermo Fraschetti.
 *			Mariana Frutos.
 *					
 *	Integrantes : 	Buttignol, Leandro
 *			Lòpez,Martìn
 * 	
 *	En el presente documento se encuentra el script que permite la creacion de 
 * 	la base de datos requerida en el proyecto.
 */



DROP SCHEMA IF EXISTS dbconnect4 CASCADE;
CREATE SCHEMA dbconnect4;
SET search_path='dbconnect4';

DROP TABLE IF EXISTS dbconnect4.user CASCADE ;

-- creamos el dominio que idica el estado del juego.
DROP DOMAIN IF EXISTS GameStatus;
CREATE DOMAIN GameStatus AS varchar(20) DEFAULT 'STAND_BY' NOT NULL CHECK (VALUE IN ('STAND_BY','FINISHED'));

-- crea el dominio que indica el ganador del juego, en el caso que no haya uno indicara TIE, 
-- si el juego no esta finalizado el valor por defecto es "TIE" 
DROP DOMAIN IF EXISTS Winner;
CREATE DOMAIN Winner AS varchar(20) DEFAULT NULL CHECK (VALUE IN (NULL,'PLAYER1','PLAYER2','TIE'));

-- creamos la tabla user.
CREATE TABLE dbconnect4.user(
	EMAIL varchar(56) NOT NULL,
	FIRST_NAME varchar(56) DEFAULT NULL,
	LAST_NAME varchar(56) DEFAULT NULL,
	PRIMARY KEY ( EMAIL )
);


-- creamos la talba userdeleted que contiene la informacion de 
-- auditoria para controlas los usuarios que fueron eliminados, 
-- por quien fueron eliminados y la fecha en la cual ocurrio el suceso.
DROP TABLE IF EXISTS dbconnect4.userdeleted CASCADE;
CREATE TABLE dbconnect4.userdeleted(
	EMAIL varchar(56) NOT NULL,
	D_INIT TIMESTAMP NOT NULL,
	EMAIL_REMOVER varchar(56) NOT NULL,
	PRIMARY KEY (EMAIL)
);

-- creamos la tabla cell que contiene todas las celdas que pertenecen a
-- un tablero con su respectiva posicion, es decir fila y columna.
DROP TABLE IF EXISTS dbconnect4.cell CASCADE;
CREATE TABLE dbconnect4.cell(
	ROW_CELL INT NOT NULL,
	COL_CELL INT NOT NULL,
	PRIMARY KEY( ROW_CELL , COL_CELL)
);


-- declaramos un tipo que utilizamos para controlar el tamaño del talbero.
DROP TYPE IF EXISTS BoardSize;
CREATE TYPE BoardSize AS (R INT,C INT);

-- funcion que controla que el tamaño del tablero sea un tamaño correcto,
-- como dice la consigna del proyecto, los tamaños validos son (fila, columna), (6x7),(8x7),(9x7),(10x7),(8x8)
CREATE OR REPLACE FUNCTION correct_size (R INT DEFAULT 6, C INT DEFAULT 7) RETURNS BoardSize AS $correct_size$
	DECLARE b BoardSize;
	BEGIN
		b.R=correct_size.R;
		b.C=correct_size.C;
		IF b.C=7 THEN
			IF b.R=6 OR b.R=8 OR b.R=9 OR b.R=10 THEN
				RETURN b;
			ELSE
				RAISE EXCEPTION 'INVALID SIZE';
			END IF;
		END IF;
		IF b.C=8 AND b.R=8 THEN
			RETURN b;
		ELSE 
			RAISE EXCEPTION 'INVALID SIZE';
		END IF;
		
	END;
	$correct_size$
	LANGUAGE 'plpgsql';


-- creamos la talba game que contiene la informacion del partido que se va a jugar
DROP TABLE IF EXISTS dbconnect4.game CASCADE;
CREATE TABLE dbconnect4.game (
	ID SERIAL,			
	D_INIT TIMESTAMP DEFAULT NOW(),
	D_END TIMESTAMP DEFAULT NULL,
	GAME_CONDITION GameStatus,
	RESULT Winner,
	EMAIL_PLAYER1 varchar(56) NOT NULL,
	EMAIL_PLAYER2 varchar(56) NOT NULL,
	COL_SIZE INT DEFAULT 7,					
	ROW_SIZE INT DEFAULT 6,					
	CONSTRAINT FK_GAME_1 FOREIGN KEY ( EMAIL_PLAYER1 ) REFERENCES dbconnect4.user ( EMAIL ) ON DELETE CASCADE,
	CONSTRAINT FK_GAME_2 FOREIGN KEY ( EMAIL_PLAYER2 ) REFERENCES dbconnect4.user ( EMAIL ) ON DELETE CASCADE,
	PRIMARY KEY (ID)
);

-- creamos la tabla movement que se encarga de guardar todos los movimientos 
-- de la partida con su respectivo orden, para luego porder recuperar una partida deseada 
DROP TABLE IF EXISTS dbconnect4.movement CASCADE;
CREATE TABLE dbconnect4.movement(
	ROW_CELL INT NOT NULL,
	COL_CELL INT NOT NULL,
	GAME_ID INT NOT NULL,
	MOVEMENT_NUMBER INT NOT NULL,
	CONSTRAINT FK_MOVEMENT_1 FOREIGN KEY (ROW_CELL , COL_CELL) REFERENCES dbconnect4.cell(ROW_CELL,COL_CELL) ON DELETE CASCADE,
	CONSTRAINT FK_MOVEMENT_2 FOREIGN KEY (GAME_ID) REFERENCES dbconnect4.game(ID) ON DELETE CASCADE,
	PRIMARY KEY (ROW_CELL, COL_CELL, GAME_ID)
);

-- funcion que llamamos en el trigger restriccion_new_game, 
-- controla que el tamaño del tablero de juego sea correcto,
-- y que no haya solapamiento de fechas en las partidas de los dos jugadores.
CREATE OR REPLACE FUNCTION restriccion_new_game() RETURNS TRIGGER AS $restriccion_new_game$
	BEGIN
		IF EXISTS(SELECT NULL FROM dbconnect4.game WHERE (((EMAIL_PLAYER1=new.EMAIL_PLAYER1 OR EMAIL_PLAYER2=new.EMAIL_PLAYER1)AND(D_END IS NULL))OR ((EMAIL_PLAYER1=new.EMAIL_PLAYER2 OR EMAIL_PLAYER2=new.EMAIL_PLAYER2)AND(D_END IS NULL)))) THEN 
			RAISE EXCEPTION 'IMPOSSIBLE INSERT NEW GAME';		
		ELSE
			IF  EXISTS(SELECT NULL FROM correct_size(R:=new.ROW_SIZE,C:=new.COL_SIZE)) THEN
				IF NOT EXISTS (SELECT NULL FROM dbconnect4.game WHERE (new.D_INIT>D_INIT AND new.D_INIT<D_END OR (new.D_END>D_INIT AND new.D_END<D_END))AND (new.EMAIL_PLAYER1=EMAIL_PLAYER1 OR new.EMAIL_PLAYER2=EMAIL_PLAYER1 OR new.EMAIL_PLAYER1=EMAIL_PLAYER2 OR new.EMAIL_PLAYER2=EMAIL_PLAYER2)) THEN
					RETURN new;
				ELSE 
					RAISE EXCEPTION 'IMPOSSIBLE INSERT NEW GAME. OVERLAPPING DATE';
				END IF;
			ELSE
				RAISE EXCEPTION 'INVALID BOARD SIZE';
			END IF;
		END IF;	
	END;
	$restriccion_new_game$
	LANGUAGE 'plpgsql';

CREATE TRIGGER restriccion_new_game BEFORE INSERT ON dbconnect4.game
	FOR EACH ROW 
		EXECUTE PROCEDURE restriccion_new_game();

-- funcion que crea la informacion de auditoria de un usuario en el momento que es eliminado
CREATE OR REPLACE FUNCTION auditar_usuario() RETURNS TRIGGER AS $eliminar_partida$

	BEGIN	
		INSERT INTO dbconnect4.userdeleted VALUES (old.EMAIL,now(),CURRENT_USER);
		RETURN old;	
	END;
	$eliminar_partida$
	LANGUAGE 'plpgsql';

CREATE TRIGGER auditar_usuario AFTER DELETE ON dbconnect4.user
	FOR EACH ROW
		EXECUTE PROCEDURE auditar_usuario();

-- Verifica que el movimiento sea un movimiento vàlido
CREATE OR REPLACE FUNCTION verificar_col_row() RETURNS TRIGGER AS $verificar_col_row$
	BEGIN
		IF EXISTS(SELECT NULL FROM dbconnect4.game g WHERE g.ID=new.GAME_ID AND new.ROW_CELL>0 AND new.ROW_CELL<=g.ROW_SIZE AND new.COL_CELL>0 AND new.COL_CELL<=g.COL_SIZE) THEN
			IF NOT EXISTS (SELECT NULL FROM dbconnect4.cell c WHERE c.ROW_CELL=new.ROW_CELL AND c.COL_CELL=new.COL_CELL ) THEN
				INSERT INTO dbconnect4.cell values (new.ROW_CELL,new.COL_CELL);
			END IF;
			RETURN new;
		ELSE
			RAISE EXCEPTION 'INVALID ROW OR COLUMN';
		END IF;
	END;
$verificar_col_row$
LANGUAGE 'plpgsql';

CREATE TRIGGER verificar_col_row BEFORE INSERT ON dbconnect4.movement
	FOR EACH ROW
		EXECUTE PROCEDURE verificar_col_row();



/*Definición de views para facilitar el cálculo del promedio de fichas por partido de cada usuario*/


DROP VIEW IF EXISTS uno CASCADE;
CREATE VIEW uno AS SELECT ID, EMAIL_PLAYER1 AS EMAIL FROM dbconnect4.game;

DROP VIEW IF EXISTS dos CASCADE;
CREATE VIEW dos AS SELECT ID, EMAIL_PLAYER2 AS EMAIL FROM dbconnect4.game;


DROP VIEW IF EXISTS tres CASCADE;
CREATE VIEW tres AS SELECT ID, EMAIL, count(MOVEMENT_NUMBER ) AS COUNTER FROM (uno JOIN dbconnect4.movement on ( uno.ID=dbconnect4.movement.GAME_ID AND dbconnect4.movement.MOVEMENT_NUMBER  % 2= 0)) GROUP BY ID,EMAIL;



DROP VIEW IF EXISTS cuatro CASCADE;
CREATE VIEW cuatro AS SELECT ID, EMAIL, count(MOVEMENT_NUMBER ) AS COUNTER FROM (dos JOIN dbconnect4.movement ON (dos.ID=dbconnect4.movement.GAME_ID AND dbconnect4.movement.MOVEMENT_NUMBER  % 2= 1)) GROUP BY ID,EMAIL;

DROP VIEW IF EXISTS cinco CASCADE;
CREATE VIEW cinco AS (SELECT * FROM tres UNION SELECT * FROM cuatro);

