    select 
    a.date_time, 
    a.cell, 
    avg(o.devices) as other_devices, 
    avg(o.bytes_down) as other_bytes_down,
    avg(o.duration) as other_duration,
    avg(s.devices) as social_devices, 
    avg(s.bytes_down) as social_bytes_down,
    avg(s.duration) as social_duration,
    avg(n.devices) as ntl_news_devices, 
    avg(n.bytes_down) as ntl_news_bytes_down,
    avg(n.duration) as ntl_news_duration,
    avg(i.devices) as intl_news_devices, 
    avg(i.bytes_down) as intl_news_bytes_down,
    avg(i.duration) as intl_news_duration,
    avg(n.duration) + avg(i.duration) as news_duration,
    avg(n.bytes_down) + avg(i.bytes_down) as news_bytes_down,
    avg(n.devices) + avg(i.devices) as news_devices,
    (avg(n.devices) + avg(i.devices)) / avg(s.devices) as news_vs_social_devices,
    (avg(n.duration) + avg(i.duration)) / avg(s.duration) as news_vs_social_duration,
    avg(avg_n.devices_median) as ntl_news_devices_median, 
    avg(avg_n.duration_median) as ntl_news_duration_median,
    avg(avg_i.devices_median) as intl_news_devices_median,
    avg(avg_i.duration_median) as intl_news_duration_median,
    avg(avg_s.devices_median) as social_devices_median,
    avg(avg_s.duration_median) as social_duration_median,
    avg(avg_o.devices_median) as other_devices_median,
    avg(avg_o.duration_median) as other_duration_median,
    avg(n.devices) - avg_n.devices_median as ntl_news_devices_diff,
    avg(n.duration) - avg_n.duration_median as ntl_news_duration_diff,
    avg(i.devices) - avg_i.devices_median as intl_news_devices_diff,
    avg(i.duration) - avg_i.duration_median as intl_news_duration_diff,
    avg(s.devices) - avg_s.devices_median as social_devices_diff,
    avg(s.duration) - avg_s.duration_median as social_duration_diff,
    avg(o.devices) - avg_o.devices_median as other_devices_diff,
    avg(o.duration) - avg_o.duration_median as other_duration_diff,
    avg(cells.perf_ratio_diff) as cell_perf_ratio_diff,
    avg(cells.perf_ratio_4g) as cell_perf_ratio,
    avg(cells.avg_perf_ratio4g) as cell_perf_ratio_avg


    from cell_nav_4g a    
    /* Add daily navegation data */
    inner join nav_other_4g o
        on a.cell = o.cell AND a.date_time = o.date_time
    inner join nav_social_4g s
        on a.cell = s.cell AND a.date_time = s.date_time
    inner join nav_ntl_news_4g n
        on a.cell = n.cell AND a.date_time = n.date_time
    inner join nav_intl_news_4g i
        on a.cell = i.cell AND a.date_time = i.date_time
    
    /*Add cell nav averages*/
    inner join (
        select cell, median(devices) as devices_median, median(duration) as duration_median
        from nav_intl_news_4g
        group by cell) avg_i
    on a.cell = avg_i.cell
    
    inner join (
        select cell, median(devices) as devices_median, median(duration) as duration_median
        from nav_other_4g
        group by cell) avg_o
    on a.cell = avg_o.cell
    
    inner join (
        select cell, median(devices) as devices_median, median(duration) as duration_median
        from nav_ntl_news_4g
        group by cell) avg_n
    on a.cell = avg_n.cell
    
    inner join (
        select cell, median(devices) as devices_median, median(duration) as duration_median
        from nav_social_4g
        group by cell) avg_s
    on a.cell = avg_s.cell
    
    inner join (
                    select  
                            fct_dt, 
                            bts_lng_nm, 
                            sum(mbytes_4g) as mbytes_4g, 
                            sum(time4g) as time4g, 
                            sum(timenavreq804g) as timenavreq804g,
                            sum(timenavreq804g) / sum(time4g) as perf_ratio_4g,
                            (sum(timenavreq804g) / sum(time4g)) - (avg(cell_avg.avg_timenavreq) / avg(cell_avg.avg_time4g)) as perf_ratio_diff,
                            avg(cell_avg.avg_mbytes) as avg_mbytes,
                            avg(cell_avg.avg_time4g) as avg_time4g,
                            avg(cell_avg.avg_timenavreq) as timenavreq,
                            avg(cell_avg.avg_timenavreq) / avg(cell_avg.avg_time4g) as avg_perf_ratio4g 
                    from cells_qos_4g gross
                    join CELLS_QOS_AVGS_4G cell_avg
                    on gross.bts_lng_nm = cell_avg.cell
                    group by bts_lng_nm, fct_dt) cells
    on a.cell = cells.bts_lng_nm and a.date_time = cells.fct_dt
    GROUP BY a.date_time, a.cell;


select  
        fct_dt, 
        bts_lng_nm, 
        sum(mbytes_4g) as mbytes_4g, 
        sum(time4g) as time4g, 
        sum(timenavreq804g) as timenavreq804g,
        sum(timenavreq804g) / sum(time4g) as perf_ratio_4g,
        (sum(timenavreq804g) / sum(time4g)) - (avg(cell_avg.avg_timenavreq) / avg(cell_avg.avg_time4g)) as perf_ratio_diff,
        avg(cell_avg.avg_mbytes) as avg_mbytes,
        avg(cell_avg.avg_time4g) as avg_time4g,
        avg(cell_avg.avg_timenavreq) as timenavreq,
        avg(cell_avg.avg_timenavreq) / avg(cell_avg.avg_time4g) as avg_perf_ratio4g 
from cells_qos_4g gross
join CELLS_QOS_AVGS_4G cell_avg
on gross.bts_lng_nm = cell_avg.cell
group by bts_lng_nm, fct_dt;
        
    
from cells_qos_4g gross
join CELLS_QOS_AVGS_4G cell_avg 
on gross.bts_lng_nm = cell_avg.cell
group by gross.bts_lng_nm, gross.fct_d

