-- 3.1.1 создание "грязной" таблицы для олимпиад
create table olymp_re_stage (
  "муниципалитет" text,
  "английский язык_рэ_2025" text,
  "астрономия_рэ_2025" text,
  "биология_рэ_2025" text,
  "география_рэ_2025" text,
  "информатика_рэ_2025" text,
  "искусство_рэ_2025" text,
  "испанский язык_рэ_2025" text,
  "история_рэ_2025" text,
  "итальянский язык_рэ_2025" text,
  "китайский язык_рэ_2025" text,
  "литература_рэ_2025" text,
  "математика_рэ_2025" text,
  "немецкий язык_рэ_2025" text,
  "обществознание_рэ_2025" text,
  "астр_рэ_2025 им. струве" text,
  "физ_рэ_2025 им. дж.к. максвелла" text,
  "мат_рэ_2025 им. л.эйлера" text,
  "инф_рэ_2025 им. м. келдыша" text,
  "обж_рэ_2025" text,
  "право_рэ_2025" text,
  "русский язык_рэ_2025" text,
  "технология_рэ_2025" text,
  "физика_рэ_2025" text,
  "физическая культура_рэ_2025" text,
  "французский язык_рэ_2025" text,
  "экология_рэ_2025" text,
  "экономика_рэ_2025" text
);

-- 3.1.2 проверка импорта олимпиад
select count(*) from olymp_re_stage;
select * from olymp_re_stage limit 5;

-- 3.4.1 профилирование качества (олимпиады): поиск "грязных" муниципалитетов (двойные пробелы)
select "муниципалитет"
from olymp_re_stage
where "муниципалитет" like '%  %';

-- 3.5.5 отсутствующие данные / очистка: нормализация пробелов в муниципалитете
update olymp_re_stage
set "муниципалитет" = regexp_replace("муниципалитет", '\s+', ' ', 'g');

-- 3.3.1 профилирование распределения (олимпиады): частоты значений (пример по математике)
select "математика_рэ_2025" as val, count(*) as freq
from olymp_re_stage
group by "математика_рэ_2025"
order by freq desc, val;

-- 3.5.3 преобразование типов (0.0 -> 0): создание "чистой" таблицы олимпиад
create table olymp_re_clean (
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
  struvelymp_astronomy int,
  maxwellolymp_physics int,
  eulerolymp_math int,
  keldysholymp_informatics int,
  obzh int,
  law int,
  russian int,
  technology int,
  physics int,
  pe int,
  french int,
  ecology int,
  economics int
);

-- 3.5.4 работа с null значениями (coalesce) + 3.5.3 преобразование типов:
-- в исходном csv встречаются пустоты (null), поэтому при переливке превращаем их в 0
insert into olymp_re_clean
select
  "муниципалитет",
  coalesce(nullif("английский язык_рэ_2025", ''), '0')::numeric::int,
  coalesce(nullif("астрономия_рэ_2025", ''), '0')::numeric::int,
  coalesce(nullif("биология_рэ_2025", ''), '0')::numeric::int,
  coalesce(nullif("география_рэ_2025", ''), '0')::numeric::int,
  coalesce(nullif("информатика_рэ_2025", ''), '0')::numeric::int,
  coalesce(nullif("искусство_рэ_2025", ''), '0')::numeric::int,
  coalesce(nullif("испанский язык_рэ_2025", ''), '0')::numeric::int,
  coalesce(nullif("история_рэ_2025", ''), '0')::numeric::int,
  coalesce(nullif("итальянский язык_рэ_2025", ''), '0')::numeric::int,
  coalesce(nullif("китайский язык_рэ_2025", ''), '0')::numeric::int,
  coalesce(nullif("литература_рэ_2025", ''), '0')::numeric::int,
  coalesce(nullif("математика_рэ_2025", ''), '0')::numeric::int,
  coalesce(nullif("немецкий язык_рэ_2025", ''), '0')::numeric::int,
  coalesce(nullif("обществознание_рэ_2025", ''), '0')::numeric::int,
  coalesce(nullif("астр_рэ_2025 им. струве", ''), '0')::numeric::int,
  coalesce(nullif("физ_рэ_2025 им. дж.к. максвелла", ''), '0')::numeric::int,
  coalesce(nullif("мат_рэ_2025 им. л.эйлера", ''), '0')::numeric::int,
  coalesce(nullif("инф_рэ_2025 им. м. келдыша", ''), '0')::numeric::int,
  coalesce(nullif("обж_рэ_2025", ''), '0')::numeric::int,
  coalesce(nullif("право_рэ_2025", ''), '0')::numeric::int,
  coalesce(nullif("русский язык_рэ_2025", ''), '0')::numeric::int,
  coalesce(nullif("технология_рэ_2025", ''), '0')::numeric::int,
  coalesce(nullif("физика_рэ_2025", ''), '0')::numeric::int,
  coalesce(nullif("физическая культура_рэ_2025", ''), '0')::numeric::int,
  coalesce(nullif("французский язык_рэ_2025", ''), '0')::numeric::int,
  coalesce(nullif("экология_рэ_2025", ''), '0')::numeric::int,
  coalesce(nullif("экономика_рэ_2025", ''), '0')::numeric::int
from olymp_re_stage;

select * from olymp_re_clean limit 5;

-- 3.1.1 создание "грязной" таблицы для импорта
create table vac_stage (
  "ID вакансии" text,
  "Название вакансии" text,
  "Описание вакансии" text,
  "Ключевые навыки" text,
  "Название специальности" text,
  "Заработная плата" text,
  "Опыт работы" text
);

-- 3.1.2 проверка успешности импорта
select count(*) from vac_stage;
select * from vac_stage limit 5;


-- 3.3.1 профилирование (распределение)
-- частоты значений без дубликатов (данные для гистограмм)

-- частоты по специальности
select "Название специальности", count(*) as cnt
from vac_stage
group by "Название специальности"
order by cnt desc;

-- частоты по опыту работы
select "Опыт работы", count(*) as cnt
from vac_stage
group by "Опыт работы"
order by cnt desc;

-- частоты по зарплате
select "Заработная плата", count(*) as freq
from vac_stage
group by "Заработная плата"
order by freq desc;


-- 3.4.1 профилирование качества данных: поиск дубликатов
-- с применением группировки и упорядочивания

-- дубликаты по id вакансии
select "ID вакансии", count(*)
from vac_stage
group by "ID вакансии"
having count(*) > 1
order by count(*) desc;

-- "смысловые" дубликаты: название + фрагмент описания
select
  "Название вакансии",
  left("Описание вакансии", 120) as descr_preview,
  count(*)
from vac_stage
group by "Название вакансии", left("Описание вакансии", 120)
having count(*) > 1
order by count(*) desc;


-- 3.4.2 исключение дубликатов: без дубликатов через distinct

select distinct
  "ID вакансии",
  "Название вакансии",
  "Описание вакансии",
  "Ключевые навыки",
  "Название специальности",
  "Заработная плата",
  "Опыт работы"
from vac_stage
limit 10;


-- 3.4.2 исключение дубликатов: без дубликатов через group by

select
  "ID вакансии",
  "Название вакансии",
  "Описание вакансии",
  "Ключевые навыки",
  "Название специальности",
  "Заработная плата",
  "Опыт работы"
from vac_stage
group by
  "ID вакансии",
  "Название вакансии",
  "Описание вакансии",
  "Ключевые навыки",
  "Название специальности",
  "Заработная плата",
  "Опыт работы"
limit 10;


-- 3.5.4 работа с null значениями: замена null на значение

-- сколько null в ключевых навыках
select count(*) as null_skills
from vac_stage
where "Ключевые навыки" is null;

-- замена null на константу
update vac_stage
set "Ключевые навыки" = 'не указано'
where "Ключевые навыки" is null;


-- 3.5.3 преобразование типов + 3.5.5 отсутствующие данные
-- "0" по зарплате интерпретируем как отсутствие данных -> null

create table vac_clean (
  vacancy_id text primary key,
  title text,
  description text,
  skills text,
  specialty text,
  salary int,
  experience text
);

insert into vac_clean
select
  "ID вакансии",
  "Название вакансии",
  "Описание вакансии",
  "Ключевые навыки",
  "Название специальности",
  nullif("Заработная плата", '0')::int,
  "Опыт работы"
from vac_stage;

select count(*) from vac_clean;
select * from vac_clean limit 5;


-- 3.3.1 гистограмма для числовых значений

select
  case
    when salary is null then 'null (не указана)'
    when salary < 70000 then '<70k'
    when salary < 100000 then '70-99k'
    when salary < 150000 then '100-149k'
    when salary < 200000 then '150-199k'
    else '200k+'
  end as bin,
  count(*) as freq
from vac_clean
group by bin
order by freq desc;


-- 3.5.1 очистка данных с помощью case: категоризация

-- категоризация зарплаты
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

-- категоризация опыта работы
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


-- 3.5.2 очистка с помощью флагов (0/1)

-- флаг: указана ли зарплата
select *,
case when salary is null then 0 else 1 end as has_salary
from vac_clean
limit 10;

-- флаг: встречается ли sql в навыках
select *,
case when skills ilike '%sql%' then 1 else 0 end as has_sql
from vac_clean
limit 10;

-- 3.5.2 более сложный флаг (числовое условие): зарплата >= 100000
select *,
case when salary is not null and salary >= 100000 then 1 else 0 end as salary_ge_100k
from vac_clean
limit 10;


-- 3.5.4 работа с null значениями: coalesce

select
  vacancy_id,
  coalesce(salary, 0) as salary_filled
from vac_clean;


-- 3.3.2 агрегирование с подсчётом частоты

-- количество вакансий по специальности
select specialty, count(*) as cnt
from vac_clean
group by specialty
order by cnt desc;

-- внешняя агрегация: среднее число записей по группам specialy
-- при одной специальности результат будет равен общему числу строк (демонстрация приёма)
select round(avg(cnt), 2) as avg_vacancies_per_specialty
from (
  select specialty, count(*) as cnt
  from vac_clean
  group by specialty
);

-- внешняя агрегация: среднее число вакансий на категорию опыта
select round(avg(cnt), 2) as avg_vacancies_per_experience
from (
  select experience, count(*) as cnt
  from vac_clean
  group by experience
);


-- 3.5.6 структурирование данных (агрегация)
-- "выравнивание": сводим много строк к 1 строке на сущность (например, на специальность)

select
  specialty,
  count(*) as total_vacancies,
  round(avg(salary), 2) as avg_salary
from vac_clean
group by specialty
order by avg_salary desc nulls last;