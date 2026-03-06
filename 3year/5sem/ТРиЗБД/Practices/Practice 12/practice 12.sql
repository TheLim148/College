-- 4.1.1. Создайте переменные st, которая ссылается на запись из таблицы users.
-- В данную переменную получите пользователя, который взял наибольшее количество книг
-- (если таких пользователей несколько, то выберем первого по алфавиту).
-- Выведите на экран фамилию и имя пользователя
do $$
declare
    st "user"%rowtype;
begin
    select u.*
    into st
    from "user" u
    join (
        select user_id, count(*) as cnt
        from ticket
        group by user_id
    ) t on t.user_id = u.id
    order by t.cnt desc, u.lastname, u.name
    limit 1;

    raise notice 'пользователь с макс количеством книг: % %',
        st.lastname, st.name;
end $$;

-- 4.1.2. Создайте переменную – запись, которая включает информацию об авторе и его количестве книг.
-- В данную переменную получите автора, который написал наибольшее количество книг.
-- Выведите на экран его фамилию и данное количество.
do $$
declare
    author_info record;
begin
    select a.id,
           a.lastname,
           a.name,
           count(b.bshifr) as book_cnt
    into author_info
    from author a
    join book b on b.id_author = a.id
    group by a.id, a.lastname, a.name
    order by count(b.bshifr) desc, a.lastname, a.name
    limit 1;

    raise notice 'автор с максимальным количеством книг: % %; всего книг: %',
        author_info.lastname,
        author_info.name,
        author_info.book_cnt;
end $$;

-- 4.1.3. Создайте переменную типа запись, которая создана на основании строки таблицы Books.
-- Создайте программу, с помощью которой получите запись о книгах(ге) определённого автора,
-- при этом нужно использовать ограничение количества записей по запросу. 
do $$
declare
    v_author_id integer := 1;
    bk book%rowtype;
begin
    select *
    into bk
    from book
    where id_author = v_author_id
    order by title
    limit 1;

    raise notice 'одна из книг автора id=%: % (шифр %, раздел %)',
        v_author_id, bk.title, bk.bshifr, bk.section;
end $$;

-- 4.2.1. (SQL%NOTFOUND) Напишите программу для выборки записей о выдаче книг определённому пользователю,
-- при этом обработайте исключение, если таких записей нет
do $$
declare
    v_user_id integer := 2;
    r record;
begin
    for r in
        select id, book_id, date_of_issue, date_of_return
        from ticket
        where user_id = v_user_id
    loop
        raise notice
            'выдача: ticket_id=%, book_id=%, дата выдачи=%, дата возврата=%',
            r.id, r.book_id, r.date_of_issue, r.date_of_return;
    end loop;

    if not found then
        raise notice 'для пользователя id=% выдач не найдено', v_user_id;
    end if;
end $$;

-- 4.2.2. (SQL%ROWCOUNT) Напишите программу, в которой удалите записи о выдачи книг с определенным значением поля id_users,
-- используя указанный атрибут неявного курсора получите о количестве строк, которые были удалены.
select * from ticket;
insert into ticket(id, user_id, book_id, date_of_issue, date_of_return) values (1, 1, 1, '2024-01-01', '2024-02-01');

do $$
declare
    v_user_id integer := 1;
    v_deleted integer;
begin
    delete from ticket
    where user_id = v_user_id;

    get diagnostics v_deleted = row_count;

    raise notice
        'удалено записей о выдаче книг для пользователя id=%: %',
        v_user_id, v_deleted;
end $$;

-- 4.3.1. (Выбор в переменную %TYPE) Напишите программу, в которой опишете переменную n_vidachi
-- и получите значение полей код билета в текущий день.
insert into ticket(id, user_id, book_id, date_of_issue, date_of_return) values (101, 2, 2, current_date, '2025-12-30');

do $$
declare
    n_vidachi ticket.id%type;
    cur_issues cursor for
        select id
        from ticket
        where date_of_issue = current_date
        order by id;
begin
    open cur_issues;

    loop
        fetch cur_issues into n_vidachi;
        exit when not found;

        raise notice 'билет, выданный сегодня: id=%', n_vidachi;
    end loop;

    close cur_issues;
end $$;

-- 4.3.2. (Выбор в запись %ROWTYPE) Напишите программу для получения списка книг библиотеки.
do $$
declare
    bk book%rowtype;
    cur_books cursor for
        select *
        from book
        order by title;
begin
    open cur_books;

    loop
        fetch cur_books into bk;
        exit when not found;

        raise notice 'книга: % (шифр %, id автора=%, раздел=%)',
            bk.title, bk.bshifr, bk.id_author, bk.section;
    end loop;

    close cur_books;
end $$;

-- 4.3.3. (Выбор в переменную RECORD) Объявите тип запись, включающую поля Фамилия пользователя, Название книги, Дата выдачи книги.
-- Создайте программу, которая по номеру выдачи книги получит запись – фамилия пользователя, название книги и дата выдачи.
-- Выведите результат работы функции в окно вывода.
do $$
declare
    rec record;
    cur_user_issues cursor for
        select u.lastname,
               u.name,
               t.date_of_issue
        from "user" u
        join ticket t on t.user_id = u.id
        order by t.date_of_issue, u.lastname, u.name;
begin
    open cur_user_issues;

    loop
        fetch cur_user_issues into rec;
        exit when not found;

        raise notice 'выдача: % % — дата выдачи: %',
            rec.lastname, rec.name, rec.date_of_issue;
    end loop;

    close cur_user_issues;
end $$;

-- 4.4.1. Напишите процедуру tek_vr, которая выводит текущее время n раз, где n - параметр, задаваемый пользователем.
create procedure tek_vr(n integer)
language plpgsql
as $$
declare
    i integer := 1;
begin
    while i <= n loop
        raise notice 'текущее время: %', clock_timestamp();
        i := i + 1;
    end loop;
end $$;

call tek_vr(5);

-- 4.4.2. Создайте хранимую процедуру stoim, которая по введённой цене товара и его количеству вычислит сумму к выдаче. 
create procedure stoim(
    in cena numeric,
    in kol integer,
    out summa numeric
)
language plpgsql
as $$
begin
    summa := cena * kol;
end $$;

call stoim(100.0, 5, 1);

-- 4.4.3. Напишите хранимую процедуру, которая в зависимости от введенного значения переменной cur
-- вычислит стоимость товара в долларах, если переменная cur=0 и в рублях, если переменная cur=1.
-- Используйте созданную процедуру в п 4.2.
create procedure stoim_cur(
    in summa_rub numeric,   -- стоимость в рублях
    in cur integer,         -- 0 = показать в долларах, 1 = в рублях
    in kurs numeric,        -- курс руб/долл
    out result numeric
)
language plpgsql
as $$
begin
    if cur = 0 then
        -- переводим в доллары
        result := round(summa_rub / kurs, 2);
    else
        -- оставляем в рублях
        result := round(summa_rub, 2);
    end if;
end $$;

call stoim_cur(200, 0, 90, 0);

-- 4.4.4. Напишите процедуру dni для нахождения количества дней между двумя датами.
create procedure dni(
    in d1 date,
    in d2 date,
    out k integer
)
language plpgsql
as $$
begin
    k := d2 - d1;
end $$;

call dni('2024-01-01', current_date, 0);

-- 4.5.1. Создание процедуры cnt_books, которая подсчитывает количество записей в таблице BOOKS.
create procedure cnt_books(
    out cnt integer
)
language plpgsql
as $$
begin
    select count(*) into cnt
    from book;
end $$;

call cnt_books(0);

-- 4.5.2. Создайте хранимую процедуру booksnazv, которая по первичному ключу книги bshift выдаёт название книги.
-- Для решения задачи требуется определить параметр bshift с атрибутом IN, а параметр nazv с атрибутом OUT.
create procedure booksnazv(
    in  p_bshifr integer,
    out nazv     varchar
)
language plpgsql
as $$
begin
    select title
    into nazv
    from book
    where bshifr = p_bshifr;

    if not found then
        nazv := null;
    end if;
end $$;

call booksnazv(1, '');

-- 4.5.3. Создание хранимой процедуры author_book, которая по имени автора выводит название книги.
-- Указание к выполнению задания: в ходе создания процедуры будем использовать процедуру booksnazv,
-- которая по первичному ключу выдаёт название книги;
-- При решении задачи используйте временную переменную, например, id, которая будет являться входной для процедуры booksnazv;
create procedure author_book(
    in  p_lastname varchar,
    in  p_name     varchar,
    out nazv       varchar
)
language plpgsql
as $$
declare
    id integer;
begin
    select b.bshifr
    into id
    from author a
    join book   b on b.id_author = a.id
    where a.lastname = p_lastname
      and a.name     = p_name
    order by b.title
    limit 1;

    if not found then
        nazv := null;
        return;
    end if;

    call booksnazv(id, nazv);
end $$;

call author_book('Пушкин', 'Александр С.', '');

-- 4.5.4. Создание хранимой процедуры sp_book, которая по введённому коду автора выведет список книг и цену книг в долларах
-- (если переменная cur=0) и в рублях (если переменная cur=1).
-- напоминание: stoim_cur(summa_rub, cur, kurs, out result)
create procedure sp_book(
    in  p_bshifr integer,
    in  cur      integer,  -- 0 = доллары, 1 = рубли
    in  kurs     numeric,  -- курс руб/доллар
    out result   numeric
)
language plpgsql
as $$
declare
    price_rub numeric;
begin
    select price
    into price_rub
    from book
    where bshifr = p_bshifr;

    if not found then
        raise exception 'книга с шифром % не найдена', p_bshifr;
    end if;

    call stoim_cur(price_rub, cur, kurs, result);
end $$;

call sp_book(1, 0, 90, 0);

-- 4.5.5. Напишите хранимую процедуру, которая по коду пользователя найдёт общую задолженность на текущую дату.
create procedure user_arrears(
    in  p_user_id      integer,
    out total_arrears integer
)
language plpgsql
as $$
begin
    select coalesce(sum(arrears), 0)
    into total_arrears
    from ticket
    where user_id = p_user_id
      and date_of_return < current_date;
end $$;

select * from ticket where user_id = 3;

call user_arrears(3, 0);

-- 4.5.6. Создайте переменную типа запись, которая создана на основании строки таблицы Books.
-- Создайте хранимую процедуру, с помощью которой получите запись о книгах(ге) определённого автора,
-- при этом можно использовать курсоры, или ограничение количества записей по запросу
create procedure get_book_of_author(
    in  p_author_id integer
)
language plpgsql
as $$
declare
    bk record;
begin
    select *
    into bk
    from book
    where id_author = p_author_id
    order by title
    limit 1;

    if not found then
        raise notice 'у автора id=% нет книг', p_author_id;
        return;
    end if;

    raise notice 'книга: id=%, шифр=%, название=%',
        bk.id_author, bk.bshifr, bk.title;
end $$;

call get_book_of_author(3);

-- 4.6.1. Создайте хранимую процедуру ввода данных в таблицу book
create procedure add_book(
    in p_bshifr    integer,
    in p_section   varchar(50),
    in p_id_author integer,
    in p_title     varchar(25),
    in p_publishing varchar(25),
    in p_year_publ integer,
    in p_price     real,
    in p_about     text,
    in p_shifr     varchar(6)
)
language plpgsqlselect * from book;
as $$
begin
    insert into book(
        bshifr, section, id_author, title,
        publishing, year_publ, price, about, shifr
    )
    values (
        p_bshifr, p_section, p_id_author, p_title,
        p_publishing, p_year_publ, p_price, p_about, p_shifr
    );
end $$;

call add_book(100, 'Художественная', 2, 'тест 1', 'тест 1', 2000, 9000, 'тест 1', 'TS0001');
select * from book;

-- 4.6.2. Создайте хранимую процедуру изменения записей таблицы ticket
create procedure update_ticket_row(
    in p_id            integer,
    in p_user_id       integer,
    in p_book_id       integer,
    in p_date_of_issue date,
    in p_date_of_return date,
    in p_arrears       integer,
    in p_kdays         integer
)
language plpgsql
as $$
begin
    update ticket
    set user_id       = p_user_id,
        book_id       = p_book_id,
        date_of_issue = p_date_of_issue,
        date_of_return = p_date_of_return,
        arrears       = p_arrears,
        kdays         = p_kdays
    where id = p_id;
end $$;

select * from ticket where id = 18;

call update_ticket_row(18, 6, 5, '1999-01-01', '2000-01-01', 0, 14);

-- 4.6.3. Добавьте поле рейтинг в таблицу Users. Присвойте всем пользователям библиотеки рейтинг 50.
-- Создайте хранимую процедуру для изменения рейтинга на 10% с каждой взятой книгой. 
select * from "user";

alter table "user"
add column rating numeric(10,2) default 50;

update "user"
set rating = 50
where rating >= 50;

create procedure recalc_user_rating(
    in p_user_id integer
)
language plpgsql
as $$
declare
    n_books integer;
begin
    select count(*) 
    into n_books
    from ticket
    where user_id = p_user_id;

    update "user"
    set rating = 50 * power(1.10, n_books)
    where id = p_user_id;
end $$;

call recalc_user_rating(3);

select * from "user" where id = 3;