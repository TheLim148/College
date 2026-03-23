-- создание "грязной" таблицы
create table vac_stage (
  "ID вакансии" text,
  "Название вакансии" text,
  "Описание вакансии" text,
  "Ключевые навыки" text,
  "Опыт работы" text,
  "Название специальности" text,
  "Заработная плата" text
);

drop table vac_stage;

-- проверка корректности импорта
select count(*) as vac_stage_rows from vac_stage;
select * from vac_stage limit 5;

-- 3.4.	Профилирование (качество данных).

-- 3.4.1. Поиск дубликатовselect "ID вакансии", count(*) as cnt
select "ID вакансии", count(*) as cnt
from vac_stage
group by "ID вакансии"
having count(*) > 1
order by cnt desc, "ID вакансии";

-- 3.4.2. Исключение дубликатов с помощью group by и distinct
-- (distinct)
select distinct
  "ID вакансии",
  "Название вакансии",
  "Описание вакансии",
  "Ключевые навыки",
  "Опыт работы",
  "Название специальности",
  "Заработная плата"
from vac_stage limit 5;

-- (group by)
select
  "ID вакансии",
  "Название вакансии",
  "Описание вакансии",
  "Ключевые навыки",
  "Опыт работы",
  "Название специальности",
  "Заработная плата"
from vac_stage
group by
  "ID вакансии",
  "Название вакансии",
  "Описание вакансии",
  "Ключевые навыки",
  "Опыт работы",
  "Название специальности",
  "Заработная плата"
limit 5;

-- создание "чистой" таблицы
create table vac_clean (
  vacancy_id text primary key,
  title text,
  description text,
  skills text,
  experience text,
  specialty text,
  salary int
);

drop table vac_clean;

-- 1.6 предобработка и корректный импорт в "чистую" таблицу
-- nullif(..., '') превращает пустые строки в null
-- salary: пытаемся привести к числу; 0 считаем "не указана"
insert into vac_clean (
  vacancy_id, title, description, skills, experience, specialty, salary
)
select distinct on (nullif(trim("ID вакансии"), ''))
  nullif(trim("ID вакансии"), '') as vacancy_id,
  nullif(trim("Название вакансии"), '') as title,
  nullif(trim("Описание вакансии"), '') as description,
  nullif(trim("Ключевые навыки"), '') as skills,
  nullif(trim("Опыт работы"), '') as experience,
  nullif(trim("Название специальности"), '') as specialty,
  nullif(
    case
      when "Заработная плата" is null then null
      when trim("Заработная плата") = '' then null
      when trim("Заработная плата") ~ '^[0-9]+([.,][0-9]+)?$' then replace(trim("Заработная плата"), ',', '.')::numeric::int
      when trim("Заработная плата") ~ '^[0-9]+\s*-\s*[0-9]+$' then
        round((
          split_part(replace(trim("Заработная плата"), ' ', ''), '-', 1)::numeric +
          split_part(replace(trim("Заработная плата"), ' ', ''), '-', 2)::numeric
        ) / 2.0)::int
      else null
    end,
    0
  ) as salary
from vac_stage
where nullif(trim("ID вакансии"), '') is not null
order by nullif(trim("ID вакансии"), ''), trim("Название вакансии");

select count(*) as vac_clean_rows from vac_clean;

-- 3.3.	Профилирование (распределение).
-- 3.3.1. Постройте гистограмму на основе полученных данных о частоте значений без дубликатов.
select specialty, count(*) as freq
from vac_clean
group by specialty
order by freq desc, specialty;

select experience, count(*) as freq
from vac_clean
group by experience
order by freq desc, experience;

-- 3.3.	Постойте гистограмму для визуализации числовых значений
select
  case
    when salary is null then 'не указана'
    when salary < 70000 then '<70k'
    when salary < 100000 then '70-99k'
    when salary < 150000 then '100-149k'
    when salary < 200000 then '150-199k'
    else '200k+'
  end as salary_bin,
  count(*) as freq
from vac_clean
group by salary_bin
order by freq desc, salary_bin;

-- Поиск аналитиков
select title, count(*) as cnt
from vac_clean
where title ilike '%аналитик%'
group by title
order by cnt desc, title;

-- create table vac_variant5 as
-- select *
-- from vac_clean
-- where
--   title ilike '%аналитик данных%'
--   or title ilike '%bi-аналитик%';

create table vac_variant5 as
with filtered as (
    select *
    from vac_clean
    where
        title ilike '%аналитик данных%'
        or title ilike '%bi-аналитик%'
        or title ilike '%bi аналитик%'
),
numbered as (
    select
        *,
        row_number() over (
            partition by
                lower(coalesce(title, '')),
                lower(coalesce(description, '')),
                lower(coalesce(skills, '')),
                coalesce(experience, ''),
                coalesce(specialty, ''),
                coalesce(salary, -1)
            order by vacancy_id
        ) as rn
    from filtered
)
select
    vacancy_id,
    title,
    description,
    skills,
    experience,
    specialty,
    salary
from numbered
where rn = 1;

drop table vac_variant5 cascade;

alter table vac_variant5 add primary key (vacancy_id);

-- представление
create or replace view v_vac_variant5 as
select * from vac_variant5;

select count(*) as vac_variant5_rows from vac_variant5;
select vacancy_id, title, experience, salary from vac_variant5 order by salary desc nulls last limit 20;

-- 3.3 профилирование (распределение): частоты по опыту и по зарплате
select experience, count(*) as cnt
from vac_variant5
group by experience
order by cnt desc, experience;

select
  case
    when salary is null then 'не указана'
    when salary < 70000 then '<70k'
    when salary < 100000 then '70-99k'
    when salary < 150000 then '100-149k'
    when salary < 200000 then '150-199k'
    else '200k+'
  end as salary_bin,
  count(*) as freq
from vac_variant5
group by salary_bin
order by freq desc;

-- 3.3.2 агрегация с подсчётом частоты + внешняя агрегация
-- среднее число вакансий на каждую категорию опыта
select round(avg(cnt), 2) as avg_vacancies_per_experience
from (
  select experience, count(*) as cnt
  from vac_variant5
  group by experience
) t;

-- 3.5.1 Очистка через case (категоризация)
select
  vacancy_id,
  salary,
  case
    when salary is null then 'не указана'
    when salary < 70000 then 'низкая'
    when salary < 150000 then 'средняя'
    else 'высокая'
  end as salary_category
from vac_variant5;

-- 3.5.2 Очистка с помощью флагов (0/1)
select
  vacancy_id,
  title,
  skills,
  salary,
  case when salary is null then 0 else 1 end as has_salary,
  case when coalesce(skills, '') ilike '%sql%' then 1 else 0 end as has_sql_skill,
  case when (coalesce(skills, '') || ' ' || coalesce(description, '')) ilike '%power bi%' then 1 else 0 end as mentions_power_bi,
  case when (coalesce(skills, '') || ' ' || coalesce(description, '')) ilike '%tableau%' then 1 else 0 end as mentions_tableau
from vac_variant5;

-- 3.3.2 агрегация средней зарплаты (по найденным вакансиям)
select round(avg(salary), 2) as avg_salary
from vac_variant5;