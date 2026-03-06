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

-- Проверка корректности импорта
SELECT * FROM olympiad_all_2025;

--Постройте гистограмму на основе полученных данных о частоте значений без дубликатов (по своему усмотрению).
SELECT mathematics, COUNT(*) AS freq
FROM olympiad_all_2025
GROUP BY mathematics
ORDER BY mathematics;


--3.3.2.Агрегирование с подсчётом частоты
SELECT stage, round(AVG(total_participants),1) AS avg_total_participants
FROM (
    SELECT stage, municipality,
           (english_language + astronomy + biology + geography + computer_science +
            art + spanish_language + history + italian_language + chinese_language +
            literature + mathematics + german_language + social_studies +
            life_safety + law + russian_language + technology + physics +
            physical_education + french_language + chemistry + ecology + economics) AS total_participants
    FROM olympiad_all_2025
) AS sub
GROUP BY stage;

--3.4.1.Поиск дубликатов
SELECT 
    english_language, astronomy, biology, geography, computer_science,
    art, spanish_language, history, italian_language, chinese_language,
    literature, mathematics, german_language, social_studies,
    life_safety, law, russian_language, technology, physics,
    physical_education, french_language, chemistry, ecology, economics,
    struve_astronomy, maxwell_physics, euler_mathematics, keldysh_computer_science,
    COUNT(*) AS cnt
FROM olympiad_all_2025
GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28
HAVING COUNT(*) > 1
ORDER BY cnt DESC;

---Напишите запрос для нахождения данных без дубликатов с применением distinct

SELECT DISTINCT municipality, stage
FROM olympiad_all_2025
ORDER BY municipality, stage;

---Напишите запрос для нахождения данных без дубликатов с применением group by

SELECT municipality
FROM olympiad_all_2025
GROUP BY municipality
ORDER BY municipality;

--3.5.1.Очистка данных с помощью case

SELECT 
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
    keldysh_computer_science,
    CASE 
        WHEN subjects_count = 0 THEN 'нет участия'
        WHEN subjects_count BETWEEN 1 AND 5 THEN 'низкое разнообразие'
        WHEN subjects_count BETWEEN 6 AND 10 THEN 'среднее разнообразие'
        WHEN subjects_count BETWEEN 11 AND 15 THEN 'высокое разнообразие'
        ELSE 'очень высокое разнообразие'
    END AS diversity_category
FROM (
    SELECT *,
        (CASE WHEN english_language > 0 THEN 1 ELSE 0 END +
         CASE WHEN astronomy > 0 THEN 1 ELSE 0 END +
         CASE WHEN biology > 0 THEN 1 ELSE 0 END +
         CASE WHEN geography > 0 THEN 1 ELSE 0 END +
         CASE WHEN computer_science > 0 THEN 1 ELSE 0 END +
         CASE WHEN art > 0 THEN 1 ELSE 0 END +
         CASE WHEN spanish_language > 0 THEN 1 ELSE 0 END +
         CASE WHEN history > 0 THEN 1 ELSE 0 END +
         CASE WHEN italian_language > 0 THEN 1 ELSE 0 END +
         CASE WHEN chinese_language > 0 THEN 1 ELSE 0 END +
         CASE WHEN literature > 0 THEN 1 ELSE 0 END +
         CASE WHEN mathematics > 0 THEN 1 ELSE 0 END +
         CASE WHEN german_language > 0 THEN 1 ELSE 0 END +
         CASE WHEN social_studies > 0 THEN 1 ELSE 0 END +
         CASE WHEN life_safety > 0 THEN 1 ELSE 0 END +
         CASE WHEN law > 0 THEN 1 ELSE 0 END +
         CASE WHEN russian_language > 0 THEN 1 ELSE 0 END +
         CASE WHEN technology > 0 THEN 1 ELSE 0 END +
         CASE WHEN physics > 0 THEN 1 ELSE 0 END +
         CASE WHEN physical_education > 0 THEN 1 ELSE 0 END +
         CASE WHEN french_language > 0 THEN 1 ELSE 0 END +
         CASE WHEN chemistry > 0 THEN 1 ELSE 0 END +
         CASE WHEN ecology > 0 THEN 1 ELSE 0 END +
         CASE WHEN economics > 0 THEN 1 ELSE 0 END +
         CASE WHEN struve_astronomy > 0 THEN 1 ELSE 0 END +
         CASE WHEN maxwell_physics > 0 THEN 1 ELSE 0 END +
         CASE WHEN euler_mathematics > 0 THEN 1 ELSE 0 END +
         CASE WHEN keldysh_computer_science > 0 THEN 1 ELSE 0 END) AS subjects_count
    FROM olympiad_all_2025
) AS sub
ORDER BY municipality, stage;

--3.5.2.Очистка с помощью флагов
SELECT 
    municipality,
    stage,
    CASE WHEN english_language > 0 THEN 1 ELSE 0 END AS flag_english,
    CASE WHEN astronomy > 0 THEN 1 ELSE 0 END AS flag_astronomy
FROM olympiad_all_2025;

---Добавьте более сложное условие для создания флагов, например, количество участий в олимпиаде по математике больше 5, тогда флаг 1.

SELECT 
    municipality,
    stage,
    mathematics,
    CASE WHEN mathematics > 5 THEN 1 ELSE 0 END AS flag_math
FROM olympiad_all_2025
ORDER BY municipality, stage;

--3.5.3.Преобразование типов

SELECT 
    municipality,
    stage,
    mathematics,
    CAST(mathematics as NUMERIC(10,2)) AS math_float
FROM olympiad_all_2025;

--3.5.4.Работа с null значениями – замените NULL значения на по своему усмотрению
SELECT 
    municipality,
    COALESCE(english_language, 0),
    COALESCE(mathematics, 0),
    COALESCE(russian_language, 0)
FROM olympiad_all_2025;

SELECT 
    municipality,
	stage,
    COALESCE(NULLIF(english_language::text, '0'),'нет участников'),
    COALESCE(NULLIF(mathematics::text, '0'),'нет участников'),
    COALESCE(NULLIF(astronomy::text, '0'),'нет участников'),
	 COALESCE(NULLIF(biology::text, '0'),'нет участников'),
	  COALESCE(NULLIF(russian_language::text, '0'),'нет участников'),
	   COALESCE(NULLIF(geography::text, '0'),'нет участников'),
	    COALESCE(NULLIF(computer_science::text, '0'),'нет участников'),
		 COALESCE(NULLIF(art::text, '0'),'нет участников'),
		 COALESCE(NULLIF(spanish_language::text, '0'),'нет участников'),
		 COALESCE(NULLIF(history::text, '0'),'нет участников'),
		 COALESCE(NULLIF(italian_language::text, '0'),'нет участников'),
		 COALESCE(NULLIF(chinese_language::text, '0'),'нет участников'),
		 COALESCE(NULLIF(literature::text, '0'),'нет участников'),
		 COALESCE(NULLIF(german_language::text, '0'),'нет участников'),
		 COALESCE(NULLIF(social_studies::text, '0'),'нет участников'),
		 COALESCE(NULLIF(life_safety::text, '0'),'нет участников'),
		 COALESCE(NULLIF(law::text, '0'),'нет участников'),
		 COALESCE(NULLIF(technology::text, '0'),'нет участников'),
		 COALESCE(NULLIF(physics::text, '0'),'нет участников'),
		 COALESCE(NULLIF(physical_education::text, '0'),'нет участников'),
		 COALESCE(NULLIF(french_language::text, '0'),'нет участников'),
		 COALESCE(NULLIF(chemistry::text, '0'),'нет участников'),
		 COALESCE(NULLIF(ecology::text, '0'),'нет участников'),
		 COALESCE(NULLIF(economics::text, '0'),'нет участников'),
		 COALESCE(NULLIF(struve_astronomy::text, '0'),'нет участников'),
		 COALESCE(NULLIF(maxwell_physics::text, '0'),'нет участников'),
		 COALESCE(NULLIF(euler_mathematics::text, '0'),'нет участников'),
		 COALESCE(NULLIF(keldysh_computer_science::text, '0'),'нет участников')
FROM olympiad_all_2025;

CREATE OR REPLACE FUNCTION nvl(anyelement, anyelement)
RETURNS anyelement AS $$
BEGIN
    RETURN COALESCE($1, $2);
END;
$$ LANGUAGE plpgsql;

SELECT 
    municipality,
    nvl(NULLIF(english_language::TEXT, '0'), 'нет данных'),
    nvl(NULLIF(mathematics::TEXT, '0'), 'нет данных'),
    nvl(NULLIF(russian_language::TEXT, '0'), 'нет данных')
FROM olympiad_all_2025;

--3.5.5.Отсутствующие данные

WITH avg_values AS (
    SELECT 
        AVG(english_language) as avg_eng,
        AVG(mathematics) as avg_math,
        AVG(russian_language) as avg_rus
    FROM olympiad_all_2025
	GROUP BY stage
)
SELECT DISTINCT
    municipality, stage,
    COALESCE(NULLIF(english_language,0), avg_eng::INT) as english,
    COALESCE(NULLIF(mathematics,0), avg_math::INT) as math,
    COALESCE(NULLIF(russian_language,0), avg_rus::INT) as russian
FROM olympiad_all_2025, avg_values;

