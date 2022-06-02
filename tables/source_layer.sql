/*
Таблица для https://generation-startup.ru/startups/
*/
CREATE TABLE `src_gs_startups` (
  `event_id`    INT           NOT NULL AUTO_INCREMENT,
  `name`        VARCHAR(255)  NOT NULL,
  `site`        VARCHAR(1000),
  PRIMARY KEY (`event_id`)
);

/*
Таблица для https://generation-startup.ru/calendar/
*/
CREATE TABLE `src_gs_calendar` (
  `event_id`    INT           NOT NULL AUTO_INCREMENT,
  `name`        VARCHAR(255)  NOT NULL,
  `event_date`  VARCHAR(50),
  `place`       VARCHAR(255),
  `site`        VARCHAR(1000),
  `descr`       LONGTEXT,
  PRIMARY KEY (`event_id`)
);

/*
Таблица для https://rb.ru/chance/
*/
CREATE TABLE `src_rb` (
  `event_id`    INT           NOT NULL AUTO_INCREMENT,
  `name`        VARCHAR(255)  NOT NULL,
  `event_day`   TINYINT,
  `event_month` VARCHAR(20),
  `site`        VARCHAR(1000),
  `event_type`  VARCHAR(50),
  PRIMARY KEY (`event_id`)
);

/*
Таблица для https://changellenge.com/event/
*/
CREATE TABLE `src_change` (
  `event_id`    INT           NOT NULL AUTO_INCREMENT,
  `name`        VARCHAR(255)  NOT NULL,
  `event_day`   TINYINT,
  `event_month` VARCHAR(20),
  `site`        VARCHAR(1000),
  `event_type`  VARCHAR(50),
  PRIMARY KEY (`event_id`)
);


/*
Таблица для информационных писем, загруженных через бота
*/
CREATE TABLE `src_info_letter` (
  `event_id`    INT           NOT NULL AUTO_INCREMENT,
  `name`        VARCHAR(255)  NOT NULL,
  `link`        VARCHAR(1000) NOT NULL,
  `comment`     LONGTEXT,
  PRIMARY KEY (`event_id`)
);

/*
Таблица для формы на сайте
*/
CREATE TABLE `src_form` (
  `event_id`    INT           NOT NULL AUTO_INCREMENT,
  `name`        VARCHAR(255)  NOT NULL,
  `descr`       LONGTEXT      NOT NULL,
  `place`       VARCHAR(255)  NOT NULL,
  `link`        VARCHAR(1000) NOT NULL,
  `date_from`   DATE          NOT NULL,
  `date_to`     DATE          NOT NULL,
  `category`    VARCHAR(255)  NOT NULL,
  PRIMARY KEY (`event_id`)
);
