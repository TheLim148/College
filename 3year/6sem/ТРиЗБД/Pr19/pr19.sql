create or replace function nvl(value double precision, fallback double precision)
returns double precision
language sql
immutable
as $$
    select coalesce(value, fallback);
$$;

-- 3.2.1 сырые таблицы для импорта csv за 2025 год

drop table if exists olympiad_school_2025_raw;
create table olympiad_school_2025_raw (
    municipality text,
    eng double precision,
    astr double precision,
    bio double precision,
    geo double precision,
    cs double precision,
    art double precision,
    span double precision,
    hist double precision,
    ital double precision,
    chin double precision,
    lit double precision,
    math double precision,
    germ double precision,
    soc double precision,
    life double precision,
    law double precision,
    rus double precision,
    tech double precision,
    phys double precision,
    pe double precision,
    french double precision,
    chem double precision,
    eco double precision,
    econ double precision
);

drop table if exists olympiad_municipal_2025_raw;
create table olympiad_municipal_2025_raw (
    municipality text,
    eng double precision,
    astr double precision,
    bio double precision,
    geo double precision,
    cs double precision,
    art double precision,
    span double precision,
    hist double precision,
    ital double precision,
    chin double precision,
    lit double precision,
    math double precision,
    germ double precision,
    soc double precision,
    life double precision,
    law double precision,
    rus double precision,
    tech double precision,
    phys double precision,
    pe double precision,
    french double precision,
    chem double precision,
    eco double precision,
    econ double precision
);

drop table if exists olympiad_regional_2025_raw;
create table olympiad_regional_2025_raw (
    municipality text,
    eng double precision,
    astr double precision,
    bio double precision,
    geo double precision,
    cs double precision,
    art double precision,
    span double precision,
    hist double precision,
    ital double precision,
    chin double precision,
    lit double precision,
    math double precision,
    germ double precision,
    soc double precision,
    struve double precision,
    maxwell double precision,
    euler double precision,
    keldysh double precision,
    life double precision,
    law double precision,
    rus double precision,
    tech double precision,
    phys double precision,
    pe double precision,
    french double precision,
    eco double precision,
    econ double precision
);

drop table if exists olympiad_final_2025_raw;
create table olympiad_final_2025_raw (
    municipality text,
    eng double precision,
    astr double precision,
    bio double precision,
    geo double precision,
    cs double precision,
    art double precision,
    span double precision,
    hist double precision,
    ital double precision,
    chin double precision,
    lit double precision,
    math double precision,
    germ double precision,
    soc double precision,
    struve double precision,
    maxwell double precision,
    euler double precision,
    keldysh double precision,
    life double precision,
    law double precision,
    rus double precision,
    tech double precision,
    phys double precision,
    pe double precision,
    french double precision,
    chem double precision,
    eco double precision,
    econ double precision
);

drop table if exists olympiad_results_2025_raw;
create table olympiad_results_2025_raw (
    municipality text,
    chem double precision
);

-- 3.2.3 очистка данных и загрузка в чистые таблицы
create table olympiad_school_2025 (
    municipality varchar(19) not null,
    english_language int default 0,
    astronomy int default 0,
    biology int default 0,
    geography int default 0,
    computer_science int default 0,
    art int default 0,
    spanish_language int default 0,
    history int default 0,
    italian_language int default 0,
    chinese_language int default 0,
    literature int default 0,
    mathematics int default 0,
    german_language int default 0,
    social_studies int default 0,
    life_safety int default 0,
    law int default 0,
    russian_language int default 0,
    technology int default 0,
    physics int default 0,
    physical_education int default 0,
    french_language int default 0,
    chemistry int default 0,
    ecology int default 0,
    economics int default 0,
    primary key (municipality)
);

insert into olympiad_school_2025 (
    municipality,
    english_language,
    astronomy,
    biology,
    geography,
    computer_science,
    art,
    spanish_language,
    history,
    italian_language,
    chinese_language,
    literature,
    mathematics,
    german_language,
    social_studies,
    life_safety,
    law,
    russian_language,
    technology,
    physics,
    physical_education,
    french_language,
    chemistry,
    ecology,
    economics
)
select
    left(regexp_replace(trim(municipality), '\s+', ' ', 'g'), 19) as municipality,
    round(coalesce(eng, 0))::int,
    round(coalesce(astr, 0))::int,
    round(coalesce(bio, 0))::int,
    round(coalesce(geo, 0))::int,
    round(coalesce(cs, 0))::int,
    round(coalesce(art, 0))::int,
    round(coalesce(span, 0))::int,
    round(coalesce(hist, 0))::int,
    round(coalesce(ital, 0))::int,
    round(coalesce(chin, 0))::int,
    round(coalesce(lit, 0))::int,
    round(coalesce(math, 0))::int,
    round(coalesce(germ, 0))::int,
    round(coalesce(soc, 0))::int,
    round(coalesce(life, 0))::int,
    round(coalesce(law, 0))::int,
    round(coalesce(rus, 0))::int,
    round(coalesce(tech, 0))::int,
    round(coalesce(phys, 0))::int,
    round(coalesce(pe, 0))::int,
    round(coalesce(french, 0))::int,
    round(coalesce(chem, 0))::int,
    round(coalesce(eco, 0))::int,
    round(coalesce(econ, 0))::int
from olympiad_school_2025_raw; -- INSERT - ШКОЛЬНЫЙ ЭТАП - 2025 - ЧИСТАЯ ТАБЛИЦА


create table olympiad_municipal_2025 (
    municipality varchar(19) not null,
    english_language int default 0,
    astronomy int default 0,
    biology int default 0,
    geography int default 0,
    computer_science int default 0,
    art int default 0,
    spanish_language int default 0,
    history int default 0,
    italian_language int default 0,
    chinese_language int default 0,
    literature int default 0,
    mathematics int default 0,
    german_language int default 0,
    social_studies int default 0,
    life_safety int default 0,
    law int default 0,
    russian_language int default 0,
    technology int default 0,
    physics int default 0,
    physical_education int default 0,
    french_language int default 0,
    chemistry int default 0,
    ecology int default 0,
    economics int default 0,
    primary key (municipality)
);

insert into olympiad_municipal_2025 (
    municipality,
    english_language,
    astronomy,
    biology,
    geography,
    computer_science,
    art,
    spanish_language,
    history,
    italian_language,
    chinese_language,
    literature,
    mathematics,
    german_language,
    social_studies,
    life_safety,
    law,
    russian_language,
    technology,
    physics,
    physical_education,
    french_language,
    chemistry,
    ecology,
    economics
)
select
    left(regexp_replace(trim(municipality), '\s+', ' ', 'g'), 19) as municipality,
    round(coalesce(eng, 0))::int,
    round(coalesce(astr, 0))::int,
    round(coalesce(bio, 0))::int,
    round(coalesce(geo, 0))::int,
    round(coalesce(cs, 0))::int,
    round(coalesce(art, 0))::int,
    round(coalesce(span, 0))::int,
    round(coalesce(hist, 0))::int,
    round(coalesce(ital, 0))::int,
    round(coalesce(chin, 0))::int,
    round(coalesce(lit, 0))::int,
    round(coalesce(math, 0))::int,
    round(coalesce(germ, 0))::int,
    round(coalesce(soc, 0))::int,
    round(coalesce(life, 0))::int,
    round(coalesce(law, 0))::int,
    round(coalesce(rus, 0))::int,
    round(coalesce(tech, 0))::int,
    round(coalesce(phys, 0))::int,
    round(coalesce(pe, 0))::int,
    round(coalesce(french, 0))::int,
    round(coalesce(chem, 0))::int,
    round(coalesce(eco, 0))::int,
    round(coalesce(econ, 0))::int
from olympiad_municipal_2025_raw; -- INSERT - МУНИЦИПАЛЬНЫЙ ЭТАП - 2025 - ЧИСТАЯ ТАБЛИЦА


create table olympiad_regional_2025 (
    municipality varchar(19) not null,
    english_language int default 0,
    astronomy int default 0,
    biology int default 0,
    geography int default 0,
    computer_science int default 0,
    art int default 0,
    spanish_language int default 0,
    history int default 0,
    italian_language int default 0,
    chinese_language int default 0,
    literature int default 0,
    mathematics int default 0,
    german_language int default 0,
    social_studies int default 0,
    struve_astronomy int default 0,
    maxwell_physics int default 0,
    euler_mathematics int default 0,
    keldysh_computer_science int default 0,
    life_safety int default 0,
    law int default 0,
    russian_language int default 0,
    technology int default 0,
    physics int default 0,
    physical_education int default 0,
    french_language int default 0,
    ecology int default 0,
    economics int default 0,
    primary key (municipality)
);

insert into olympiad_regional_2025 (
    municipality,
    english_language,
    astronomy,
    biology,
    geography,
    computer_science,
    art,
    spanish_language,
    history,
    italian_language,
    chinese_language,
    literature,
    mathematics,
    german_language,
    social_studies,
    struve_astronomy,
    maxwell_physics,
    euler_mathematics,
    keldysh_computer_science,
    life_safety,
    law,
    russian_language,
    technology,
    physics,
    physical_education,
    french_language,
    ecology,
    economics
)
select
    left(regexp_replace(trim(municipality), '\s+', ' ', 'g'), 19) as municipality,
    round(coalesce(eng, 0))::int,
    round(coalesce(astr, 0))::int,
    round(coalesce(bio, 0))::int,
    round(coalesce(geo, 0))::int,
    round(coalesce(cs, 0))::int,
    round(coalesce(art, 0))::int,
    round(coalesce(span, 0))::int,
    round(coalesce(hist, 0))::int,
    round(coalesce(ital, 0))::int,
    round(coalesce(chin, 0))::int,
    round(coalesce(lit, 0))::int,
    round(coalesce(math, 0))::int,
    round(coalesce(germ, 0))::int,
    round(coalesce(soc, 0))::int,
    round(coalesce(struve, 0))::int,
    round(coalesce(maxwell, 0))::int,
    round(coalesce(euler, 0))::int,
    round(coalesce(keldysh, 0))::int,
    round(coalesce(life, 0))::int,
    round(coalesce(law, 0))::int,
    round(coalesce(rus, 0))::int,
    round(coalesce(tech, 0))::int,
    round(coalesce(phys, 0))::int,
    round(coalesce(pe, 0))::int,
    round(coalesce(french, 0))::int,
    round(coalesce(eco, 0))::int,
    round(coalesce(econ, 0))::int
from olympiad_regional_2025_raw; -- INSERT - РЕГИОНАЛЬНЫЙ ЭТАП - 2025 - ЧИСТАЯ ТАБЛИЦА


create table olympiad_final_2025 (
    municipality varchar(19) not null,
    english_language int default 0,
    astronomy int default 0,
    biology int default 0,
    geography int default 0,
    computer_science int default 0,
    art int default 0,
    spanish_language int default 0,
    history int default 0,
    italian_language int default 0,
    chinese_language int default 0,
    literature int default 0,
    mathematics int default 0,
    german_language int default 0,
    social_studies int default 0,
    struve_astronomy int default 0,
    maxwell_physics int default 0,
    euler_mathematics int default 0,
    keldysh_computer_science int default 0,
    life_safety int default 0,
    law int default 0,
    russian_language int default 0,
    technology int default 0,
    physics int default 0,
    physical_education int default 0,
    french_language int default 0,
    chemistry int default 0,
    ecology int default 0,
    economics int default 0,
    primary key (municipality)
);

insert into olympiad_final_2025 (
    municipality,
    english_language,
    astronomy,
    biology,
    geography,
    computer_science,
    art,
    spanish_language,
    history,
    italian_language,
    chinese_language,
    literature,
    mathematics,
    german_language,
    social_studies,
    struve_astronomy,
    maxwell_physics,
    euler_mathematics,
    keldysh_computer_science,
    life_safety,
    law,
    russian_language,
    technology,
    physics,
    physical_education,
    french_language,
    chemistry,
    ecology,
    economics
)
select
    left(regexp_replace(trim(municipality), '\s+', ' ', 'g'), 19) as municipality,
    round(coalesce(eng, 0))::int,
    round(coalesce(astr, 0))::int,
    round(coalesce(bio, 0))::int,
    round(coalesce(geo, 0))::int,
    round(coalesce(cs, 0))::int,
    round(coalesce(art, 0))::int,
    round(coalesce(span, 0))::int,
    round(coalesce(hist, 0))::int,
    round(coalesce(ital, 0))::int,
    round(coalesce(chin, 0))::int,
    round(coalesce(lit, 0))::int,
    round(coalesce(math, 0))::int,
    round(coalesce(germ, 0))::int,
    round(coalesce(soc, 0))::int,
    round(coalesce(struve, 0))::int,
    round(coalesce(maxwell, 0))::int,
    round(coalesce(euler, 0))::int,
    round(coalesce(keldysh, 0))::int,
    round(coalesce(life, 0))::int,
    round(coalesce(law, 0))::int,
    round(coalesce(rus, 0))::int,
    round(coalesce(tech, 0))::int,
    round(coalesce(phys, 0))::int,
    round(coalesce(pe, 0))::int,
    round(coalesce(french, 0))::int,
    round(coalesce(chem, 0))::int,
    round(coalesce(eco, 0))::int,
    round(coalesce(econ, 0))::int
from olympiad_final_2025_raw; -- INSERT - ЗАКЛЮЧИТЕЛЬНЫЙ ЭТАП - 2025 - ЧИСТАЯ ТАБЛИЦА


create table olympiad_results_2025 (
    municipality varchar(19) not null,
    chemistry int default 0,
    primary key (municipality)
);

insert into olympiad_results_2025 (
    municipality,
    chemistry
)
select
    left(regexp_replace(trim(municipality), '\s+', ' ', 'g'), 19) as municipality,
    round(coalesce(chem, 0))::int
from olympiad_results_2025_raw; -- INSERT - РЕЗУЛЬТАТЫ- 2025 - ЧИСТАЯ ТАБЛИЦА

-- 3.2.4 заполнение общей таблицы
create table olympiad_all_2025 (
    municipality varchar(100) not null,
    stage varchar(10) not null,
    english_language int default 0,
    astronomy int default 0,
    biology int default 0,
    geography int default 0,
    computer_science int default 0,
    art int default 0,
    spanish_language int default 0,
    history int default 0,
    italian_language int default 0,
    chinese_language int default 0,
    literature int default 0,
    mathematics int default 0,
    german_language int default 0,
    social_studies int default 0,
    life_safety int default 0,
    law int default 0,
    russian_language int default 0,
    technology int default 0,
    physics int default 0,
    physical_education int default 0,
    french_language int default 0,
    chemistry int default 0,
    ecology int default 0,
    economics int default 0,
    struve_astronomy int default 0,    
    maxwell_physics int default 0,   
    euler_mathematics int default 0,     
    keldysh_computer_science int default 0, 
    primary key (municipality, stage)
);

insert into olympiad_all_2025 (
    municipality,
    stage,
    english_language,
    astronomy,
    biology,
    geography,
    computer_science,
    art,
    spanish_language,
    history,
    italian_language,
    chinese_language,
    literature,
    mathematics,
    german_language,
    social_studies,
    life_safety,
    law,
    russian_language,
    technology,
    physics,
    physical_education,
    french_language,
    chemistry,
    ecology,
    economics,
    struve_astronomy,
    maxwell_physics,
    euler_mathematics,
    keldysh_computer_science
)
select
    municipality,
    'шэ',
    english_language,
    astronomy,
    biology,
    geography,
    computer_science,
    art,
    spanish_language,
    history,
    italian_language,
    chinese_language,
    literature,
    mathematics,
    german_language,
    social_studies,
    life_safety,
    law,
    russian_language,
    technology,
    physics,
    physical_education,
    french_language,
    chemistry,
    ecology,
    economics,
    0,
    0,
    0,
    0
from olympiad_school_2025; -- INSERT - ШКОЛЬНЫЙ ЭТАП - 2025 - ОБЩАЯ ТАБЛИЦА

insert into olympiad_all_2025 (
    municipality,
    stage,
    english_language,
    astronomy,
    biology,
    geography,
    computer_science,
    art,
    spanish_language,
    history,
    italian_language,
    chinese_language,
    literature,
    mathematics,
    german_language,
    social_studies,
    life_safety,
    law,
    russian_language,
    technology,
    physics,
    physical_education,
    french_language,
    chemistry,
    ecology,
    economics,
    struve_astronomy,
    maxwell_physics,
    euler_mathematics,
    keldysh_computer_science
)
select
    municipality,
    'мэ',
    english_language,
    astronomy,
    biology,
    geography,
    computer_science,
    art,
    spanish_language,
    history,
    italian_language,
    chinese_language,
    literature,
    mathematics,
    german_language,
    social_studies,
    life_safety,
    law,
    russian_language,
    technology,
    physics,
    physical_education,
    french_language,
    chemistry,
    ecology,
    economics,
    0,
    0,
    0,
    0
from olympiad_municipal_2025; -- INSERT - МУНИЦИПАЛЬНЫЙ ЭТАП - 2025 - ОБЩАЯ ТАБЛИЦА

insert into olympiad_all_2025 (
    municipality,
    stage,
    english_language,
    astronomy,
    biology,
    geography,
    computer_science,
    art,
    spanish_language,
    history,
    italian_language,
    chinese_language,
    literature,
    mathematics,
    german_language,
    social_studies,
    life_safety,
    law,
    russian_language,
    technology,
    physics,
    physical_education,
    french_language,
    chemistry,
    ecology,
    economics,
    struve_astronomy,
    maxwell_physics,
    euler_mathematics,
    keldysh_computer_science
)
select
    municipality,
    'рэ',
    english_language,
    astronomy,
    biology,
    geography,
    computer_science,
    art,
    spanish_language,
    history,
    italian_language,
    chinese_language,
    literature,
    mathematics,
    german_language,
    social_studies,
    life_safety,
    law,
    russian_language,
    technology,
    physics,
    physical_education,
    french_language,
    0,
    ecology,
    economics,
    struve_astronomy,
    maxwell_physics,
    euler_mathematics,
    keldysh_computer_science
from olympiad_regional_2025; -- INSERT - РЕГИОНАЛЬНЫЙ ЭТАП - 2025 - ОБЩАЯ ТАБЛИЦА

insert into olympiad_all_2025 (
    municipality,
    stage,
    english_language,
    astronomy,
    biology,
    geography,
    computer_science,
    art,
    spanish_language,
    history,
    italian_language,
    chinese_language,
    literature,
    mathematics,
    german_language,
    social_studies,
    life_safety,
    law,
    russian_language,
    technology,
    physics,
    physical_education,
    french_language,
    chemistry,
    ecology,
    economics,
    struve_astronomy,
    maxwell_physics,
    euler_mathematics,
    keldysh_computer_science
)
select
    municipality,
    'зэ',
    english_language,
    astronomy,
    biology,
    geography,
    computer_science,
    art,
    spanish_language,
    history,
    italian_language,
    chinese_language,
    literature,
    mathematics,
    german_language,
    social_studies,
    life_safety,
    law,
    russian_language,
    technology,
    physics,
    physical_education,
    french_language,
    chemistry,
    ecology,
    economics,
    struve_astronomy,
    maxwell_physics,
    euler_mathematics,
    keldysh_computer_science
from olympiad_final_2025; -- INSERT - ЗАКЛЮЧИТЕЛЬНЫЙ ЭТАП - 2025 - ОБЩАЯ ТАБЛИЦА

insert into olympiad_all_2025 (
    municipality,
    stage,
    chemistry
)
select
    municipality,
    'р',
    chemistry
from olympiad_results_2025; -- INSERT - РЕЗУЛЬТАТЫ - 2025 - ОБЩАЯ ТАБЛИЦА

select * from olympiad_all_2025;

-- 3.3.1 профилирование распределения
select
    biology,
    count(*) as freq
from olympiad_all_2025
group by biology
order by biology;

-- 3.3.2 агрегирование с подсчётом частоты
select
    stage,
    round(avg(science_total), 1) as avg_science_participants
from (
    select
        stage,
        municipality,
        astronomy + biology + physics + chemistry + ecology as science_total
    from olympiad_all_2025
) as sub
group by stage
order by stage;

-- 3.4.1 поиск возможных дубликатов
select
    municipality,
    stage,
    count(*) as cnt
from olympiad_all_2025
group by municipality, stage
having count(*) > 1
order by cnt desc, municipality, stage;

-- 3.4.2 distinct
select distinct
    stage,
    municipality
from olympiad_all_2025
order by stage, municipality;

-- 3.4.3 group by
select
    stage,
    count(distinct municipality) as municipalities_count
from olympiad_all_2025
group by stage
order by stage;

-- 3.5.1 очистка данных с помощью case
select
    municipality,
    stage,
    mathematics,
    physics,
    computer_science,
    case
        when exact_sciences_sum = 0 then 'нет участия в точных науках'
        when exact_sciences_sum between 1 and 10 then 'низкая активность'
        when exact_sciences_sum between 11 and 30 then 'средняя активность'
        else 'высокая активность'
    end as exact_sciences_category
from (
    select
        *,
        coalesce(mathematics, 0)
        + coalesce(physics, 0)
        + coalesce(computer_science, 0)
        + coalesce(euler_mathematics, 0)
        + coalesce(maxwell_physics, 0)
        + coalesce(keldysh_computer_science, 0) as exact_sciences_sum
    from olympiad_all_2025
) as sub
order by exact_sciences_sum desc;

-- 3.5.2 очистка с помощью флагов
select
    municipality,
    stage,
    biology,
    chemistry,
    case when biology > 3 then 1 else 0 end as flag_high_biology,
    case when chemistry > 3 then 1 else 0 end as flag_high_chemistry,
    case when biology > 3 and chemistry > 3 then 1 else 0 end as flag_both_sciences,
    case when mathematics > 5 then 1 else 0 end as flag_math_gt_5
from olympiad_all_2025
order by municipality, stage;

-- 3.5.3 преобразование типов
select
    municipality,
    stage,
    physics,
    cast(physics as decimal(10, 1)) as physics_decimal,
    computer_science,
    cast(computer_science as float) as cs_float,
    (physics + computer_science)::text as total_text
from olympiad_all_2025;

-- 3.5.4 работа с null значениями: coalesce, nullif, nvl
select
    municipality,
    stage,
    coalesce(physics, 0) as physics_no_null,
    coalesce(chemistry, 0) as chemistry_no_null,
    nvl(biology::double precision, 0)::int as biology_no_null,
    nullif(history, 0) as history_zero_to_null
from olympiad_all_2025;

-- VIEW
drop view if exists olympiad_report_2025;

create view olympiad_report_2025 as
select
    2025 as year,
    municipality,
    stage,
    subject,
    participants_count
from olympiad_all_2025
cross join lateral (
    values
        ('английский язык', english_language),
        ('астрономия', astronomy),
        ('биология', biology),
        ('география', geography),
        ('информатика', computer_science),
        ('искусство', art),
        ('испанский язык', spanish_language),
        ('история', history),
        ('итальянский язык', italian_language),
        ('китайский язык', chinese_language),
        ('литература', literature),
        ('математика', mathematics),
        ('немецкий язык', german_language),
        ('обществознание', social_studies),
        ('обж', life_safety),
        ('право', law),
        ('русский язык', russian_language),
        ('технология', technology),
        ('физика', physics),
        ('физическая культура', physical_education),
        ('французский язык', french_language),
        ('химия', chemistry),
        ('экология', ecology),
        ('экономика', economics),
        ('струве', struve_astronomy),
        ('максвелл', maxwell_physics),
        ('эйлер', euler_mathematics),
        ('келдыш', keldysh_computer_science)
) as v(subject, participants_count)
where participants_count > 0;

-- Сырые таблицы для импорта данных за 2024 год
drop table if exists olympiad_school_2024_raw;
create table olympiad_school_2024_raw (
    municipality text,
    eng double precision,
    astr double precision,
    bio double precision,
    geo double precision,
    eng_graph double precision,
    cs double precision,
    art double precision,
    span double precision,
    hist double precision,
    ital double precision,
    chin double precision,
    lit double precision,
    math double precision,
    germ double precision,
    soc double precision,
    life double precision,
    law double precision,
    rus double precision,
    tech double precision,
    phys double precision,
    pe double precision,
    french double precision,
    chem double precision,
    eco double precision,
    econ double precision
);

drop table if exists olympiad_municipal_2024_raw;
create table olympiad_municipal_2024_raw (
    municipality text,
    eng double precision,
    astr double precision,
    bio double precision,
    geo double precision,
    cs double precision,
    art double precision,
    span double precision,
    hist double precision,
    ital double precision,
    chin double precision,
    lit double precision,
    math double precision,
    germ double precision,
    soc double precision,
    life double precision,
    law double precision,
    rus double precision,
    tech double precision,
    phys double precision,
    pe double precision,
    french double precision,
    chem double precision,
    eco double precision,
    econ double precision
);

drop table if exists olympiad_regional_2024_raw;
create table olympiad_regional_2024_raw (
    municipality text,
    eng double precision,
    astr double precision,
    bio double precision,
    geo double precision,
    cs double precision,
    art double precision,
    span double precision,
    hist double precision,
    ital double precision,
    chin double precision,
    lit double precision,
    math double precision,
    germ double precision,
    soc double precision,
    struve double precision,
    maxwell double precision,
    euler double precision,
    keldysh double precision,
    life double precision,
    law double precision,
    rus double precision,
    tech double precision,
    phys double precision,
    pe double precision,
    french double precision,
    chem double precision,
    eco double precision,
    econ double precision
);

-- drop table if exists olympiad_final_2024_raw;
-- create table olympiad_final_2024_raw (
--     municipality text,
--     eng double precision,
--     astr double precision,
--     bio double precision,
--     geo double precision,
--     cs double precision,
--     art double precision,
--     span double precision,
--     hist double precision,
--     ital double precision,
--     chin double precision,
--     lit double precision,
--     math double precision,
--     germ double precision,
--     soc double precision,
--     struve double precision,
--     maxwell double precision,
--     euler double precision,
--     keldysh double precision,
--     life double precision,
--     law double precision,
--     rus double precision,
--     tech double precision,
--     phys double precision,
--     pe double precision,
--     french double precision,
--     chem double precision,
--     eco double precision,
--     econ double precision
-- );

-- drop table if exists olympiad_results_2024_raw;
-- create table olympiad_results_2024_raw (
--     municipality text,
--     chem double precision
-- );

-- 3.2.6 чистые таблицы для 2024 года

drop table if exists olympiad_school_2024;
create table olympiad_school_2024 (
    municipality varchar(19) not null,
    english_language int default 0,
    astronomy int default 0,
    biology int default 0,
    geography int default 0,
    engineering_graphics int default 0,
    computer_science int default 0,
    art int default 0,
    spanish_language int default 0,
    history int default 0,
    italian_language int default 0,
    chinese_language int default 0,
    literature int default 0,
    mathematics int default 0,
    german_language int default 0,
    social_studies int default 0,
    life_safety int default 0,
    law int default 0,
    russian_language int default 0,
    technology int default 0,
    physics int default 0,
    physical_education int default 0,
    french_language int default 0,
    chemistry int default 0,
    ecology int default 0,
    economics int default 0,
    primary key (municipality)
);

insert into olympiad_school_2024 (
    municipality,
    english_language,
    astronomy,
    biology,
    geography,
    engineering_graphics,
    computer_science,
    art,
    spanish_language,
    history,
    italian_language,
    chinese_language,
    literature,
    mathematics,
    german_language,
    social_studies,
    life_safety,
    law,
    russian_language,
    technology,
    physics,
    physical_education,
    french_language,
    chemistry,
    ecology,
    economics
)
select
    left(regexp_replace(trim(municipality), '\s+', ' ', 'g'), 19) as municipality,
    round(coalesce(eng, 0))::int,
    round(coalesce(astr, 0))::int,
    round(coalesce(bio, 0))::int,
    round(coalesce(geo, 0))::int,
    round(coalesce(eng_graph, 0))::int,
    round(coalesce(cs, 0))::int,
    round(coalesce(art, 0))::int,
    round(coalesce(span, 0))::int,
    round(coalesce(hist, 0))::int,
    round(coalesce(ital, 0))::int,
    round(coalesce(chin, 0))::int,
    round(coalesce(lit, 0))::int,
    round(coalesce(math, 0))::int,
    round(coalesce(germ, 0))::int,
    round(coalesce(soc, 0))::int,
    round(coalesce(life, 0))::int,
    round(coalesce(law, 0))::int,
    round(coalesce(rus, 0))::int,
    round(coalesce(tech, 0))::int,
    round(coalesce(phys, 0))::int,
    round(coalesce(pe, 0))::int,
    round(coalesce(french, 0))::int,
    round(coalesce(chem, 0))::int,
    round(coalesce(eco, 0))::int,
    round(coalesce(econ, 0))::int
from olympiad_school_2024_raw; -- INSERT - ШКАОЛЬНЫЙ ЭТАП - 2024  - ЧИСТАЯ ТАБЛИЦА


drop table if exists olympiad_municipal_2024;
create table olympiad_municipal_2024 (
    municipality varchar(19) not null,
    english_language int default 0,
    astronomy int default 0,
    biology int default 0,
    geography int default 0,
    computer_science int default 0,
    art int default 0,
    spanish_language int default 0,
    history int default 0,
    italian_language int default 0,
    chinese_language int default 0,
    literature int default 0,
    mathematics int default 0,
    german_language int default 0,
    social_studies int default 0,
    life_safety int default 0,
    law int default 0,
    russian_language int default 0,
    technology int default 0,
    physics int default 0,
    physical_education int default 0,
    french_language int default 0,
    chemistry int default 0,
    ecology int default 0,
    economics int default 0,
    primary key (municipality)
);

insert into olympiad_municipal_2024 (
    municipality,
    english_language,
    astronomy,
    biology,
    geography,
    computer_science,
    art,
    spanish_language,
    history,
    italian_language,
    chinese_language,
    literature,
    mathematics,
    german_language,
    social_studies,
    life_safety,
    law,
    russian_language,
    technology,
    physics,
    physical_education,
    french_language,
    chemistry,
    ecology,
    economics
)
select
    left(regexp_replace(trim(municipality), '\s+', ' ', 'g'), 19) as municipality,
    round(coalesce(eng, 0))::int,
    round(coalesce(astr, 0))::int,
    round(coalesce(bio, 0))::int,
    round(coalesce(geo, 0))::int,
    round(coalesce(cs, 0))::int,
    round(coalesce(art, 0))::int,
    round(coalesce(span, 0))::int,
    round(coalesce(hist, 0))::int,
    round(coalesce(ital, 0))::int,
    round(coalesce(chin, 0))::int,
    round(coalesce(lit, 0))::int,
    round(coalesce(math, 0))::int,
    round(coalesce(germ, 0))::int,
    round(coalesce(soc, 0))::int,
    round(coalesce(life, 0))::int,
    round(coalesce(law, 0))::int,
    round(coalesce(rus, 0))::int,
    round(coalesce(tech, 0))::int,
    round(coalesce(phys, 0))::int,
    round(coalesce(pe, 0))::int,
    round(coalesce(french, 0))::int,
    round(coalesce(chem, 0))::int,
    round(coalesce(eco, 0))::int,
    round(coalesce(econ, 0))::int
from olympiad_municipal_2024_raw; -- INSERT - МУНИЦИПАЛЬНЫЙ ЭТАП - 2024  - ЧИСТАЯ ТАБЛИЦА


drop table if exists olympiad_regional_2024;
create table olympiad_regional_2024 (
    municipality varchar(19) not null,
    english_language int default 0,
    astronomy int default 0,
    biology int default 0,
    geography int default 0,
    computer_science int default 0,
    art int default 0,
    spanish_language int default 0,
    history int default 0,
    italian_language int default 0,
    chinese_language int default 0,
    literature int default 0,
    mathematics int default 0,
    german_language int default 0,
    social_studies int default 0,
    struve_astronomy int default 0,
    maxwell_physics int default 0,
    euler_mathematics int default 0,
    keldysh_computer_science int default 0,
    life_safety int default 0,
    law int default 0,
    russian_language int default 0,
    technology int default 0,
    physics int default 0,
    physical_education int default 0,
    french_language int default 0,
    chemistry int default 0,
    ecology int default 0,
    economics int default 0,
    primary key (municipality)
);

insert into olympiad_regional_2024 (
    municipality,
    english_language,
    astronomy,
    biology,
    geography,
    computer_science,
    art,
    spanish_language,
    history,
    italian_language,
    chinese_language,
    literature,
    mathematics,
    german_language,
    social_studies,
    struve_astronomy,
    maxwell_physics,
    euler_mathematics,
    keldysh_computer_science,
    life_safety,
    law,
    russian_language,
    technology,
    physics,
    physical_education,
    french_language,
    chemistry,
    ecology,
    economics
)
select
    left(regexp_replace(trim(municipality), '\s+', ' ', 'g'), 19) as municipality,
    round(coalesce(eng, 0))::int,
    round(coalesce(astr, 0))::int,
    round(coalesce(bio, 0))::int,
    round(coalesce(geo, 0))::int,
    round(coalesce(cs, 0))::int,
    round(coalesce(art, 0))::int,
    round(coalesce(span, 0))::int,
    round(coalesce(hist, 0))::int,
    round(coalesce(ital, 0))::int,
    round(coalesce(chin, 0))::int,
    round(coalesce(lit, 0))::int,
    round(coalesce(math, 0))::int,
    round(coalesce(germ, 0))::int,
    round(coalesce(soc, 0))::int,
    round(coalesce(struve, 0))::int,
    round(coalesce(maxwell, 0))::int,
    round(coalesce(euler, 0))::int,
    round(coalesce(keldysh, 0))::int,
    round(coalesce(life, 0))::int,
    round(coalesce(law, 0))::int,
    round(coalesce(rus, 0))::int,
    round(coalesce(tech, 0))::int,
    round(coalesce(phys, 0))::int,
    round(coalesce(pe, 0))::int,
    round(coalesce(french, 0))::int,
    round(coalesce(chem, 0))::int,
    round(coalesce(eco, 0))::int,
    round(coalesce(econ, 0))::int
from olympiad_regional_2024_raw; -- INSERT - РЕГИОНАЛЬНЫЙ ЭТАП - 2024  - ЧИСТАЯ ТАБЛИЦА


-- drop table if exists olympiad_final_2024;
-- create table olympiad_final_2024 (
--     municipality varchar(19) not null,
--     english_language int default 0,
--     astronomy int default 0,
--     biology int default 0,
--     geography int default 0,
--     computer_science int default 0,
--     art int default 0,
--     spanish_language int default 0,
--     history int default 0,
--     italian_language int default 0,
--     chinese_language int default 0,
--     literature int default 0,
--     mathematics int default 0,
--     german_language int default 0,
--     social_studies int default 0,
--     struve_astronomy int default 0,
--     maxwell_physics int default 0,
--     euler_mathematics int default 0,
--     keldysh_computer_science int default 0,
--     life_safety int default 0,
--     law int default 0,
--     russian_language int default 0,
--     technology int default 0,
--     physics int default 0,
--     physical_education int default 0,
--     french_language int default 0,
--     chemistry int default 0,
--     ecology int default 0,
--     economics int default 0,
--     primary key (municipality)
-- );

-- insert into olympiad_final_2024 (
--     municipality,
--     english_language,
--     astronomy,
--     biology,
--     geography,
--     computer_science,
--     art,
--     spanish_language,
--     history,
--     italian_language,
--     chinese_language,
--     literature,
--     mathematics,
--     german_language,
--     social_studies,
--     struve_astronomy,
--     maxwell_physics,
--     euler_mathematics,
--     keldysh_computer_science,
--     life_safety,
--     law,
--     russian_language,
--     technology,
--     physics,
--     physical_education,
--     french_language,
--     chemistry,
--     ecology,
--     economics
-- )
-- select
--     left(regexp_replace(trim(municipality), '\s+', ' ', 'g'), 19) as municipality,
--     round(coalesce(eng, 0))::int,
--     round(coalesce(astr, 0))::int,
--     round(coalesce(bio, 0))::int,
--     round(coalesce(geo, 0))::int,
--     round(coalesce(cs, 0))::int,
--     round(coalesce(art, 0))::int,
--     round(coalesce(span, 0))::int,
--     round(coalesce(hist, 0))::int,
--     round(coalesce(ital, 0))::int,
--     round(coalesce(chin, 0))::int,
--     round(coalesce(lit, 0))::int,
--     round(coalesce(math, 0))::int,
--     round(coalesce(germ, 0))::int,
--     round(coalesce(soc, 0))::int,
--     round(coalesce(struve, 0))::int,
--     round(coalesce(maxwell, 0))::int,
--     round(coalesce(euler, 0))::int,
--     round(coalesce(keldysh, 0))::int,
--     round(coalesce(life, 0))::int,
--     round(coalesce(law, 0))::int,
--     round(coalesce(rus, 0))::int,
--     round(coalesce(tech, 0))::int,
--     round(coalesce(phys, 0))::int,
--     round(coalesce(pe, 0))::int,
--     round(coalesce(french, 0))::int,
--     round(coalesce(chem, 0))::int,
--     round(coalesce(eco, 0))::int,
--     round(coalesce(econ, 0))::int
-- from olympiad_final_2024_raw; -- INSERT - ЗАКЛЮЧИТЕЛЬНЫЙ ЭТАП - 2024 - ЧИСТАЯ ТАБЛИЦА


-- drop table if exists olympiad_results_2024;
-- create table olympiad_results_2024 (
--     municipality varchar(19) not null,
--     chemistry int default 0,
--     primary key (municipality)
-- );

-- insert into olympiad_results_2024 (
--     municipality,
--     chemistry
-- )
-- select
--     left(regexp_replace(trim(municipality), '\s+', ' ', 'g'), 19) as municipality,
--     round(coalesce(chem, 0))::int
-- from olympiad_results_2024_raw; -- INSERT - РЕЗУЛЬТАТЫ - 2024 - ЧИСТАЯ ТАБЛИЦА


drop table if exists olympiad_all_2024;
create table olympiad_all_2024 (
    municipality varchar(100) not null,
    stage varchar(10) not null,
    english_language int default 0,
    astronomy int default 0,
    biology int default 0,
    geography int default 0,
    engineering_graphics int default 0,
    computer_science int default 0,
    art int default 0,
    spanish_language int default 0,
    history int default 0,
    italian_language int default 0,
    chinese_language int default 0,
    literature int default 0,
    mathematics int default 0,
    german_language int default 0,
    social_studies int default 0,
    life_safety int default 0,
    law int default 0,
    russian_language int default 0,
    technology int default 0,
    physics int default 0,
    physical_education int default 0,
    french_language int default 0,
    chemistry int default 0,
    ecology int default 0,
    economics int default 0,
    struve_astronomy int default 0,
    maxwell_physics int default 0,
    euler_mathematics int default 0,
    keldysh_computer_science int default 0,
    primary key (municipality, stage)
);

insert into olympiad_all_2024 (
    municipality,
    stage,
    english_language,
    astronomy,
    biology,
    geography,
    engineering_graphics,
    computer_science,
    art,
    spanish_language,
    history,
    italian_language,
    chinese_language,
    literature,
    mathematics,
    german_language,
    social_studies,
    life_safety,
    law,
    russian_language,
    technology,
    physics,
    physical_education,
    french_language,
    chemistry,
    ecology,
    economics,
    struve_astronomy,
    maxwell_physics,
    euler_mathematics,
    keldysh_computer_science
)
select
    municipality,
    'шэ',
    english_language,
    astronomy,
    biology,
    geography,
    engineering_graphics,
    computer_science,
    art,
    spanish_language,
    history,
    italian_language,
    chinese_language,
    literature,
    mathematics,
    german_language,
    social_studies,
    life_safety,
    law,
    russian_language,
    technology,
    physics,
    physical_education,
    french_language,
    chemistry,
    ecology,
    economics,
    0,
    0,
    0,
    0
from olympiad_school_2024; -- INSERT - ШКОЛЬНЫЙ ЭТАП - 2024 - ОБЩАЯ ТАБЛИЦА

insert into olympiad_all_2024 (
    municipality,
    stage,
    english_language,
    astronomy,
    biology,
    geography,
    engineering_graphics,
    computer_science,
    art,
    spanish_language,
    history,
    italian_language,
    chinese_language,
    literature,
    mathematics,
    german_language,
    social_studies,
    life_safety,
    law,
    russian_language,
    technology,
    physics,
    physical_education,
    french_language,
    chemistry,
    ecology,
    economics,
    struve_astronomy,
    maxwell_physics,
    euler_mathematics,
    keldysh_computer_science
)
select
    municipality,
    'мэ',
    english_language,
    astronomy,
    biology,
    geography,
    0,
    computer_science,
    art,
    spanish_language,
    history,
    italian_language,
    chinese_language,
    literature,
    mathematics,
    german_language,
    social_studies,
    life_safety,
    law,
    russian_language,
    technology,
    physics,
    physical_education,
    french_language,
    chemistry,
    ecology,
    economics,
    0,
    0,
    0,
    0
from olympiad_municipal_2024; -- INSERT - МУНИЦИПАЛЬНЫЙ ЭТАП - 2024 - ОБЩАЯ ТАБЛИЦА

insert into olympiad_all_2024 (
    municipality,
    stage,
    english_language,
    astronomy,
    biology,
    geography,
    engineering_graphics,
    computer_science,
    art,
    spanish_language,
    history,
    italian_language,
    chinese_language,
    literature,
    mathematics,
    german_language,
    social_studies,
    life_safety,
    law,
    russian_language,
    technology,
    physics,
    physical_education,
    french_language,
    chemistry,
    ecology,
    economics,
    struve_astronomy,
    maxwell_physics,
    euler_mathematics,
    keldysh_computer_science
)
select
    municipality,
    'рэ',
    english_language,
    astronomy,
    biology,
    geography,
    0,
    computer_science,
    art,
    spanish_language,
    history,
    italian_language,
    chinese_language,
    literature,
    mathematics,
    german_language,
    social_studies,
    life_safety,
    law,
    russian_language,
    technology,
    physics,
    physical_education,
    french_language,
    chemistry,
    ecology,
    economics,
    struve_astronomy,
    maxwell_physics,
    euler_mathematics,
    keldysh_computer_science
from olympiad_regional_2024; -- INSERT - РЕГИОНАЛЬНЫЙ ЭТАП - 2024 - ОБЩАЯ ТАБЛИЦА

-- insert into olympiad_all_2024 (
--     municipality,
--     stage,
--     english_language,
--     astronomy,
--     biology,
--     geography,
--     engineering_graphics,
--     computer_science,
--     art,
--     spanish_language,
--     history,
--     italian_language,
--     chinese_language,
--     literature,
--     mathematics,
--     german_language,
--     social_studies,
--     life_safety,
--     law,
--     russian_language,
--     technology,
--     physics,
--     physical_education,
--     french_language,
--     chemistry,
--     ecology,
--     economics,
--     struve_astronomy,
--     maxwell_physics,
--     euler_mathematics,
--     keldysh_computer_science
-- )
-- select
--     municipality,
--     'зэ',
--     english_language,
--     astronomy,
--     biology,
--     geography,
--     0,
--     computer_science,
--     art,
--     spanish_language,
--     history,
--     italian_language,
--     chinese_language,
--     literature,
--     mathematics,
--     german_language,
--     social_studies,
--     life_safety,
--     law,
--     russian_language,
--     technology,
--     physics,
--     physical_education,
--     french_language,
--     chemistry,
--     ecology,
--     economics,
--     struve_astronomy,
--     maxwell_physics,
--     euler_mathematics,
--     keldysh_computer_science
-- from olympiad_final_2024;

-- insert into olympiad_all_2024 (
--     municipality,
--     stage,
--     chemistry
-- )
-- select
--     municipality,
--     'р',
--     chemistry
-- from olympiad_results_2024;

-- 3.6.1 представление за 2024 год

drop view if exists olympiad_report_2024;
create view olympiad_report_2024 as
select
    2024 as year,
    municipality,
    stage,
    subject,
    participants_count
from olympiad_all_2024
cross join lateral (
    values
        ('английский язык', english_language),
        ('астрономия', astronomy),
        ('биология', biology),
        ('география', geography),
        ('инжинерная графика', engineering_graphics),
        ('информатика', computer_science),
        ('искусство', art),
        ('испанский язык', spanish_language),
        ('история', history),
        ('итальянский язык', italian_language),
        ('китайский язык', chinese_language),
        ('литература', literature),
        ('математика', mathematics),
        ('немецкий язык', german_language),
        ('обществознание', social_studies),
        ('обж', life_safety),
        ('право', law),
        ('русский язык', russian_language),
        ('технология', technology),
        ('физика', physics),
        ('физическая культура', physical_education),
        ('французский язык', french_language),
        ('химия', chemistry),
        ('экология', ecology),
        ('экономика', economics),
        ('струве', struve_astronomy),
        ('максвелл', maxwell_physics),
        ('эйлер', euler_mathematics),
        ('келдыш', keldysh_computer_science)
) as v(subject, participants_count)
where participants_count > 0;

-- Общая итоговая view по всем годам

drop view if exists olympiad_report_all;
create view olympiad_report_all as
select
    year,
    municipality,
    stage,
    subject,
    participants_count
from olympiad_report_2024

union all

select
    year,
    municipality,
    stage,
    subject,
    participants_count
from olympiad_report_2025;

-- итоговый запрос для вывода общего результата
select
    year,
    municipality,
    stage,
    subject,
    participants_count
from olympiad_report_all
order by year, municipality, stage, subject;

select year, count(*)
from olympiad_report_all
group by year
order by year;


-- 2025
-- итоговый запрос для вывода результата за 2025
select
    year,
    municipality,
    stage,
    subject,
    participants_count
from olympiad_report_2025
-- where municipality ilike 'парф%'
order by year, municipality, stage, subject;
-- order by year, participants_count desc;

-- 2024
-- итоговый запрос для вывода результата за 2024
select
    year,
    municipality,
    stage,
    subject,
    participants_count
from olympiad_report_2024
order by year, municipality, stage, subject;