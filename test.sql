set search_path='dbconnect4';

insert into dbconnect4.user values('Martin','d','d');
insert into dbconnect4.user values('Leandro','d','d');
insert into dbconnect4.user values('postgres','d','d');


insert into dbconnect4.game values 
(1,'1970-01-01 00:00:01','1975-01-01 00:00:01','STAND_BY','TIE','Martin','Leandro',8,8);

insert into dbconnect4.game values 
(2,'1970-01-01 00:00:01',NULL,'STAND_BY','TIE','Martin','Leandro',8,8);

/*insert into dbconnect4.game values 
(3,'1970-01-01 00:00:01','1975-01-01 00:00:01','STAND_BY','TIE','Martin','Leandro',8,8);*/

insert into dbconnect4.user values('gaston','d','d');




insert into dbconnect4.game values 
(6,'1970-01-01 00:00:01','1975-01-01 00:00:01','STAND_BY','TIE','gaston','postgres',10,8);

insert into dbconnect4.movement values( 10,2,1,2);
--insert into dbconnect4.movement values( 2,3,1,4);
--insert into dbconnect4.movement values( 2,9,1,4);