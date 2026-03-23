-- 3.1.	Подготовка данных
-- 3.1.1. Импортируйте набор данных о землетрясениях (2010-2020 гг)
--        Создайте таблицу со следующей структурой
create table earthquakes
(
time timestamp
,latitude decimal
,longitude decimal
,depth decimal
,mag decimal
,magType varchar
,nst decimal
,gap decimal
,dmin decimal
,rms decimal
,net varchar
,id varchar
,updated timestamp
,place varchar
,type varchar
,horizontalError decimal
,depthError decimal
,magError decimal
,magNst decimal
,status varchar
,locationSource varchar
,magSource varchar
);

-- Импортируйте данные согласно своему варианту
-- (вариант 1,6,11,16,21,26 (1-3),
-- вариант 2,7,12,17,22,27 (4-6),
-- вариант 3,8,13,18,23,28 (7-9),
-- вариант 4,9,14,19,24,29 (10-12),
-- вариант 5,10,15,20,25,30 (13-15))
-- Землетрясения вызываются скольжением пород вдоль разломов тектонических плит, в места вблизи разломов землетрясения проходят чаще. 
-- Магнитуда – это мера силы землетрясения в его очаге, записывается по шкале десятичного логарифма.
select * from earthquakes limit 20;
select count(*) from earthquakes;

-- 3.2.	Поиск аномалий
-- Сортировка и произвольная группировка данных с последующим визуальным просмотром результатов – это удобный способ выявления аномалий,
--особенно когда в данных присутствуют очень экстремальные значения.
-- 3.2.1. Сортировка данных – напишите запрос на получение данных о магнитуде землетрясения (mag) по убыванию значения с исключением null значений
select time, place, mag, depth, status
from earthquakes
where mag is not null
order by mag desc limit 20;

-- 3.2.2. Подсчитаем количество значений и сгруппируем по полю mag для нахождения количества землетрясений по каждой магнитуде. Построим график
select mag, count(*) as earthquakes_count
from earthquakes
where mag is not null
group by mag
order by mag;

-- 3.2.3. Найдём наименьшие показатели магнитуды (отсортируем в обратном порядке), отрицательные значения, полученные в результате, 
-- будем также считать аномалиями (чрезвычайно малые магнитуды). Исключим их.
select time, place, mag
from earthquakes
where mag < 0
order by mag asc; -- поиск аномалий


select time, place, mag
from earthquakes
where mag is not null
and mag >= 0
order by mag asc; -- исключаем аномальные отрицательные магнитуды

-- 3.2.4. Сгруппируем по нескольким атрибутам, чтобы найти аномалии в подмножествах данных (проанализируйте пример со с.261).
select
    status,
    magtype,
    mag,
    count(id) as earthquakes,
    round(count(id) * 100.0 / sum(count(id)) over (partition by status, magtype), 8) as pct_earthquakes -- общее число записей внутри каждого подмножества
from earthquakes
where mag is not null
and status is not null
and magtype is not null
group by status, magtype, mag
order by status, magtype, mag desc;

-- 3.3.	Расчёт процентилей и стандартных отклонений
-- Количественная оценка экстремальности точек данных поднимет точность анализа.
-- Методы: с помощью процентилей или с помощью стандартных отклонений. Процентили представляют собой процент точек в распределении, которые меньше определенного значения.
-- Медиана распределения или 50-й процентиль — это значение, относительно которого половина точек имеет меньшее значение, а вторая половина — большее.
-- 3.3.1. Расчёт процентилей
-- С помощью оконной функции вычислите процентиль магнитуды каждого землетрясения для конкретного места (с.269). Сделайте выводы по полученным данным.
-- Что означает процентиль 0 и 1?
-- percent_rank() over (partition by ... order by...)
select distinct place from earthquakes;

select
    place,
    mag,
    percentile,
    count(*) as earthquakes_count
from
(
    select
        place,
        mag,
        percent_rank() over (
            partition by place
            order by mag
        ) as percentile
    from earthquakes
    where mag is not null
	  and place ilike '%Peru%'
) a
group by 1, 2, 3
order by 1,2 desc;

-- 0 — минимальное значение в группе (если в группе всего одна строка, то она одна и получает 0);
-- 1 — максимальное значение в группе.


-- С помощью ntile разбейте набор данных на 4 интервала, по каждому интервалу найдите максимальное и минимальное значения (с.271).
select
    place,
    ntile,
    max(mag) as maximum,
    min(mag) as minimum
from
(
    select
        place,
        mag,
        ntile(4) over (
            partition by place
            order by mag
        ) as ntile
    from earthquakes
    where mag is not null
      and place = 'Central Alaska'
) a
group by 1, 2
order by 1, 2 desc;

-- Рассчитаем конкретный процентиль по всем результата запроса, для этого используем функцию (с.272). Разберитесь с синтаксисом данной функции.
select
    percentile_cont(0.25) within group (order by mag) as pct_25,
    percentile_cont(0.50) within group (order by mag) as pct_50,
    percentile_cont(0.75) within group (order by mag) as pct_75
from earthquakes
where mag is not null
  and place = 'Central Alaska';

-- percentile_cont (numeric) within group (order by field_name) over (partition by field_name)
-- Вычислите медиану по предыдущему запросу.
select
    percentile_cont(0.5) within group (order by mag) as median_mag
from earthquakes
where mag is not null
  and place = 'Central Alaska';

-- 3.3.2. Расчёт отклонений
-- Чтобы определить, насколько экстремальными являются значения в наборе данных, мы можем использовать стандартное отклонение. 
-- Стандартное отклонение — это показатель вариативности набора значений. 
-- Когда данные имеют нормальное распределение, около 68% всех значений лежат в пределах +/- одно стандартное отклонение от среднего значения,
-- а около 95% — в пределах +/- два стандартных отклонения.   , где х - наблюдение, и - среднее арифметическое всех наблюдений, а N - количество наблюдений.
-- Меньшее значение этого показателя означает меньшую вариативность, и наоборот.
-- В большинстве баз данных реализовано три функции стандартного отклонения. Функция stddev_pop возвращает стандартное отклонение всей совокупности. 
-- Функция stddev_samp находит стандартное отклонение для выборки и отличается от приведенной выше формулы делением на N - 1 вместо N.

-- Выведите результат сравнения работы двух функций для расчёта отклонений
select
    stddev_pop(mag) as stddev_pop_mag,
    stddev_samp(mag) as stddev_samp_mag
from earthquakes
where mag is not null;

-- Рассчитаем на сколько стандартных отклонений значение из набора данных удалено от среднего значения (z-оценка) – с.275-276. 
-- Сделайте выводы. Найдите минимальное и максимальное значение z-оценки.
select
    a.place,
    a.mag,
    b.avg_mag,
    b.std_dev,
    (a.mag - b.avg_mag) / b.std_dev as z_score
from earthquakes a
join
(
    select
        avg(mag) as avg_mag,
        stddev_pop(mag) as std_dev
    from earthquakes
    where mag is not null
) b on 1 = 1
where a.mag is not null
order by 2 desc;

-- Значения, которые выше среднего, имеют положительную z-оценку, а те, которые ниже среднего, — отрицательную z-оценку.


-- 3.4.	Поиск аномалий с помощью графиков
-- Одним из достоинств графиков является их способность обобщать и представлять множество точек данных в компактной форме.
-- Анализируя графики, мы можем заметить закономерности и отклонения от нормы, которые могли бы пропустить, если бы рассматривали только исходные данные.
-- 3.4.1. Построение гистограмм
-- Гистограмма используется для построения распределения значений и удобна как для знакомства с данными, так и для обнаружения выбросов.
-- По оси х откладывается полный диапазон значений поля, а по оси у - количество повторений каждого значения. 
-- Интересны самые высокие и самые низкие значения, а также форма графика. 
-- Мы можем быстро определить, является ли распределение близким к нормальному 
-- (симметричным относительно пика или среднего значения), или имеет другой тип распределения или дополнительные пики при каких-то значениях.
--   Постройте гистограмму амплитуд землетрясений, сделайте выводы.
--   Увеличьте фрагмент графика с наибольшей магнитудой, сделайте выводы (с.278). 
select
    mag,
    count(*) as earthquakes_count
from earthquakes
where mag is not null
group by mag
order by mag;

-- 3.4.2. Построение диаграммы рассеивания
-- Диаграмма рассеяния подходит, когда набор данных содержит как минимум два числовых поля, которые представляют интерес.
-- По оси х откладывают значения первого поля, по оси у - значения второго поля, и для каждой пары значений х и у из набора данных на график наносится точка.
-- Построим график зависимости магнитуды от глубины землетрясений
select
    depth,
    mag
from earthquakes
where depth is not null
  and mag is not null
order by depth; -- Диаграмма рассеивания

-- 3.4.3. Построение диаграммы размаха
-- Диаграмма размаха, также известная как «ящик с усами». Этот график обобщает данные в середине диапазона значений, сохраняя при этом выбросы. 
-- Тип графика назван так из-за прямоугольника в центре. 
-- Нижняя сторона прямоугольника расположена на уровне 25-го процентиля, верхняя сторона — на уровне 75-го процентиля, 
-- а линия в середине — на уровне 50-го процентиля или медианы. Процентили мы разбирали в предыдущем разделе. 
-- «Усы» ящика — это линии, выходящие за пределы прямоугольника, обычно в 1.5 раза превышающие межквартильный размах. 
-- Межквартильный размах — это разница между 75-м и 25-м процентилями. Любые значения, выходящие за границы усов, отображаются на графике как выбросы.
-- Постройте диаграмму размаха по месяцам года, для которого Вы делаете анализ (c.282), сделайте выводы.
select
    extract(month from time) as month_num,
    mag
from earthquakes
where mag is not null
  and time is not null
  and extract(year from time) = 2020
order by month_num, mag; -- Ящик с усами

-- 3.5. Нахождение аномальных значений
-- 3.5.1. Частота 
-- События, которые происходят с необычной частотой в течение короткого промежутка времени, могут указывать на аномальную активность.
-- Найдите количество землетрясений по месяцам (с.290)
select
    date_trunc('month', time)::date as earthquake_month,
    count(*) as earthquakes
from earthquakes
where time is not null
group by 1
order by 1;

-- Выведите динамику изменения количества землетрясений со статусами 'automatic', 'reviewed'. Постройте график.
select
    date_trunc('month', time)::date as earthquake_month,
    count(*) filter (where status = 'automatic') as automatic,
    count(*) filter (where status = 'reviewed') as reviewed
from earthquakes
where time is not null
group by 1
order by 1;

-- Аномальное отсутствие данных. Постройте запрос (с.294), 
-- чтобы найти временные промежутки между крупными землетрясениями и время, прошедшее с момента последнего землетрясения.
-- Сделайте выводы
select
    place,
    extract(days from timestamp '2020-12-31 23:59:59' - latest) as days_since_latest,
    count(*) as earthquakes,
    extract(days from avg(gap)) as avg_gap,
    extract(days from max(gap)) as max_gap
from
(
    select
        place,
        time,
        lead(time) over (
            partition by place
            order by time
        ) as next_time,
        lead(time) over (
            partition by place
            order by time
        ) - time as gap,
        max(time) over (
            partition by place
        ) as latest
    from
    (
        select
            replace(
                initcap(
                    case
                        when place ~ ', [A-Z]' then split_part(place, ', ', 2)
                        when place like '% of %' then split_part(place, ' of ', 2)
                        else place
                    end
                ),
                'Region',
                ''
            ) as place,
            time
        from earthquakes
        where mag > 5
          and time is not null
    ) a
) a
group by 1, 2
order by 1;


-- 3.6. Работа с аномальными значениями
-- Если есть основания подозревать, что при сборе данных была допущена ошибка, которая может повлиять на результаты, удаление будет уместным.
-- 3.6.1. Исключение аномальных значений. 
-- Исключим записи в диапазоне от -9,99 до -9
select
    time,
    mag,
    type
from earthquakes
where mag not between -9.99 and -9
limit 100;

-- Вычислим среднее значение по всему набору данных и среднее значение без учета экстремально низких значений магнитуды (с.297)
select avg(mag) as avg_mag,
avg(case when mag > -9 then mag end) as avg_mag_adjusted
from earthquakes;

-- 3.6.2. Замена на альтернативные значения
-- Ранее мы видели, ЧТО null1-значения можно заменить значением по умолчанию с помощью функции coalesce. Если значения не обязательно равны null, но являются проблемными по какой-то другой причине, можно использовать оператор CASE для замены на значение по умолчанию.
-- Сгруппируем аномальные значения в отдельную группу (c.298)
select
    case
        when type = 'earthquake' then type
        else 'other'
    end as event_type,
    count(*) as count
from earthquakes
group by 1
order by 2 desc;

-- 3.6.3. Замена значений
-- Винсоризация - это специальный метод, при котором выбросы заменяются на определенный процентиль данных.
-- Выполните винсоризацию (с.299)
select
    percentile_cont(0.95) within group (order by mag) as percentile_95,
    percentile_cont(0.05) within group (order by mag) as percentile_05
from earthquakes
where mag is not null;


with percentiles as (
    select
        percentile_cont(0.95) within group (order by mag) as percentile_95,
        percentile_cont(0.05) within group (order by mag) as percentile_05
    from earthquakes
    where mag is not null
)
select
    time,
    place,
    mag as original_mag,
    case
        when mag < percentile_05 then percentile_05
        when mag > percentile_95 then percentile_95
        else mag
    end as winsorized_mag
from earthquakes
cross join percentiles
where mag is not null
order by time
limit 100;

-- 3.6.4. Изменение масштаба значений
-- Вместо того чтобы отфильтровывать записи или изменять значения выбросов, можно изменить масштаб значений, что обеспечит сохранение всех значений, но упростит анализ и построение графиков.
-- Разберитесь с примером (с.301)
select
    round(depth, 1) as depth,
    log(round(depth, 1)) as log_depth,
    count(*) as earthquakes
from earthquakes
where depth >= 0.05
group by 1, 2
order by 1;
