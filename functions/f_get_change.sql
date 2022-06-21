/*
Заполняет фактовую таблицу f_current из таблицы источника src_change
*/
DROP PROCEDURE IF EXISTS `frogger`.`f_get_change`;

CREATE DEFINER=`rmadmin`@`%` PROCEDURE `frogger`.`f_get_change`()
BEGIN  
    INSERT INTO f_current (name, place, date_from, date_to, link, post_link, descr, excerpt, is_published, is_draft, archived_at, src_id, parent_id)
    SELECT sc.name,
    	   NULL AS place,
    	   -- получаем дату проведения мероприятия
    	   (SELECT `frogger`.`f_date`(event_day, event_month)) AS date_from,
    	   (SELECT `frogger`.`f_date`(event_day, event_month)) AS date_to,
    	   
    	   sc.site,
    	   -- переводим название в транслит
    	   (SELECT `frogger`.`f_translit`(sc.name)) AS post_link,
    	   
    	   NULL AS descr,
    	   NULL AS excerpt,
    	   
    	   FALSE AS is_published,
    	   FALSE AS is_draft,
    	   NULL  AS archived_at,
    	   
    	   d_src.src_id,
    	   0 AS parent_id
      FROM src_change sc
    
    -- проверяем наличие записи в целевой таблице
    -- если мероприятие уже есть, но какое-то из его полей обновилось на источнике
    -- то оно записывается снова, но с другой отметкой времени timestamp
          LEFT JOIN f_current fc
          ON sc.name = fc.name
          AND sc.site = fc.link
          AND (SELECT `f_date`(event_day, event_month)) = fc.date_to
          
          CROSS JOIN d_src
    WHERE table_name = 'src_change'
   	AND fc.name IS Null
    AND sc.event_type NOT IN ('Вебинар');
END;


/* Проверка работоспособности */
call `frogger`.`f_get_change`();
