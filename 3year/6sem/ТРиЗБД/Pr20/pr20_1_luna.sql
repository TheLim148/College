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

select count(*) as vac_stage_rows from vac_stage;
select * from vac_stage limit 5;

-- 3.4.	Профилирование (качество данных).
-- 3.4.1. Поиск дубликатов
select "ID вакансии", count(*) as cnt
from vac_stage
group by "ID вакансии"
having count(*) > 1
order by cnt desc, "ID вакансии";

-- 3.4.2. Исключение дубликатов с помощью group by и distinct
-- покажем, что distinct действительно уменьшает количество строк.
select count(*) as stage_total from vac_stage;

select count(*) as stage_distinct
from (
  select distinct
    "ID вакансии",
    "Название вакансии",
    "Описание вакансии",
    "Ключевые навыки",
    "Опыт работы",
    "Название специальности",
    "Заработная плата"
  from vac_stage
) t;

-- 3.5.	Подготовка данных
-- 3.5.3. Преобразование типов
-- делаем "чистую" таблицу с нормальными именами столбцов и salary в int (где это возможно).
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

insert into vac_clean (vacancy_id, title, description, skills, specialty, salary, experience)
select distinct on (nullif(trim("ID вакансии"), ''))
  nullif(trim("ID вакансии"), '') as vacancy_id,
  nullif(trim("Название вакансии"), '') as title,
  nullif(trim("Описание вакансии"), '') as description,
  nullif(trim("Ключевые навыки"), '') as skills,
  nullif(trim("Название специальности"), '') as specialty,
  nullif(
    case
      when "Заработная плата" is null then null
      when trim("Заработная плата") = '' then null
      when trim("Заработная плата") = '0' then null
      when trim("Заработная плата") ~ '^[0-9]+$' then trim("Заработная плата")::int
      when trim("Заработная плата") ~ '^[0-9]+([.,][0-9]+)?$' then replace(trim("Заработная плата"), ',', '.')::numeric::int
      when trim("Заработная плата") ~ '^[0-9]+\s*-\s*[0-9]+$' then
        round((
          split_part(replace(trim("Заработная плата"), ' ', ''), '-', 1)::numeric +
          split_part(replace(trim("Заработная плата"), ' ', ''), '-', 2)::numeric
        ) / 2.0)::int
      else null
    end,
    0
  ) as salary,
  nullif(trim("Опыт работы"), '') as experience
from vac_stage
where nullif(trim("ID вакансии"), '') is not null
order by nullif(trim("ID вакансии"), ''), trim("Название вакансии");

select count(*) as vac_clean_rows from vac_clean;
select * from vac_clean limit 5;

-- 3.3.	Профилирование (распределение).
-- 3.3.1. Постройте гистограмму на основе полученных данных о частоте значений без дубликатов.
select experience, count(*) as freq
from vac_clean
group by experience
order by freq desc, experience;

-- 3.3.	Постойте гистограмму для визуализации числовых значений
select
  case
    when salary is null then 'не указана'
    when salary < 30000 then '<30k'
    when salary < 50000 then '30-49k'
    when salary < 80000 then '50-79k'
    when salary < 120000 then '80-119k'
    else '120k+'
  end as salary_bin,
  count(*) as freq
from vac_clean
group by salary_bin
order by freq desc, salary_bin;

-- 3.3.2.	Агрегирование с подсчётом частоты
-- пример агрегирования: среднее количество вакансий на категорию опыта.
select round(avg(cnt), 2) as avg_vacancies_per_experience
from (
  select experience, count(*) as cnt
  from vac_clean
  group by experience
) t;

-- 3.5.1.	Очистка данных с помощью case
-- пример: перевод зарплаты в категорию (удобно для отчётности).
select
  vacancy_id,
  salary,
  case
    when salary is null then 'не указана'
    when salary < 50000 then 'ниже рынка'
    when salary < 90000 then 'средняя'
    else 'высокая'
  end as salary_category
from vac_clean
limit 5;

-- 3.5.2. Очистка с помощью флагов
-- флаги позволяют быстро отбирать/проверять подмножества строк (например, вакансии со "SQL" в навыках).
select
  vacancy_id,
  title,
  case when salary is null then 0 else 1 end as has_salary,
  case when coalesce(skills, '') ilike '%sql%' then 1 else 0 end as has_sql_skill
from vac_clean
limit 5;

-- 3.5.4. Работа с null значениями – замените NULL значения на по своему усмотрению
-- 3.5.4. coalesce
select vacancy_id, coalesce(skills, 'не указано') as skills_filled
from vac_clean
limit 50;

-- 3.5.4. nullif
select vacancy_id, nullif(trim(skills), '') as skills_nullif
from vac_clean
limit 50;

-- 3.5.5. Отсутствующие данные
select
  count(*) filter (where salary is null) as salary_missing,
  count(*) as total
from vac_clean;

-- 3.5.6. Структурирование данных
select
  experience,
  count(*) as vacancies,
  round(avg(salary), 2) as avg_salary
from vac_clean
group by experience
order by vacancies desc, experience;


drop table if exists vac_teacher cascade;
create table vac_teacher as
with filtered as (
    select *
    from vac_clean
    where
      title ilike '%учител%'
      or title ilike '%преподав%'
      or title ilike '%педагог%'
      or title ~* '(^|[^а-яё])(учитель|преподаватель|педагог)([^а-яё]|$)'
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

alter table vac_teacher add primary key (vacancy_id);

create or replace view v_vac_teacher as
select * from vac_teacher;

select count(*) as vac_teacher_rows from vac_teacher;

select vacancy_id, title, experience, salary
from vac_teacher
order by salary desc nulls last, title;