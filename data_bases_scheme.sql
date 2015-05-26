DROP SCHEMA IF EXISTS dbconnect4 CASCADE;
CREATE SCHEMA dbconnect4;
SET search_path='dbconnect4';

DROP TABLE IF EXISTS dbconnect4.user CASCADE ;

CREATE TABLE dbconnect4.user(
	EMAIL varchar(56) NOT NULL,
	FIRST_NAME varchar(56) DEFAULT NULL,
	LAST_NAME varchar(56) DEFAULT NULL,
	PRIMARY KEY ( EMAIL )
);

-- insert into dbconnect4.user values(CURRENT_USER,'d','d'); -- PREGUNTAR SI VA

CREATE TABLE dbconnect4.userdeleted(
	EMAIL varchar(56) NOT NULL,
	D_INIT TIMESTAMP NOT NULL,
	EMAIL_REMOVER varchar(56) NOT NULL,
	CONSTRAINT FK_USERDELETED_1 FOREIGN KEY (EMAIL_REMOVER) REFERENCES dbconnect4.user(EMAIL),
	PRIMARY KEY (EMAIL)
);

DROP TABLE IF EXISTS dbconnect4.cell CASCADE;
CREATE TABLE dbconnect4.cell(
	ROW_CELL INT NOT NULL,
	COL_CELL INT NOT NULL,
	PRIMARY KEY( ROW_CELL , COL_CELL)
);

INSERT INTO dbconnect4.cell VALUES (6,7),(8,7),(9,7),(10,7),(8,8);

DROP DOMAIN IF EXISTS GameStatus;
CREATE DOMAIN GameStatus AS varchar(20) DEFAULT 'STAND_BY' NOT NULL CHECK (VALUE IN ('STAND_BY','FINISHED'));

DROP DOMAIN IF EXISTS Winner;
CREATE DOMAIN Winner AS varchar(20) DEFAULT NULL CHECK (VALUE IN (NULL,'PLAYER1','PLAYER2','TIE'));



DROP TYPE IF EXISTS BoardSize;
CREATE TYPE BoardSize AS (R INT,C INT);


CREATE OR REPLACE FUNCTION correct_size (R INT DEFAULT 6, C INT DEFAULT 7) RETURNS BoardSize AS $correct_size$
	DECLARE b BoardSize;
	BEGIN
		b.R=correct_size.R;
		b.C=correct_size.C;

		IF EXISTS (SELECT NULL FROM dbconnect4.cell WHERE ROW_CELL=b.R AND COL_CELL=b.C) THEN
			RETURN b;
		ELSE
			RAISE EXCEPTION 'INVALID SIZE';
		END IF;
		
	END;
	$correct_size$
	LANGUAGE 'plpgsql';



DROP TABLE IF EXISTS dbconnect4.game CASCADE;
CREATE TABLE dbconnect4.game (
	ID SERIAL,			
	D_INIT TIMESTAMP NOT NULL,
	D_END TIMESTAMP DEFAULT NULL,
	GAME_CONDITION GameStatus,
	RESULT Winner,
	EMAIL_PLAYER1 varchar(56) NOT NULL,
	EMAIL_PLAYER2 varchar(56) NOT NULL,
	COL_SIZE INT DEFAULT 7,					--PREGUNTAR SI VA NOT NULL
	ROW_SIZE INT DEFAULT 6,					--IGUAL
	CONSTRAINT FK_GAME_1 FOREIGN KEY ( EMAIL_PLAYER1 ) REFERENCES dbconnect4.user ( EMAIL ),
	CONSTRAINT FK_GAME_2 FOREIGN KEY ( EMAIL_PLAYER2 ) REFERENCES dbconnect4.user ( EMAIL ),
	PRIMARY KEY (ID)
);


DROP TABLE IF EXISTS dbconnect4.movement CASCADE;
CREATE TABLE dbconnect4.movement(
	ROW_CELL INT NOT NULL,
	COL_CELL INT NOT NULL,
	GAME_ID INT NOT NULL,
	MOVEMENT_NUMBER INT NOT NULL,
	
	CONSTRAINT FK_MOVEMENT_2 FOREIGN KEY (GAME_ID) REFERENCES dbconnect4.game(ID),
	PRIMARY KEY (ROW_CELL, COL_CELL, GAME_ID)
);




CREATE OR REPLACE FUNCTION restriccion_new_game() RETURNS TRIGGER AS $restriccion_new_game$
	BEGIN
		IF EXISTS(SELECT NULL FROM dbconnect4.game WHERE (((EMAIL_PLAYER1=new.EMAIL_PLAYER1 OR EMAIL_PLAYER2=new.EMAIL_PLAYER1)AND(D_END IS NULL))OR ((EMAIL_PLAYER1=new.EMAIL_PLAYER2 OR EMAIL_PLAYER2=new.EMAIL_PLAYER2)AND(D_END IS NULL)))) THEN 
			RAISE EXCEPTION 'IMPOSSIBLE INSERT NEW GAME';		--debe tirar un error
		ELSE
			IF  EXISTS(SELECT NULL FROM correct_size(R:=new.ROW_SIZE,C:=new.COL_SIZE)) THEN
				RETURN new;
			ELSE
				RETURN 'INVALID BOARD SIZE';
			END IF;
		END IF;

		
		
	END;
	$restriccion_new_game$
	LANGUAGE 'plpgsql';

CREATE TRIGGER restriccion_new_game BEFORE INSERT ON dbconnect4.game
	FOR EACH ROW 
		EXECUTE PROCEDURE restriccion_new_game();


CREATE OR REPLACE FUNCTION eliminar_partidas() RETURNS TRIGGER AS $eliminar_partida$

	BEGIN	
		
		DELETE FROM dbconnect4.game WHERE EMAIL_PLAYER1=old.EMAIL OR EMAIL_PLAYER2=old.EMAIL;
		INSERT INTO dbconnect4.userdeleted VALUES (old.EMAIL,now(),CURRENT_USER);
		RETURN old;
		

	END;
	$eliminar_partida$
	LANGUAGE 'plpgsql';




CREATE TRIGGER eliminar_partidas BEFORE DELETE ON dbconnect4.user	--PREGUNTAR SI ES BEFORE.
	FOR EACH ROW
		EXECUTE PROCEDURE eliminar_partidas();



CREATE OR REPLACE FUNCTION verificar_col_row() RETURNS TRIGGER AS $verificar_col_row$
	BEGIN
		IF EXISTS(SELECT NULL FROM dbconnect4.game g WHERE g.ID=new.GAME_ID AND new.ROW_CELL>0 AND new.ROW_CELL<=g.ROW_SIZE AND new.COL_CELL>0 AND new.COL_CELL<=g.COL_SIZE) THEN
			RETURN new;
		ELSE
			RETURN 'INVALID ROW OR COLUMN';
		END IF;

	END;
$verificar_col_row$
LANGUAGE 'plpgsql';

CREATE TRIGGER verificar_col_row BEFORE INSERT ON dbconnect4.movement
	FOR EACH ROW
		EXECUTE PROCEDURE verificar_col_row();



/*	Los diferentes códigos deben ser generados automáticamente.
	No puede haber dos partidas de un mismo jugador que tengan solapamiento de fechas.
	Cuando se elimina un jugador debe eliminar las partidas que jugó. El resto de las especificaciones ON DELETE Y ON UPDATE en la definición de claves foráneas deben ser definidas por el grupo.
	La implementación de la base de datos deberá permitir generar información de auditoría automáticamente. Se deberá agregar información en una tabla sobre los eliminación de usuarios, está información deberá contener el usuario eliminado, fecha de eliminación y el usuario de la base de datos que la realizó.
	Se deberá controlar que según el tipo de tablero usado, los valores X,Y de sus celdas deben estar en el rango correcto.
*/
