-- Создаем новую таблицу для 9 варианта
create table vacations_designers (
    id text primary key,
    name text not null,
    description text,
    skills text,
    name_spec text,
    price bigint,
    experience text
);

select * from vacations_designers;

-- ЗАПРОСЫ К ВАКАНСИЯМ
-- 3.3.	Профилирование (распределение). 
-- 3.3.1.	Выполните профилирование данных (в Excel или программный способ построения данных на основе результата запроса)
-- 3.3.1. Профилирование данных для дизайнеров
with price_bins as (
select 
case 
when price = 0 then '0 (не указана)'
when price between 1 and 30000 then '1-30000'
when price between 30001 and 50000 then '30001-50000'
when price between 50001 and 70000 then '50001-70000'
when price between 70001 and 90000 then '70001-90000'
when price between 90001 and 110000 then '90001-110000'
when price between 110001 and 150000 then '110001-150000'
when price > 150000 then 'более 150000'
end as price_range,
price
from vacations_designers
where price > 0
)
select 
price_range,
count(*) as frequency
from price_bins
group by price_range
order by 
case price_range
when '1-30000' then 1
when '30001-50000' then 2
when '50001-70000' then 3
when '70001-90000' then 4
when '90001-110000' then 5
when '110001-150000' then 6
when 'более 150000' then 7
end;

-- 3.3.2.	Агрегирование с подсчётом частоты
select 
name_spec as specialty,
count(*) as vacancies_count,
round(avg(price)) as avg_salary,
min(price) as min_salary,
max(price) as max_salary
from vacations_designers
group by name_spec
order by vacancies_count desc;


-- 3.4.	Профилирование (качество данных). 
-- 3.4.1.	Поиск дубликатов
select count(*) as duplicate_groups
from (
    select id, count(*) as records
    from vacations_designers
    group by id
) as duplicates
where records > 1;

-- 3.4.2.	Исключение дубликатов с помощью group by и distinct
--	Напишите запрос для нахождения данных без дубликатов с применением distinct
select distinct name, name_spec, price, experience
from vacations_designers
order by name;

--	Напишите запрос для нахождения данных без дубликатов с применением group by
select name, name_spec, price, experience
from vacations_designers
group by name, name_spec, price, experience
order by name;
-- 3.5.	Подготовка данных
-- 3.5.1.	Очистка данных с помощью case
--	Выполните категоризацию данных, добавив поле к исходным данных, содержащее значение категории, например, категоризировать по возрасту можно от 12-16 подросток, от 17 до 24 юноша и т.д.
-- добавляем категорию уровня зарплаты
select 
name,
name_spec,
price,
case 
when price = 0 then 'зарплата не указана'
when price < 30000 then 'низкий уровень'
when price between 30000 and 60000 then 'средний уровень'
when price between 60001 and 90000 then 'выше среднего'
when price > 90000 then 'высокий уровень'
end as salary_category,
experience
from vacations_designers
order by price;

-- 3.5.2.	Очистка с помощью флагов
select 
name,
price,
skills,
case when price > 60000 then 1 else 0 end as flag_high_salary,
case when skills ilike '%figma%' then 1 else 0 end as flag_figma,
case when skills ilike '%photoshop%' then 1 else 0 end as flag_photoshop,
case when skills ilike '%ui%' or skills ilike '%ux%' then 1 else 0 end as flag_ui_ux
from vacations_designers
limit 30;

-- 3.5.3.	Преобразование типов
select 
name,
price,
price::int as price_int,
cast(price as numeric) as price_numeric,
floor(price) as price_floor,
ceil(price) as price_ceil
from vacations_designers
where price > 0
limit 10;

-- 3.5.4.	Работа с null значениями – замените NULL значения на по своему усмотрению
select 
name,
coalesce(price::text, 'не указана') as price,
coalesce(experience, 'опыт не указан') as experience,
coalesce(skills, 'навыки не указаны') as skills
from vacations_designers
limit 20;

-- 3.5.5.	Отсутствующие данные
select 
name,
price,
case 
when price is null or price = 0 then 'зарплата не указана'
else price::text
end as price_filled_constant,
case 
when price is null or price = 0 then 50000
else price
end as price_filled_numeric
from vacations;

-- 3.5.6.	Структурирование данных
select 
name_spec as specialty,
count(*) as vacancies_count,
round(avg(price)) as avg_salary,
percentile_cont(0.5) within group (order by price) as median_salary,
sum(case when skills ilike '%figma%' then 1 else 0 end) as figma_count
from vacations_designers
group by name_spec
order by vacancies_count desc;

-- ЗАПРОСЫ К ОЛИМПИАДАМ
create table results_ze_2025 (
    municipality text primary key,
    english_language real,
    astronomy real,
    biology real,
    geography real,
    computer_science real,
    art real,
    spanish_language real,
    history real,
    italian_language real,
    chinese_language real,
    literature real,
    mathematics real,
    german_language real,
    social_studies real,
    struve_astronomy_olympiad real,
    maxwell_physics_olympiad real,
    euler_mathematics_olympiad real,
    keldysh_computer_science_olympiad real,
    life_safety_basics real,
    law real,
    russian_language real,
    technology real,
    physics real,
    physical_education real,
    french_language real,
    chemistry real,
    ecology real,
    economics real
);

create table results_me_2025 (
    municipality text primary key,
    english_language real,
    astronomy real,
    biology real,
    geography real,
    computer_science real,
    art real,
    spanish_language real,
    history real,
    italian_language real,
    chinese_language real,
    literature real,
    mathematics real,
    german_language real,
    social_studies real,
    life_safety_basics real,
    law real,
    russian_language real,
    technology real,
    physics real,
    physical_education real,
    french_language real,
    chemistry real,
    ecology real,
    economics real
);

create table results_re_2025_chemistry (
    municipality text primary key,
    chemistry real
);

create table results_re_2025 (
    municipality text primary key,
    english_language real,
    astronomy real,
    biology real,
    geography real,
    computer_science real,
    art real,
    spanish_language real,
    history real,
    italian_language real,
    chinese_language real,
    literature real,
    mathematics real,
    german_language real,
    social_studies real,
    struve_astronomy_olympiad real,
    maxwell_physics_olympiad real,
    euler_mathematics_olympiad real,
    keldysh_computer_science_olympiad real,
    life_safety_basics real,
    law real,
    russian_language real,
    technology real,
    physics real,
    physical_education real,
    french_language real,
    ecology real,
    economics real
);

create table results_she_2025 (
    municipality text primary key,
    english_language real,
    astronomy real,
    biology real,
    geography real,
    computer_science real,
    art real,
    spanish_language real,
    history real,
    italian_language real,
    chinese_language real,
    literature real,
    mathematics real,
    german_language real,
    social_studies real,
    life_safety_basics real,
    law real,
    russian_language real,
    technology real,
    physics real,
    physical_education real,
    french_language real,
    chemistry real,
    ecology real,
    economics real
);

-- Создаем общую таблицу со всеми этапами
-- создаем пустую таблицу
create table olympiad_results_2025_all (
    municipality text,
    stage text,
    english_language real,
    astronomy real,
    biology real,
    geography real,
    computer_science real,
    art real,
    spanish_language real,
    history real,
    italian_language real,
    chinese_language real,
    literature real,
    mathematics real,
    german_language real,
    social_studies real,
    life_safety_basics real,
    law real,
    russian_language real,
    technology real,
    physics real,
    physical_education real,
    french_language real,
    chemistry real,
    ecology real,
    economics real,
    struve_astronomy_olympiad real,
    maxwell_physics_olympiad real,
    euler_mathematics_olympiad real,
    keldysh_computer_science_olympiad real
);

--заполняем данными из шэ
insert into olympiad_results_2025_all (
    municipality, stage, english_language, astronomy, biology, geography, 
    computer_science, art, spanish_language, history, italian_language, 
    chinese_language, literature, mathematics, german_language, social_studies,
    life_safety_basics, law, russian_language, technology, physics,
    physical_education, french_language, chemistry, ecology, economics
)
select 
    municipality, 'шэ', english_language, astronomy, biology, geography, 
    computer_science, art, spanish_language, history, italian_language, 
    chinese_language, literature, mathematics, german_language, social_studies,
    life_safety_basics, law, russian_language, technology, physics,
    physical_education, french_language, chemistry, ecology, economics
from results_she_2025;

-- заполняем данными из мэ
insert into olympiad_results_2025_all (
    municipality, stage, english_language, astronomy, biology, geography, 
    computer_science, art, spanish_language, history, italian_language, 
    chinese_language, literature, mathematics, german_language, social_studies,
    life_safety_basics, law, russian_language, technology, physics,
    physical_education, french_language, chemistry, ecology, economics
)
select 
    municipality, 'мэ', english_language, astronomy, biology, geography, 
    computer_science, art, spanish_language, history, italian_language, 
    chinese_language, literature, mathematics, german_language, social_studies,
    life_safety_basics, law, russian_language, technology, physics,
    physical_education, french_language, chemistry, ecology, economics
from results_me_2025;

-- заполняем данными из рэ
insert into olympiad_results_2025_all (
    municipality, stage, english_language, astronomy, biology, geography, 
    computer_science, art, spanish_language, history, italian_language, 
    chinese_language, literature, mathematics, german_language, social_studies,
    life_safety_basics, law, russian_language, technology, physics,
    physical_education, french_language, ecology, economics,
    struve_astronomy_olympiad, maxwell_physics_olympiad, 
    euler_mathematics_olympiad, keldysh_computer_science_olympiad
)
select 
    municipality, 'рэ', english_language, astronomy, biology, geography, 
    computer_science, art, spanish_language, history, italian_language, 
    chinese_language, literature, mathematics, german_language, social_studies,
    life_safety_basics, law, russian_language, technology, physics,
    physical_education, french_language, ecology, economics,
    struve_astronomy_olympiad, maxwell_physics_olympiad, 
    euler_mathematics_olympiad, keldysh_computer_science_olympiad
from results_re_2025;

-- заполняем данными из рэ_химия
insert into olympiad_results_2025_all (municipality, stage, chemistry)
select municipality, 'рэ_химия', chemistry
from results_re_2025_chemistry;

-- заполняем данными из зэ
insert into olympiad_results_2025_all (
    municipality, stage, english_language, astronomy, biology, geography, 
    computer_science, art, spanish_language, history, italian_language, 
    chinese_language, literature, mathematics, german_language, social_studies,
    life_safety_basics, law, russian_language, technology, physics,
    physical_education, french_language, chemistry, ecology, economics,
    struve_astronomy_olympiad, maxwell_physics_olympiad, 
    euler_mathematics_olympiad, keldysh_computer_science_olympiad
)
select 
    municipality, 'зэ', english_language, astronomy, biology, geography, 
    computer_science, art, spanish_language, history, italian_language, 
    chinese_language, literature, mathematics, german_language, social_studies,
    life_safety_basics, law, russian_language, technology, physics,
    physical_education, french_language, chemistry, ecology, economics,
    struve_astronomy_olympiad, maxwell_physics_olympiad, 
    euler_mathematics_olympiad, keldysh_computer_science_olympiad
from results_ze_2025;

-- проверка результата
select * from olympiad_results_2025_all;

-- 3.3. профилирование (распределение). 
-- 3.3.1. выполните профилирование данных (в excel или программный способ построения данных на основе результата запроса)
-- получаем все значения по математике
select 
    mathematics,
    count(*) as frequency
from olympiad_results_2025_all
where mathematics is not null
group by mathematics
order by mathematics;

-- 3.4. профилирование (качество данных). 
--3.4.1. поиск дубликатов
select count(*)
from (
    select 
        municipality,
        stage,
        count(*) as records
    from olympiad_results_2025_all
    group by municipality, stage
) as duplicates
where records > 1;

-- 3.4.2. исключение дубликатов с помощью group by и distinct
-- напишите запрос для нахождения данных без дубликатов с применением distinct
select distinct 
    municipality,
    stage,
    mathematics,
    physics,
    chemistry,
    biology,
    computer_science,
    russian_language
from olympiad_results_2025_all
order by municipality, stage;

-- напишите запрос для нахождения данных без дубликатов с применением group by
select 
    municipality,
    stage,
    mathematics,
    physics,
    chemistry,
    biology,
    computer_science,
    russian_language
from olympiad_results_2025_all
group by municipality, stage, mathematics, physics, chemistry, biology, computer_science, russian_language
order by municipality, stage;

-- 3.5. подготовка данных
-- 3.5.1. очистка данных с помощью case
-- выполните категоризацию данных, добавив поле к исходным данных, содержащее значение категории
-- категоризация по уровню баллов по математике
select 
    municipality,
    stage,
    mathematics,
    case 
        when mathematics >= 80 then 'Высокий уровень (80-100)'
        when mathematics between 60 and 79 then 'Хороший уровень (60-79)'
        when mathematics between 40 and 59 then 'Средний уровень (40-59)'
        when mathematics between 1 and 39 then 'Низкий уровень (1-39)'
        when mathematics = 0 then 'Нет участников'
        else 'Нет данных'
    end as math_level
from olympiad_results_2025_all
order by mathematics desc nulls last;

-- 3.5.2. очистка с помощью флагов
-- создайте флаги, указывающие на равенство определённому значению
-- добавьте более сложное условие для создания флагов
-- простые флаги (участие/неучастие)
select 
    municipality,
    stage,
    mathematics,
    case when mathematics > 0 then 1 else 0 end as flag_math_participants,
    physics,
    case when physics > 0 then 1 else 0 end as flag_physics_participants,
    chemistry,
    case when chemistry > 0 then 1 else 0 end as flag_chemistry_participants
from olympiad_results_2025_all
limit 20;

-- 3.5.3. преобразование типов
-- примените функции преобразования типа данных для значения количества
-- почитайте документацию о возможных вариантах преобразования данных
select 
    municipality,
    stage,
    mathematics,
    -- преобразования в integer
    mathematics::int as math_integer,
    cast(mathematics as int) as math_cast,
    floor(mathematics) as math_floor,
    ceil(mathematics) as math_ceil,
    round(mathematics) as math_rounded,
    -- преобразование в текст
    mathematics::text as math_text,
    cast(mathematics as text) as math_text_cast,
    -- преобразование с форматированием
    to_char(coalesce(mathematics, 0), '999.99') as math_formatted,
    -- преобразование null в текст
    coalesce(mathematics::text, 'нет данных') as math_with_label
from olympiad_results_2025_all
where mathematics is not null
limit 20;

-- 3.5.4. работа с null значениями – замените null значения на по своему усмотрению
-- coalesce - замена null на значение по умолчанию
select 
    municipality,
    stage,
    coalesce(mathematics, 0) as mathematics,
    coalesce(physics, 0) as physics,
    coalesce(chemistry, 0) as chemistry,
    coalesce(computer_science, 0) as computer_science
from olympiad_results_2025_all
limit 30;

-- 3.5.5. отсутствующие данные
-- отсутствующие данные могут помочь выявить недостатки в процессе сбора данных
-- распространённый способ восстановления данных – заполнение данных постоянным значением
-- либо заполнение значением с применением математических функций или оператора case
-- заполнение средним значением
select 
    municipality,
    stage,
    mathematics,
    case 
        when mathematics is null then (select avg(mathematics) from olympiad_results_2025_all)
        else mathematics
    end as math_filled
from olympiad_results_2025_all
limit 30;