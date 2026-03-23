SELECT 
    "Название вакансии",
    "Название специальности",
    COUNT(*) OVER(PARTITION BY "Название специальности") as "Всего таких"
FROM vacancies
WHERE 
    "Название вакансии" ILIKE '%учитель%'
    OR "Название вакансии" ILIKE '%преподаватель%'
    OR "Название вакансии" ILIKE '%педагог%'
    OR "Название вакансии" ILIKE '%репетитор%'
    OR "Название вакансии" ILIKE '%воспитатель%'
    OR "Название вакансии" ILIKE '%методист%';

  DELETE FROM vacancies
WHERE NOT (
    "Название вакансии" ILIKE '%учитель%'
    OR "Название вакансии" ILIKE '%преподаватель%'
    OR "Название вакансии" ILIKE '%педагог%'
    OR "Название вакансии" ILIKE '%репетитор%'
    OR "Название вакансии" ILIKE '%воспитатель%'
    OR "Название вакансии" ILIKE '%методист%'
);
SELECT COUNT(*) FROM vacancies;
SELECT DISTINCT "Название специальности", COUNT(*) AS "Кол-во"
FROM vacancies
GROUP BY "Название специальности"
ORDER BY "Кол-во" DESC;


-- Задание 3.3.1

SELECT "Название вакансии", COUNT(*) AS "Частота"
FROM vacancies
GROUP BY "Название вакансии"
ORDER BY "Частота" DESC;


-- Задание 3.3.1


SELECT "Заработная плата", COUNT(*) AS "Количество вакансий"
FROM vacancies
GROUP BY "Заработная плата"
ORDER BY "Заработная плата" DESC;

-- 3.3.2

SELECT "Опыт работы", AVG("Кол_во_вакансий") AS "Среднее кол-во вакансий"
FROM (
    SELECT "Опыт работы", COUNT("Название вакансии") AS "Кол_во_вакансий"
    FROM vacancies
    GROUP BY "Опыт работы"
) AS a
GROUP BY "Опыт работы"
ORDER BY "Среднее кол-во вакансий" DESC;

-- 3.4.1
SELECT COUNT(*)
FROM (
    SELECT "Название вакансии", "Описание вакансии", COUNT(*) AS records
    FROM vacancies
    GROUP BY "Название вакансии", "Описание вакансии"
) AS a
WHERE records > 1;

-- Задание 3.4.2

SELECT DISTINCT "Название вакансии", "Описание вакансии", "Опыт работы", "Заработная плата"
FROM vacancies
ORDER BY "Название вакансии";

-- Задание 3.4.2

SELECT "Название вакансии", "Описание вакансии", "Опыт работы", "Заработная плата"
FROM vacancies
GROUP BY "Название вакансии", "Описание вакансии", "Опыт работы", "Заработная плата"
ORDER BY "Название вакансии";


-- Задание 3.5.1

SELECT
    "Название вакансии",
    "Опыт работы",
    "Заработная плата",
    CASE
        WHEN "Заработная плата" = 0 THEN 'Не указана'
        WHEN "Заработная плата" > 0 AND "Заработная плата" <= 50000 THEN 'Низкая'
        WHEN "Заработная плата" > 50000 AND "Заработная плата" <= 150000 THEN 'Средняя'
        WHEN "Заработная плата" > 150000 THEN 'Высокая'
    END AS "Категория зарплаты"
FROM gamidov_dv.vacancies
ORDER BY "Заработная плата" DESC;

-- Задание 3.5.2


SELECT
    "Название вакансии",
    "Заработная плата",
    CASE WHEN "Заработная плата" > 0 THEN 1 ELSE 0 END AS "Флаг_зарплата"
FROM gamidov_dv.vacancies
ORDER BY "Флаг_зарплата" DESC;

-- Задание 3.5.2

SELECT
    "Название вакансии",
    "Опыт работы",
    "Заработная плата",
    CASE
        WHEN "Заработная плата" > 150000 AND "Опыт работы" = '3-6' THEN 1
        ELSE 0
    END AS "Флаг_топ_вакансия"
FROM gamidov_dv.vacancies
ORDER BY "Флаг_топ_вакансия" DESC;

-- Задание 3.5.3


SELECT
    "Название вакансии",
    "Заработная плата",
    CAST("Заработная плата" AS INTEGER) AS "Зарплата_целое"
FROM gamidov_dv.vacancies
ORDER BY "Заработная плата" DESC;

-- Задание 3.5.3


SELECT
    "Муниципалитет",
    "Математика_ЗЭ_2025",
    CAST("Математика_ЗЭ_2025" AS INTEGER) AS "в_целое",
    CAST("Математика_ЗЭ_2025" AS TEXT) AS "в_текст",
    ROUND("Математика_ЗЭ_2025", 2) AS "округление",
    CAST("Математика_ЗЭ_2025" AS NUMERIC(10,1)) AS "в_numeric"
FROM gamidov_dv.ze_2025 
ORDER BY "Математика_ЗЭ_2025" DESC;

-- Задание 3.5.4


SELECT
    "Название вакансии",
    COALESCE("Ключевые навыки", 'Не указаны') AS "Ключевые навыки"
FROM gamidov_dv.vacancies
ORDER BY "Название вакансии";

-- Задание 3.5.4

SELECT
    "Название вакансии",
    "Заработная плата",
    NULLIF("Заработная плата", 0) AS "Зарплата_без_нулей"  -- исправлено: сравниваем с 0, а не с null
FROM gamidov_dv.vacancies
ORDER BY "Название вакансии";

-- Задание 3.5.5


SELECT
    COUNT(*) AS "Всего строк",
    COUNT("Ключевые навыки") AS "Заполнено навыков",
    COUNT(*) - COUNT("Ключевые навыки") AS "Пропусков в навыках",
    COUNT("Заработная плата") AS "Заполнено зарплат",
    COUNT(*) - COUNT("Заработная плата") AS "Пропусков в зарплате"
FROM gamidov_dv.vacancies;

-- Задание 3.5.5


SELECT
    "Название вакансии",
    CASE
        WHEN "Ключевые навыки" IS NULL THEN 'Не указаны'
        ELSE "Ключевые навыки"
    END AS "Ключевые навыки"
FROM gamidov_dv.vacancies
ORDER BY "Название вакансии";

-- Задание 3.5.5


WITH avg_salary AS (
    SELECT AVG("Заработная плата") as avg_sal
    FROM gamidov_dv.vacancies
    WHERE "Заработная плата" > 0
)
SELECT
    "Название вакансии",
    "Заработная плата",
    CASE
        WHEN "Заработная плата" = 0 THEN ROUND((SELECT avg_sal FROM avg_salary), 0)
        ELSE "Заработная плата"
    END AS "Зарплата_восстановленная"
FROM gamidov_dv.vacancies
ORDER BY "Название вакансии";