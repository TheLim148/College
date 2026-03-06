-- 4.1.1. Создайте копию таблицы usernew без serial.
create table usernew
as table "user"
with no data;

alter table usernew
add primary key (id);

-- 4.1.2. Создайте триггер для формирования значения первичного ключа для таблицы usernew
-- (триггер должен формировать случайное число, проверять, что это значение не задействовано как ключ и добавлять его в поле).
create function f_usernew_rand_pk()
returns trigger
language plpgsql
as $$
declare
    v_id integer;
begin
    loop
        v_id := (random() * 1000000)::integer;

        exit when not exists (
            select 1 from usernew where id = v_id
        );
    end loop;

    new.id := v_id;
    return new;
end;
$$;

create trigger tr_usernew_rand_pk
before insert on usernew
for each row
when (new.id is null)
execute function f_usernew_rand_pk();
-- 4.1.3. Добавьте записи, проверьте работу триггера.
insert into usernew (lastname, name, user_group, year_b, age, level, category, contact_number)
values
    ('Иванов', 'Иван', 2991, 2000, 24, 1, 'студент', array['+7']),
    ('Петров', 'Пётр', 2991, 2001, 23, 1, 'студент', array['+7']);

select * from usernew;

-- 4.2.1. Триггер по поддержанию значений внешних ключей (on update cascade). 
-- Добавьте таблицу grouplist (gruppa, spec, yearn), заполните таблицу данными. 
-- Создайте триггер, который при изменении номера группы в таблице grouplist происходит автоматическое изменение всех кодовых значений users.
-- Указания для выполнения: произведите проверку условия неравенства нового и старого значения ключевого поля,
-- в случае неравенства выполните запрос на обновление подчинённой таблицы,
-- установив в поле внешнего ключа связи новое значение первичного ключа главной таблицы,
-- при условии равенства внешнего ключа старому значению поля внешнего ключа.
-- Проверьте работу созданного триггера, для этого измените группу с номером 2991 на код 91, проверьте изменение данных в таблице users.
create table grouplist (
    gruppa integer primary key,
    spec   text    not null,
    yearn  integer not null
);

insert into grouplist (gruppa, spec, yearn) values
    (2991, 'Программирование', 2023),
    (2992, 'Дизайн',           2023);

create function f_grouplist_update_cascade()
returns trigger
language plpgsql
as $$
begin
    if new.gruppa = old.gruppa then
        return new;
    end if;

    update "user"
    set user_group = new.gruppa
    where user_group = old.gruppa;

    return new;
end $$;


create trigger tr_grouplist_update_cascade
after update of gruppa
on grouplist
for each row
execute function f_grouplist_update_cascade();

insert into "user"(id, lastname, name, user_group, year_b, age)
values
    (10, 'Тестов', 'Тест', 2991, 2000, 24),
    (11, 'Пробный', 'Петр', 2991, 1999, 25);

select id, lastname, name, user_group
from "user"
order by id;

select * from grouplist;

update grouplist
set gruppa = 91
where gruppa = 2991;

-- 4.2.2. Удаление строк подчинённой таблицы (on delete cascade)
-- Создайте триггер, который будет производить каскадное удаление строк из таблицы book при удалении записи в таблице author.
create function f_author_delete_cascade()
returns trigger
language plpgsql
as $$
begin
    delete from book
    where id_author = old.id;

    return old;
end $$;

create trigger tr_author_delete_cascade
after delete
on author
for each row
execute function f_author_delete_cascade();


-- 4.2.2.1.	Проверьте работу созданного триггера,
-- для этого удалите данные об авторе с кодом 1, проверьте удаление данных обо всех книгах автора.
select * from author;

insert into author (id, lastname, name, year_b, gender)
values (4, 'Тестов', 'Тест', 1880, 'm');

insert into book (
    bshifr, section, id_author,
    title, publishing, year_publ, price, about, shifr
)
values
    (9001, 'тестовый раздел', 4, 'Тестовая книга 1', 'Тест-Изд', 2020, 100, 'первая тестовая книга', 'TS0001'),
    (9002, 'тестовый раздел', 4, 'Тестовая книга 2', 'Тест-Изд', 2021, 150, 'вторая тестовая книга', 'TS0002');

select * from book   where title like 'Тестовая книга%';

delete from author
where lastname = 'Тестов' and name = 'Тест';

-- 4.2.3. Триггер для поддержки целостности на уровни ссылок.
-- Создайте триггер, который при вводе данных в таблицу book, не связанных с таблицей author будет вывод сообщения об ошибке,
-- а при успешном вводе - успешного ввода данных. Триггер должен работать таким образом,
-- чтобы при вводе записи в таблицу book, которая содержит данные об авторе,
-- отсутствующего в таблице author запись не добавлялась в таблицу, а при верном вводе – добавлялась. 
create function f_book_check_author()
returns trigger
language plpgsql
as $$
begin
    if not exists (
        select 1
        from author
        where id = new.id_author
    ) then
        raise exception 'Ошибка: автора с id % не существует. Вставка отменена.', new.id_author;
    end if;

    return new;
end $$;

create trigger tr_book_check_author
before insert or update
on book
for each row
execute function f_book_check_author();

-- 4.2.4. Создайте аналогичный триггер для контроля ввода данных в таблицу ticket.
-- Также предусмотрите проверку ввода, которая не позволяла бы добавлять запись о выдачи книги,
-- если дата возврата введена меньше даты выдачи книги.
create function f_ticket_check_links()
returns trigger
language plpgsql
as $$
begin
    -- 1. Проверка существования пользователя
    if not exists (
        select 1 from "user"
        where id = new.user_id
    ) then
        raise exception 'Ошибка: пользователя % не существует.', new.user_id;
    end if;

    -- 2. Проверка существования книги
    if not exists (
        select 1 from book
        where bshifr = new.book_id
    ) then
        raise exception 'Ошибка: книги % не существует.', new.book_id;
    end if;

    -- 3. Проверка, что книга не находится на руках у другого пользователя
    if exists (
        select 1
        from ticket
        where book_id = new.book_id
          and date_of_return is null   -- не возвращена
    ) then
        raise exception 'Ошибка: книга % уже выдана и не возвращена.', new.book_id;
    end if;

    return new;
end $$;

create trigger tr_ticket_check_links
before insert or update
on ticket
for each row
execute function f_ticket_check_links();

-- 4.2.5. Проверьте работу триггеров.
insert into book (bshifr, section, id_author, title, publishing, year_publ, price, about, shifr)
values (8001, 'тест', 9999, 'Несуществующая книга', 'Нет', 2024, 100, '...', 'NS0001');

insert into book (bshifr, section, id_author, title, publishing, year_publ, price, about, shifr)
values (8002, 'тест', 1, 'Настоящая книга', 'Тест-Изд', 2024, 200, 'ok', 'OK0001');

select * from book;

------------------

insert into "user"(id, lastname, name, user_group, year_b, age)
values (5000, 'Тестовый', 'Пользователь', 2991, 2000, 23);

insert into book(bshifr, section, id_author, title, publishing, year_publ, price, about, shifr)
values (7000, 'тест', 2, 'Тестовая книга для ticket', 'Test', 2024, 100, 'test', 'TK0003');

insert into ticket(user_id, book_id, date_of_issue, date_of_return, arrears, kdays)
values (5000, 7000, current_date, null, 0, 14);

-- 4.3.1. Создайте триггер, который при добавлении нового автора будет заполнять значение поля IO (инициалы). Для этого:
-- Добавьте в таблицу author поле io тип данных текстовый два символа (в зависимости от кодировки м.б. больше).
-- Создайте триггер на событие before insert on author, значение первых букв инициала имени и отчества из полей firstname, middlename.
-- При этом можно применить регулярное выражение для нахождения имени и отчества из поля name.
alter table author
add column io varchar(2);

create function f_author_fill_io()
returns trigger
language plpgsql
as $$
declare
    v_name text;
    v_first text;
    v_middle text;
begin
    v_name := trim(new.name);

    v_first  := substr(v_name, 1, 1);

    v_middle := substr(split_part(v_name, ' ', 2), 1, 1);

    new.io := upper(coalesce(v_first, '') || coalesce(v_middle, ''));

    return new;
end $$;

create trigger tr_author_fill_io
before insert
on author
for each row
execute function f_author_fill_io();

insert into author(id, lastname, name, year_b, gender)
values (5, 'Иванов', 'Иван Петрович', 1780, 'm');

select lastname, name, io from author
where lastname = 'Иванов';

-- 4.3.2. Создайте триггер, который при изменении даты выдачи книги будет проверять,
-- что эта дата меньше даты возврата (используем предложение when для уточнения условий,
-- при которых должен выполняться триггер, код триггера должен быть реализован только при изменении значения даты выдачи).
create function f_ticket_check_issue_change()
returns trigger
language plpgsql
as $$
begin
    if new.date_of_issue is not distinct from old.date_of_issue then
        return new;
    end if;

    if new.date_of_return is not null
       and new.date_of_return < new.date_of_issue then
        raise exception 'Ошибка: дата возврата (%) меньше новой даты выдачи (%)',
            new.date_of_return, new.date_of_issue;
    end if;

    return new;
end $$;

create trigger tr_ticket_check_issue_change
before update of date_of_issue
on ticket
for each row
execute function f_ticket_check_issue_change();

select * from ticket;

update ticket
set date_of_issue = '2026-11-14'
where id = 100

-- 4.3.3. Создание триггера, который записывает в таблицу logs(bk,cena_new,cena_old) данные о тех случаях изменения цены книги в таблице book,
-- при которых значение стоимости книги стало больше 1000 рублей.
-- Триггер должен фиксировать и те случаи изменений цены, которые отменены командой rollback
create table logs (
    id serial primary key,
    bk integer,
    cena_new real,
    cena_old real
);

create function f_book_price_log()
returns trigger
language plpgsql
as $$
begin
    if new.price is distinct from old.price then
        insert into logs(bk, cena_new, cena_old)
        values (old.bshifr, new.price, old.price);
    end if;

    return new;
end $$;

create trigger tr_book_price_log
after update of price
on book
for each row
execute function f_book_price_log();

update book
set price = price + 10
where bshifr = 1;

select * from logs;

-- 4.3.4. Создайте триггер, который обеспечит выполнение бизнес-правила: в каждой группе не может быть больше определенного количества студентов.
-- Установите максимальное количество студентов в команде равным 5.
-- При попытке добавить нового студента в группу, если в группе уже 5 студентов, триггер должен блокировать вставку новых данных.
create function f_user_group_limit()
returns trigger
language plpgsql
as $$
declare
    v_cnt integer;
begin
    select count(*) into v_cnt
    from "user"
    where user_group = new.user_group
      and (tg_op <> 'UPDATE' or id <> old.id);

    if v_cnt >= 5 then
        raise exception 'Ошибка: в группе % уже % студентов, добавление запрещено',
            new.user_group, v_cnt;
    end if;

    return new;
end $$;

create trigger tr_user_group_limit
before insert or update of user_group
on "user"
for each row
execute function f_user_group_limit();

insert into "user"(id, lastname, name, user_group, year_b, age)
values
    (6001, 'Студент1', 'Тест', 4001, 2005, 19),
    (6002, 'Студент2', 'Тест', 4001, 2005, 19),
    (6003, 'Студент3', 'Тест', 4001, 2005, 19),
    (6004, 'Студент4', 'Тест', 4001, 2005, 19),
    (6005, 'Студент5', 'Тест', 4001, 2005, 19);

insert into "user"(id, lastname, name, user_group, year_b, age)
values (6006, 'Студент6', 'Тест', 4001, 2005, 19);

-- Напишите команду MERGE, которая будет обновлять информацию о студенте, если он уже существует в базе, или добавлять его, если он новый.
merge into "user" u
using (
    values
        (7001, 'Новый', 'Студент', 4002, 2005, 19)
) as s(id, lastname, name, user_group, year_b, age)
on (u.id = s.id)
when matched then
    update set
        lastname       = s.lastname,
        name           = s.name,
        user_group     = s.user_group,
        year_b         = s.year_b,
        age            = s.age
when not matched then
    insert (id, lastname, name, user_group, year_b, age)
    values (s.id, s.lastname, s.name, s.user_group, s.year_b, s.age);

select * from "user";

-- 4.4.1. Создайте таблицу logbooks, которая будет содержать поля:
-- id_ (номер записи – с инкрементным значением,
-- date_ строка для хранения даты изменения,
-- time_ – строка для хранения времени изменения,
-- event – строка, хранящая значение действия, выполняемого с таблицей,
-- row_number – номер изменяемой строки,
-- user_ - пользователь, который вносит изменение).
create table logbooks (
    id_ serial primary key,
    date_ varchar(10),
    time_ varchar(8),
    event varchar(10),
    row_number integer,
    user_ text
);

-- 4.4.2. Создайте триггер, который будет следить за операциями добавления записей в таблицу books,
-- удаления записей в таблице books, изменения записей в таблице books.
create function f_book_log()
returns trigger
language plpgsql
as $$
declare
    v_row_number integer;
begin
    if TG_OP = 'INSERT' or TG_OP = 'UPDATE' then
        v_row_number := new.bshifr;
    elsif TG_OP = 'DELETE' then
        v_row_number := old.bshifr;
    end if;

    insert into logbooks(date_, time_, event, row_number, user_)
    values (
        to_char(now(), 'YYYY-MM-DD'),
        to_char(now(), 'HH24:MI:SS'),
        TG_OP,
        v_row_number,
        current_user
    );

    if TG_OP = 'DELETE' then
        return old;
    else
        return new;
    end if;
end $$;

create trigger tr_book_log
after insert or update or delete
on book
for each row
execute function f_book_log();

-- 4.4.3. Проверьте триггер, для этого выполните операцию добавления от имени другого пользователя.
-- !!!
insert into book (bshifr, section, id_author, title, publishing, year_publ, price, about, shifr)
values (8100, 'тестовый раздел', 3, 'Логируемая книга', 'Тест-Изд', 2024, 300, 'книга для проверки логирования', 'LG0001');

update book
set price = 350
where bshifr = 8100;

delete from book
where bshifr = 8100;

select * from logbooks
order by id_;

-- 4.5.1. Создайте многотабличное представление, которое выводит данные о книгах, пользователях и о выдачах книг.
-- Попробуйте вставить данные в созданное представление. В результате вы получите ошибку ввода.
-- 2. Создаём представление заново
create view v_books_users_tickets as
select
    t.id as ticket_id,
    b.bshifr as book_id,
    b.title as book_title,
    u.id as user_id,
    u.lastname as user_lastname,
    u.name as user_name,
    t.date_of_issue,
    t.date_of_return,
    t.arrears,
    t.kdays
from ticket t
join book  b on b.bshifr = t.book_id
join "user" u on u.id = t.user_id;

insert into v_books_users_tickets (book_id, user_id, date_of_issue, date_of_return, arrears, kdays)
values (7000, 5000, current_date, null, 0, 14);

-- 4.5.2. Создайте триггер на вставку данных в представление, который будет вставлять данные в базовые таблицы.
create or replace function f_v_books_users_tickets_insert()
returns trigger
language plpgsql
as $$
begin
    insert into ticket (user_id, book_id, date_of_issue, date_of_return, arrears, kdays)
    values (
        new.user_id,
        new.book_id,
        new.date_of_issue,
        new.date_of_return,
        new.arrears,
        new.kdays
    );
    return null;
end $$;

create trigger tr_v_books_users_tickets_insert
instead of insert
on v_books_users_tickets
for each row
execute function f_v_books_users_tickets_insert();

insert into v_books_users_tickets (book_id, user_id, user_lastname, user_name, date_of_issue, date_of_return, arrears, kdays)
values (3, 5000, 'TmpLN', 'TmpN', current_date, null, 0, 10);

select * from ticket where user_id = 5000 order by id desc;

-- 4.6.1. Создайте триггер, который будет запрещать удалять таблицы после 18-00 и фиксирует попытки это сделать.
create table ddl_log (
    id serial primary key,
    username text,
    event text,
    object text,
    date_ date,
    time_ time,
    allowed boolean
);

create function f_block_drop_after_18()
returns event_trigger
language plpgsql
as $$
declare
    v_time time := now()::time;
    obj text;
begin
    select object_identity into obj
    from pg_event_trigger_dropped_objects()
    limit 1;

    insert into ddl_log(username, event, object, date_, time_, allowed)
    values (current_user, 'DROP TABLE', obj, current_date, v_time, (v_time < '18:00'));


    if v_time >= '18:00' then
        raise exception 'Удаление таблиц запрещено после 18:00';
    end if;
end $$;

-- !!!
create event trigger trg_block_drop_after_18
on drop
execute function f_block_drop_after_18();

-- 4.6.2. Создайте триггер, который будет фиксировать случаи выполнения DML кода в субботу и в воскресенье.
-- В лог нужно записывать имя пользователя, дату и время, текст запроса.
create table weekend_log (
    id serial primary key,
    username text,
    event text,
    query text,
    date_ date,
    time_ time
);

create or replace function f_dml_weekend_log()
returns trigger
language plpgsql
as $$
declare
    dow int := extract(dow from now());
    v_query text;
begin
    if true then
        select query
          into v_query
        from pg_stat_activity
        where pid = pg_backend_pid();

        insert into weekend_log(username, event, query, date_, time_)
        values (
            current_user,
            TG_OP,
            v_query,
            current_date,
            now()::time
        );
    end if;

    if TG_OP = 'DELETE' then
        return old;
    else
        return new;
    end if;
end $$;

create trigger tr_weekend_user
before insert or update or delete
on "user"
for each row
execute function f_dml_weekend_log();

create trigger tr_weekend_book
before insert or update or delete
on book
for each row
execute function f_dml_weekend_log();

create trigger tr_weekend_ticket
before insert or update or delete
on ticket
for each row
execute function f_dml_weekend_log();

drop trigger tr_weekend_ticket on ticket;
drop trigger tr_weekend_user on "user";
drop trigger tr_weekend_book on book;

insert into book(bshifr, section, id_author, title, publishing, year_publ, price, about, shifr)
values (9900, 'weekend', 1, 'weekend book', 'test', 2024, 10, 't', 'WK0001');

select * from weekend_log order by id desc limit 10;