INSERT INTO `d_category` (name, nav_link, bttn_link)
VALUES ('Акселераторы'      , 'акселераторы'      , '/all-events/accelerators/'      ),
	   ('Другое'            , 'другое'            , '/all-events/other/'             ),
	   ('Кейс-чемпионаты'   , 'кейс-чемпионаты'   , '/all-events/case-championships/'),
	   ('Конкурсы проектов' , 'конкурсы-проектов' , '/all-events/project-contests/'  ),
	   ('Конференции'       , 'конференции'       , '/all-events/conferences/'       ),
	   ('Хакатоны'          , 'хакатоны'          , '/all-events/hackathons/'        );
	   
	   
INSERT INTO `d_role` (role_name, `desc`)
VALUES ('reader'      , 'Читатель'      ),
	   ('contributor' , 'Редактор'      ),
	   ('admin'       , 'Администратор' );


INSERT INTO `d_permissions` (`action`, role_id)
VALUES ('read'       , '1' ),
	   ('read'       , '2' ),
	   ('create'     , '2' ),
	   ('edit_own'   , '2' ),
	   ('delete_own' , '2' ),
	   ('read'       , '3' ),
	   ('create'     , '3' ),
	   ('edit'       , '3' ),
	   ('delete'     , '3' );


INSERT INTO `d_src` (src_name, table_name, src_link)
VALUES ('changellenge.com'      , 'src_change'      , 'https://changellenge.com/event/'         ),
	   ('Публичная форма'       , 'src_form'        , ''                                        ),
	   ('generation-startup.ru' , 'src_gs_calendar' , 'https://generation-startup.ru/calendar/' ),
	   ('generation-startup.ru' , 'src_gs_startups' , 'https://generation-startup.ru/startups/' ),
	   ('Информационное письмо' , 'src_info_letter' , ''                                        ),
	   ('rb.ru'                 , 'src_rb'          , 'https://rb.ru/chance/'                   );


INSERT INTO `d_tag` (name, nav_link, bttn_link)
VALUES ('Scopus'  , 'scopus'  , '/tag/scopus/'  ),
	   ('ИГУиП'   , 'iguip'   , '/tag/iguip/'   ),
	   ('ИИС'     , 'iis'     , '/tag/iis/'     ),
	   ('ИМ'      , 'im'      , '/tag/im/'      ),
	   ('ИОМ'     , 'iom'     , '/tag/iom/'     ),
	   ('ИУПСиБК' , 'iupsibk' , '/tag/iupsibk/' ),
	   ('ИЭФ'     , 'ief'     , '/tag/ief/'     ),
	   ('РИНЦ'    , 'rinc'    , '/tag/rinc/'    );
	  