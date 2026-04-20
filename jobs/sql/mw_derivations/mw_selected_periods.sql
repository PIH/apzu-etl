drop table if exists mw_selected_periods;
create table mw_selected_periods (
	year int,
    quarter int,
    yearquarter varchar(255),
    start_date date,
    end_date date,
    zero int
);

-- Generate quarterly periods from 2016Q1 through the current quarter
-- Uses a cross-join sequence generator instead of WITH RECURSIVE (not supported in MySQL 5.6)
insert into mw_selected_periods (year, quarter, yearquarter, start_date, end_date, zero)
select
    yr,
    q,
    concat(yr, 'Q', q),
    case q when 1 then date(concat(yr, '-01-01'))
            when 2 then date(concat(yr, '-04-01'))
            when 3 then date(concat(yr, '-07-01'))
            when 4 then date(concat(yr, '-10-01')) end,
    case q when 1 then date(concat(yr, '-03-31'))
            when 2 then date(concat(yr, '-06-30'))
            when 3 then date(concat(yr, '-09-30'))
            when 4 then date(concat(yr, '-12-31')) end,
    0
from (
    select
        2016 + floor(n / 4) as yr,
        mod(n, 4) + 1 as q
    from (
        select a.n + b.n * 10 as n
        from (
            select 0 as n union select 1 union select 2 union select 3 union select 4
            union select 5 union select 6 union select 7 union select 8 union select 9
        ) a
        cross join (
            select 0 as n union select 1 union select 2 union select 3 union select 4
            union select 5 union select 6 union select 7 union select 8 union select 9
        ) b
    ) seq
    where 2016 + floor(n / 4) < year(now())
       or (2016 + floor(n / 4) = year(now()) and mod(n, 4) + 1 <= quarter(now()))
) quarters;
