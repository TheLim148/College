-- 3.1. По данным наборам данных. Данные о законодателях. 
-- Импортируйте данные в отдельную схему
-- Заполните отсутствующие даты для большей точности (с.152)
drop table if exists legislators;

create table legislators
(
full_name varchar--name_official_full
,first_name varchar --name_first
,last_name varchar --name_last
,middle_name varchar --name_middle
,nickname varchar --name_nickname
,suffix varchar --name_suffix
,other_names_end date -- other_names_0_end date
,other_names_middle varchar -- other_names_0_middle
,other_names_last varchar -- other_names_0_last
,birthday date -- bio_birthday
,gender varchar-- bio_gender
,id_bioguide varchar primary key
,id_bioguide_previous_0 varchar
,id_govtrack int
,id_icpsr int
,id_wikipedia varchar
,id_wikidata varchar
,id_google_entity_id varchar
,id_house_history bigint
,id_house_history_alternate int
,id_thomas int
,id_cspan int
,id_votesmart int
,id_lis varchar
,id_ballotpedia varchar
,id_opensecrets varchar
,id_fec_0 varchar
,id_fec_1 varchar
,id_fec_2 varchar
);

select * from legislators;

drop table if exists legislators_terms;
create table legislators_terms
(
id_bioguide varchar
,term_number int 
,term_id varchar primary key
,term_type varchar
,term_start date
,term_end date
,state varchar
,district int
,class int
,party varchar
,how varchar
,url varchar--terms_1_url
,address varchar --terms_1_address
,phone varchar --terms_1_phone
,fax varchar --terms_1_fax
,contact_form varchar --terms_1_contact_form
,office varchar--terms_1_office
,state_rank varchar --terms_1_state_rank
,rss_url varchar --terms_1_rss_url
,caucus varchar -- terms_1_caucus
);

select * from legislators_terms;

-- 3.2. Виды когортного анализа
-- 3.2.1. Анализ удержания
-- Удержание связано с тем, есть ли у участников когорты ещё записи во временном ряду через конкретное количество периодов, прошедших с начальной даты.
-- Постройте кривую удержания (с.148-150) – запрос и график.
select date_part('year', age(b.term_start, a.first_term)) as period
    ,count(distinct a.id_bioguide) as cohort_retained
from
(
    select id_bioguide, min(term_start) as first_term
    from legislators_terms
    group by 1
) a
join legislators_terms b on a.id_bioguide = b.id_bioguide
group by 1
;



select period
    ,first_value(cohort_retained) over (order by period) as cohort_size
    ,cohort_retained
    ,round(cohort_retained * 100.0 /
        first_value(cohort_retained) over (order by period), 2) as pct_retained
from
(
    select date_part('year', age(b.term_start, a.first_term)) as period
        ,count(distinct a.id_bioguide) as cohort_retained
    from
    (
        select id_bioguide, min(term_start) as first_term
        from legislators_terms
        group by 1
    ) a
    join legislators_terms b on a.id_bioguide = b.id_bioguide
    group by 1
) aa
;



with date_dim as (
    select make_date(year_num, 12, 31) as date
    from generate_series(
        (select min(date_part('year', term_start))::int from legislators_terms),
        (select max(date_part('year', term_end))::int from legislators_terms),
        1
    ) as gs(year_num)
)
select period
    ,first_value(cohort_retained) over (order by period) as cohort_size
    ,cohort_retained
    ,round(cohort_retained * 100.0 /
        first_value(cohort_retained) over (order by period), 2) as pct_retained
from
(
    select coalesce(date_part('year', age(c.date, a.first_term)), 0) as period
        ,count(distinct a.id_bioguide) as cohort_retained
    from
    (
        select id_bioguide, min(term_start) as first_term
        from legislators_terms
        group by 1
    ) a
    join legislators_terms b on a.id_bioguide = b.id_bioguide
    left join date_dim c on c.date between b.term_start and b.term_end
    group by 1
) aa
order by period
;

-- Разобьём сущности на ежегодные когорты (с.159). Построим график.
with date_dim as (
    select make_date(year_num, 12, 31) as date
    from generate_series(
        (select min(date_part('year', term_start))::int from legislators_terms),
        (select max(date_part('year', term_end))::int from legislators_terms),
        1
    ) as gs(year_num)
)
select first_year
    ,period
    ,first_value(cohort_retained) over (
        partition by first_year
        order by period
    ) as cohort_size
    ,cohort_retained
    ,round(cohort_retained * 100.0 /
        first_value(cohort_retained) over (
            partition by first_year
            order by period
        ), 2) as pct_retained
from
(
    select date_part('year', a.first_term) as first_year
        ,coalesce(date_part('year', age(c.date, a.first_term)), 0) as period
        ,count(distinct a.id_bioguide) as cohort_retained
    from
    (
        select id_bioguide, min(term_start) as first_term
        from legislators_terms
        group by 1
    ) a
    join legislators_terms b on a.id_bioguide = b.id_bioguide
    left join date_dim c on c.date between b.term_start and b.term_end
    group by 1, 2
) aa
order by 1, 2
;



with date_dim as (
    select
        make_date(year_num, 12, 31) as date,
        'December'::text as month_name,
        31 as day_of_month
    from generate_series(
        (select min(date_part('year', term_start))::int from legislators_terms),
        (select max(date_part('year', term_end))::int from legislators_terms),
        1
    ) as gs(year_num)
),
source_data as (
    select date_part('century', a.first_term) as first_century
        ,coalesce(date_part('year', age(c.date, a.first_term)), 0) as period
        ,count(distinct a.id_bioguide) as cohort_retained
    from
    (
        select id_bioguide, min(term_start) as first_term
        from legislators_terms
        group by 1
    ) a
    join legislators_terms b on a.id_bioguide = b.id_bioguide
    left join date_dim c on c.date between b.term_start and b.term_end
        and c.month_name = 'December' and c.day_of_month = 31
    group by 1, 2
),
retention as (
    select first_century
        ,period
        ,round(cohort_retained * 100.0 /
            first_value(cohort_retained) over (
                partition by first_century
                order by period
            ), 2) as pct_retained
    from source_data
)
select period
    ,max(case when first_century = 18 then pct_retained end) as c18
    ,max(case when first_century = 19 then pct_retained end) as c19
    ,max(case when first_century = 20 then pct_retained end) as c20
    ,max(case when first_century = 21 then pct_retained end) as c21
from retention
group by 1
order by 1
;

-- Когорты от даты, отлично от первой даты (с.174).
with date_dim as (
    select
        make_date(year_num, 12, 31) as date,
        'December'::text as month_name,
        31 as day_of_month,
        year_num as year
    from generate_series(
        2000,
        (select max(date_part('year', term_end))::int from legislators_terms),
        1
    ) as gs(year_num)
),
source_data as (
    select a.term_type
        ,coalesce(date_part('year', age(c.date, a.first_term)), 0) as period
        ,count(distinct a.id_bioguide) as cohort_retained
    from
    (
        select distinct id_bioguide, term_type
            ,date '2000-01-01' as first_term
            ,min(term_start) as min_start
        from legislators_terms
        where term_start <= '2000-12-31'
            and term_end >= '2000-01-01'
        group by 1, 2, 3
    ) a
    join legislators_terms b on a.id_bioguide = b.id_bioguide
        and b.term_start >= a.min_start
    left join date_dim c on c.date between b.term_start and b.term_end
        and c.month_name = 'December'
        and c.day_of_month = 31
        and c.year >= 2000
    group by 1, 2
),
retention as (
    select term_type
        ,period
        ,round(cohort_retained * 100.0
            / first_value(cohort_retained) over (
                partition by term_type
                order by period
            ), 2) as pct_retained
    from source_data
)
select period
    ,max(case when term_type = 'rep' then pct_retained end) as rep
    ,max(case when term_type = 'sen' then pct_retained end) as sen
from retention
group by 1
order by 1
;

-- 3.2.2. Выживаемость
-- Выживаемость связана с тем, сколько сущностей осталось в наборе данных на протяжении определённого периода времени или дольше, независимо от количества или частоты действий.
-- Вычислим долю законодателей, которые задержались на посту в течение 10 и более лет после начала их первого срока (с.178). 
-- Постоим график.
select first_century
    ,count(distinct id_bioguide) as cohort_size
    ,count(distinct case when tenure >= 10 then id_bioguide end) as survived_10
    ,round(count(distinct case when tenure >= 10 then id_bioguide end)
        * 100.0 / count(distinct id_bioguide), 2) as pct_survived_10
from
(
    select id_bioguide
        ,date_part('century', min(term_start)) as first_century
        ,min(term_start) as first_term
        ,max(term_start) as last_term
        ,date_part('year', age(max(term_start), min(term_start))) as tenure
    from legislators_terms
    group by 1
) a
group by 1
order by 1
;


-- 3.2.3. Возвращаемость
-- Возвращаемость или поведение при повторной покупке связана с тем, произошло ли действие больше определённого количества раз
-- (минимального порога) – чаще всего более одного раза – в течение фиксированного временного окна.
-- Найдём, сколько законодателей занимали должность в обеих палатах, какая доля из них начинала как представитель и впоследствии стала сенатором (с.183).
select date_part('century', a.first_term) as cohort_century
    ,count(distinct a.id_bioguide) as rep_and_sen
from
(
    select id_bioguide, min(term_start) as first_term
    from legislators_terms
    where term_type = 'rep'
    group by 1
) a
join legislators_terms b on a.id_bioguide = b.id_bioguide
    and b.term_type = 'sen'
    and b.term_start > a.first_term
group by 1
order by 1
;


select aa.cohort_century
    ,round(bb.rep_and_sen * 100.0 / aa.reps, 2) as pct_rep_and_sen
from
(
    select date_part('century', a.first_term) as cohort_century
        ,count(id_bioguide) as reps
    from
    (
        select id_bioguide, min(term_start) as first_term
        from legislators_terms
        where term_type = 'rep'
        group by 1
    ) a
    group by 1
) aa
left join
(
    select date_part('century', b.first_term) as cohort_century
        ,count(distinct b.id_bioguide) as rep_and_sen
    from
    (
        select id_bioguide, min(term_start) as first_term
        from legislators_terms
        where term_type = 'rep'
        group by 1
    ) b
    join legislators_terms c on b.id_bioguide = c.id_bioguide
        and c.term_type = 'sen'
        and c.term_start > b.first_term
    group by 1
) bb on aa.cohort_century = bb.cohort_century
order by 1
;

-- Постройте график (с.188).

with first_reps as (
    select id_bioguide
        ,min(term_start) as first_term
        ,floor(date_part('year', min(term_start)) / 10) * 10 as first_decade
    from legislators_terms
    where term_type = 'rep'
    group by 1
),
cohort_size as (
    select first_decade
        ,count(distinct id_bioguide) as reps
    from first_reps
    group by 1
),
returned as (
    select a.first_decade
        ,count(distinct case
            when b.term_start <= a.first_term + interval '10 years'
            then a.id_bioguide
        end) as became_sen_10
        ,count(distinct case
            when b.term_start <= a.first_term + interval '20 years'
            then a.id_bioguide
        end) as became_sen_20
    from first_reps a
    join legislators_terms b on a.id_bioguide = b.id_bioguide
        and b.term_type = 'sen'
        and b.term_start > a.first_term
    group by 1
)
select c.first_decade
    ,round(coalesce(r.became_sen_10, 0) * 100.0 / c.reps, 2) as pct_10
    ,round(coalesce(r.became_sen_20, 0) * 100.0 / c.reps, 2) as pct_20
from cohort_size c
left join returned r on c.first_decade = r.first_decade
order by 1
;


-- 3.2.4. Накопительный итог
-- Накопительный итог связан с общим количеством или общей суммой, вычисляемой в пределах одного или нескольких фиксированных временных окон, 
-- независимо от того, когда именно в этом окне произошли действия.
-- Найдём количество сроков, начатых в течение 10 лет первого temp_start, разбив законодателей на когорты по столетиям и типу первого срока (с.189).
select date_part('century', a.first_term) as century
    ,first_type
    ,count(distinct a.id_bioguide) as cohort
    ,count(b.term_start) as terms
from
(
    select distinct id_bioguide
        ,first_value(term_type) over (
            partition by id_bioguide
            order by term_start
        ) as first_type
        ,min(term_start) over (
            partition by id_bioguide
        ) as first_term
        ,min(term_start) over (
            partition by id_bioguide
        ) + interval '10 years' as first_plus_10
    from legislators_terms
) a
left join legislators_terms b on a.id_bioguide = b.id_bioguide
    and b.term_start between a.first_term and a.first_plus_10
group by 1, 2
order by 1, 2
;

-- 3.2.5. Поперечный анализ через все когорты
-- Определим количество законодателей, занимающих свои должности, для каждого года (с.193).
with date_dim as (
    select
        make_date(year_num, 12, 31) as date,
        'December'::text as month_name,
        31 as day_of_month,
        year_num as year
    from generate_series(
        (select min(date_part('year', term_start))::int from legislators_terms),
        2019,
        1
    ) as gs(year_num)
)
select b.date
    ,count(distinct a.id_bioguide) as legislators
from legislators_terms a
join date_dim b on b.date between a.term_start and a.term_end
    and b.month_name = 'December'
    and b.day_of_month = 31
    and b.year <= 2019
group by 1
order by 1
;

-- 3.3.	Анализ данных о вакансиях с целью выявления закономерностей и трендов, связанных с поведением работодателей и кандидатов в зависимости от времени и других факторов
-- 3.3.1. Импортируйте данные с Роснавык (данные по 18 работе).

select * from vac_clean limit 10;

-- 3.3.2. Анализ удержания (показатель, который отражает, какие доли сотрудников остаются на работе спустя определенное время после трудоустройства)
-- Построение кривой удержания: сколько вакансий остаются активными через определенный промежуток времени после публикации.
-- Сравнение удержания по годам: разделение вакансий на ежегодные когорты и построение графика для каждой когорты.
-- Анализ удержания начиная с разных дат: исследование удержания вакансий относительно произвольной даты, отличной от первой даты публикации.

-- 3.3.3. Анализ выживаемости (длительность пребывания вакансий на рынке труда до момента закрытия)
-- Выявление доли вакансий, оставшихся открытыми на протяжении определенного времени (например, 30 дней).
-- Построение графика продолжительности жизни вакансий.

-- 3.3.4. Анализ возвращаемости (оценка того, насколько часто работодатели повторно публикуют одни и те же вакансии или похожие вакансии)
-- Определение количества вакансий, опубликованных повторно теми же работодателями.
-- Оценка долей работодателей, которые размещают несколько схожих вакансий.

-- 3.3.5. Поперечный анализ через все когорты (анализ изменения числа активных вакансий в каждый конкретный год или месяц)
-- Подсчет общего количества вакансий, актуальных на каждый временной интервал (год, квартал), чтобы выявить динамику рынка труда.

-- 3.3.6. Сформулируйте выводы о поведении работодателей и изменениях на рынке труда.

-- 3.3.7. Доп.задачи
-- Средний срок размещения вакансии (сколько дней проходит между публикацией и закрытием вакансии).
-- Частота обновления вакансий (как часто обновляются вакансии).
-- Динамика ключевых навыков (изменение востребованности определенных профессиональных навыков).
