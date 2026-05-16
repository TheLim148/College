-- 3.1. По данным наборам данных. Данные о законодателях.
-- Импортируйте данные в отдельную схему
-- Заполните отсутствующие даты для большей точности (с.152)

drop table if exists legislators_terms;
drop table if exists legislators;

create table legislators
(
    full_name varchar, -- name_official_full
    first_name varchar, -- name_first
    last_name varchar, -- name_last
    middle_name varchar, -- name_middle
    nickname varchar, -- name_nickname
    suffix varchar, -- name_suffix
    other_names_end date, -- other_names_0_end
    other_names_middle varchar, -- other_names_0_middle
    other_names_last varchar, -- other_names_0_last
    birthday date, -- bio_birthday
    gender varchar, -- bio_gender
    id_bioguide varchar primary key,
    id_bioguide_previous_0 varchar,
    id_govtrack int,
    id_icpsr int,
    id_wikipedia varchar,
    id_wikidata varchar,
    id_google_entity_id varchar,
    id_house_history bigint,
    id_house_history_alternate int,
    id_thomas int,
    id_cspan int,
    id_votesmart int,
    id_lis varchar,
    id_ballotpedia varchar,
    id_opensecrets varchar,
    id_fec_0 varchar,
    id_fec_1 varchar,
    id_fec_2 varchar
);

create table legislators_terms
(
    id_bioguide varchar references legislators(id_bioguide),
    term_number int,
    term_id varchar primary key,
    term_type varchar,
    term_start date,
    term_end date,
    state varchar,
    district int,
    class int,
    party varchar,
    how varchar,
    url varchar, -- terms_1_url
    address varchar, -- terms_1_address
    phone varchar, -- terms_1_phone
    fax varchar, -- terms_1_fax
    contact_form varchar, -- terms_1_contact_form
    office varchar, -- terms_1_office
    state_rank varchar, -- terms_1_state_rank
    rss_url varchar, -- terms_1_rss_url
    caucus varchar -- terms_1_caucus
);

select * from legislators limit 10;
select * from legislators_terms limit 10;

-- базовая проверка временных границ датасета
select
    min(term_start) as min_term_start,
    max(term_end) as max_term_end,
    count(*) as terms_count,
    count(distinct id_bioguide) as legislators_count
from legislators_terms;

-- 3.2. Виды когортного анализа
-- 3.2.1. Анализ удержания
-- Удержание связано с тем, есть ли у участников когорты ещё записи во временном ряду через конкретное количество периодов, прошедших с начальной даты.
-- Постройте кривую удержания (с.148-150) – запрос и график.

-- общий анализ удержания по годам от первого срока законодателя.
-- период 0 означает первый год/первый срок, период 1 означает примерно один год после начала первого срока и т.д.
with first_terms as (
    select
        id_bioguide,
        min(term_start) as first_term
    from legislators_terms
    group by id_bioguide
), retained as (
    select
        date_part('year', age(t.term_start, f.first_term))::int as period,
        count(distinct f.id_bioguide) as cohort_retained
    from first_terms f
    join legislators_terms t on t.id_bioguide = f.id_bioguide
    group by period
)
select
    period,
    first_value(cohort_retained) over (order by period) as cohort_size,
    cohort_retained,
    round(
        cohort_retained * 100.0
        / first_value(cohort_retained) over (order by period),
        2
    ) as pct_retained
from retained
order by period;

-- более точный анализ удержания.
-- вместо заранее созданной таблицы дат используется generate_series().
-- для каждого года создаётся дата 31 декабря, после чего проверяется,
-- занимал ли законодатель должность на эту дату.
with date_dim as (
    select make_date(year_num, 12, 31) as check_date
    from generate_series(
        (select min(extract(year from term_start))::int from legislators_terms),
        (select max(extract(year from term_end))::int from legislators_terms),
        1
    ) as gs(year_num)
), first_terms as (
    select
        id_bioguide,
        min(term_start) as first_term
    from legislators_terms
    group by id_bioguide
), retained as (
    select
        date_part('year', age(d.check_date, f.first_term))::int as period,
        count(distinct f.id_bioguide) as cohort_retained
    from first_terms f
    join legislators_terms t on t.id_bioguide = f.id_bioguide
    join date_dim d on d.check_date between t.term_start and t.term_end
    group by period
)
select
    period,
    first_value(cohort_retained) over (order by period) as cohort_size,
    cohort_retained,
    round(
        cohort_retained * 100.0
        / first_value(cohort_retained) over (order by period),
        2
    ) as pct_retained
from retained
order by period;

-- Разобьём сущности на ежегодные когорты (с.159). Построим график.
-- first_year показывает год первого вступления в должность.
-- period показывает, сколько лет прошло от первой даты когорты.
with date_dim as (
    select make_date(year_num, 12, 31) as check_date
    from generate_series(
        (select min(extract(year from term_start))::int from legislators_terms),
        (select max(extract(year from term_end))::int from legislators_terms),
        1
    ) as gs(year_num)
), first_terms as (
    select
        id_bioguide,
        min(term_start) as first_term
    from legislators_terms
    group by id_bioguide
), retained as (
    select
        extract(year from f.first_term)::int as first_year,
        date_part('year', age(d.check_date, f.first_term))::int as period,
        count(distinct f.id_bioguide) as cohort_retained
    from first_terms f
    join legislators_terms t on t.id_bioguide = f.id_bioguide
    join date_dim d on d.check_date between t.term_start and t.term_end
    group by first_year, period
)
select
    first_year,
    period,
    first_value(cohort_retained) over (
        partition by first_year
        order by period
    ) as cohort_size,
    cohort_retained,
    round(
        cohort_retained * 100.0
        / first_value(cohort_retained) over (
            partition by first_year
            order by period
        ),
        2
    ) as pct_retained
from retained
order by first_year, period;

-- анализ удержания по столетиям.
-- результат удобно использовать для графика: одна строка — период, отдельные столбцы — когорты по векам.
with date_dim as (
    select make_date(year_num, 12, 31) as check_date
    from generate_series(
        (select min(extract(year from term_start))::int from legislators_terms),
        (select max(extract(year from term_end))::int from legislators_terms),
        1
    ) as gs(year_num)
), first_terms as (
    select
        id_bioguide,
        min(term_start) as first_term
    from legislators_terms
    group by id_bioguide
), retained as (
    select
        date_part('century', f.first_term)::int as cohort_century,
        date_part('year', age(d.check_date, f.first_term))::int as period,
        count(distinct f.id_bioguide) as cohort_retained
    from first_terms f
    join legislators_terms t on t.id_bioguide = f.id_bioguide
    join date_dim d on d.check_date between t.term_start and t.term_end
    group by cohort_century, period
), retention_pct as (
    select
        cohort_century,
        period,
        round(
            cohort_retained * 100.0
            / first_value(cohort_retained) over (
                partition by cohort_century
                order by period
            ),
            2
        ) as pct_retained
    from retained
)
select
    period,
    max(case when cohort_century = 18 then pct_retained end) as century_18,
    max(case when cohort_century = 19 then pct_retained end) as century_19,
    max(case when cohort_century = 20 then pct_retained end) as century_20,
    max(case when cohort_century = 21 then pct_retained end) as century_21
from retention_pct
group by period
order by period;

-- Когорты от даты, отлично от первой даты (с.174).
-- здесь когорта задаётся искусственно: все законодатели, занимавшие должность в 2000 году.
-- дальше считается, какая доля представителей и сенаторов оставалась в должности по годам после 2000 года.
with date_dim as (
    select make_date(year_num, 12, 31) as check_date
    from generate_series(
        2000,
        (select max(extract(year from term_end))::int from legislators_terms),
        1
    ) as gs(year_num)
), cohort_2000 as (
    select
        id_bioguide,
        term_type,
        date '2000-01-01' as first_term,
        min(term_start) as min_start
    from legislators_terms
    where term_start <= date '2000-12-31'
      and term_end >= date '2000-01-01'
    group by id_bioguide, term_type
), retained as (
    select
        c.term_type,
        date_part('year', age(d.check_date, c.first_term))::int as period,
        count(distinct c.id_bioguide) as cohort_retained
    from cohort_2000 c
    join legislators_terms t on t.id_bioguide = c.id_bioguide
      and t.term_start >= c.min_start
    join date_dim d on d.check_date between t.term_start and t.term_end
    group by c.term_type, period
), retention_pct as (
    select
        term_type,
        period,
        round(
            cohort_retained * 100.0
            / first_value(cohort_retained) over (
                partition by term_type
                order by period
            ),
            2
        ) as pct_retained
    from retained
)
select
    period,
    max(case when term_type = 'rep' then pct_retained end) as rep,
    max(case when term_type = 'sen' then pct_retained end) as sen
from retention_pct
group by period
order by period;

-- 3.2.2. Выживаемость
-- Выживаемость связана с тем, сколько сущностей осталось в наборе данных на протяжении определённого периода времени или дольше, независимо от количества или частоты действий.
-- Вычислим долю законодателей, которые задержались на посту в течение 10 и более лет после начала их первого срока (с.178).
-- Построим график.

-- tenure считается как разница между последним и первым началом срока.
-- здесь важен сам факт, прослужил ли законодатель 10 и более лет.
with tenure_by_legislator as (
    select
        id_bioguide,
        date_part('century', min(term_start))::int as cohort_century,
        min(term_start) as first_term,
        max(term_start) as last_term,
        date_part('year', age(max(term_start), min(term_start))) as tenure
    from legislators_terms
    group by id_bioguide
)
select
    cohort_century,
    count(distinct id_bioguide) as cohort_size,
    count(distinct case when tenure >= 10 then id_bioguide end) as survived_10,
    round(
        count(distinct case when tenure >= 10 then id_bioguide end) * 100.0
        / count(distinct id_bioguide),
        2
    ) as pct_survived_10
from tenure_by_legislator
group by cohort_century
order by cohort_century;

-- 3.2.3. Возвращаемость
-- Возвращаемость или поведение при повторной покупке связана с тем, произошло ли действие больше определённого количества раз
-- (минимального порога) – чаще всего более одного раза – в течение фиксированного временного окна.
-- Найдём, сколько законодателей занимали должность в обеих палатах, какая доля из них начинала как представитель и впоследствии стала сенатором (с.183).

-- количество представителей, которые позднее стали сенаторами, по столетиям первого срока представителя.
with first_reps as (
    select
        id_bioguide,
        min(term_start) as first_term
    from legislators_terms
    where term_type = 'rep'
    group by id_bioguide
)
select
    date_part('century', r.first_term)::int as cohort_century,
    count(distinct r.id_bioguide) as rep_and_sen
from first_reps r
join legislators_terms t on t.id_bioguide = r.id_bioguide
  and t.term_type = 'sen'
  and t.term_start > r.first_term
group by cohort_century
order by cohort_century;

-- доля представителей, которые позднее стали сенаторами, от общего количества представителей в своей когорте.
with first_reps as (
    select
        id_bioguide,
        min(term_start) as first_term
    from legislators_terms
    where term_type = 'rep'
    group by id_bioguide
), cohort_size as (
    select
        date_part('century', first_term)::int as cohort_century,
        count(distinct id_bioguide) as reps
    from first_reps
    group by cohort_century
), returned as (
    select
        date_part('century', r.first_term)::int as cohort_century,
        count(distinct r.id_bioguide) as rep_and_sen
    from first_reps r
    join legislators_terms t on t.id_bioguide = r.id_bioguide
      and t.term_type = 'sen'
      and t.term_start > r.first_term
    group by cohort_century
)
select
    c.cohort_century,
    c.reps,
    coalesce(r.rep_and_sen, 0) as rep_and_sen,
    round(coalesce(r.rep_and_sen, 0) * 100.0 / c.reps, 2) as pct_rep_and_sen
from cohort_size c
left join returned r on r.cohort_century = c.cohort_century
order by c.cohort_century;

-- Постройте график (с.188).
-- сравниваем долю представителей, которые стали сенаторами за 5, 10 и 15 лет после первого срока.
with first_reps as (
    select
        id_bioguide,
        min(term_start) as first_term,
        date_part('century', min(term_start))::int as cohort_century
    from legislators_terms
    where term_type = 'rep'
    group by id_bioguide
), cohort_size as (
    select
        cohort_century,
        count(distinct id_bioguide) as reps
    from first_reps
    where first_term <= date '2009-12-31'
    group by cohort_century
), returned as (
    select
        r.cohort_century,
        count(distinct case
            when age(t.term_start, r.first_term) <= interval '5 years'
            then r.id_bioguide
        end) as rep_and_sen_5_yrs,
        count(distinct case
            when age(t.term_start, r.first_term) <= interval '10 years'
            then r.id_bioguide
        end) as rep_and_sen_10_yrs,
        count(distinct case
            when age(t.term_start, r.first_term) <= interval '15 years'
            then r.id_bioguide
        end) as rep_and_sen_15_yrs
    from first_reps r
    join legislators_terms t on t.id_bioguide = r.id_bioguide
      and t.term_type = 'sen'
      and t.term_start > r.first_term
    group by r.cohort_century
)
select
    c.cohort_century,
    c.reps,
    round(coalesce(r.rep_and_sen_5_yrs, 0) * 100.0 / c.reps, 2) as pct_5_yrs,
    round(coalesce(r.rep_and_sen_10_yrs, 0) * 100.0 / c.reps, 2) as pct_10_yrs,
    round(coalesce(r.rep_and_sen_15_yrs, 0) * 100.0 / c.reps, 2) as pct_15_yrs
from cohort_size c
left join returned r on r.cohort_century = c.cohort_century
order by c.cohort_century;

-- 3.2.4. Накопительный итог
-- Накопительный итог связан с общим количеством или общей суммой, вычисляемой в пределах одного или нескольких фиксированных временных окон,
-- независимо от того, когда именно в этом окне произошли действия.
-- Найдём количество сроков, начатых в течение 10 лет первого temp_start, разбив законодателей на когорты по столетиям и типу первого срока (с.189).

-- здесь считаются все сроки, начавшиеся в первые 10 лет после первого срока законодателя.
-- когорты разделены по веку первого срока и типу первого срока: rep или sen.
with first_terms as (
    select distinct
        id_bioguide,
        first_value(term_type) over (
            partition by id_bioguide
            order by term_start, term_id
        ) as first_type,
        min(term_start) over (
            partition by id_bioguide
        ) as first_term
    from legislators_terms
)
select
    date_part('century', f.first_term)::int as century,
    f.first_type,
    count(distinct f.id_bioguide) as cohort,
    count(t.term_start) as terms
from first_terms f
left join legislators_terms t on t.id_bioguide = f.id_bioguide
  and t.term_start between f.first_term and f.first_term + interval '10 years'
group by century, f.first_type
order by century, f.first_type;

-- 3.2.5. Поперечный анализ через все когорты
-- Определим количество законодателей, занимающих свои должности, для каждого года (с.193).

-- поперечный анализ не смотрит на возраст когорты.
-- он отвечает на вопрос: сколько законодателей было активно на 31 декабря каждого года.
with date_dim as (
    select make_date(year_num, 12, 31) as check_date
    from generate_series(
        (select min(extract(year from term_start))::int from legislators_terms),
        2019,
        1
    ) as gs(year_num)
)
select
    d.check_date as date,
    count(distinct t.id_bioguide) as legislators
from date_dim d
join legislators_terms t on d.check_date between t.term_start and t.term_end
group by d.check_date
order by d.check_date;

-- 3.3. Анализ данных о вакансиях с целью выявления закономерностей и трендов, 
-- связанных с поведением работодателей и кандидатов в зависимости от времени и других факторов
-- 3.3.1. Импортируйте данные с Роснавык (данные по 18 работе).

select * from earthquakes limit 10;

-- базовая проверка временных границ датасета
select
    min(time)::date as min_event_date,
    max(time)::date as max_event_date,
    min(updated)::date as min_updated_date,
    max(updated)::date as max_updated_date,
    count(*) as events_count,
    count(distinct id) as unique_events_count
from earthquakes;

-- очистка базовых дат для дальнейшего анализа.
-- event_date используется как дата появления записи, close_date -- как дата последнего обновления записи.
-- если updated отсутствует или оказался раньше time, дата завершения заменяется на time.
with events_clean as (
    select
        id,
        time::date as event_date,
        greatest(coalesce(updated::date, time::date), time::date) as close_date,
        latitude,
        longitude,
        depth,
        mag,
        magtype,
        net,
        place,
        type,
        status,
        locationsource,
        magsource
    from earthquakes
    where time is not null
)
select *
from events_clean
limit 10;

-- 3.3.2. Анализ удержания
-- Показатель отражает, какая доля записей остаётся актуальной спустя определённое время после появления.
-- Для датасета earthquakes запись считается актуальной от time до updated.

-- Построение кривой удержания: сколько записей остаются активными через определенный промежуток времени после публикации.
-- Период измеряется в днях от даты события до даты последнего обновления.
with events_clean as (
    select
        id,
        time::date as event_date,
        greatest(coalesce(updated::date, time::date), time::date) as close_date
    from earthquakes
    where time is not null
), periods as (
    select generate_series(0, 90, 5) as period_day
), retained as (
    select
        p.period_day,
        count(e.id) as cohort_retained
    from periods p
    left join events_clean e
      on e.close_date >= e.event_date + p.period_day
    group by p.period_day
)
select
    period_day,
    first_value(cohort_retained) over (order by period_day) as cohort_size,
    cohort_retained,
    round(
        cohort_retained * 100.0
        / nullif(first_value(cohort_retained) over (order by period_day), 0),
        2
    ) as pct_retained
from retained
order by period_day;

-- Сравнение удержания по годам: разделение записей на ежегодные когорты и построение графика для каждой когорты.
with events_clean as (
    select
        id,
        time::date as event_date,
        greatest(coalesce(updated::date, time::date), time::date) as close_date,
        extract(year from time)::int as cohort_year
    from earthquakes
    where time is not null
), years as (
    select distinct cohort_year
    from events_clean
), periods as (
    select generate_series(0, 90, 5) as period_day
), retained as (
    select
        y.cohort_year,
        p.period_day,
        count(e.id) filter (
            where e.close_date >= e.event_date + p.period_day
        ) as cohort_retained
    from years y
    cross join periods p
    left join events_clean e on e.cohort_year = y.cohort_year
    group by y.cohort_year, p.period_day
), cohort_sizes as (
    select
        cohort_year,
        count(*) as cohort_size
    from events_clean
    group by cohort_year
)
select
    r.cohort_year,
    r.period_day,
    c.cohort_size,
    r.cohort_retained,
    round(r.cohort_retained * 100.0 / nullif(c.cohort_size, 0), 2) as pct_retained
from retained r
join cohort_sizes c on c.cohort_year = r.cohort_year
order by r.cohort_year, r.period_day;

-- Анализ удержания начиная с разных дат: исследование удержания относительно произвольной даты.
-- В качестве произвольной даты берётся 2020-01-01.
with base_events as (
    select distinct
        id,
        date '2020-01-01' as first_date,
        time::date as event_date,
        greatest(coalesce(updated::date, time::date), time::date) as close_date
    from earthquakes
    where time::date <= date '2020-01-01'
      and greatest(coalesce(updated::date, time::date), time::date) >= date '2020-01-01'
), periods as (
    select generate_series(0, 90, 5) as period_day
), retained as (
    select
        p.period_day,
        count(b.id) filter (
            where b.close_date >= b.first_date + p.period_day
        ) as cohort_retained
    from periods p
    cross join base_events b
    group by p.period_day
)
select
    period_day,
    first_value(cohort_retained) over (order by period_day) as cohort_size,
    cohort_retained,
    round(
        cohort_retained * 100.0
        / nullif(first_value(cohort_retained) over (order by period_day), 0),
        2
    ) as pct_retained
from retained
order by period_day;

-- 3.3.3. Анализ выживаемости
-- Анализ показывает длительность пребывания записи в актуальном состоянии до последнего обновления.

-- Выявление доли записей, оставшихся открытыми на протяжении определенного времени, например 30 дней.
with events_clean as (
    select
        id,
        time::date as event_date,
        greatest(coalesce(updated::date, time::date), time::date) as close_date
    from earthquakes
    where time is not null
), lifetime as (
    select
        id,
        close_date - event_date as lifetime_days
    from events_clean
)
select
    count(*) as events_count,
    count(*) filter (where lifetime_days >= 30) as survived_30_days,
    round(
        count(*) filter (where lifetime_days >= 30) * 100.0
        / nullif(count(*), 0),
        2
    ) as pct_survived_30_days
from lifetime;

-- Построение графика продолжительности жизни записей.
-- Запрос группирует записи по длительности актуальности с шагом 10 дней.
with events_clean as (
    select
        id,
        time::date as event_date,
        greatest(coalesce(updated::date, time::date), time::date) as close_date
    from earthquakes
    where time is not null
), lifetime as (
    select
        id,
        close_date - event_date as lifetime_days
    from events_clean
), grouped as (
    select
        floor(lifetime_days / 10.0)::int * 10 as lifetime_group_from,
        floor(lifetime_days / 10.0)::int * 10 + 9 as lifetime_group_to,
        count(*) as events_count
    from lifetime
    group by 1, 2
)
select
    lifetime_group_from,
    lifetime_group_to,
    events_count
from grouped
order by lifetime_group_from;

-- 3.3.4. Анализ возвращаемости
-- Для вакансий возвращаемость означала бы повторную публикацию работодателем похожих вакансий.
-- Для earthquakes аналогом является повторение событий по одному источнику и месту.

-- Определение количества повторных записей, опубликованных теми же источниками по тем же местам.
with repeated_events as (
    select
        coalesce(net, 'unknown') as source_name,
        coalesce(place, 'unknown') as place_name,
        count(*) as events_count,
        min(time)::date as first_event_date,
        max(time)::date as last_event_date
    from earthquakes
    where time is not null
    group by coalesce(net, 'unknown'), coalesce(place, 'unknown')
)
select
    source_name,
    place_name,
    events_count,
    first_event_date,
    last_event_date
from repeated_events
where events_count > 1
order by events_count desc, source_name, place_name;

-- Оценка долей источников, которые размещают несколько схожих записей.
with source_places as (
    select
        coalesce(net, 'unknown') as source_name,
        coalesce(place, 'unknown') as place_name,
        count(*) as events_count
    from earthquakes
    where time is not null
    group by coalesce(net, 'unknown'), coalesce(place, 'unknown')
), source_stats as (
    select
        source_name,
        count(*) as place_groups,
        count(*) filter (where events_count > 1) as repeated_place_groups
    from source_places
    group by source_name
)
select
    source_name,
    place_groups,
    repeated_place_groups,
    round(repeated_place_groups * 100.0 / nullif(place_groups, 0), 2) as pct_repeated_place_groups
from source_stats
order by pct_repeated_place_groups desc, repeated_place_groups desc;

-- 3.3.5. Поперечный анализ через все когорты
-- Подсчет общего количества записей, актуальных на каждый временной интервал, чтобы выявить динамику.

-- Количество актуальных записей на конец каждого месяца.
with events_clean as (
    select
        id,
        time::date as event_date,
        greatest(coalesce(updated::date, time::date), time::date) as close_date
    from earthquakes
    where time is not null
), date_dim as (
    select
        (date_trunc('month', gs)::date + interval '1 month - 1 day')::date as check_date
    from generate_series(
        (select date_trunc('month', min(event_date))::date from events_clean),
        (select date_trunc('month', max(close_date))::date from events_clean),
        interval '1 month'
    ) as gs
)
select
    d.check_date,
    count(distinct e.id) as active_events
from date_dim d
left join events_clean e on d.check_date between e.event_date and e.close_date
group by d.check_date
order by d.check_date;

-- Количество актуальных записей на конец каждого квартала.
with events_clean as (
    select
        id,
        time::date as event_date,
        greatest(coalesce(updated::date, time::date), time::date) as close_date
    from earthquakes
    where time is not null
), date_dim as (
    select
        (date_trunc('quarter', gs)::date + interval '3 month - 1 day')::date as check_date
    from generate_series(
        (select date_trunc('quarter', min(event_date))::date from events_clean),
        (select date_trunc('quarter', max(close_date))::date from events_clean),
        interval '3 month'
    ) as gs
)
select
    d.check_date,
    count(distinct e.id) as active_events
from date_dim d
left join events_clean e on d.check_date between e.event_date and e.close_date
group by d.check_date
order by d.check_date;

-- 3.3.6. Сформулируйте выводы о поведении работодателей и изменениях на рынке труда.
-- Для датасета earthquakes выводы формулируются не о работодателях, а о динамике записей о землетрясениях.
-- По результатам запросов можно оценить:
-- 1) как быстро записи перестают обновляться после появления;
-- 2) какие годы имеют более высокое удержание записей;
-- 3) какие источники и территории дают больше повторных событий;
-- 4) как меняется количество актуальных записей по месяцам и кварталам.

-- 3.3.7. Доп.задачи

-- Средний срок размещения записи: сколько дней проходит между появлением события и последним обновлением.
with events_clean as (
    select
        id,
        time::date as event_date,
        greatest(coalesce(updated::date, time::date), time::date) as close_date
    from earthquakes
    where time is not null
)
select
    round(avg(close_date - event_date), 2) as avg_lifetime_days,
    percentile_cont(0.5) within group (order by close_date - event_date) as median_lifetime_days,
    min(close_date - event_date) as min_lifetime_days,
    max(close_date - event_date) as max_lifetime_days
from events_clean;

-- Частота обновления записей: сколько времени проходит между time и updated по источникам.
with events_clean as (
    select
        id,
        coalesce(net, 'unknown') as source_name,
        time::date as event_date,
        greatest(coalesce(updated::date, time::date), time::date) as close_date
    from earthquakes
    where time is not null
)
select
    source_name,
    count(*) as events_count,
    round(avg(close_date - event_date), 2) as avg_update_delay_days,
    percentile_cont(0.5) within group (order by close_date - event_date) as median_update_delay_days
from events_clean
group by source_name
order by events_count desc, source_name;

-- Динамика ключевых признаков.
-- В датасете earthquakes нет навыков, поэтому вместо них анализируется динамика типов магнитуды magtype.
select
    date_trunc('month', time)::date as month,
    coalesce(magtype, 'unknown') as magtype,
    count(*) as events_count,
    round(avg(mag), 2) as avg_mag
from earthquakes
where time is not null
group by date_trunc('month', time)::date, coalesce(magtype, 'unknown')
order by month, events_count desc;
