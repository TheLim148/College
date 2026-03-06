-- 3.1.1. Создайте транзакцию, которая состоит из операций
-- - Ввод данных об авторе
-- - Ввод данных о двух книгах автора

select * from author;

rollback;

begin;

do $$
declare
    v_author_id integer;
begin
    insert into author (id, lastname, name, year_b, io)
    values (4, 'Пушкин', 'Александр', 1799, 'RU')
    returning id into v_author_id;

    insert into book (bshifr, id_author, section, title, publishing, year_publ, price, about, shifr)
    values (101, v_author_id, 'ru', 'Евгений Онегин', 'Азбука', 1833, 900, 'роман в стихах', 'sh0101');

    insert into book (bshifr, id_author, section, title, publishing, year_publ, price, about, shifr)
    values (102, v_author_id, 'ru', 'Борис Годунов', 'Азбука', 1825, 1200, 'драматическое произведение', 'sh0102');
end $$;

commit;

select * from author;
select * from book;


-- 3.1.2. Произведите проверку, что стоимость книги не больше определённого значения,
-- если стоимость больше, то транзакция отменяется, иначе – фиксируется.

rollback;

begin;

do $$
declare
    v_author_id integer;
    v_max_price real := 1000;
begin
    insert into author (lastname, name, year_b, io)
    values ('Толстой', 'Лев', 1828, 'RU')
    returning id into v_author_id;

    insert into book (bshifr, id_author, section, title, publishing, year_publ, price, about, shifr)
    values (201, v_author_id, 'ru', 'Война и Мир', 'азбука', 1869, 950, 'роман', 'sh0201');

    insert into book (bshifr, id_author, section, title, publishing, year_publ, price, about, shifr)
    values (202, v_author_id, 'ru', 'Анна Каренина', 'азбука', 1877, 1100, 'роман', 'sh0202');

    if exists (
        select 1
        from book
        where id_author = v_author_id
          and price > v_max_price
    ) then
        raise exception 'Цена книги больше лимита (%). транзакция отменена.', v_max_price;
    end if;
end $$;

commit;


-- 3.2.	Разработать хранимую процедуру, которая не позволяла бы добавлять запись о выдачи книги,
-- если дата возврата введена меньше даты выдачи книги.
-- Для отмены команды вставки записи применить команду отката транзакций ROLLBACK.
-- 3.2.1. Создайте процедуру proverka:
-- - Задайте входные параметры процедуры: kodU, kodB, dVid, dVoz;
-- - Задайте локальную переменную rez и присвойте ей значение ‘ОК’.
-- - Задайте локальную переменную pr для проверки разницы между двумя датами.
-- - Напишите инструкцию для ввода записей в таблицу Bilet, значение берите из входных параметров процедуры.
-- - Вычислите значение переменной pr как разница между двумя датами (дата возврата и дата выдачи), 
-- где код билета = последнему добавленному ключевому значению.
-- - Произведите проверку, если полученное число больше 0, то примените транзакцию, иначе откатите транзакцию и установите значение переменной rez как ‘No’.
-- - Выведите значение переменной rez на экран.

rollback;

create or replace procedure proverka(
    kodu integer,
    kodb integer,
    dvid date,
    dvoz date
)
language plpgsql
as $$
declare
    rez text := 'ok';
    pr integer;
begin
    pr := dvoz - dvid;

    if pr > 0 then
        insert into ticket (user_id, book_id, date_of_issue, date_of_return)
        values (kodu, kodb, dvid, dvoz);

        commit;
    else
        rollback;
        rez := 'no';
    end if;

    raise notice 'rez = %', rez;
end;
$$;


-- 3.2.2. Выведите записи из таблицы bilet.
-- 3.2.3. Задайте значения для переменных, дату выдачи поставьте меньше даты возврата
-- 3.2.4. Вызовите процедуру proverka с параметрами (user,kniga,d1,d2);
-- 3.2.5. Проверьте, произведено ли добавление записи в таблицу.
-- 3.2.6. Задайте значения переменных, дату выдачи поставьте больше даты возврата
-- 3.2.7. Вызовите процедуру и проверьте, произведено ли добавление записей в таблицу.

-- дата выдачи меньше даты возврата (должно добавиться)
call proverka(1, 101, date '2026-01-01', date '2026-01-10');
select * from ticket order by id desc;

-- дата выдачи больше даты возврата (не должно добавиться)
call proverka(1, 101, date '2026-02-10', date '2026-02-01');
select * from ticket order by id desc;


-- 3.3.	*Автономные транзакции
-- 3.3.1. Реализуйте функцию автономного логирования для аудита операций выдачи книг. Для этого создайте таблицу логов, функцию автономного логирования.
-- 3.3.2. Создание триггера, который записывает в таблицу Logs(bk,cena_new,cena_old)
-- данные о тех случаях изменения цены книги в таблице books, при которых значение стоимости книги стало больше 1000 рублей.
-- Триггер должен фиксировать и те случаи изменений цены, которые отменены командой rollback.
create extension if not exists dblink;

create table if not exists issue_audit (
    id bigserial primary key,
    created_at timestamptz not null default now(),
    user_id integer,
    book_id integer,
    action text
);

create table if not exists logs (
    id bigserial primary key,
    created_at timestamptz not null default now(),
    bk integer,
    cena_new real,
    cena_old real
);

create or replace function log_issue_autonomous(p_user_id integer, p_book_id integer, p_action text)
returns void
language plpgsql
as $$
declare
    conn text := 'audit_conn';
    sql text;
begin
    perform dblink_connect(conn, 'dbname=' || current_database());

    sql := format(
        'insert into ryzhov_ka.issue_audit(user_id, book_id, action) values (%s, %s, %L)',
        coalesce(p_user_id::text, 'null'),
        coalesce(p_book_id::text, 'null'),
        p_action
    );

    perform dblink_exec(conn, sql);
    perform dblink_disconnect(conn);
exception when others then
    begin
        perform dblink_disconnect(conn);
    exception when others then
        null;
    end;
end;
$$;


create or replace function trg_ticket_audit()
returns trigger
language plpgsql
as $$
begin
    perform log_issue_autonomous(new.user_id, new.book_id, 'issue');
    return new;
end;
$$;

drop trigger if exists ticket_audit_ai on ticket;

create trigger ticket_audit_ai
after insert on ticket
for each row
execute function trg_ticket_audit();


create or replace function log_price_autonomous(p_bk integer, p_new real, p_old real)
returns void
language plpgsql
as $$
declare
    conn text := 'price_conn';
    sql text;
begin
    perform dblink_connect(conn, 'dbname=' || current_database());

    sql := format(
        'insert into ryzhov_ka.logs(bk, cena_new, cena_old) values (%s, %s, %s)',
        coalesce(p_bk::text, 'null'),
        coalesce(p_new::text, 'null'),
        coalesce(p_old::text, 'null')
    );

    perform dblink_exec(conn, sql);
    perform dblink_disconnect(conn);
exception when others then
    begin
        perform dblink_disconnect(conn);
    exception when others then
        null;
    end;
end;
$$;

create or replace function trg_book_price_log()
returns trigger
language plpgsql
as $$
begin
    if new.price is not null and new.price > 1000 then
        perform log_price_autonomous(new.bshifr, new.price, old.price);
    end if;
    return new;
end;
$$;

drop trigger if exists book_price_au on book;

create trigger book_price_au
after update of price on book
for each row
execute function trg_book_price_log();

begin;
update book set price = 1500 where bshifr = 101;
rollback;

select * from logs order by id desc;

-- 3.4. (Использование курсоров). Используя курсорный цикл, 
-- увеличьте на 20% стоимость книг тех авторов, которые менее 1950 года рождения. 
-- В конце каждой итерации проверять, не получится ли данная стоимость более 10_000 рублей,
-- в случае нарушения условия отменить изменение цены.

do $$
declare
    cur_books cursor for
        select b.bshifr, b.price
        from book b
        join author a on a.id = b.id_author
        where a.year_b < 1950;

    v_bshifr integer;
    v_price numeric;
    v_new_price numeric;
begin
    open cur_books;

    loop
        fetch cur_books into v_bshifr, v_price;
        exit when not found;
  
        v_new_price := v_price * 1.2;

        if v_new_price > 10000 then
            raise notice 'book % skipped, new price % > 10000', v_bshifr, v_new_price;
        else
            update book
            set price = v_new_price
            where bshifr = v_bshifr;

            raise notice 'book % updated: % -> %', v_bshifr, v_price, v_new_price;
        end if;
    end loop;

    close cur_books;
end $$;

-- 3.5.	Создание хранимых процедур
-- 3.5.1. Добавьте в таблицу Book поле Vidano для хранения информации, 
-- находится ли книга на руках у читателя. Измените значение данного поля для всех записей.
-- Разработать процедуру для удаления книги, которая не позволяла бы удалить экземпляр книги,
-- если этот экземпляр в данный момент находится на руках у читателя.
-- Для отмены команды удаления применить команду отката транзакций ROLLBACK.
-- Проверить работу процедуры, попробовав удалить не экземпляр книги, который имеет отметку о том, что он находится у читателя.
alter table book
    add column if not exists vidano boolean;

update book
set vidano = false
where vidano is distinct from false;

update book b
set vidano = true
where exists (
    select 1
    from ticket t
    where t.book_id = b.bshifr
      and t.date_of_return is null
);


drop function if exists delete_book_if_not_issued(integer);
drop procedure if exists delete_book_if_not_issued(integer);

create or replace procedure delete_book_if_not_issued(p_bshifr integer)
language plpgsql
as $$
declare
    v_vidano boolean;
    v_ref_cnt integer;
begin
    select vidano
      into v_vidano
      from book
     where bshifr = p_bshifr;

    if not found then
        rollback;
        raise notice 'книга bshifr=% не найдена', p_bshifr;
        return;
    end if;

    if coalesce(v_vidano, false) then
        rollback;
        raise notice 'нельзя удалить: книга на руках (vidano=true)';
        return;
    end if;

    select count(*)
      into v_ref_cnt
      from ticket
     where book_id = p_bshifr;

    if v_ref_cnt > 0 then
        rollback;
        raise notice 'нельзя удалить: есть записи в ticket (%)', v_ref_cnt;
        return;
    end if;

    delete from book
    where bshifr = p_bshifr;

    commit;
    raise notice 'книга удалена';
end;
$$;

call delete_book_if_not_issued(101);

-- 3.5.2. Разработать процедуру, которая бы контролировала выдачу книг читателю 
-- и при превышении количества трех несданных книг на руках не позволял бы выдать данному читателю еще одну книгу.
create or replace procedure issue_book_limit_3(
    p_user_id integer,
    p_book_id integer,
    p_date_issue date,
    p_date_return date
)
language plpgsql
as $$
declare
    v_cnt integer;
    v_vidano boolean;
begin
    select vidano into v_vidano
    from book
    where bshifr = p_book_id;

    if not found then
        rollback;
        raise notice 'книга bshifr=% не найдена', p_book_id;
        return;
    end if;

    if coalesce(v_vidano, false) = true then
        rollback;
        raise notice 'нельзя выдать: книга bshifr=% уже на руках (vidano=true)', p_book_id;
        return;
    end if;

    select count(*)
      into v_cnt
      from ticket
     where user_id = p_user_id
       and date_of_return is null;

    if v_cnt >= 3 then
        rollback;
        raise notice 'нельзя выдать: у читателя user_id=% уже % несданных книг', p_user_id, v_cnt;
        return;
    end if;

    insert into ticket (user_id, book_id, date_of_issue, date_of_return)
    values (p_user_id, p_book_id, p_date_issue, p_date_return);

    update book
    set vidano = true
    where bshifr = p_book_id;

    commit;

    raise notice 'выдача выполнена: user_id=%, book_id=%', p_user_id, p_book_id;
end;
$$;


call issue_book_limit_3(1, 100, date '2026-01-10', null);
select * from book;

-- 3.5.3. Добавьте в таблицу Users два поля для хранения информации о домашнем и сотовом телефоне.
-- Разработать процедуру для ввода записей в таблицу users.
-- Данная процедура должна проверять, есть ли информация хотя бы об одном из телефонов для связи с читателем,
-- и если такой информации нет, то не вводить данные о читателе.
alter table "user"
    add column if not exists phone_home text;

alter table "user"
    add column if not exists phone_mobile text;

create or replace procedure insert_reader_with_phones(
    p_lastname text,
    p_name text,
    p_phone_home text,
    p_phone_mobile text
)
language plpgsql
as $$
begin
    if (p_phone_home is null or btrim(p_phone_home) = '')
       and (p_phone_mobile is null or btrim(p_phone_mobile) = '') then
        rollback;
        raise notice 'читатель не добавлен: отсутствуют оба телефона';
        return;
    end if;

    insert into "user" (id, lastname, name, category, phone_home, phone_mobile, user_group, year_b, age)
    values (default, p_lastname, p_name, 'reader', nullif(btrim(p_phone_home), ''), nullif(btrim(p_phone_mobile), ''), 1, 2000, 25);

    commit;

    raise notice 'читатель добавлен: % %', p_lastname, p_name;
end;
$$;

select * from "user";

call insert_reader_with_phones('иванов', 'иван', null, null);
call insert_reader_with_phones('петров', 'пётр', '222-22-22', null);
call insert_reader_with_phones('сидоров', 'сидор', null, '+7 999 111-22-33');

-- 3.5.4. Разработать процедуру, которая не позволяет удалить читателя, если за ним числится хотя бы одна книга из библиотеки.
create or replace procedure delete_reader_if_any_books(p_user_id integer)
language plpgsql
as $$
declare
    v_cnt integer;
begin
    -- есть ли вообще записи выдачи по пользователю
    select count(*)
      into v_cnt
      from ticket
     where user_id = p_user_id;

    if v_cnt > 0 then
        rollback;
        raise notice 'нельзя удалить читателя user_id=%: за ним числится % запис(ь/и) в ticket', p_user_id, v_cnt;
        return;
    end if;

    delete from "user"
    where id = p_user_id;

    if not found then
        rollback;
        raise notice 'читатель user_id=% не найден', p_user_id;
        return;
    end if;

    commit;
    raise notice 'читатель user_id=% удалён', p_user_id;
end;
$$;

call delete_reader_if_any_books(2);

select * from ticket;