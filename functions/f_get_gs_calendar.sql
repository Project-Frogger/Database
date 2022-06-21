/*
Заполняет фактовую таблицу f_post из таблицы источника rb src_gs_calendar
*/
DROP PROCEDURE IF EXISTS `frogger`.`f_get_gs_calendar`;

CREATE DEFINER=`rmadmin`@`%` PROCEDURE `frogger`.`f_get_gs_calendar`()
BEGIN
	
	DECLARE _day_to INT;
	DECLARE _month_to VARCHAR(50);
	DECLARE _day_from INT;
	DECLARE _month_from VARCHAR(50);
    	
    -- создаем временную таблицу, чтобы обрабатывать дату только новых записей из src_gs_calendar
	DROP TABLE IF EXISTS temp_current;

	CREATE TEMPORARY TABLE temp_current (LIKE f_current);

	ALTER TABLE temp_current ADD event_date TEXT;
    INSERT INTO temp_current (name, place, link, post_link, descr, excerpt, is_published, is_draft, archived_at, src_id, parent_id, event_date)
    SELECT src.name,
           src.place,
    	   src.site,
    	   -- переводим название в транслит
    	   (SELECT `f_translit`(src.name)) AS post_link,

    	   src.descr,
    	   NULL AS excerpt,
    	   
    	   FALSE AS is_published,
    	   FALSE AS is_draft,
    	   NULL  AS archived_at,
    	   
    	   d_src.src_id,
    	   0 AS parent_id,
    	   src.event_date
      FROM src_gs_calendar src
    
    -- проверяем наличие записи в целевой таблице
    -- если мероприятие уже есть, но какое-то из его полей обновилось на источнике
    -- то оно записывается снова, но с другой отметкой времени timestamp
           LEFT JOIN f_current fc
           ON  src.name = fc.name
           AND src.site = fc.link
           AND src.descr = fc.descr
    
           CROSS JOIN d_src
     WHERE table_name = 'src_gs_calendar' AND fc.name IS Null;

    -- вычисляем даты проведения по исходной строке event_date
	UPDATE temp_current
	   SET date_to = IF(
                        LOCATE('-',SUBSTRING_INDEX(SUBSTRING_INDEX(`event_date`, ' ', 3), ' ', -3)) = 0,
					        `f_date`(SUBSTRING_INDEX(SUBSTRING_INDEX(`event_date`, ' ', 1), ' ', -1), SUBSTRING_INDEX(SUBSTRING_INDEX(`event_date`, ' ', 2), ' ', -1)),
				            Null
                        ),
   	     date_from = IF(
                    LOCATE('-',SUBSTRING_INDEX(SUBSTRING_INDEX(`event_date`, ' ', 3), ' ', -3)) = 0,
				        `f_date`(SUBSTRING_INDEX(SUBSTRING_INDEX(`event_date`, ' ', 1), ' ', -1), SUBSTRING_INDEX(SUBSTRING_INDEX(`event_date`, ' ', 2), ' ', -1)),
			            Null
                    );
					  
	UPDATE temp_current
	   SET date_to = IF(
                        LOCATE('-',SUBSTRING_INDEX(SUBSTRING_INDEX(`event_date`, ' ', 2), ' ', -2)) <> 0,
					        `f_date`(SUBSTRING_INDEX(SUBSTRING_INDEX(`event_date`, ' ', 3), ' ', -1), SUBSTRING_INDEX(SUBSTRING_INDEX(`event_date`, ' ', 4), ' ', -1)),
				  
				            IF(
                               LOCATE('-',SUBSTRING_INDEX(SUBSTRING_INDEX(`event_date`, ' ', 3), ' ', -3)) <> 0,
				                    `f_date`(SUBSTRING_INDEX(SUBSTRING_INDEX(`event_date`, ' ', 4), ' ', -1), SUBSTRING_INDEX(SUBSTRING_INDEX(`event_date`, ' ', 5), ' ', -1)),
				  
				                    IF(
                                       LOCATE('-',SUBSTRING_INDEX(SUBSTRING_INDEX(`event_date`, ' ', 4), ' ', -4)) <> 0,
				                           `f_date`(SUBSTRING_INDEX(SUBSTRING_INDEX(`event_date`, ' ', 5), ' ', -1), SUBSTRING_INDEX(SUBSTRING_INDEX(`event_date`, ' ', 6), ' ', -1)),
				                           date_to
				                    )
				            )
				    ),
	       date_from = IF(
                          LOCATE('-',SUBSTRING_INDEX(SUBSTRING_INDEX(`event_date`, ' ', 2), ' ', -2)) <> 0,
					          `f_date`(SUBSTRING_INDEX(SUBSTRING_INDEX(`event_date`, ' ', 1), ' ', -1), SUBSTRING_INDEX(SUBSTRING_INDEX(`event_date`, ' ', 4), ' ', -1)),
				  
				              IF(
                                 LOCATE('-',SUBSTRING_INDEX(SUBSTRING_INDEX(`event_date`, ' ', 3), ' ', -3)) <> 0,
				                     `f_date`(SUBSTRING_INDEX(SUBSTRING_INDEX(`event_date`, ' ', 1), ' ', -1), SUBSTRING_INDEX(SUBSTRING_INDEX(`event_date`, ' ', 2), ' ', -1)),
				  
				                     IF(
                                        LOCATE('-',SUBSTRING_INDEX(SUBSTRING_INDEX(`event_date`, ' ', 4), ' ', -4)) <> 0,
				                            `f_date`(SUBSTRING_INDEX(SUBSTRING_INDEX(`event_date`, ' ', 1), ' ', -1), SUBSTRING_INDEX(SUBSTRING_INDEX(`event_date`, ' ', 2), ' ', -1)),
				                            date_from
				                    )
				            )
				        );

    -- заносим данные в целевую таблицу	
	INSERT INTO f_current (name, place, date_from, date_to, link, post_link, descr, excerpt, is_published, is_draft, archived_at, src_id, parent_id)
	SELECT name, place, date_from, date_to, link, post_link, descr, excerpt, is_published, is_draft, archived_at, src_id, parent_id
      FROM temp_current;
   
END;


/* Проверка работоспособности */
call `frogger`.`f_get_gs_calendar`();
select * from src_gs_calendar;
select * from f_current;
select * from temp_current;
