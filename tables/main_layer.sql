/*
Таблица для тегов мероприятий
*/
CREATE TABLE `d_tag` (
  `tag_id`      INT          NOT NULL AUTO_INCREMENT,
  `name`        VARCHAR(255) NOT NULL,
  `nav_link`    VARCHAR(255) NOT NULL,
  `bttn_link`   VARCHAR(255) NOT NULL,
  
  PRIMARY KEY (`tag_id`)
);

/*
Таблица ролей пользователей плагина
*/
CREATE TABLE `d_role` (
  `role_id`     INT          NOT NULL AUTO_INCREMENT,
  `role_name`   VARCHAR(20)  NOT NULL,
  `desc`        LONGTEXT,
  
  PRIMARY KEY (`role_id`)
);


/*
Таблица разрешений и привилегий ролей
*/
CREATE TABLE `d_permissions` (
  `permissions_id`    INT          NOT NULL AUTO_INCREMENT,
  `action`            VARCHAR(30)  NOT NULL,
  `role_id`           INT          NOT NULL,
  
  PRIMARY KEY (`permissions_id`),
  
  CONSTRAINT `fk_permissions_role`
  FOREIGN KEY (`role_id`) 
  REFERENCES `d_role`(`role_id`)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

/*
Таблица пользователей (формируется согласно пользователям из p5mo_users)
*/
CREATE TABLE `f_user` (
  `user_id`     INT       NOT NULL,
  `role_id`     INT       NOT NULL,
  
  PRIMARY KEY (`user_id`),
  
  CONSTRAINT `fk_user_role`
  FOREIGN KEY (`role_id`) 
  REFERENCES `d_role`(`role_id`)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

/*
Таблица SQL запросов поиска по мероприятиям
*/
CREATE TABLE `f_event_query` (
  `query_id`    INT           NOT NULL AUTO_INCREMENT,
  `name`        VARCHAR(255)  NOT NULL,
  `where`       LONGTEXT      NOT NULL,
  `is_public`   BOOL          NOT NULL,
  `author_id`   INT           NOT NULL,
  
  PRIMARY KEY (`query_id`),
  
  CONSTRAINT `fk_event_query_author`
  FOREIGN KEY (`author_id`) 
  REFERENCES `f_user`(`user_id`)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

/*
Таблица источников мероприятий
*/
CREATE TABLE `d_src` (
  `src_id`      INT           NOT NULL AUTO_INCREMENT,
  `src_name`    VARCHAR(50)   NOT NULL,
  `table_name`  VARCHAR(20)   NOT NULL,
  `src_link`    VARCHAR(255)  NOT NULL,
  
  PRIMARY KEY (`src_id`)
);

/*
Таблица категорий мероприятий
*/
CREATE TABLE `d_category` (
  `category_id` INT           NOT NULL AUTO_INCREMENT,
  `name`        VARCHAR(255)  NOT NULL,
  `nav_link`    VARCHAR(255)  NOT NULL,
  `bttn_link`   VARCHAR(255)  NOT NULL,
  
  PRIMARY KEY (`category_id`)
);

/*
Таблица текущих мероприятий (не удаленных)
*/
CREATE TABLE `f_current` (
  `event_id`       BIGINT         UNSIGNED NOT NULL AUTO_INCREMENT,
  `name`           VARCHAR(255)   NOT NULL,
  `place`          VARCHAR(255),
  `date_from`      DATE,
  `date_to`        DATE,
  `link`           VARCHAR(1000),
  `post_link`      VARCHAR(75)    NOT NULL,
  `descr`          LONGTEXT,
  `excerpt`        TEXT,
  `is_published`   BOOL           NOT NULL,
  `is_draft`       BOOL           NOT NULL,
  `archived_at`    DATETIME,
  `src_id`         INT,
  `created_at`     TIMESTAMP      NOT NULL,
  `post_id`        INT,
  `author_id`      INT,
  `parent_id`      INT            NOT NULL,
  
  PRIMARY KEY (`event_id`),
  
  CONSTRAINT `fk_current_src`
  FOREIGN KEY (`src_id`) 
  REFERENCES `d_src`(`src_id`)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
    
  CONSTRAINT `fk_current_author`
  FOREIGN KEY (`author_id`) 
  REFERENCES `f_user`(`user_id`)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

/*
Таблица удаленных мероприятий
*/
CREATE TABLE `f_bin` (
  `event_id`       BIGINT         UNSIGNED NOT NULL,
  `name`           VARCHAR(255)   NOT NULL,
  `place`          VARCHAR(255),
  `date_from`      DATE,
  `date_to`        DATE,
  `link`           VARCHAR(1000),
  `post_link`      VARCHAR(75)    NOT NULL,
  `descr`          LONGTEXT,
  `excerpt`        TEXT,
  `is_published`   BOOL           NOT NULL,
  `is_draft`       BOOL           NOT NULL,
  `src_id`         INT,
  `created_at`     DATETIME       NOT NULL,
  `post_id`        INT,
  `author_id`      INT            NOT NULL,
  
  PRIMARY KEY (`event_id`),
  
  CONSTRAINT `fk_bin_src`
  FOREIGN KEY (`src_id`) 
  REFERENCES `d_src`(`src_id`)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
    
  CONSTRAINT `fk_bin_author`
  FOREIGN KEY (`author_id`) 
  REFERENCES `f_user`(`user_id`)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

/*
Таблица связи между d_tag, f_current и f_bin
*/
CREATE TABLE `m_tag_event` (
  `tag_event_id`    INT         NOT NULL AUTO_INCREMENT,
  `tag_id`          INT         NOT NULL,
  `event_id`        BIGINT      UNSIGNED NOT NULL,
  
  PRIMARY KEY (`tag_event_id`),
  
  CONSTRAINT `fk_tag_event_tag`
  FOREIGN KEY (`tag_id`) 
  REFERENCES `d_tag`(`tag_id`)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
    
  CONSTRAINT `fk_tag_event_current_event`
  FOREIGN KEY (`event_id`) 
  REFERENCES `f_current`(`event_id`)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
    
  CONSTRAINT `fk_tag_event_bin_event`
  FOREIGN KEY (`event_id`) 
  REFERENCES `f_bin`(`event_id`)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

/*
Таблица связи между d_category, f_current и f_bin
*/
CREATE TABLE `m_category_event` (
  `category_event_id`    INT         NOT NULL AUTO_INCREMENT,
  `category_id`          INT         NOT NULL,
  `event_id`             BIGINT      UNSIGNED NOT NULL,
  
  PRIMARY KEY (`category_event_id`),
  
  CONSTRAINT `fk_category_event_category`
  FOREIGN KEY (`category_id`) 
  REFERENCES `d_category`(`category_id`)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
    
  CONSTRAINT `fk_category_event_current_event`
  FOREIGN KEY (`event_id`) 
  REFERENCES `f_current`(`event_id`)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

/*
Таблица для определения, прочитана ли конкретная запись в плагине пользователем
*/
CREATE TABLE `m_is_read` (
  `is_read`     BOOL        NOT NULL,
  `event_id`    BIGINT      UNSIGNED NOT NULL,
  `user_id`     INT         NOT NULL,
  
  CONSTRAINT `fk_is_read_user`
  FOREIGN KEY (`user_id`) 
  REFERENCES `f_user`(`user_id`)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
    
  CONSTRAINT `fk_is_read_current_event`
  FOREIGN KEY (`event_id`) 
  REFERENCES `f_current`(`event_id`)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);
