
/*
Таблица для перевода месяца на английский язык и дальнейшего его преобразования в формат date
*/
CREATE TABLE `elt_month` (
  `eng`    VARCHAR(20) NOT NULL,
  `rus`    VARCHAR(20) NOT NULL
);

/*
Таблица для перевода названия мероприятия в транслит для формирования ярлыка поста
*/
CREATE TABLE `elt_translit` (
  `eng`    VARCHAR(5)  NOT NULL,
  `rus`    VARCHAR(5)  NOT NULL
);
