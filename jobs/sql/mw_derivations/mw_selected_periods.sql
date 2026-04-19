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
insert into mw_selected_periods (year, quarter, yearquarter, start_date, end_date, zero)
WITH RECURSIVE quarters as (
    select 2016 as yr, 1 as q
    union all
    select case when q = 4 then yr + 1 else yr end,
           case when q = 4 then 1 else q + 1 end
    from quarters
    where yr < YEAR(NOW()) or (yr = YEAR(NOW()) and q <= QUARTER(NOW()))
)
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
from quarters;
