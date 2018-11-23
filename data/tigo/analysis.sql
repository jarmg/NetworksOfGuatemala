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
avg(avg_o.duration_median) as other_duration_median


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

/*Add cell navegation averages*/
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

GROUP BY a.date_time, a.cell;




select cell, median(devices) as devices_median, median(duration) as duration_median
from nav_ntl_news_4g
group by cell;
 
/* NEXT: ADD IN AVERAGES SO WE CAN START TO LOOK AT VARIATION*/






