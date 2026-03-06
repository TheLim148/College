
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

create table olympiad_results_2025 (
    municipality varchar(19) not null,
    chemistry int default 0,
    primary key (municipality)
);




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
    municipality, stage,
    english_language, astronomy, biology, geography, computer_science,
    art, spanish_language, history, italian_language, chinese_language,
    literature, mathematics, german_language, social_studies,
    life_safety, law, russian_language, technology, physics,
    physical_education, french_language, chemistry, ecology, economics,
    struve_astronomy, maxwell_physics, euler_mathematics, keldysh_computer_science
)
select
    municipality, 'ШЭ',
    english_language, astronomy, biology, geography, computer_science,
    art, spanish_language, history, italian_language, chinese_language,
    literature, mathematics, german_language, social_studies,
    life_safety, law, russian_language, technology, physics,
    physical_education, french_language, chemistry, ecology, economics,
    0, 0, 0, 0  
from olympiad_school_2025;

insert into olympiad_all_2025 (
    municipality, stage,
    english_language, astronomy, biology, geography, computer_science,
    art, spanish_language, history, italian_language, chinese_language,
    literature, mathematics, german_language, social_studies,
    life_safety, law, russian_language, technology, physics,
    physical_education, french_language, chemistry, ecology, economics,
    struve_astronomy, maxwell_physics, euler_mathematics, keldysh_computer_science
)
select
    municipality, 'МЭ',
    english_language, astronomy, biology, geography, computer_science,
    art, spanish_language, history, italian_language, chinese_language,
    literature, mathematics, german_language, social_studies,
    life_safety, law, russian_language, technology, physics,
    physical_education, french_language, chemistry, ecology, economics,
    0, 0, 0, 0
from olympiad_municipal_2025;

insert into olympiad_all_2025 (
    municipality, stage,
    english_language, astronomy, biology, geography, computer_science,
    art, spanish_language, history, italian_language, chinese_language,
    literature, mathematics, german_language, social_studies,
    life_safety, law, russian_language, technology, physics,
    physical_education, french_language, chemistry, ecology, economics,
    struve_astronomy, maxwell_physics, euler_mathematics, keldysh_computer_science
)
select
    municipality, 'РЭ',
    english_language, astronomy, biology, geography, computer_science,
    art, spanish_language, history, italian_language, chinese_language,
    literature, mathematics, german_language, social_studies,
    life_safety, law, russian_language, technology, physics,
    physical_education, french_language, 0, ecology, economics,
    struve_astronomy, maxwell_physics, euler_mathematics, keldysh_computer_science
from olympiad_regional_2025;

insert into olympiad_all_2025 (
    municipality, stage,
    english_language, astronomy, biology, geography, computer_science,
    art, spanish_language, history, italian_language, chinese_language,
    literature, mathematics, german_language, social_studies,
    life_safety, law, russian_language, technology, physics,
    physical_education, french_language, chemistry, ecology, economics,
    struve_astronomy, maxwell_physics, euler_mathematics, keldysh_computer_science
)
select
    municipality, 'ЗЭ',
    english_language, astronomy, biology, geography, computer_science,
    art, spanish_language, history, italian_language, chinese_language,
    literature, mathematics, german_language, social_studies,
    life_safety, law, russian_language, technology, physics,
    physical_education, french_language, chemistry, ecology, economics,
    struve_astronomy, maxwell_physics, euler_mathematics, keldysh_computer_science
from olympiad_final_2025;

insert into olympiad_all_2025 (
    municipality, stage,
    chemistry
)
select
    municipality, 'Р',
    chemistry
from olympiad_results_2025;

select * from olympiad_all_2025;

--3.3.1
select biology, count(*) as freq
from olympiad_all_2025
group by biology
order by biology;

-- 3.3.2

select stage, round(avg(science_total),1) as avg_science_participants
from (
    select stage, municipality,
           (astronomy + biology + physics + chemistry + ecology) as science_total
    from olympiad_all_2025
) as sub
group by stage;

-- 3.4.1
select 
    english_language, german_language,
    count(*) as cnt
from olympiad_all_2025
where english_language > 10 
   or german_language > 10 
   or french_language > 10
group by english_language, german_language
order by cnt desc;

select distinct stage, municipality
from olympiad_all_2025
order by stage, municipality;

select stage, count(distinct municipality) as municipalities_count
from olympiad_all_2025
group by stage
order by stage;

--3.5.1
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
    select *,
           (coalesce(mathematics, 0) + coalesce(physics, 0) + 
            coalesce(computer_science, 0) + coalesce(euler_mathematics, 0) + 
            coalesce(maxwell_physics, 0) + coalesce(keldysh_computer_science, 0)) as exact_sciences_sum
    from olympiad_all_2025
) as sub
order by exact_sciences_sum desc;


--3.5.2

select 
    municipality,
    stage,
    biology,
    chemistry,
    case when biology > 3 then 1 else 0 end as flag_high_biology,
    case when chemistry > 3 then 1 else 0 end as flag_high_chemistry,
    case when biology > 3 and chemistry > 3 then 1 else 0 end as flag_both_sciences
from olympiad_all_2025
order by municipality, stage;


--3.5.3

select 
    municipality,
    stage,
    physics,
    cast(physics as decimal(10,1)) as physics_decimal,
    computer_science,
    cast(computer_science as float) as cs_float,
    (physics + computer_science)::text as total_text
from olympiad_all_2025;

--3.5.4

select 
    municipality,
    stage,
    coalesce(physics, 0) as physics_no_null,
    coalesce(chemistry, 0) as chemistry_no_null,
    coalesce(biology, 0) as biology_no_null
from olympiad_all_2025;

