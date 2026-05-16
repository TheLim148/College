-- 3.1.1. работа со системными представлениями.
-- выведите список 10 самых крупных таблиц схемы bookings с указанием их приблизительного размера (в строках).
-- примечание: reltuples показывает приблизительное количество строк, поэтому значение может отличаться от count(*).
select
    n.nspname as schema_name,
    c.relname as table_name,
    c.reltuples::bigint as approximate_rows,
    pg_size_pretty(pg_total_relation_size(c.oid)) as total_size
from pg_class c
join pg_namespace n on n.oid = c.relnamespace
where n.nspname = 'bookings'
  and c.relkind in ('r', 'p')
order by c.reltuples desc
limit 10;


-- 3.1.2. профилирование данных.
-- постройте распределение количества рейсов (flights) по их статусам (status).
-- сделайте вывод о доле отмененных и задержанных рейсов.
select
    status,
    count(*) as flights_count,
    round(count(*) * 100.0 / sum(count(*)) over (), 2) as pct_of_total
from bookings.flights
group by status
order by flights_count desc;

-- отдельно рассчитаем долю отмененных и задержанных рейсов.
select
    count(*) as total_flights,
    count(*) filter (where lower(status) = 'cancelled') as cancelled_flights,
    round(
        count(*) filter (where lower(status) = 'cancelled') * 100.0
        / nullif(count(*), 0),
        2
    ) as cancelled_pct,
    count(*) filter (where lower(status) = 'delayed') as delayed_flights,
    round(
        count(*) filter (where lower(status) = 'delayed') * 100.0
        / nullif(count(*), 0),
        2
    ) as delayed_pct
from bookings.flights;


-- 3.1.2. профилирование данных.
-- найдите дубликаты в данных пассажиров (tickets), где совпадает passenger_id, но различается passenger_name.
-- является ли это ошибкой данных?
-- вывод: такие строки могут быть ошибкой ввода, сменой имени или разным написанием имени одного пассажира.
select
    t.passenger_id,
    min(t.passenger_name) as example_name_1,
    max(t.passenger_name) as example_name_2,
    count(*) as tickets_count
from bookings.tickets t
group by t.passenger_id
having min(t.passenger_name) <> max(t.passenger_name)
order by tickets_count desc, t.passenger_id
limit 100;

-- 3.2.1. анализ временных рядов и визуализация полученных данных.
-- построить столбчатую диаграмму количества бронирований по дням недели за последнюю неделю.
-- напишем sql-запрос для нахождения дня недели и количества бронирований за последнюю неделю с сортировкой по дате.
-- результат запроса можно выгрузить в csv и построить столбчатую диаграмму.
select
    date_trunc('day', b.book_date)::date as book_day,
    extract(isodow from b.book_date)::int as weekday_no,
    trim(to_char(b.book_date, 'tmday')) as weekday_name,
    count(*) as bookings_count
from bookings.bookings b
where b.book_date >= bookings.now() - interval '7 days'
  and b.book_date < bookings.now()
group by book_day, weekday_no, weekday_name
order by weekday_no;


-- 3.2.2. динамика продаж.
-- постройте временной ряд общего объема выручки (total_amount) по дням за любые 3 месяца относительно bookings.now().
-- визуализируйте полученные данные.
select
    date_trunc('day', b.book_date)::date as revenue_day,
    count(*) as bookings_count,
    round(sum(b.total_amount), 2) as total_revenue
from bookings.bookings b
where b.book_date >= date_trunc('month', bookings.now()) - interval '3 months'
  and b.book_date < date_trunc('month', bookings.now())
group by revenue_day
order by revenue_day;


-- 3.2.2. динамика продаж.
-- рассчитайте скользящее среднее выручки за 7 дней.
-- запрос выдает два ряда: дневную выручку и скользящее среднее, которые можно отобразить на одном графике.
with params as (
    select
        date_trunc('month', bookings.now()) - interval '3 months' as date_from,
        date_trunc('month', bookings.now()) as date_to
), date_dim as (
    select
        generate_series(
            p.date_from::date,
            (p.date_to - interval '1 day')::date,
            interval '1 day'
        )::date as revenue_day
    from params p
), daily_revenue as (
    select
        date_trunc('day', b.book_date)::date as revenue_day,
        sum(b.total_amount) as total_revenue
    from bookings.bookings b
    join params p on b.book_date >= p.date_from
                 and b.book_date < p.date_to
    group by revenue_day
)
select
    d.revenue_day,
    round(coalesce(r.total_revenue, 0), 2) as total_revenue,
    round(
        avg(coalesce(r.total_revenue, 0)) over (
            order by d.revenue_day
            rows between 6 preceding and current row
        ),
        2
    ) as moving_avg_7_days
from date_dim d
left join daily_revenue r on r.revenue_day = d.revenue_day
order by d.revenue_day;


-- 3.2.3. сезонность рейсов.
-- преобразуйте даты вылета из bookings.flights.scheduled_departure в день недели и час.
-- постройте гистограмму количества вылетов по часам суток. какие часы самые загруженные?
select
    extract(hour from f.scheduled_departure)::int as departure_hour,
    count(*) as flights_count
from bookings.flights f
group by departure_hour
order by departure_hour;

-- количество вылетов по дням недели и часам.
select
    extract(isodow from f.scheduled_departure)::int as weekday_no,
    trim(to_char(f.scheduled_departure, 'tmday')) as weekday_name,
    extract(hour from f.scheduled_departure)::int as departure_hour,
    count(*) as flights_count
from bookings.flights f
group by weekday_no, weekday_name, departure_hour
order by weekday_no, departure_hour;


-- 3.2.3. сезонность рейсов.
-- сравните общее количество вылетов в текущем месяце (декабрь 2025) с аналогичным месяцем в прошлом (ноябрь 2025).
-- используйте функцию lag(). визуализируйте полученные данные.
with monthly_departures as (
    select
        date_trunc('month', f.scheduled_departure)::date as month_start,
        count(*) as departures_count
    from bookings.flights f
    where f.scheduled_departure >= '2025-05-01'::timestamptz
      and f.scheduled_departure < '2026-05-01'::timestamptz
    group by month_start
), monthly_with_lag as (
    select
        month_start,
        departures_count,
        lag(departures_count) over (order by month_start) as previous_month_departures
    from monthly_departures
)
select
    month_start,
    departures_count,
    previous_month_departures,
    departures_count - previous_month_departures as departures_diff,
    round(
        (departures_count - previous_month_departures) * 100.0
        / nullif(previous_month_departures, 0),
        2
    ) as departures_mom_pct
from monthly_with_lag
order by month_start;


-- 3.2.3. сезонность рейсов.
-- рассчитайте процентное изменение (mom - month over month) количества бронирований за последние доступные месяца,
-- используя lag() и round() для точности.
with monthly_bookings as (
    select
        date_trunc('month', b.book_date)::date as month_start,
        count(*) as bookings_count
    from bookings.bookings b
    group by month_start
), last_available_months as (
    select *
    from monthly_bookings
    order by month_start desc
    limit 6
), monthly_with_lag as (
    select
        month_start,
        bookings_count,
        lag(bookings_count) over (order by month_start) as previous_month_bookings
    from last_available_months
)
select
    month_start,
    bookings_count,
    previous_month_bookings,
    bookings_count - previous_month_bookings as bookings_diff,
    round(
        (bookings_count - previous_month_bookings) * 100.0
        / nullif(previous_month_bookings, 0),
        2
    ) as bookings_mom_pct
from monthly_with_lag
order by month_start;


-- 3.3.1. выявление аномалий.
-- используя представление flight_performance, рассчитайте среднюю задержку вылета и стандартное отклонение по всем рейсам.
with flight_performance as (
    select
        f.flight_id,
        f.route_no,
        f.scheduled_departure,
        f.actual_departure,
        r.departure_airport,
        r.arrival_airport,
        dep.city as departure_city,
        arr.city as arrival_city,
        extract(epoch from (f.actual_departure - f.scheduled_departure)) / 60.0 as departure_delay_minutes
    from bookings.flights f
    join bookings.routes r on r.route_no = f.route_no
    left join bookings.airports dep on dep.airport_code = r.departure_airport
    left join bookings.airports arr on arr.airport_code = r.arrival_airport
    where f.actual_departure is not null
)
select
    count(*) as flights_count,
    round(avg(departure_delay_minutes), 2) as avg_delay_minutes,
    round(stddev_pop(departure_delay_minutes), 2) as stddev_pop_delay_minutes,
    round(stddev_samp(departure_delay_minutes), 2) as stddev_samp_delay_minutes
from flight_performance;


-- 3.3.2. выявление аномалий.
-- найдите рейсы, задержка вылета которых превышает 3 стандартных отклонения от среднего.
-- выведите топ-10 таких рейсов с самой большой задержкой: маршрут, дата, задержка.
with flight_performance as (
    select
        f.flight_id,
        f.route_no,
        f.scheduled_departure,
        f.actual_departure,
        coalesce(dep.city ->> 'ru', r.departure_airport::text) as departure_city,
        coalesce(arr.city ->> 'ru', r.arrival_airport::text) as arrival_city,
        extract(epoch from (f.actual_departure - f.scheduled_departure)) / 60.0 as departure_delay_minutes
    from bookings.flights f
    join lateral (
        select
            r.route_no,
            r.validity,
            r.departure_airport,
            r.arrival_airport
        from bookings.routes r
        where r.route_no = f.route_no
          and r.validity @> f.scheduled_departure
        order by lower(r.validity) desc nulls last
        limit 1
    ) r on true
    left join bookings.airports_data dep on dep.airport_code = r.departure_airport
    left join bookings.airports_data arr on arr.airport_code = r.arrival_airport
    where f.actual_departure is not null
), stats as (
    select
        avg(departure_delay_minutes) as avg_delay_minutes,
        stddev_pop(departure_delay_minutes) as stddev_delay_minutes
    from flight_performance
)
select
    fp.flight_id,
    fp.route_no,
    concat(fp.departure_city, ' -> ', fp.arrival_city) as route,
    fp.scheduled_departure::date as departure_date,
    round(fp.departure_delay_minutes, 2) as departure_delay_minutes,
    round((fp.departure_delay_minutes - s.avg_delay_minutes) / nullif(s.stddev_delay_minutes, 0), 2) as z_score
from flight_performance fp
cross join stats s
where fp.departure_delay_minutes > s.avg_delay_minutes + 3 * s.stddev_delay_minutes
order by fp.departure_delay_minutes desc, fp.flight_id
limit 10;

-- 3.3.3. выявление аномалий.
-- рассчитайте медианную стоимость билета для каждого класса обслуживания (fare_conditions), используя таблицы segments и tickets.
select
    s.fare_conditions,
    count(*) as segments_count,
    round((percentile_cont(0.5) within group (order by s.price))::numeric, 2) as median_price,
    round(avg(s.price), 2) as avg_price
from bookings.segments s
group by s.fare_conditions
order by median_price desc;


-- 3.3.4. выявление аномалий.
-- посчитайте среднее количество перелетов (segments) на одного уникального пассажира (passenger_id).
drop table if exists tmp_passenger_segments;

create temp table tmp_passenger_segments as
select
    t.passenger_id,
    min(t.passenger_name) as passenger_name,
    count(*) as segments_count
from bookings.segments s
join bookings.tickets t on t.ticket_no = s.ticket_no
group by t.passenger_id;

analyze tmp_passenger_segments;


select
    count(*) as joined_segments,
    count(distinct t.passenger_id) as passengers_with_segments,
    round(count(*)::numeric / nullif(count(distinct t.passenger_id), 0), 2) as avg_segments_per_passenger
from bookings.segments s
join bookings.tickets t on t.ticket_no = s.ticket_no;

select
    count(*) as passengers_count,
    round(avg(segments_count), 2) as avg_segments_per_passenger,
    min(segments_count) as min_segments_per_passenger,
    max(segments_count) as max_segments_per_passenger
from tmp_passenger_segments;


-- 3.3.5. выявление аномалий.
-- выявите пассажиров, количество перелетов которых превышает 95-й процентиль.
-- можно ли их считать "супер-путешественниками" или это ошибка данных?
-- вывод зависит от результата: если пассажиры имеют много билетов и разные даты, это может быть нормальным поведением частых клиентов;
-- если у одного passenger_id встречаются разные имена или слишком много одинаковых записей, это похоже на проблему качества данных.
with threshold as (
    select percentile_cont(0.95) within group (order by segments_count) as pct_95_segments
    from tmp_passenger_segments
)
select
    ps.passenger_id,
    ps.passenger_name,
    ps.segments_count,
    t.pct_95_segments
from tmp_passenger_segments ps
cross join threshold t
where ps.segments_count > t.pct_95_segments
order by ps.segments_count desc, ps.passenger_id;

-- 3.4.1. когортный анализ.
-- анализ удержания пассажиров.
-- используя таблицы bookings.bookings и bookings.tickets, сформируйте когорты пассажиров по месяцу их первой покупки.
-- для каждой когорты рассчитайте кривую удержания: процент пассажиров, совершивших повторное бронирование
-- в течение 1 месяца после первой покупки и 3 месяцев после первой покупки.
with passenger_bookings as (
    select distinct
        t.passenger_id,
        b.book_ref,
        b.book_date
    from bookings.tickets t
    join bookings.bookings b on b.book_ref = t.book_ref
), first_purchase as (
    select
        passenger_id,
        min(book_date) as first_book_date,
        date_trunc('month', min(book_date))::date as cohort_month
    from passenger_bookings
    group by passenger_id
)
select
    fp.cohort_month,
    count(distinct fp.passenger_id) as cohort_size,
    count(distinct fp.passenger_id) filter (
        where pb.book_date > fp.first_book_date
          and pb.book_date <= fp.first_book_date + interval '1 month'
    ) as retained_1_month,
    round(
        count(distinct fp.passenger_id) filter (
            where pb.book_date > fp.first_book_date
              and pb.book_date <= fp.first_book_date + interval '1 month'
        ) * 100.0 / nullif(count(distinct fp.passenger_id), 0),
        2
    ) as retained_1_month_pct,
    count(distinct fp.passenger_id) filter (
        where pb.book_date > fp.first_book_date
          and pb.book_date <= fp.first_book_date + interval '3 months'
    ) as retained_3_months,
    round(
        count(distinct fp.passenger_id) filter (
            where pb.book_date > fp.first_book_date
              and pb.book_date <= fp.first_book_date + interval '3 months'
        ) * 100.0 / nullif(count(distinct fp.passenger_id), 0),
        2
    ) as retained_3_months_pct
from first_purchase fp
left join passenger_bookings pb on pb.passenger_id = fp.passenger_id
group by fp.cohort_month
order by fp.cohort_month;


-- 3.4.2. когортный анализ.
-- анализ "выживаемости" маршрутов.
-- выживание означает, что маршрут не прекратил выполнение в течение указанного срока, то есть имел рейсы в этот период.
-- когорта задается кварталом первого рейса.
-- используя таблицу bookings.flights и bookings.routes, сформируйте когорты маршрутов (route_no)
-- по кварталу их первого выполнения (первого рейса по scheduled_departure).
-- для каждой когорты рассчитайте долю маршрутов, которые "выжили", то есть имели хотя бы один рейс
-- в течение 2 месяцев после первого рейса и 4 месяцев после первого рейса.
with route_first_flight as (
    select
        r.route_no,
        min(f.scheduled_departure) as first_departure,
        date_trunc('quarter', min(f.scheduled_departure))::date as cohort_quarter
    from bookings.routes r
    join bookings.flights f on f.route_no = r.route_no
    group by r.route_no
), route_survival as (
    select
        rf.route_no,
        rf.cohort_quarter,
        exists (
            select 1
            from bookings.flights f2
            where f2.route_no = rf.route_no
              and f2.scheduled_departure > rf.first_departure
              and f2.scheduled_departure <= rf.first_departure + interval '2 months'
        ) as survived_2_months,
        exists (
            select 1
            from bookings.flights f3
            where f3.route_no = rf.route_no
              and f3.scheduled_departure > rf.first_departure
              and f3.scheduled_departure <= rf.first_departure + interval '4 months'
        ) as survived_4_months
    from route_first_flight rf
)
select
    cohort_quarter,
    count(*) as routes_count,
    count(*) filter (where survived_2_months) as survived_2_months,
    round(count(*) filter (where survived_2_months) * 100.0 / nullif(count(*), 0), 2) as survived_2_months_pct,
    count(*) filter (where survived_4_months) as survived_4_months,
    round(count(*) filter (where survived_4_months) * 100.0 / nullif(count(*), 0), 2) as survived_4_months_pct
from route_survival
group by cohort_quarter
order by cohort_quarter;


-- 3.5.1. текстовый анализ и эксперименты.
-- анализ географии: используя like и регулярные выражения, найдите все аэропорты,
-- в названии города (airports.city) которых упоминаются направления света (северный, южно- и т.д.).
-- в airports.city хранится текст, а в airports_data.city хранится jsonb с русским названием города.
select
    ad.airport_code,
    ad.airport_name ->> 'ru' as airport_name_ru,
    ad.city ->> 'ru' as city_ru
from bookings.airports_data ad
where coalesce(ad.city ->> 'ru', '') ilike any (array['%север%', '%южн%', '%юго%', '%восточн%', '%запад%', '%северо%'])
   or coalesce(ad.city ->> 'ru', '') ~* '(север|южн|юго|восточн|запад|северо)'
order by city_ru, airport_name_ru;


-- 3.5.2. текстовый анализ и эксперименты.
-- разберитесь с полнотекстовым поиском (ts_vector, ts_rank и другие функции).
-- пример: полнотекстовый поиск по русским названиям аэропортов и городов.
with airport_text as (
    select
        ad.airport_code,
        coalesce(ad.airport_name ->> 'ru', '') as airport_name_ru,
        coalesce(ad.city ->> 'ru', '') as city_ru,
        setweight(to_tsvector('russian', coalesce(ad.city ->> 'ru', '')), 'a') ||
        setweight(to_tsvector('russian', coalesce(ad.airport_name ->> 'ru', '')), 'b') as search_vector,
        concat_ws(' ', ad.city ->> 'ru', ad.airport_name ->> 'ru') as source_text
    from bookings.airports_data ad
), query_text as (
    select to_tsquery('russian', 'москв:* | петербург:* | соч:*') as search_query
)
select
    apt.airport_code,
    apt.airport_name_ru,
    apt.city_ru,
    round(ts_rank(apt.search_vector, qt.search_query)::numeric, 4) as rank_value,
    ts_headline('russian', apt.source_text, qt.search_query) as headline
from airport_text apt
cross join query_text qt
where apt.search_vector @@ qt.search_query
order by rank_value desc, apt.city_ru, apt.airport_name_ru;


-- 3.5.3. текстовый анализ и эксперименты.
-- гипотетический a/b-тест.
-- предположим, авиакомпания ввела новую систему лояльности для пассажиров, летающих классом comfort.
-- разделите пассажиров, летавших классом comfort за последний год, на две гипотетические группы:
-- те, кто летал до введения программы (контроль), и после (тест).
-- границу установите произвольно: max(book_date) - interval '3 months'.
-- сравните для этих двух групп среднее количество бронирований на пассажира и средний чек после границы.
with params as (
    select
        max(b.book_date) - interval '3 months' as border_date,
        max(b.book_date) - interval '1 year' as date_from
    from bookings.bookings b
), comfort_passengers as materialized (
    select
        t.passenger_id,
        min(b.book_date) as first_comfort_date
    from bookings.bookings b
    join params p on b.book_date >= p.date_from
    join bookings.tickets t on t.book_ref = b.book_ref
    join bookings.segments s on s.ticket_no = t.ticket_no
    where s.fare_conditions = 'Comfort'
    group by t.passenger_id
), experiment_groups as (
    select
        cp.passenger_id,
        case
            when cp.first_comfort_date < p.border_date then 'control'
            else 'test'
        end as experiment_group,
        p.border_date
    from comfort_passengers cp
    cross join params p
), post_border_bookings as materialized (
    select
        t.passenger_id,
        b.book_ref,
        max(b.total_amount) as total_amount
    from bookings.bookings b
    join params p on b.book_date >= p.border_date
    join bookings.tickets t on t.book_ref = b.book_ref
    group by t.passenger_id, b.book_ref
), passenger_metrics as (
    select
        eg.experiment_group,
        eg.passenger_id,
        count(pb.book_ref) as bookings_after_border,
        avg(pb.total_amount) as avg_check_after_border,
        coalesce(sum(pb.total_amount), 0) as revenue_after_border
    from experiment_groups eg
    left join post_border_bookings pb on pb.passenger_id = eg.passenger_id
    group by eg.experiment_group, eg.passenger_id
)
select
    experiment_group,
    count(*) as passengers_count,
    sum(bookings_after_border) as bookings_count,
    round(avg(bookings_after_border), 2) as avg_bookings_per_passenger,
    round(avg(avg_check_after_border), 2) as avg_check_per_passenger,
    round(sum(revenue_after_border), 2) as total_revenue,
    round(sum(revenue_after_border) / nullif(count(*), 0), 2) as arpu,
    round(sum(revenue_after_border) / nullif(sum(bookings_after_border), 0), 2) as avg_check,
    round(stddev_samp(revenue_after_border), 2) as stddev_revenue_per_passenger
from passenger_metrics
group by experiment_group
order by experiment_group;

-- 3.6.1. создание сложных отчетов.
-- рассчитайте конверсию по шагам: бронь -> выпуск билета -> регистрация на рейс -> фактический вылет.
-- конверсия (%) = (количество сущностей на текущем этапе / количество сущностей на предыдущем этапе) * 100%.
with counts as (
    select
        (select count(*) from bookings.bookings) as bookings_count,
        (select count(*) from bookings.tickets) as tickets_count,
        (select count(*) from bookings.boarding_passes) as boarding_passes_count,
        (select count(*) from bookings.flights f where f.actual_departure is not null) as actual_departures_count
)
select
    v.stage,
    v.value,
    v.conversion_pct
from counts c
cross join lateral (
    values
        ('1. бронь', c.bookings_count, null::numeric),
        ('2. выпуск билета', c.tickets_count, round(c.tickets_count * 100.0 / nullif(c.bookings_count, 0), 2)),
        ('3. регистрация на рейс', c.boarding_passes_count, round(c.boarding_passes_count * 100.0 / nullif(c.tickets_count, 0), 2)),
        ('4. фактический вылет', c.actual_departures_count, round(c.actual_departures_count * 100.0 / nullif(c.boarding_passes_count, 0), 2))
) as v(stage, value, conversion_pct);


-- 3.6.2. создание сложных отчетов.
-- найдите топ-5 самых частых комбинаций городов в рамках одного бронирования.
-- используем least() и greatest() для нормализации пары городов,
-- чтобы направление москва -> санкт-петербург и санкт-петербург -> москва считалось одной комбинацией.
-- русские названия городов берем из json-полей airports_data.city ->> 'ru'.
-- формат вывода: строка вида "город1↔город2".
with params as (
    select
        max(book_date) - interval '3 months' as date_from,
        max(book_date) as date_to
    from bookings.bookings
), route_city_pairs as materialized (
    select
        r.route_no,
        concat(
            least(dep.city ->> 'ru', arr.city ->> 'ru'),
            '↔',
            greatest(dep.city ->> 'ru', arr.city ->> 'ru')
        ) as city_pair
    from bookings.routes r
    join bookings.airports_data dep on dep.airport_code = r.departure_airport
    join bookings.airports_data arr on arr.airport_code = r.arrival_airport
    where dep.city ->> 'ru' is not null
      and arr.city ->> 'ru' is not null
), recent_tickets as materialized (
    select
        t.ticket_no,
        t.book_ref
    from bookings.tickets t
    join bookings.bookings b on b.book_ref = t.book_ref
    join params p on b.book_date >= p.date_from
                 and b.book_date < p.date_to
), booking_city_pairs as materialized (
    select
        rt.book_ref,
        rcp.city_pair
    from recent_tickets rt
    join bookings.segments s on s.ticket_no = rt.ticket_no
    join bookings.flights f on f.flight_id = s.flight_id
    join route_city_pairs rcp on rcp.route_no = f.route_no
    group by rt.book_ref, rcp.city_pair
)
select
    city_pair,
    count(*) as bookings_count
from booking_city_pairs
group by city_pair
order by bookings_count desc, city_pair
limit 5;
