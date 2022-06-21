/*
Принимает день и месяц проведения мероприятия,
возвращает дату проведения (типа данных date)
*/
DROP FUNCTION IF EXISTS `frogger`.`f_date`;

CREATE DEFINER=`rmadmin`@`%` FUNCTION `frogger`.`f_date`(`_day` int,`_month` text) RETURNS date
BEGIN
	DECLARE _eng varchar(50);
	DECLARE _rus varchar(50);
	DECLARE `_year` int;
	DECLARE `_date` date;
	DECLARE done INT DEFAULT FALSE;
	DECLARE cur CURSOR FOR SELECT eng, rus from `elt_month`;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
	open cur;
	the_loop: LOOP

	-- get the values of each column into our variables
	FETCH cur INTO _eng,_rus;
	IF done THEN
	  LEAVE the_loop;
	END IF;
	set `_month` = replace(lower(`_month`),_rus,_eng);
	END LOOP the_loop;

	SET `_year` = IF(
					month(CURDATE()) > month(str_to_date(concat('1', `_month`, '1000'),'%d %M %Y')),
					year(CURDATE()) + 1,
					year(CURDATE())
				);
	SET `_date` = str_to_date(CONCAT(CONVERT(`_day`, CHAR), `_month`, CONVERT(`_year`, CHAR)),'%d %M %Y');

	CLOSE cur;
	RETURN `_date`;
END;

/* Проверка работоспособности */
SELECT `frogger`.`f_date`(31, 'мая');
SELECT `frogger`.`f_date`(31, 'Октября');
