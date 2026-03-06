-- Задание 3.3.1
-- Гистограмма 1: частота значений без дубликатов
-- Таблица olympiad_all_2025: суммарное количество участников по математике на всех этапах

SELECT municipality, SUM(mathematics) AS "Всего участников по математике"
FROM olympiad_all_2025
GROUP BY municipality
ORDER BY "Всего участников по математике" DESC;

-- Задание 3.3.1
-- Гистограмма 2: визуализация числовых значений
-- Таблица olympiad_all_2025: распределение участников по математике на всех этапах

SELECT stage, SUM(mathematics) AS "Всего участников по математике"
FROM olympiad_all_2025
GROUP BY stage
ORDER BY "Всего участников по математике" DESC;

-- Задание 3.3.2
-- Агрегирование с подсчётом частоты
-- Подзапрос считает участников по математике на каждом этапе для каждого муниципалитета,
-- внешняя агрегация считает среднее по всем этапам

SELECT municipality, ROUND(AVG("Участников"), 1) AS "Среднее участников по математике"
FROM (
    SELECT municipality, stage, mathematics AS "Участников"
    FROM olympiad_all_2025
) AS a
GROUP BY municipality
ORDER BY "Среднее участников по математике" DESC;

-- Задание 3.4.1
-- Поиск дубликатов в таблице olympiad_all_2025
-- С применением группировки и упорядочивания по столбцам

SELECT COUNT(*)
FROM (
    SELECT municipality, stage, COUNT(*) AS records
    FROM olympiad_all_2025
    GROUP BY municipality, stage
) AS a
WHERE records > 1;

-- Задание 3.4.2
-- Исключение дубликатов с помощью DISTINCT
-- Таблица olympiad_all_2025: уникальные комбинации муниципалитет + этап

SELECT DISTINCT municipality, stage, mathematics, physics, chemistry
FROM olympiad_all_2025
ORDER BY municipality;

-- Задание 3.4.2
-- Исключение дубликатов с помощью GROUP BY
-- Таблица olympiad_all_2025: уникальные комбинации муниципалитет + этап

SELECT municipality, stage, mathematics, physics, chemistry
FROM olympiad_all_2025
GROUP BY municipality, stage, mathematics, physics, chemistry
ORDER BY municipality;

-- Задание 3.5.1
-- Очистка данных с помощью CASE
-- Таблица olympiad_all_2025: категоризация муниципалитетов по уровню участия в математике

SELECT
    municipality,
    stage,
    mathematics,
    CASE
        WHEN mathematics = 0 THEN 'Нет участников'
        WHEN mathematics > 0 AND mathematics <= 5 THEN 'Низкий уровень'
        WHEN mathematics > 5 AND mathematics <= 15 THEN 'Средний уровень'
        WHEN mathematics > 15 THEN 'Высокий уровень'
    END AS "Категория"
FROM olympiad_all_2025
ORDER BY mathematics DESC;

-- Задание 3.5.2
-- Флаг 1: наличие или отсутствие участников по физике
-- Таблица olympiad_all_2025

SELECT
    municipality,
    stage,
    physics,
    CASE WHEN physics > 0 THEN 1 ELSE 0 END AS "Флаг_физика"
FROM olympiad_all_2025
ORDER BY "Флаг_физика" DESC;

-- Задание 3.5.2
-- Флаг 2: сложное условие — если участников по математике больше 5
-- И по физике больше 5, тогда флаг 1
-- Таблица olympiad_all_2025

SELECT
    municipality,
    stage,
    mathematics,
    physics,
    CASE
        WHEN mathematics > 5 AND physics > 5 THEN 1
        ELSE 0
    END AS "Флаг_топ_муниципалитет"
FROM olympiad_all_2025
ORDER BY "Флаг_топ_муниципалитет" DESC;

-- Задание 3.5.2
-- Флаг 2: сложное условие — если участников по математике больше 5
-- И по физике больше 5, тогда флаг 1
-- Таблица olympiad_all_2025

SELECT
    municipality,
    stage,
    mathematics,
    physics,
    CASE
        WHEN mathematics > 5 AND physics > 5 THEN 1
        ELSE 0
    END AS "Флаг_топ_муниципалитет"
FROM olympiad_all_2025
ORDER BY "Флаг_топ_муниципалитет" DESC;

-- Задание 3.5.3
-- Преобразование типов: различные варианты
-- Таблица olympiad_all_2025: преобразование числовых значений математики

SELECT
    municipality,
    stage,
    mathematics,
    CAST(mathematics AS TEXT)            AS "в_текст",
    CAST(mathematics AS NUMERIC(10,2))   AS "в_numeric",
    ROUND(CAST(mathematics AS NUMERIC), 2) AS "округление"
FROM olympiad_all_2025
ORDER BY mathematics DESC;

-- Задание 3.5.4
-- COALESCE: сначала создаём NULL через NULLIF (нули → NULL),
-- затем COALESCE заменяет NULL на 'Нет участников'
-- Таблица olympiad_all_2025

SELECT
    municipality,
    stage,
    struve_astronomy,
    COALESCE(
        CAST(NULLIF(struve_astronomy, 0) AS TEXT),
        'Нет участников'
    ) AS "Струве_заполнено"
FROM olympiad_all_2025
ORDER BY municipality;

-- Задание 3.5.4
-- NULLIF: если участников по астрономии = 0, заменяем на NULL
-- Таблица olympiad_all_2025

SELECT
    municipality,
    stage,
    astronomy,
    NULLIF(astronomy, 0) AS "Астрономия_без_нулей"
FROM olympiad_all_2025
ORDER BY municipality;

-- Задание 3.5.5
-- Выявление пропусков в таблице olympiad_all_2025

SELECT
    COUNT(*) AS "Всего строк",
    COUNT(mathematics) AS "Заполнено математика",
    COUNT(*) - COUNT(mathematics) AS "Пропусков математика",
    COUNT(chemistry) AS "Заполнено химия",
    COUNT(*) - COUNT(chemistry) AS "Пропусков химия",
    COUNT(struve_astronomy) AS "Заполнено струве",
    COUNT(*) - COUNT(struve_astronomy) AS "Пропусков струве"
FROM olympiad_all_2025;

-- Задание 3.5.5
-- Заполнение пропусков постоянным значением
-- Таблица olympiad_all_2025: нули в итальянском языке сначала превращаем в NULL,
-- затем заменяем на 'Нет участников'

SELECT
    municipality,
    stage,
    CASE
        WHEN NULLIF(italian_language, 0) IS NULL THEN 'Нет участников'
        ELSE CAST(italian_language AS TEXT)
    END AS "Итальянский язык"
FROM olympiad_all_2025
ORDER BY municipality;

-- Задание 3.5.5
-- Заполнение пропусков средним значением по всем записям
-- Таблица olympiad_all_2025: нули по физике заменяем на среднее

SELECT
    municipality,
    stage,
    physics,
    CASE
        WHEN physics = 0 THEN ROUND(AVG(physics) OVER (), 2)
        ELSE CAST(physics AS NUMERIC)
    END AS "Физика_восстановленная"
FROM olympiad_all_2025
ORDER BY municipality;

-- Задание 3.5.6
-- Определение степени детализации данных
-- Таблица olympiad_all_2025: сколько уникальных значений в ключевых столбцах

SELECT
    COUNT(DISTINCT municipality)  AS "Уник. муниципалитетов",
    COUNT(DISTINCT stage)         AS "Уник. этапов",
    COUNT(DISTINCT mathematics)   AS "Уник. знач. математика",
    COUNT(DISTINCT physics)       AS "Уник. знач. физика",
    COUNT(DISTINCT chemistry)     AS "Уник. знач. химия",
    COUNT(*)                      AS "Всего строк"
FROM olympiad_all_2025;

-- Задание 3.5.6
-- Выравнивание данных: агрегация до 1 строки на муниципалитет
-- Таблица olympiad_all_2025: суммарное участие по всем этапам

SELECT
    municipality,
    SUM(mathematics)  AS "Всего по математике",
    SUM(physics)      AS "Всего по физике",
    SUM(chemistry)    AS "Всего по химии",
    AVG(mathematics)  AS "Среднее по математике",
    MAX(mathematics)  AS "Макс по математике"
FROM olympiad_all_2025
GROUP BY municipality
ORDER BY "Всего по математике" DESC;