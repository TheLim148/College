CREATE TABLE olympiad_all_2025 (
    municipality VARCHAR(100) NOT NULL,
    stage VARCHAR(10) NOT NULL,
    english_language INT DEFAULT 0,
    astronomy INT DEFAULT 0,
    biology INT DEFAULT 0,
    geography INT DEFAULT 0,
    computer_science INT DEFAULT 0,
    art INT DEFAULT 0,
    spanish_language INT DEFAULT 0,
    history INT DEFAULT 0,
    italian_language INT DEFAULT 0,
    chinese_language INT DEFAULT 0,
    literature INT DEFAULT 0,
    mathematics INT DEFAULT 0,
    german_language INT DEFAULT 0,
    social_studies INT DEFAULT 0,
    life_safety INT DEFAULT 0,
    law INT DEFAULT 0,
    russian_language INT DEFAULT 0,
    technology INT DEFAULT 0,
    physics INT DEFAULT 0,
    physical_education INT DEFAULT 0,
    french_language INT DEFAULT 0,
    chemistry INT DEFAULT 0,
    ecology INT DEFAULT 0,
    economics INT DEFAULT 0,
    struve_astronomy INT DEFAULT 0,    
    maxwell_physics INT DEFAULT 0,   
    euler_mathematics INT DEFAULT 0,     
    keldysh_computer_science INT DEFAULT 0, 
    PRIMARY KEY (municipality, stage)
);


INSERT INTO olympiad_all_2025 (
    municipality, stage,
    english_language, astronomy, biology, geography, computer_science,
    art, spanish_language, history, italian_language, chinese_language,
    literature, mathematics, german_language, social_studies,
    life_safety, law, russian_language, technology, physics,
    physical_education, french_language, chemistry, ecology, economics,
    struve_astronomy, maxwell_physics, euler_mathematics, keldysh_computer_science
)
SELECT
    municipality, 'ШЭ',
    english_language, astronomy, biology, geography, computer_science,
    art, spanish_language, history, italian_language, chinese_language,
    literature, mathematics, german_language, social_studies,
    life_safety, law, russian_language, technology, physics,
    physical_education, french_language, chemistry, ecology, economics,
    0, 0, 0, 0  
FROM olympiad_school_2025;

INSERT INTO olympiad_all_2025 (
    municipality, stage,
    english_language, astronomy, biology, geography, computer_science,
    art, spanish_language, history, italian_language, chinese_language,
    literature, mathematics, german_language, social_studies,
    life_safety, law, russian_language, technology, physics,
    physical_education, french_language, chemistry, ecology, economics,
    struve_astronomy, maxwell_physics, euler_mathematics, keldysh_computer_science
)
SELECT
    municipality, 'МЭ',
    english_language, astronomy, biology, geography, computer_science,
    art, spanish_language, history, italian_language, chinese_language,
    literature, mathematics, german_language, social_studies,
    life_safety, law, russian_language, technology, physics,
    physical_education, french_language, chemistry, ecology, economics,
    0, 0, 0, 0
FROM olympiad_municipal_2025;

INSERT INTO olympiad_all_2025 (
    municipality, stage,
    english_language, astronomy, biology, geography, computer_science,
    art, spanish_language, history, italian_language, chinese_language,
    literature, mathematics, german_language, social_studies,
    life_safety, law, russian_language, technology, physics,
    physical_education, french_language, chemistry, ecology, economics,
    struve_astronomy, maxwell_physics, euler_mathematics, keldysh_computer_science
)
SELECT
    municipality, 'РЭ',
    english_language, astronomy, biology, geography, computer_science,
    art, spanish_language, history, italian_language, chinese_language,
    literature, mathematics, german_language, social_studies,
    life_safety, law, russian_language, technology, physics,
    physical_education, french_language, 0, ecology, economics,
    struve_astronomy, maxwell_physics, euler_mathematics, keldysh_computer_science
FROM olympiad_regional_2025;

INSERT INTO olympiad_all_2025 (
    municipality, stage,
    english_language, astronomy, biology, geography, computer_science,
    art, spanish_language, history, italian_language, chinese_language,
    literature, mathematics, german_language, social_studies,
    life_safety, law, russian_language, technology, physics,
    physical_education, french_language, chemistry, ecology, economics,
    struve_astronomy, maxwell_physics, euler_mathematics, keldysh_computer_science
)
SELECT
    municipality, 'ЗЭ',
    english_language, astronomy, biology, geography, computer_science,
    art, spanish_language, history, italian_language, chinese_language,
    literature, mathematics, german_language, social_studies,
    life_safety, law, russian_language, technology, physics,
    physical_education, french_language, chemistry, ecology, economics,
    struve_astronomy, maxwell_physics, euler_mathematics, keldysh_computer_science
FROM olympiad_final_2025;

INSERT INTO olympiad_all_2025 (
    municipality, stage,
    chemistry
)
SELECT
    municipality, 'Р',
    chemistry
FROM olympiad_results_2025;

SELECT * FROM olympiad_all_2025;

--3.3.1
SELECT biology, COUNT(*) AS freq
FROM olympiad_all_2025
GROUP BY biology
ORDER BY biology;

-- 3.3.2

SELECT stage, round(AVG(science_total),1) AS avg_science_participants
FROM (
    SELECT stage, municipality,
           (astronomy + biology + physics + chemistry + ecology) AS science_total
    FROM olympiad_all_2025
) AS sub
GROUP BY stage;

-- 3.4.1
SELECT 
    english_language, german_language,
    COUNT(*) AS cnt
FROM olympiad_all_2025
WHERE english_language > 10 
   OR german_language > 10 
   OR french_language > 10
GROUP BY english_language, german_language
ORDER BY cnt DESC;

SELECT DISTINCT stage, municipality
FROM olympiad_all_2025
ORDER BY stage, municipality;

SELECT stage, COUNT(DISTINCT municipality) AS municipalities_count
FROM olympiad_all_2025
GROUP BY stage
ORDER BY stage;

--3.5.1
SELECT 
    municipality,
    stage,
    mathematics,
    physics,
    computer_science,
    CASE 
        WHEN exact_sciences_sum = 0 THEN 'нет участия в точных науках'
        WHEN exact_sciences_sum BETWEEN 1 AND 10 THEN 'низкая активность'
        WHEN exact_sciences_sum BETWEEN 11 AND 30 THEN 'средняя активность'
        ELSE 'высокая активность'
    END AS exact_sciences_category
FROM (
    SELECT *,
           (COALESCE(mathematics, 0) + COALESCE(physics, 0) + 
            COALESCE(computer_science, 0) + COALESCE(euler_mathematics, 0) + 
            COALESCE(maxwell_physics, 0) + COALESCE(keldysh_computer_science, 0)) AS exact_sciences_sum
    FROM olympiad_all_2025
) AS sub
ORDER BY exact_sciences_sum DESC;


--3.5.2

SELECT 
    municipality,
    stage,
    biology,
    chemistry,
    CASE WHEN biology > 3 THEN 1 ELSE 0 END AS flag_high_biology,
    CASE WHEN chemistry > 3 THEN 1 ELSE 0 END AS flag_high_chemistry,
    CASE WHEN biology > 3 AND chemistry > 3 THEN 1 ELSE 0 END AS flag_both_sciences
FROM olympiad_all_2025
ORDER BY municipality, stage;


--3.5.3

SELECT 
    municipality,
    stage,
    physics,
    CAST(physics AS DECIMAL(10,1)) AS physics_decimal,
    computer_science,
    CAST(computer_science AS FLOAT) AS cs_float,
    (physics + computer_science)::TEXT AS total_text
FROM olympiad_all_2025;

--3.5.4

SELECT 
    municipality,
    stage,
    COALESCE(physics, 0) AS physics_no_null,
    COALESCE(chemistry, 0) AS chemistry_no_null,
    COALESCE(biology, 0) AS biology_no_null
FROM olympiad_all_2025;

