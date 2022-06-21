/*
Принимает строку в кириллице с названием мероприятия, переводит его в латиницу,
lower case, между словами "-"
*/

DROP FUNCTION IF EXISTS `frogger`.`f_translit`;

CREATE DEFINER=`rmadmin`@`%` FUNCTION `frogger`.`f_translit`(`_txt` VARCHAR(1000)) RETURNS text CHARSET utf8mb4
BEGIN
	DECLARE _rus VARCHAR(5);
	DECLARE _eng VARCHAR(5);
	DECLARE done INT DEFAULT FALSE;
	DECLARE cur CURSOR FOR SELECT rus, eng from elt_translit;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
	OPEN cur;
	the_loop: LOOP

	-- get the values of each column into our variables
	FETCH cur INTO _eng,_rus;
	IF done THEN
	  LEAVE the_loop;
	END IF;
	SET _txt = REPLACE(LOWER(`_txt`),_eng,_rus);   
	END LOOP the_loop;
	
	CLOSE cur;

	SET _txt = CASE 
					WHEN SUBSTRING(`_txt`, 75, 1) IN ('-') 
					THEN LEFT(`_txt`, 74) 
					ELSE LEFT(`_txt`, 75) 
				END;
	RETURN _txt; 
END;


/* Проверка работоспособности */
SELECT `frogger`.`f_translit`('Что-то по-русски!');
SELECT `frogger`.`f_translit`('Что-то на русском со слишком большим количеством символов, которые будут обрузаны до оптимальных 75-ти');
