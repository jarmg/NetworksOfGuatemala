CREATE TABLE CELLS_QOS_4G AS select * 
from PROFILING.cells_qos 
JOIN PROFILING.CELL_MAPPING
ON LVL_VAL = BTS_SH_NM
where time4g > 0;

CREATE TABLE CELLS_QOS_3G AS select * 
from PROFILING.cells_qos 
JOIN PROFILING.CELL_MAPPING
ON LVL_VAL = BTS_SH_NM
where time3g > 0;

CREATE TABLE CELLS_QOS_2G AS select * 
from PROFILING.cells_qos 
JOIN PROFILING.CELL_MAPPING
ON LVL_VAL = BTS_SH_NM
where time2g > 0;

create index qos_cell_day_2g on cells_qos_2g (bts_lng_nm, fct_dt);
create index qos_cell_day_3g on cells_qos_3g (bts_lng_nm, fct_dt);
create index qos_cell_day_4g on cells_qos_4g (bts_lng_nm, fct_dt);

create index qos_cell_id_2g on cells_qos_2g (bts_lng_nm);
create index qos_cell_id_3g on cells_qos_3g (bts_lng_nm);
create index qos_cell_id_4g on cells_qos_4g (bts_lng_nm);


/* 20,928,707 measurements from 10,806*/
select count(distinct BTS_SH_NM) from cells_qos_2g;

/* 64,713,293 measurement from 24,596 cells*/
select count(*), count(distinct BTS_SH_NM) from cells_qos_3g;

/* 9,684,310 measurements from 9,766 cells*/
select count(*), count(distinct BTS_SH_NM) from cells_qos_4g;



/* BUILD SERVICE CATEGORIZATION TABLE */

create table service_categories (
    service varchar(50),
    category varchar(50)
);

INSERT INTO service_categories (service, category) VALUES ('facebook', 'social');
INSERT INTO service_categories (service, category) VALUES ('vine.co', 'social');
INSERT INTO service_categories (service, category) VALUES ('free.facebook.com', 'social');
INSERT INTO service_categories (service, category) VALUES ('facebook.gt', 'social');
INSERT INTO service_categories (service, category) VALUES ('msn', 'social');
INSERT INTO service_categories (service, category) VALUES ('0.facebook.com', 'social');
INSERT INTO service_categories (service, category) VALUES ('google_plus', 'social');
INSERT INTO service_categories (service, category) VALUES ('facebook.com.gt', 'social');
INSERT INTO service_categories (service, category) VALUES ('facebook_media', 'social');
INSERT INTO service_categories (service, category) VALUES ('twitter', 'social');
INSERT INTO service_categories (service, category) VALUES ('hi5.com', 'social');
INSERT INTO service_categories (service, category) VALUES ('twitter.com', 'social');
INSERT INTO service_categories (service, category) VALUES ('t.co', 'social');
INSERT INTO service_categories (service, category) VALUES ('pinterest', 'social');
INSERT INTO service_categories (service, category) VALUES ('facebook.com', 'social');
INSERT INTO service_categories (service, category) VALUES ('fb.me', 'social');
INSERT INTO service_categories (service, category) VALUES ('msn.com', 'social');
INSERT INTO service_categories (service, category) VALUES ('instagram', 'social');
INSERT INTO service_categories (service, category) VALUES ('fbcdn.net', 'social');
INSERT INTO service_categories (service, category) VALUES ('2bunnylabs.com', 'social');
INSERT INTO service_categories (service, category) VALUES ('foursquare', 'social');
INSERT INTO service_categories (service, category) VALUES ('facebook.net', 'social');
INSERT INTO service_categories (service, category) VALUES ('elquetzalteco.com.gt', 'ntlNews');
INSERT INTO service_categories (service, category) VALUES ('publinews.gt', 'ntlNews');
INSERT INTO service_categories (service, category) VALUES ('prensalibre.com.gt', 'ntlNews');
INSERT INTO service_categories (service, category) VALUES ('republica.gt', 'ntlNews');
INSERT INTO service_categories (service, category) VALUES ('s21.com.gt', 'ntlNews');
INSERT INTO service_categories (service, category) VALUES ('sonora.com.gt', 'ntlNews');
INSERT INTO service_categories (service, category) VALUES ('diariodigital.gt', 'ntlNews');
INSERT INTO service_categories (service, category) VALUES ('contrapoder.com.gt', 'ntlNews');
INSERT INTO service_categories (service, category) VALUES ('canalantigua.tv', 'ntlNews');
INSERT INTO service_categories (service, category) VALUES ('prensalibre.com', 'ntlNews');
INSERT INTO service_categories (service, category) VALUES ('relato.gt', 'ntlNews');
INSERT INTO service_categories (service, category) VALUES ('agn.com.gt', 'ntlNews');
INSERT INTO service_categories (service, category) VALUES ('s02.gt', 'ntlNews');
INSERT INTO service_categories (service, category) VALUES ('prensalibre', 'ntlNews');
INSERT INTO service_categories (service, category) VALUES ('emisoras.com.gt', 'ntlNews');
INSERT INTO service_categories (service, category) VALUES ('guatevision.com', 'ntlNews');
INSERT INTO service_categories (service, category) VALUES ('republicagt.com', 'ntlNews');
INSERT INTO service_categories (service, category) VALUES ('lahora.com.gt', 'ntlNews');
INSERT INTO service_categories (service, category) VALUES ('chapintv.com', 'ntlNews');
INSERT INTO service_categories (service, category) VALUES ('lahora.gt', 'ntlNews');
INSERT INTO service_categories (service, category) VALUES ('deguate.com', 'ntlNews');
INSERT INTO service_categories (service, category) VALUES ('nuestrodiario.com', 'ntlNews');
INSERT INTO service_categories (service, category) VALUES ('emisorasunidas.com', 'ntlNews');
INSERT INTO service_categories (service, category) VALUES ('soy502.com', 'ntlNews');
INSERT INTO service_categories (service, category) VALUES ('elperiodico.com.gt', 'ntlNews');
INSERT INTO service_categories (service, category) VALUES ('plazapublica.com.gt', 'ntlNews');
INSERT INTO service_categories (service, category) VALUES ('elperiodico.com', 'ntlNews');
INSERT INTO service_categories (service, category) VALUES ('nuestrodiario.com.gt', 'ntlNews');
INSERT INTO service_categories (service, category) VALUES ('noti7.com.gt', 'ntlNews');
INSERT INTO service_categories (service, category) VALUES ('bbc', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('epimg.net', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('nytimes.com', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('huffingtonpost.it', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('elmundo.com.sv', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('cnn.com', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('huffingtonpost.jp', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('el-mundo.net', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('radioformula.com.mx', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('eluniversal.com.mx', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('bbc.com', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('bbcamerica.com', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('tvnotas.com.mx', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('huffpost.com', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('eltiempo.com.ec', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('eltiempo.com', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('huffingtonpost.com', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('foxnews.com', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('telegraph.co.uk', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('econ.st', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('huff.to', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('bbclatinoamerica.com', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('bbci.co.uk', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('eluniversal.com.co', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('peopleenespanol.com', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('infobae.com', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('elmundo.com', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('fivethirtyeight.com', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('huffingtonpost.fr', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('bbc.co.uk', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('nbcnews.com', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('uni.vi', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('economist.com', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('bbc.in', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('huffingtonpost.es', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('huffingtonpost.co.uk', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('cnn.it', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('abc.es', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('elmundo.es', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('esmas.com', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('ideal.es', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('elmundo.com.ve', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('cnn', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('foxnews', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('univision.com', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('eluniverso.com', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('rpp.com.pe', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('jsonline.com', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('semana.com', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('elpais.com', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('20minutos.es', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('huffingtonpost.ca', 'intlNews');
INSERT INTO service_categories (service, category) VALUES ('other', 'other');
INSERT INTO service_categories (service, category) VALUES ('consejosgratis.es', 'other');
INSERT INTO service_categories (service, category) VALUES ('gigya.com', 'other');
INSERT INTO service_categories (service, category) VALUES ('rcn1.com.gt', 'other');

select * from profiling.cells_nav where rownum < 10;


CREATE TABLE CELL_NAV_4G AS
    select * 
    from profiling.cells_nav n
    JOIN service_categories
    ON n.service_name = service_categories.service
    where EXISTS 
        (SELECT * FROM cells_qos_4g g
            where g.bts_LNG_nm = n.cell);

CREATE TABLE CELL_NAV_3G AS
    select * 
    from profiling.cells_nav n
    JOIN service_categories
    ON n.service_name = service_categories.service
    where EXISTS 
        (SELECT * FROM cells_qos_3g g
            where g.bts_LNG_nm = n.cell);

CREATE TABLE CELL_NAV_2G AS
    select * 
    from profiling.cells_nav n
    JOIN service_categories
    ON n.service_name = service_categories.service
    where EXISTS 
        (SELECT * FROM cells_qos_2g g
            where g.bts_LNG_nm = n.cell);

create index nav_cell_day_2g on cell_nav_2g (cell, date_time);
create index nav_cell_day_3g on cell_nav_3g (cell, date_time);
create index nav_cell_day_4g on cell_nav_4g (cell, date_time);

