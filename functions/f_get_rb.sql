/*
Заполняет фактовую таблицу f_current из таблицы источника rb
*/
DROP PROCEDURE IF EXISTS `frogger`.`f_get_rb`;

CREATE DEFINER=`rmadmin`@`%` PROCEDURE `frogger`.`f_get_rb`()
BEGIN  
    INSERT INTO f_current (name, place, date_from, date_to, link, post_link, descr, excerpt, is_published, is_draft, archived_at, src_id, parent_id)
    SELECT rb.name,
    	   NULL AS place,
    	   -- получаем дату проведения мероприятия
    	   (SELECT `frogger`.`f_date`(event_day, event_month)) AS date_from,
    	   (SELECT `frogger`.`f_date`(event_day, event_month)) AS date_to,
    	   
    	   rb.site,
    	   -- переводим название в транслит
    	   (SELECT `frogger`.`f_translit`(rb.name)) AS post_link,
    	   
    	   NULL AS descr,
    	   NULL AS excerpt,
    	   
    	   FALSE AS is_published,
    	   FALSE AS is_draft,
    	   NULL  AS archived_at,
    	   
    	   d_src.src_id,
    	   0 AS parent_id
      FROM src_rb rb
    
    -- проверяем наличие записи в целевой таблице
    -- если мероприятие уже есть, но какое-то из его полей обновилось на источнике
    -- то оно записывается снова, но с другой отметкой времени timestamp
          LEFT JOIN f_current fc
          ON rb.name = fc.name
          AND rb.site = fc.link
          AND (SELECT `f_date`(event_day, event_month)) = fc.date_to
        
          CROSS JOIN d_src
    WHERE table_name = 'src_rb' AND fc.name IS NULL;
   
   
    -- добавляем категорию мероприятия в соответсвии с d_category
   INSERT INTO m_category_event (category_id, event_id)
   SELECT CASE
	   		   WHEN event_type = 'Акселерации' THEN 1
	   		   WHEN event_type = 'Хакатоны'    THEN 6
	   		   WHEN event_type = 'Конкурсы'    THEN 4
	   		   WHEN event_type IN ('Гранты', 'Young', 'Другое') THEN 2
	   		   ELSE NULL
	   	  END AS category_id,
	   	  fc.event_id
	 FROM f_current fc
	 	  JOIN src_rb rb
	 	  ON fc.name = rb.name
	 	  
	 	  LEFT JOIN m_category_event mce
	 	  ON fc.event_id = mce.event_id
	WHERE mce.category_event_id IS NULL;
END;


/* Проверка работоспособности */
call `frogger`.`f_get_rb`();
