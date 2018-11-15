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
(avg(n.duration) + avg(i.duration)) / avg(s.duration) as news_vs_social_duration
from cell_nav_4g a
join (select 
            date_time,
            cell,
            sum(bytes_down) as bytes_down,
            sum(bytes_up) as bytes_up,
            sum(duration) as duration,
            sum(subscribers) as devices 
        from cell_nav_4g 
        where category = 'other'
        group by (date_time, cell)
    ) o
    on a.cell = o.cell AND a.DAte_time = o.date_time
join (select 
            date_time,
            cell,
            sum(bytes_down) as bytes_down,
            sum(bytes_up) as bytes_up,
            sum(duration) as duration,
            sum(subscribers) as devices 
        from cell_nav_4g 
        where category = 'social'
        group by (date_time, cell)
    ) s
    on a.cell = s.cell AND a.DAte_time = s.date_time
join (select 
            date_time,
            cell,
            sum(bytes_down) as bytes_down,
            sum(bytes_up) as bytes_up,
            sum(duration) as duration,
            sum(subscribers) as devices 
        from cell_nav_4g 
        where category = 'ntlNews'
        group by (date_time, cell)
    ) n
    on a.cell = n.cell AND a.DAte_time = n.date_time
join (select 
            date_time,
            cell,
            sum(bytes_down) as bytes_down,
            sum(bytes_up) as bytes_up,
            sum(duration) as duration,
            sum(subscribers) as devices 
        from cell_nav_4g 
        where category = 'intlNews'
        group by (date_time, cell)
    ) i
    on a.cell = i.cell AND a.DAte_time = i.date_time
GROUP BY a.date_time, a.cell;



/* NEXT: ADD IN AVERAGES SO WE CAN START TO LOOK AT VARIATION*/











