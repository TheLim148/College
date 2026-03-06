-- 4.1.1. Вывести список авторов с количеством написанных книг и итоговым значением, подписанным как Всего.
create extension if not exists tablefunc;

select coalesce(a.lastname, 'всего') as author_lastname, count(b.bshifr) as books_count
from author a
left join book b on b.id_author = a.id
group by rollup (a.lastname)
order by (a.lastname is null), a.lastname;

-- 4.1.2. По каждому изданию книги найдите среднюю стоимость и общую среднюю стоимость.
select coalesce(b.publishing, 'всего') as publishing, round(avg(b.price)::numeric, 2) as avg_price
from book b
group by rollup (b.publishing)
order by (b.publishing is null), b.publishing;

-- 4.1.3. (grouping) Найти сколько книг каждому жанру у каждого автора.
select coalesce(a.lastname, 'итого по всем') as author_lastname, coalesce(b.section, 'итого по автору') as section, count(*) as books_count,
    case
        when grouping(a.lastname)=1 and grouping(b.section)=1 then 'итого по всем'
        when grouping(b.section)=1 then 'итого по автору'
        else 'по разделу'
    end as grouping_type
from author a
join book b on b.id_author = a.id
group by rollup (a.lastname, b.section)
order by (a.lastname is null), a.lastname, (b.section is null), b.section;

-- 4.1.4. (group by cube) Найти сколько книг взято пользователем каждого автора.
select coalesce(u.lastname, 'итого') as user_lastname, coalesce(a.lastname, 'итого') as author_lastname,
    count(*) as issued_count,
    case
        when grouping(u.lastname)=1 and grouping(a.lastname)=1 then 'итого по всем'
        when grouping(u.lastname)=1 then 'итого по автору'
        when grouping(a.lastname)=1 then 'итого по пользователю'
        else 'по паре'
    end as grouping_type
from ticket t
join "user" u on u.id = t.user_id
join book   b on b.bshifr = t.book_id
join author a on a.id = b.id_author
group by cube (u.lastname, a.lastname)
order by (u.lastname is null), u.lastname, (a.lastname is null), a.lastname;

-- 4.1.5. (group by grouping sets) Найти все агрегации по издательству книги и по жанру, только издательство, только жанр и общее количество.
select b.publishing, b.section, count(*) as books_count
from book b
group by grouping sets
(
    (b.publishing, b.section),
    (b.publishing),
    (b.section)
)
order by b.publishing nulls last, b.section nulls last;

-- 4.1.6. Вывести количество пользователей, у которых нет просроченных книг и у скольки есть просрочки сдачи книг.
select
    case
        when exists (
            select 1
            from ticket t
            where t.user_id = u.id
              and t.date_of_issue is null
              and coalesce(t.arrears, 0) > 0
        ) then 'есть просрочки'
        else 'нет просрочек'
    end as status,
    count(*) as users_count
from "user" u
group by 1
order by 1;


-- 4.2. Запросы с CROSSTAB 
select distinct publishing from book order by 1;
select distinct section from book order by 1;

-- 4.2.1. Количество книг авторов по издательствам.
select *
from crosstab(
    $$
    select
        a.lastname,
        b.publishing,
        count(*)::int
    from author a
    join book b on b.id_author = a.id
    group by a.lastname, b.publishing
    order by 1,2
    $$,
    $$values ('Азбука'), ('Эксмо'), ('АСТ')$$
) as ct(
    author_lastname text,
    "Азбука" int,
    "Эксмо"  int,
    "АСТ"    int
);

-- 4.2.2. Найти средняя цена книги каждого автора по разделам.
select *
from crosstab(
    $$
    select
        a.lastname,
        b.section,
        round(avg(b.price)::numeric, 2)::numeric
    from author a
    join book b on b.id_author = a.id
    group by a.lastname, b.section
    order by 1,2
    $$,
    $$values ('Комедия'), ('Детская'), ('Хоррор')$$
) as ct(
    author_lastname text,
    "Комедия" numeric,
    "Детская" numeric,
    "Хоррор" numeric
);

-- 4.2.3. Вывести список книг, сгруппированных по годам публикации и количеству авторов

drop function if exists tmp_books_by_year_authors();

select * from book;

create or replace function tmp_books_by_year_authors()
returns table(pub_year int, authors_cnt int, books_cnt int)
language sql
as $$
with book_authors as (
    select
        b.bshifr as book_id,
        b.year_publ::int as pub_year,
        1::int as authors_cnt
    from book b
)
select
    pub_year,
    authors_cnt,
    count(*)::int as books_cnt
from book_authors
where authors_cnt in (1, 2, 3)
group by pub_year, authors_cnt
order by 1, 2;
$$;

select *
from crosstab(
    $$
    select pub_year, authors_cnt, books_cnt
    from tmp_books_by_year_authors()
    order by 1, 2
    $$,
    $$values (1), (2), (3)$$
) as ct(
    pub_year int,
    "1_author" int,
    "2_authors" int,
    "3_authors" int
);

-- 4.2.4. выведите возраст пользователей и количество взятых ими книг

select *
from crosstab(
    $$
    select
        (extract(year from current_date)::int - u.year_b::int) as age_years,
        'issued'::text as metric,
        count(t.book_id)::int as issued_count
    from "user" u
    left join ticket t on t.user_id = u.id
    group by 1, 2
    order by 1, 2
    $$,
    $$values ('issued')$$
) as ct(
    age_years int,
    issued int
)
order by age_years;


-- 4.2.5. Найдите количество книг, взятых пользователями по месяцам.

select *
from crosstab(
    $$
    select
        extract(year from t.date_of_issue)::int as yy,
        to_char(t.date_of_issue, 'mm') as mm,
        count(*)::int as issued_count
    from ticket t
    where t.date_of_issue is not null
    group by 1, 2
    order by 1, 2
    $$,
    $$values
        ('01'),('02'),('03'),('04'),('05'),('06'),
        ('07'),('08'),('09'),('10'),('11'),('12')
    $$
) as ct(
    yy int,
    "01" int, "02" int, "03" int, "04" int, "05" int, "06" int,
    "07" int, "08" int, "09" int, "10" int, "11" int, "12" int
)
order by yy;



-- 4.3.1. Анализ продаж книг по жанрам и авторам:
--    Создайте запрос, который покажет количество проданных экземпляров каждой книги, сгруппированных по жанру и автору.
--    Используйте CROSSTAB для представления данных в виде таблицы, где строки — авторы, а столбцы — жанры.
select *
from crosstab(
    $$
    select
        a.lastname as author_lastname,
        b.section as section,
        count(*)::int as issued_count
    from ticket t
    join book b on b.bshifr = t.book_id
    join author a on a.id = b.id_author
    group by 1, 2
    order by 1, 2
    $$,
    $$
    values
        ('Фантастический роман'),
        ('тест'),
        ('Комедия'),
        ('Художественная'),
        ('ru'),
        ('Детская'),
        ('Учебная'),
        ('Хоррор'),
        ('weekend')
    $$
) as ct(
    author_lastname text,
    "Фантастический роман" int,
    "тест" int,
    "Комедия" int,
    "Художественная" int,
    "ru" int,
    "Детская" int,
    "Учебная" int,
    "Хоррор" int,
    "weekend" int
);

select distinct section from book;

-- 4.3.2. Возрастная статистика читателей:
--    Напишите запрос, который подсчитывает количество активных читателей в библиотеке по возрастным категориям (например, до 20 лет, 21–30 лет, 31–40 лет и т.д.).
--    Примените CROSSTAB для отображения количества читателей в каждой возрастной категории.
select *
from crosstab(
    $$
    with active_users as (
        select distinct u.id, (extract(year from current_date)::int - u.year_b::int) as age_years
        from "user" u
        join ticket t on t.user_id = u.id
    )
    select
        'active_readers'::text as row_name,
        case
            when age_years <= 20 then 'до_20'
            when age_years between 21 and 30 then '21_30'
            when age_years between 31 and 40 then '31_40'
            when age_years between 41 and 50 then '41_50'
            else '51_plus'
        end as age_bucket,
        count(*)::int as cnt
    from active_users
    group by 1, 2
    order by 1, 2
    $$,
    $$values ('до_20'), ('21_30'), ('31_40'), ('41_50'), ('51_plus')$$
) as ct(
    metric text,
    "до_20" int,
    "21_30" int,
    "31_40" int,
    "41_50" int,
    "51_plus" int
);

-- 4.3.3. Популярность книг по месяцам:
--    Разработайте запрос, который вычисляет количество выданных книг за каждый месяц года.
--    С помощью CROSSTAB создайте таблицу, где строки — месяцы, а столбцы — количество выданных книг.
select *
from crosstab(
    $$
    select
        to_char(t.date_of_issue, 'mm') as month,
        'issued'::text as metric,
        count(*)::int as issued_count
    from ticket t
    where t.date_of_issue is not null
    group by 1, 2
    order by 1, 2
    $$,
    $$values ('issued')$$
) as ct(
    month text,
    issued int
)
order by month;

-- 4.3.4. Самые популярные авторы среди студентов:
--    Найдите самых популярных авторов среди студентов (возраст до 24 лет).
--    Используйте CROSSTAB для визуализации популярности авторов среди этой группы читателей.
select *
from crosstab(
    $$
    select
        a.lastname as author_lastname,
        'issued'::text as metric,
        count(*)::int as issued_count
    from ticket t
    join "user" u on u.id = t.user_id
    join book b on b.bshifr = t.book_id
    join author a on a.id = b.id_author
    where (extract(year from current_date)::int - u.year_b::int) <= 24
    group by 1, 2
    order by 1, 2
    $$,
    $$values ('issued')$$
) as ct(
    author_lastname text,
    issued int
)
order by issued desc, author_lastname;

-- 4.3.5. Сравнение количества книг, изданных разными издательствами:
--    Подсчитайте общее количество книг, изданных различными издательствами.
--    Примените CROSSTAB для сравнения числа изданий между разными издательствами.
select *
from crosstab(
    $$
    select
        b.publishing as publishing,
        'books'::text as metric,
        count(*)::int as books_count
    from book b
    group by 1, 2
    order by 1, 2
    $$,
    $$values ('books')$$
) as ct(
    publishing text,
    books int
)
order by publishing;

-- 4.3.6. Количество книг, взятых читателями разного пола:
--    Определите, сколько книг взяли читатели мужского и женского пола.
--    Воспользуйтесь CROSSTAB для создания таблицы, где строки — пол читателей, а столбцы — количество взятых книг.
select *
from crosstab(
    $$
    select
        u.gender::text as gender,
        'issued'::text as metric,
        count(*)::int as issued_count
    from ticket t
    join "user" u on u.id = t.user_id
    group by 1, 2
    order by 1, 2
    $$,
    $$values ('issued')$$
) as ct(
    gender text,
    issued int
)
order by gender;


-- 4.3.7. Процентное соотношение жанров в библиотеке:
--    Рассчитайте процентное соотношение различных жанров в общем количестве книг в библиотеке.
--    Представьте результаты с помощью CROSSTAB, где строки — жанры, а столбец — процентное соотношение.
select *
from crosstab(
    $$
    with s as (
        select
            b.section,
            count(*)::numeric as cnt
        from book b
        group by b.section
    )
    select
        s.section,
        'percent'::text as metric,
        round(100.0 * s.cnt / sum(s.cnt) over (), 2)::numeric as pct
    from s
    order by 1, 2
    $$,
    $$values ('percent')$$
) as ct(
    section text,
    percent numeric
)
order by section;

-- 4.3.8. Средняя стоимость книг по секциям:
--    Найдите среднюю стоимость книг в каждой секции библиотеки.
--    Используйте CROSSTAB для построения таблицы, где строки — секции, а столбцы — средняя стоимость книг.
select *
from crosstab(
    $$
    select
        b.section as section,
        'avg_price'::text as metric,
        round(avg(b.price)::numeric, 2)::numeric as avg_price
    from book b
    group by 1, 2
    order by 1, 2
    $$,
    $$values ('avg_price')$$
) as ct(
    section text,
    avg_price numeric
)
order by section;

-- 4.3.9. Активность читателей по дням недели:
--    Посчитайте количество посещений библиотеки читателями по дням недели.
--    Примените CROSSTAB для наглядного представления активности читателей в разные дни недели.
select *
from crosstab(
    $$
    select
        to_char(t.date_of_issue, 'dy') as dow,
        'visits'::text as metric,
        count(*)::int as visits_count
    from ticket t
    where t.date_of_issue is not null
    group by 1, 2
    order by 1, 2
    $$,
    $$values ('visits')$$
) as ct(
    dow text,
    visits int
)
order by dow;

-- 4.3.10. Соотношение новых и старых книг в фондах библиотеки:
--    Определите, какой процент книг в фонде библиотеки был опубликован менее пяти лет назад, а какой — пять и более лет назад.
--    Используйте CROSSTAB для представления соотношения новых и старых книг.
select *
from crosstab(
    $$
    with x as (
        select
            case
                when b.year_publ >= extract(year from current_date)::int - 5 then 'new_lt_5y'
                else 'old_ge_5y'
            end as age_group,
            count(*)::numeric as cnt
        from book b
        group by 1
    )
    select
        x.age_group,
        'percent'::text as metric,
        round(100.0 * x.cnt / sum(x.cnt) over (), 2)::numeric as pct
    from x
    order by 1, 2
    $$,
    $$values ('percent')$$
) as ct(
    age_group text,
    percent numeric
)
order by age_group;
