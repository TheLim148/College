-- 3.1.1 Создание "грязной" таблицы для олимпиад
create table olymp_stage (
  "Муниципалитет" text,
  "Английский язык_ШЭ_2025" text,
  "Астрономия_ШЭ_2025" text,
  "Биология_ШЭ_2025" text,
  "География_ШЭ_2025" text,
  "Информатика_ШЭ_2025" text,
  "Искусство_ШЭ_2025" text,
  "Испанский язык_ШЭ_2025" text,
  "История_ШЭ_2025" text,
  "Итальянский язык_ШЭ_2025" text,
  "Китайский язык_ШЭ_2025" text,
  "Литература_ШЭ_2025" text,
  "Математика_ШЭ_2025" text,
  "Немецкий язык_ШЭ_2025" text,
  "Обществознание_ШЭ_2025" text,
  "ОБЖ_ШЭ_2025" text,
  "Право_ШЭ_2025" text,
  "Русский язык_ШЭ_2025" text,
  "Технология_ШЭ_2025" text,
  "Физика_ШЭ_2025" text,
  "Физическая культура_ШЭ_2025" text,
  "Французский язык_ШЭ_2025" text,
  "Химия_ШЭ_2025" text,
  "Экология_ШЭ_2025" text,
  "Экономика_ШЭ_2025" text
);

-- Проверка корректности импорта
select count(*) from olymp_stage;
select * from olymp_stage limit 5;

-- 3.4. Профилирование (качество данных). Поиск двойных пробелов
select "Муниципалитет"
from olymp_stage
where "Муниципалитет" like '%  %';

-- Замена двойных пробелов на одинарные. Очистка значений
update olymp_stage
set "Муниципалитет" = regexp_replace("Муниципалитет", '\s+', ' ', 'g');

-- 3.3.1. Частоты значений
select "Математика_ШЭ_2025" as val, count(*) as freq
from olymp_stage
group by "Математика_ШЭ_2025"
order by freq desc, val;

-- Создание "чистой" таблицы
create table olymp_clean (
  municipality text primary key,
  english int,
  astronomy int,
  biology int,
  geography int,
  informatics int,
  art int,
  spanish int,
  history int,
  italian int,
  chinese int,
  literature int,
  math int,
  german int,
  social_science int,
  obzh int,
  law int,
  russian int,
  technology int,
  physics int,
  pe int,
  french int,
  chemistry int,
  ecology int,
  economics int
);

-- 3.5.3. Преобразование типов (0.0 -> 0)
insert into olymp_clean
select
  "Муниципалитет",
  "Английский язык_ШЭ_2025"::numeric::int,
  "Астрономия_ШЭ_2025"::numeric::int,
  "Биология_ШЭ_2025"::numeric::int,
  "География_ШЭ_2025"::numeric::int,
  "Информатика_ШЭ_2025"::numeric::int,
  "Искусство_ШЭ_2025"::numeric::int,
  "Испанский язык_ШЭ_2025"::numeric::int,
  "История_ШЭ_2025"::numeric::int,
  "Итальянский язык_ШЭ_2025"::numeric::int,
  "Китайский язык_ШЭ_2025"::numeric::int,
  "Литература_ШЭ_2025"::numeric::int,
  "Математика_ШЭ_2025"::numeric::int,
  "Немецкий язык_ШЭ_2025"::numeric::int,
  "Обществознание_ШЭ_2025"::numeric::int,
  "ОБЖ_ШЭ_2025"::numeric::int,
  "Право_ШЭ_2025"::numeric::int,
  "Русский язык_ШЭ_2025"::numeric::int,
  "Технология_ШЭ_2025"::numeric::int,
  "Физика_ШЭ_2025"::numeric::int,
  "Физическая культура_ШЭ_2025"::numeric::int,
  "Французский язык_ШЭ_2025"::numeric::int,
  "Химия_ШЭ_2025"::numeric::int,
  "Экология_ШЭ_2025"::numeric::int,
  "Экономика_ШЭ_2025"::numeric::int
from olymp_stage;

select * from olymp_clean;

-- Создание таблицы для выгрузки вакансий
create table vac_stage (
  "ID вакансии" text,
  "Название вакансии" text,
  "Описание вакансии" text,
  "Ключевые навыки" text,
  "Опыт работы" text,
  "Название специальности" text,
  "Заработная плата" text
);

-- Проверка корректности импорта
select count(*) from vac_stage;
select * from vac_stage limit 5;

-- 3.4.1. Поиск дубликатов
select "ID вакансии", count(*)
from vac_stage
group by "ID вакансии"
having count(*) > 1;

-- 3.4.2. Исключение дубликатов (distinct)245e1-rw.db.pub.dbaas.postgrespro.ru
select distinct
  "ID вакансии", "Название вакансии", "Описание вакансии",
  "Ключевые навыки", "Опыт работы", "Название специальности", "Заработная плата"
from vac_stage;

-- 3.4.2. Исключение дубликатов (group by)
select
  "ID вакансии", "Название вакансии", "Описание вакансии",
  "Ключевые навыки", "Опыт работы", "Название специальности", "Заработная плата"
from vac_stage
group by
  "ID вакансии", "Название вакансии", "Описание вакансии",
  "Ключевые навыки", "Опыт работы", "Название специальности", "Заработная плата";

-- 3.3.1. Частоты по специальности, опыту и зарплате
select "Название специальности", count(*) as cnt
from vac_stage
group by "Название специальности"
order by cnt desc;

select "Опыт работы", count(*) as cnt
from vac_stage
group by "Опыт работы"
order by cnt desc;

select "Заработная плата", count(*) as freq
from vac_stage
group by "Заработная плата"
order by freq desc;


select "Название вакансии", left("Описание вакансии", 120) as descr_preview, count(*)
from vac_stage
group by "Название вакансии", left("Описание вакансии", 120)
having count(*) > 1
order by count(*) desc;

-- 3.5.4. Работа с Null значениями. Поиск и замена на 'Не указано'
select count(*) as null_skills
from vac_stage
where "Ключевые навыки" is null;

update vac_stage
set "Ключевые навыки" = 'Не указано'
where "Ключевые навыки" is null;

-- 3.5.3 Преобразование типов
create table vac_clean (
  vacancy_id text primary key,
  title text,
  description text,
  skills text,
  experience text,
  specialty text,
  salary int
);

-- 3.5.5. Отсутствующие данные (0 -> null для зарплаты)
insert into vac_clean
select
  "ID вакансии",
  "Название вакансии",
  "Описание вакансии",
  "Ключевые навыки",
  "Опыт работы",
  "Название специальности",
  nullif("Заработная плата", '0')::int
from vac_stage;

-- 3.5.1 Очистка данных с помощью case
-- Категоризация заработной платы
select
  vacancy_id,
  salary,
  case
    when salary is null then 'не указана'
    when salary < 70000 then 'низкая'
    when salary < 150000 then 'средняя'
    else 'высокая'
  end as salary_category
from vac_clean;

-- Категоризация опыта работы
select
  vacancy_id,
  experience,
  case
    when experience = '0' then 'без опыта'
    when experience = '1-3' then '1-3 года'
    when experience = '3-6' then '3-6 лет'
    when experience = '6-' then '6+ лет'
    else 'неизвестно'
  end as exp_category
from vac_clean;

-- 3.3.1. Гистограмма числовых значений
-- Распределение заработной платы по диапазонам
select
  case
    when salary is null then 'null (не указана)'
    when salary < 70000 then '<70k'
    when salary < 100000 then '70–99k'
    when salary < 150000 then '100–149k'
    when salary < 200000 then '150–199k'
    else '200k+'
  end as bin,
  count(*) as freq
from vac_clean
group by bin
order by freq desc;

-- 3.5.2. Очистка с помощью флагов
-- Признак наличия зарплаты
select *,
case when salary is null then 0 else 1 end as has_salary
from vac_clean;

-- Признак наличия навыка sql
select *,
case when skills ilike '%sql%' then 1 else 0 end as has_sql
from vac_clean;

-- 3.3.2. Агрегирование с подсчётом частоты
-- Количество вакансий по специальности
select specialty, count(*) as cnt
from vac_clean
group by specialty
order by cnt desc;

-- 3.3.2. Внешняя агрегация
-- Среднее число вакансий на специальност
select round(avg(cnt), 2)
from (
  select specialty, count(*) as cnt
  from vac_clean
  group by specialty
) t;

-- 3.5.6. Структурирование данных
-- Агрегация средней заработной платы на специальность
select specialty, round(avg(salary), 2) as avg_salary
from vac_clean
group by specialty
order by avg_salary desc nulls last;