-- Список аэропортов
select
    airport_code,
    airport_name,
    city
from bookings.airports
order by city, airport_name;

-- Диапазон дат рейсов
select
    min(scheduled_departure) as min_departure_date,
    max(scheduled_departure) as max_departure_date
from bookings.flights;

-- 3.1.1-3.1.2. 1 вариант
-- Все бронирования на рейсы из определенного аэропорта в заданном диапазоне дат
select distinct
    b.book_ref,
    b.book_date,
    b.total_amount,
    f.flight_id,
    f.flight_no,
    f.departure_airport,
    dep.airport_name as departure_airport_name,
    f.arrival_airport,
    arr.airport_name as arrival_airport_name,
    f.scheduled_departure,
    f.scheduled_arrival,
    f.status
from bookings.bookings as b
join bookings.tickets as t
    on t.book_ref = b.book_ref
join bookings.ticket_flights as tf
    on tf.ticket_no = t.ticket_no
join bookings.flights as f
    on f.flight_id = tf.flight_id
join bookings.airports as dep
    on dep.airport_code = f.departure_airport
join bookings.airports as arr
    on arr.airport_code = f.arrival_airport
where f.departure_airport = 'SVO'
  and f.scheduled_departure >= timestamp '2017-08-01 00:00:00'
  and f.scheduled_departure < timestamp '2017-09-01 00:00:00'
order by f.scheduled_departure, b.book_ref;


explain (analyze, buffers)
select distinct
    b.book_ref,
    b.book_date,
    b.total_amount,
    f.flight_id,
    f.flight_no,
    f.departure_airport,
    dep.airport_name as departure_airport_name,
    f.arrival_airport,
    arr.airport_name as arrival_airport_name,
    f.scheduled_departure,
    f.scheduled_arrival,
    f.status
from bookings.bookings as b
join bookings.tickets as t
    on t.book_ref = b.book_ref
join bookings.ticket_flights as tf
    on tf.ticket_no = t.ticket_no
join bookings.flights as f
    on f.flight_id = tf.flight_id
join bookings.airports as dep
    on dep.airport_code = f.departure_airport
join bookings.airports as arr
    on arr.airport_code = f.arrival_airport
where f.departure_airport = 'SVO'
  and f.scheduled_departure >= timestamp '2017-08-01 00:00:00'
  and f.scheduled_departure < timestamp '2017-09-01 00:00:00'
order by f.scheduled_departure, b.book_ref;



-- Количество посадочных талонов, в разрезе кодов самолетов
select
    f.aircraft_code,
    a.model ->> 'ru' as aircraft_model,
    count(bp.boarding_no) as boarding_pass_count
from bookings.boarding_passes as bp
join bookings.flights as f
    on f.flight_id = bp.flight_id
join bookings.aircrafts_data as a
    on a.aircraft_code = f.aircraft_code
group by
    f.aircraft_code,
    a.model ->> 'ru'
order by boarding_pass_count desc;


explain (analyze, buffers)
select
    f.aircraft_code,
    a.model ->> 'ru' as aircraft_model,
    count(bp.boarding_no) as boarding_pass_count
from bookings.boarding_passes as bp
join bookings.flights as f
    on f.flight_id = bp.flight_id
join bookings.aircrafts_data as a
    on a.aircraft_code = f.aircraft_code
group by
    f.aircraft_code,
    a.model ->> 'ru'
order by boarding_pass_count desc;


-- Подсчёт количества строк во всех таблицах
select 'bookings' as table_name, count(*) as row_count
from bookings.bookings

union all

select 'tickets' as table_name, count(*) as row_count
from bookings.tickets

union all

select 'ticket_flights' as table_name, count(*) as row_count
from bookings.ticket_flights

union all

select 'flights' as table_name, count(*) as row_count
from bookings.flights

union all

select 'boarding_passes' as table_name, count(*) as row_count
from bookings.boarding_passes

union all

select 'aircrafts_data' as table_name, count(*) as row_count
from bookings.aircrafts_data

union all

select 'airports_data' as table_name, count(*) as row_count
from bookings.airports_data;

-- Статистика таблиц
select
    schemaname,
    relname,
    seq_scan,
    seq_tup_read,
    idx_scan,
    idx_tup_fetch,
    n_live_tup,
    n_dead_tup,
    last_analyze,
    last_autoanalyze
from pg_stat_user_tables
where schemaname = 'bookings'
  and relname in (
      'bookings',
      'tickets',
      'ticket_flights',
      'flights',
      'boarding_passes',
      'aircrafts_data',
      'airports_data'
  )
order by relname;

-- Статистика индексов
select
    schemaname,
    relname,
    indexrelname,
    idx_scan,
    idx_tup_read,
    idx_tup_fetch
from pg_stat_user_indexes
where schemaname = 'bookings'
  and relname in (
      'bookings',
      'tickets',
      'ticket_flights',
      'flights',
      'boarding_passes',
      'aircrafts_data',
      'airports_data'
  )
order by relname, indexrelname;

-- Статистика по столбцам
select
    schemaname,
    tablename,
    attname,
    n_distinct,
    null_frac,
    correlation
from pg_stats
where schemaname = 'bookings'
  and (
      (tablename = 'flights' and attname in ('flight_id', 'departure_airport', 'scheduled_departure', 'aircraft_code'))
      or (tablename = 'ticket_flights' and attname in ('ticket_no', 'flight_id'))
      or (tablename = 'tickets' and attname in ('ticket_no', 'book_ref'))
      or (tablename = 'bookings' and attname in ('book_ref', 'book_date', 'total_amount'))
      or (tablename = 'boarding_passes' and attname in ('ticket_no', 'flight_id', 'boarding_no'))
      or (tablename = 'aircrafts_data' and attname in ('aircraft_code', 'model'))
      or (tablename = 'airports_data' and attname in ('airport_code', 'airport_name'))
  )
order by tablename, attname;


-- Дропы таблиц
drop table if exists flights_part_tmp cascade;
drop table if exists bookings_tmp;
drop table if exists tickets_tmp;
drop table if exists ticket_flights_tmp;
drop table if exists flights_tmp;
drop table if exists boarding_passes_tmp;
drop table if exists aircrafts_data_tmp;
drop table if exists airports_data_tmp;


-- Создание временных таблиц
create temp table bookings_tmp as
select *
from bookings.bookings;

create temp table tickets_tmp as
select *
from bookings.tickets;

create temp table ticket_flights_tmp as
select *
from bookings.ticket_flights;

create temp table flights_tmp as
select *
from bookings.flights;

create temp table boarding_passes_tmp as
select *
from bookings.boarding_passes;

create temp table aircrafts_data_tmp as
select *
from bookings.aircrafts_data;

create temp table airports_data_tmp as
select *
from bookings.airports_data;

-- Обновление статистики таблиц
analyze bookings_tmp;
analyze tickets_tmp;
analyze ticket_flights_tmp;
analyze flights_tmp;
analyze boarding_passes_tmp;
analyze aircrafts_data_tmp;
analyze airports_data_tmp;


-- Второй подсчёт строк, но во временных таблицах
select 'bookings_tmp' as table_name, count(*) as row_count
from bookings_tmp

union all

select 'tickets_tmp' as table_name, count(*) as row_count
from tickets_tmp

union all

select 'ticket_flights_tmp' as table_name, count(*) as row_count
from ticket_flights_tmp

union all

select 'flights_tmp' as table_name, count(*) as row_count
from flights_tmp

union all

select 'boarding_passes_tmp' as table_name, count(*) as row_count
from boarding_passes_tmp

union all

select 'aircrafts_data_tmp' as table_name, count(*) as row_count
from aircrafts_data_tmp

union all

select 'airports_data_tmp' as table_name, count(*) as row_count
from airports_data_tmp;


-- Первый запрос на временных таблицах без индексов
explain (analyze, buffers)
select distinct
    b.book_ref,
    b.book_date,
    b.total_amount,
    f.flight_id,
    f.flight_no,
    f.departure_airport,
    dep.airport_name ->> 'ru' as departure_airport_name,
    f.arrival_airport,
    arr.airport_name ->> 'ru' as arrival_airport_name,
    f.scheduled_departure,
    f.scheduled_arrival,
    f.status
from bookings_tmp as b
join tickets_tmp as t
    on t.book_ref = b.book_ref
join ticket_flights_tmp as tf
    on tf.ticket_no = t.ticket_no
join flights_tmp as f
    on f.flight_id = tf.flight_id
join airports_data_tmp as dep
    on dep.airport_code = f.departure_airport
join airports_data_tmp as arr
    on arr.airport_code = f.arrival_airport
where f.departure_airport = 'svo'
  and f.scheduled_departure >= timestamp '2017-08-01 00:00:00'
  and f.scheduled_departure < timestamp '2017-09-01 00:00:00'
order by f.scheduled_departure, b.book_ref;

-- Второй запрос на временных таблицах без индексов
explain (analyze, buffers)
select
    f.aircraft_code,
    a.model ->> 'ru' as aircraft_model,
    count(bp.boarding_no) as boarding_pass_count
from boarding_passes_tmp as bp
join flights_tmp as f
    on f.flight_id = bp.flight_id
join aircrafts_data_tmp as a
    on a.aircraft_code = f.aircraft_code
group by
    f.aircraft_code,
    a.model ->> 'ru'
order by boarding_pass_count desc;


-- Индексы
-- Первый запрос
create index idx_flights_tmp_departure_airport_scheduled_departure
on flights_tmp(departure_airport, scheduled_departure);

create index idx_flights_tmp_flight_id
on flights_tmp(flight_id);

create index idx_ticket_flights_tmp_flight_id
on ticket_flights_tmp(flight_id);

create index idx_ticket_flights_tmp_ticket_no
on ticket_flights_tmp(ticket_no);

create index idx_tickets_tmp_ticket_no
on tickets_tmp(ticket_no);

create index idx_tickets_tmp_book_ref
on tickets_tmp(book_ref);

create index idx_bookings_tmp_book_ref
on bookings_tmp(book_ref);

create index idx_airports_data_tmp_airport_code
on airports_data_tmp(airport_code);

-- Второй запрос
create index idx_boarding_passes_tmp_flight_id
on boarding_passes_tmp(flight_id);

create index idx_aircrafts_data_tmp_aircraft_code
on aircrafts_data_tmp(aircraft_code);


-- Повторное обновление статистики
analyze bookings_tmp;
analyze tickets_tmp;
analyze ticket_flights_tmp;
analyze flights_tmp;
analyze boarding_passes_tmp;
analyze aircrafts_data_tmp;
analyze airports_data_tmp;


-- Первый запрос с индексами
explain (analyze, buffers)
select distinct
    b.book_ref,
    b.book_date,
    b.total_amount,
    f.flight_id,
    f.flight_no,
    f.departure_airport,
    dep.airport_name ->> 'ru' as departure_airport_name,
    f.arrival_airport,
    arr.airport_name ->> 'ru' as arrival_airport_name,
    f.scheduled_departure,
    f.scheduled_arrival,
    f.status
from bookings_tmp as b
join tickets_tmp as t
    on t.book_ref = b.book_ref
join ticket_flights_tmp as tf
    on tf.ticket_no = t.ticket_no
join flights_tmp as f
    on f.flight_id = tf.flight_id
join airports_data_tmp as dep
    on dep.airport_code = f.departure_airport
join airports_data_tmp as arr
    on arr.airport_code = f.arrival_airport
where f.departure_airport = 'svo'
  and f.scheduled_departure >= timestamp '2017-08-01 00:00:00'
  and f.scheduled_departure < timestamp '2017-09-01 00:00:00'
order by f.scheduled_departure, b.book_ref;


-- Второй запрос с индексами
explain (analyze, buffers)
select
    f.aircraft_code,
    a.model ->> 'ru' as aircraft_model,
    count(bp.boarding_no) as boarding_pass_count
from boarding_passes_tmp as bp
join flights_tmp as f
    on f.flight_id = bp.flight_id
join aircrafts_data_tmp as a
    on a.aircraft_code = f.aircraft_code
group by
    f.aircraft_code,
    a.model ->> 'ru'
order by boarding_pass_count desc;

-- Список созданных индексов
select
    schemaname,
    tablename,
    indexname,
    indexdef
from pg_indexes
where tablename in (
    'bookings_tmp',
    'tickets_tmp',
    'ticket_flights_tmp',
    'flights_tmp',
    'boarding_passes_tmp',
    'aircrafts_data_tmp',
    'airports_data_tmp'
)
order by tablename, indexname;

-- Статистика временных таблиц
select
    schemaname,
    relname,
    seq_scan,
    seq_tup_read,
    idx_scan,
    idx_tup_fetch,
    n_live_tup,
    n_dead_tup,
    last_analyze
from pg_stat_all_tables
where relname in (
    'bookings_tmp',
    'tickets_tmp',
    'ticket_flights_tmp',
    'flights_tmp',
    'boarding_passes_tmp',
    'aircrafts_data_tmp',
    'airports_data_tmp'
)
order by relname;

-- Статистика индексов временных таблиц
select
    schemaname,
    relname,
    indexrelname,
    idx_scan,
    idx_tup_read,
    idx_tup_fetch
from pg_stat_all_indexes
where relname in (
    'bookings_tmp',
    'tickets_tmp',
    'ticket_flights_tmp',
    'flights_tmp',
    'boarding_passes_tmp',
    'aircrafts_data_tmp',
    'airports_data_tmp'
)
order by relname, indexrelname;


-- Статистика столбцов временных таблиц
select
    schemaname,
    tablename,
    attname,
    n_distinct,
    null_frac,
    correlation
from pg_stats
where tablename in (
    'bookings_tmp',
    'tickets_tmp',
    'ticket_flights_tmp',
    'flights_tmp',
    'boarding_passes_tmp',
    'aircrafts_data_tmp',
    'airports_data_tmp'
)
order by tablename, attname;

-- Партиционированние
create temp table flights_part_tmp (
    like flights_tmp including all
) partition by range (scheduled_departure);

-- Создание партиций
create temp table flights_part_tmp_before_2017_08
partition of flights_part_tmp
for values from (minvalue) to ('2017-08-01');

create temp table flights_part_tmp_2017_08
partition of flights_part_tmp
for values from ('2017-08-01') to ('2017-09-01');

create temp table flights_part_tmp_after_2017_09
partition of flights_part_tmp
for values from ('2017-09-01') to (maxvalue);

-- Загрузка данных в партиции
insert into flights_part_tmp
select *
from flights_tmp;

-- Обновление статистики партиций
analyze flights_part_tmp;
analyze flights_part_tmp_before_2017_08;
analyze flights_part_tmp_2017_08;
analyze flights_part_tmp_after_2017_09;

-- Проверка количества строк
select 'flights_part_tmp_before_2017_08' as partition_name, count(*) as row_count
from flights_part_tmp_before_2017_08

union all

select 'flights_part_tmp_2017_08' as partition_name, count(*) as row_count
from flights_part_tmp_2017_08

union all

select 'flights_part_tmp_after_2017_09' as partition_name, count(*) as row_count
from flights_part_tmp_after_2017_09;

-- Индекс на партиционной таблице
create index idx_flights_part_tmp_departure_airport_scheduled_departure
on flights_part_tmp(departure_airport, scheduled_departure);

analyze flights_part_tmp;

-- Первый запрос на партиционной таблице
explain (analyze, buffers)
select distinct
    b.book_ref,
    b.book_date,
    b.total_amount,
    f.flight_id,
    f.flight_no,
    f.departure_airport,
    dep.airport_name ->> 'ru' as departure_airport_name,
    f.arrival_airport,
    arr.airport_name ->> 'ru' as arrival_airport_name,
    f.scheduled_departure,
    f.scheduled_arrival,
    f.status
from bookings_tmp as b
join tickets_tmp as t
    on t.book_ref = b.book_ref
join ticket_flights_tmp as tf
    on tf.ticket_no = t.ticket_no
join flights_part_tmp as f
    on f.flight_id = tf.flight_id
join airports_data_tmp as dep
    on dep.airport_code = f.departure_airport
join airports_data_tmp as arr
    on arr.airport_code = f.arrival_airport
where f.departure_airport = 'SVO'
  and f.scheduled_departure >= timestamp '2017-08-01 00:00:00'
  and f.scheduled_departure < timestamp '2017-09-01 00:00:00'
order by f.scheduled_departure, b.book_ref;


-- 
select
    date(f.scheduled_departure) as departure_date,
    count(distinct b.book_ref) as booking_count,
    sum(b.total_amount) as total_booking_amount
from bookings.bookings as b
join bookings.tickets as t
    on t.book_ref = b.book_ref
join bookings.ticket_flights as tf
    on tf.ticket_no = t.ticket_no
join bookings.flights as f
    on f.flight_id = tf.flight_id
where f.departure_airport = 'SVO'
  and f.scheduled_departure >= timestamp '2017-08-01 00:00:00'
  and f.scheduled_departure < timestamp '2017-09-01 00:00:00'
group by date(f.scheduled_departure)
order by departure_date;

-- 
select
    f.aircraft_code,
    a.model ->> 'ru' as aircraft_model,
    count(bp.boarding_no) as boarding_pass_count
from bookings.boarding_passes as bp
join bookings.flights as f
    on f.flight_id = bp.flight_id
join bookings.aircrafts_data as a
    on a.aircraft_code = f.aircraft_code
group by
    f.aircraft_code,
    a.model ->> 'ru'
order by boarding_pass_count desc;

-- 
with aircraft_counts as (
    select
        f.aircraft_code,
        a.model ->> 'ru' as aircraft_model,
        count(bp.boarding_no) as boarding_pass_count
    from bookings.boarding_passes as bp
    join bookings.flights as f
        on f.flight_id = bp.flight_id
    join bookings.aircrafts_data as a
        on a.aircraft_code = f.aircraft_code
    group by
        f.aircraft_code,
        a.model ->> 'ru'
),
max_value as (
    select max(boarding_pass_count) as max_boarding_pass_count
    from aircraft_counts
)
select
    ac.aircraft_code,
    ac.aircraft_model,
    ac.boarding_pass_count,
    repeat('█', greatest(1, round(ac.boarding_pass_count::numeric / mv.max_boarding_pass_count * 40)::integer)) as chart
from aircraft_counts as ac
cross join max_value as mv
order by ac.boarding_pass_count desc;

