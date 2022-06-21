DROP PROCEDURE IF EXISTS `frogger`.`f_get_gs_startups`;

CREATE DEFINER=`rmadmin`@`%` PROCEDURE `frogger`.`f_get_gs_startups`()
BEGIN  
    INSERT INTO f_current (name, link, post_link, event_type, is_published, is_deleted, src_id)
    SELECT src.name,
    	   src.site,
    	   -- переводим название в транслит
    	   (SELECT `f_translit`(src.name)) as post_link,
    	   -- 'Акселератор' AS event_type,
    	   NULL AS descr,
    	   NULL AS excerpt,
    	   
    	   FALSE AS is_published,
    	   FALSE AS is_draft,
    	   NULL  AS archived_at,
    	   
    	   d_src.src_id,
    	   0 AS parent_id 
      FROM src_gs_startups src
    
    -- проверяем наличие записи в целевой таблице
    -- если мероприятие уже есть, но какое-то из его полей обновилось на источнике
    -- то оно записывается снова, но с другой отметкой времени timestamp
          LEFT JOIN f_current fc
          ON src.name = fc.name
          AND src.site = fc.link
        
          CROSS JOIN d_src
    WHERE table_name = 'src_gs_startups' AND fc.name IS Null;
   
       -- добавляем категорию мероприятия в соответсвии с d_category
   INSERT INTO m_category_event (category_id, event_id)
   SELECT 1 AS category_id,
	   	  fc.event_id
	 FROM f_current fc
	 	  JOIN src_rb rb
	 	  ON fc.name = rb.name
	 	  
	 	  LEFT JOIN m_category_event mce
	 	  ON fc.event_id = mce.event_id
	WHERE mce.category_event_id IS NULL;
END;

/* Проверка работоспособности */
call `frogger`.`f_get_gs_startups`();
select * from src_gs_startups;
select * from f_current fc left join m_category_event mce ON fc.event_id = mce.event_id left join d_category dc on mce.category_id = dc.category_id;
select * from temp_current;
