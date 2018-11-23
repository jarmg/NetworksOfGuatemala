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

drop table cells_qos_daily_sum_4g;


CREATE TABLE CELLS_QOS_DAILY_SUM_4G AS
    select 
        fct_dt,
        bts_lng_nm as cell, 
        sum(mbytes_4g) as mbytes_4g, 
        sum(time4g) as time4g, 
        sum(timenavreq804g) as timenavreq804g,
        sum(subs) as subs
    from cells_qos_4g
    group by bts_lng_nm, fct_dt;
    
    
CREATE TABLE CELLS_QOS_DAILY_SUM_3G AS
    select 
        fct_dt,
        bts_lng_nm as cell, 
        sum(mbytes_3g) as mbytes_3g, 
        sum(time3g) as time3g, 
        sum(timenavreq803g) as timenavreq803g,
        sum(subs) as subs
    from cells_qos_3g
    group by bts_lng_nm, fct_dt;
    
    
/* Lifetime performance averages per cell */
CREATE TABLE CELLS_QOS_AVGS_4G AS 
    select
        cell as cell,
        median(mbytes_4g) as lt_avg_mbytes, 
        median(time4g) as lt_avg_time4g, 
        median(timenavreq804g) as lt_avg_timenavreq 
    from CELLS_QOS_DAILY_SUM_4G
    group by cell;

create index qos_cell_avg_id_4g on cells_qos_avgs_4g (cell);

select q.*, a.lt_avg_timenavreq/a.lt_avg_time4g as cell_avg_perf 
from cells_qos_daily_sum_4g q
join cells_qos_avgs_4g a
on q.cell = a.cell;

