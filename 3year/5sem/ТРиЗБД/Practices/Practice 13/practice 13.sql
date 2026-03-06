-- 4.1.1. Создайте выполняемые хранимые функции для вычисления суммы summa(n) (proizv(n) произведения) натуральных чисел от 1 до n
create function summa(n integer)
returns integer
language plpgsql
as $$
declare
    s integer := 0;
    i integer := 1;
begin
    while i <= n loop
        s := s + i;
        i := i + 1;
    end loop;
    return s;
end $$;

create function proizv(n integer)
returns numeric
language plpgsql
as $$
declare
    p numeric := 1;
    i integer := 1;
begin
    if n < 1 then
        return 0;
    end if;

    while i <= n loop
        p := p * i;
        i := i + 1;
    end loop;
    return p;
end $$;

-- 4.1.2. Напишите функцию Kol_Dney для нахождения количества дней между двумя датами.
create function kol_dney(d1 date, d2 date)
returns integer
language plpgsql
as $$
begin
    return d2 - d1;
end $$;

-- 4.1.3. Создайте анонимный блок, содержащий вызов хранимых функций, выведите на экран результат работы функций.
do $$
declare
    n integer := 5;
    s integer;
    p numeric;
    k integer;
begin
    select summa(n)  into s;
    select proizv(n) into p;
    select kol_dney(date '2024-01-01', date '2024-01-10') into k;

    raise notice 'summa(%) = %', n, s;
    raise notice 'proizv(%) = %', n, p;
    raise notice 'kol_dney(2024-01-01, 2024-01-10) = %', k;
end $$;

-- 4.2.1. Напишите функцию, которая по номеру месяца выведет название месяца (например, январь) выдачи книги.
create function month_name(m integer)
returns text
language plpgsql
as $$
begin
    case m
        when 1  then return 'январь';
        when 2  then return 'февраль';
        when 3  then return 'март';
        when 4  then return 'апрель';
        when 5  then return 'май';
        when 6  then return 'июнь';
        when 7  then return 'июль';
        when 8  then return 'август';
        when 9  then return 'сентябрь';
        when 10 then return 'октябрь';
        when 11 then return 'ноябрь';
        when 12 then return 'декабрь';
        else return null;
    end case;
end $$;

select month_name(2);

-- 4.2.2. Создадим хранимую функцию, которая по первичному ключу книги bshift выдаёт название книги.
create function book_title_by_bshifr(p_bshifr integer)
returns text
language plpgsql
as $$
declare
    v_title text;
begin
    select title
    into v_title
    from book
    where bshifr = p_bshifr;

    return v_title;
end $$;

select book_title_by_bshifr(1);

-- 4.2.3. Создадим хранимую функцию, которая по фамилии и имени пользователя получит общее количество взятых книг.
create function total_books_by_user(
    p_lastname text,
    p_name     text
)
returns integer
language plpgsql
as $$
declare
    cnt integer;
begin
    select count(*)
    into cnt
    from "user" u
    join ticket t on t.user_id = u.id
    where u.lastname = p_lastname
      and u.name     = p_name;

    return cnt;
end $$;

select total_books_by_user(
	'Дьячков',
	'Ярослав'
);

-- 4.2.4. Создать хранимую функцию для определения общего количества читателей, которые взяли книги за конкретный месяц.
create function total_readers_by_month(p_month integer)
returns integer
language plpgsql
as $$
declare
    cnt integer;
begin
    select count(distinct user_id)
    into cnt
    from ticket
    where extract(month from date_of_issue) = p_month;

    return cnt;
end $$;

select total_readers_by_month(12);

-- 4.2.5. Создадим хранимую функцию, которая по имени автора выводит название книги, имеющей максимальную стоимость книг для данного автора.
create function most_expensive_book_by_author(
    p_lastname text,
    p_name     text
)
returns text
language plpgsql
as $$
declare
    v_title text;
begin
    select b.title
    into v_title
    from author a
    join book   b on b.id_author = a.id
    where a.lastname = p_lastname
      and a.name     = p_name
    order by b.price desc, b.title
    limit 1;

    return v_title;
end $$;

select most_expensive_book_by_author(
	'Пушкин',
	'Александр С.'
);

-- 4.2.6. Найдите количество дней, которые прошли от даты выдачи книги пользователю до текущей даты.
-- При выполнении задания используйте функцию Kol_Dney, созданную ранее.
create function days_from_issue(p_ticket_id integer)
returns integer
language plpgsql
as $$
declare
    v_issue date;
begin
    select date_of_issue
    into v_issue
    from ticket
    where id = p_ticket_id;

    if v_issue is null then
        return null;
    end if;

    return kol_dney(v_issue, current_date);
end $$;

select * from ticket where user_id = 1;

select days_from_issue(1);

-- 4.2.7. (refcursor) Объявите тип запись, включающую поля Фамилия пользователя, Название книги, Дата выдачи книги.
-- Создайте хранимую функцию, которая по номеру выдачи книги получит запись – фамилия пользователя, название книги и дата выдачи.
-- Выведите результат работы функции в окно вывода.
create type issue_info_type as (
    lastname      text,
    book_title    text,
    date_of_issue date
);

create function issue_info_by_ticket(
    p_ticket_id integer
)
returns refcursor
language plpgsql
as $$
declare
    c refcursor;
begin
    open c for
        select
            u.lastname,
            b.title       as book_title,
            t.date_of_issue
        from ticket t
        join "user" u on u.id = t.user_id
        join book    b on b.bshifr = t.book_id
        where t.id = p_ticket_id;

    return c;
end $$;

do $$
declare
    c refcursor;
    r record;    -- вот он "тип запись"
begin
    c := issue_info_by_ticket(1);  -- номер выдачи

    fetch c into r;

    if found then
        raise notice 'пользователь: %, книга: %, дата выдачи: %',
            r.lastname, r.book_title, r.date_of_issue;
    else
        raise notice 'выдача с таким id не найдена';
    end if;

    close c;
end $$;

-- 4.2.8. (перегружаемая функция) Проверьте, есть ли книгу указанного автора,
-- если да, то найти их количество, если автор не указан, то вернуть 0. (перегрузка функции – разное количество параметров. 
-- вариант с параметрами: фамилия + имя автора
create function author_books_count(
    p_lastname text,
    p_name     text
)
returns integer
language plpgsql
as $$
declare
    cnt integer;
begin
    select count(*)
    into cnt
    from author a
    join book   b on b.id_author = a.id
    where a.lastname = p_lastname
      and a.name     = p_name;

    return cnt;
end $$;

create function author_books_count()
returns integer
language plpgsql
as $$
begin
    return 0;
end $$;

select author_books_count(
	'Пушкин',
	'Александр С.'
);

select author_books_count();

-- 4.3.1. Создайте функцию, выводящую названия специальностей как шифр книги и их название.
-- Выведите данные на экран в виде шифр – название. При выводе пользуйтесь функциями LPAD, RPAD. 
create function books_shifr_title()
returns table (line text)
language plpgsql
as $$
begin
    return query
    select
        rpad(lpad(bshifr::text, 5, '0'), 7, ' ') || ' - ' || title
    from book
    where bshifr is not null
      and title  is not null
    order by bshifr;
end $$;

select * from books_shifr_title();

-- 4.3.2. Выведите информацию о пользователях библиотеки группы с определённым номером, упорядоченных в порядке убывания года рождения
create function users_of_group(p_group integer)
returns table (
    id        integer,
    lastname  chn,
    name      chn,
    user_group integer,
    year_b    integer
)
language plpgsql
as $$
begin
    return query
    select
        u.id,
        u.lastname,
        u.name,
        u.user_group,
        u.year_b
    from "user" u
    where u.user_group = p_group
    order by u.year_b desc;
end $$;

select * from users_of_group(1);