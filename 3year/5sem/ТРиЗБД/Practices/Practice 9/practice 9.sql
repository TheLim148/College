-- 3.1.1. Создайте таблицы Студент, Преподаватель, которые наследуются от таблицы users и каждая из таблиц имеет своё собственное поле
create table student (
    student_card text unique
) inherits ("user");

create table teacher (
    job_title text
) inherits ("user");

-- 3.1.2. Создайте операции вставки, обновления, удаления данных из таблиц
insert into student (id, lastname, name, user_group, year_b, age, level, category, student_card)
values (10001, 'иванов', 'пётр', 3, 2005, 19, 1, 'студент', 'sc-001'),
       (10002, 'сидорова', 'мария', 4, 2004, 20, 2, 'студент', 'sc-002');

insert into teacher (id, lastname, name, user_group, year_b, age, level, category, job_title)
values (20001, 'петров', 'иван', 9, 1980, 45, 2, 'преподаватель', 'доцент'),
       (20002, 'смирнова', 'елена', 9, 1975, 50, 2, 'преподаватель', 'профессор');

update student set student_card = 'sc-001a' where id = 10001;

delete from teacher where id = 20002;

-- 3.1.3. Напишите операции выборки данных с применением оператора only и без
select id, lastname, name from "user";

select id, lastname, name from only "user";

select id, lastname, name, student_card from only student;


-- 3.2.1. Создание таблицы с разбиением по значению поля даты
-- Создайте секционированную таблицу Sec_Book, содержащую данные о шифрах книги и даты ее выдачи, создайте три секции, в зависимости от даты выдачи (распределите по годам или по месяцам, в зависимости от данных вашей таблицы)
-- Напишите запрос на вставку записей в созданную таблицу из таблицы Билет
-- Напишите запрос на выборку данных из каждой созданной секции, например, select * from Sec_Book partition_part1;
create table sec_book (
    id bigserial,
    book_shifr integer not null,
    date_of_issue date not null,
	primary key(id, date_of_issue)
) partition by range (date_of_issue);


-- секции по десятилетиям
create table sec_book_1990s partition of sec_book
for values from ('1990-01-01') to ('2000-01-01');

create table sec_book_2000s partition of sec_book
for values from ('2000-01-01') to ('2010-01-01');

create table sec_book_2010s partition of sec_book
for values from ('2010-01-01') to ('2020-01-01');

create table sec_book_2020s partition of sec_book
for values from ('2020-01-01') to ('2030-01-01');

create table sec_book_other partition of sec_book default;

insert into sec_book (book_shifr, date_of_issue)
select b.bshifr, t.date_of_issue
from ticket t
join book b on b.bshifr = t.book_id;

select * from sec_book_2020s;
select * from sec_book order by id;

-- 3.2.2. Создайте таблицу Book_razd, которая будет содержать список книг по разделам
create table book_razd (
    section text not null,
    bshifr integer not null references book(bshifr),
    primary key (section, bshifr)
);

insert into book_razd(section, bshifr)
select section, bshifr from book where section is not null;

select * from book_razd;

-- 3.2.3. Создайте таблицу Users, которая будет содержать список пользователей в зависимости по годам рождения (диапазонам годов).
create table Users as
select u.id, u.lastname, u.name, u.user_group, u.year_b, u.age, u.level, u.category,
    case
        when u.year_b is null then 'unknown'
        when u.year_b < 1990 then 'до 1990'
        when u.year_b between 1990 and 1999 then '1990–1999'
        when u.year_b between 2000 and 2009 then '2000–2009'
        when u.year_b between 2010 and 2019 then '2010–2019'
        else '2020+'
    end as birth_range
from "user" as u;

select birth_range, count(*) as cnt
from Users
group by birth_range
order by birth_range;

-- 3.3.1. Создайте таблицы ticket2024m1, ticket2024m2, … ticket2024m12 как таблицы наследование данных таблицы ticket. При создании таблиц добавим неперекрывающиеся ограничения, определяющие допустимые значения ключей каждой таблицы, с указанием определённых дат, по примеру
create table ticket2024m1  (
  check (date_of_issue >= date '2024-01-01' and date_of_issue < DATE '2024-02-01')
) inherits (ticket);

create table ticket2024m2  (
  check (date_of_issue >= date '2024-02-01' and date_of_issue < DATE '2024-03-01')
) inherits (ticket);

create table ticket2024m3  (
  check (date_of_issue >= date '2024-03-01' and date_of_issue < DATE '2024-04-01')
) inherits (ticket);

create table ticket2024m4  (
  check (date_of_issue >= date '2024-04-01' and date_of_issue < DATE '2024-05-01')
) inherits (ticket);

create table ticket2024m5  (
  check (date_of_issue >= date '2024-05-01' and date_of_issue < DATE '2024-06-01')
) inherits (ticket);

create table ticket2024m6  (
  check (date_of_issue >= date '2024-06-01' and date_of_issue < DATE '2024-07-01')
) inherits (ticket);

CREATE TABLE ticket2024m7  (
  check (date_of_issue >= date '2024-07-01' and date_of_issue < DATE '2024-08-01')
) inherits (ticket);

create table ticket2024m8  (
  check (date_of_issue >= date '2024-08-01' and date_of_issue < DATE '2024-09-01')
) inherits (ticket);

create table ticket2024m9  (
  check (date_of_issue >= date '2024-09-01' and date_of_issue < DATE '2024-10-01')
) inherits (ticket);

create table ticket2024m10 (
  check (date_of_issue >= date '2024-10-01' and date_of_issue < DATE '2024-11-01')
) inherits (ticket);

create table ticket2024m11 (
  check (date_of_issue >= date '2024-11-01' and date_of_issue < DATE '2024-12-01')
) inherits (ticket);

create table ticket2024m12 (
  check (date_of_issue >= date '2024-12-01' and date_of_issue < DATE '2025-01-01')
) inherits (ticket);

-- 3.3.2. Создайте индексы для каждой таблицы по полю дата выдачи книги.
create index idx_ticket2024m1_issue  on ticket2024m1  (date_of_issue);
create index idx_ticket2024m2_issue  on ticket2024m2  (date_of_issue);
create index idx_ticket2024m3_issue  on ticket2024m3  (date_of_issue);
create index idx_ticket2024m4_issue  on ticket2024m4  (date_of_issue);
create index idx_ticket2024m5_issue  on ticket2024m5  (date_of_issue);
create index idx_ticket2024m6_issue  on ticket2024m6  (date_of_issue);
create index idx_ticket2024m7_issue  on ticket2024m7  (date_of_issue);
create index idx_ticket2024m8_issue  on ticket2024m8  (date_of_issue);
create index idx_ticket2024m9_issue  on ticket2024m9  (date_of_issue);
create index idx_ticket2024m10_issue on ticket2024m10 (date_of_issue);
create index idx_ticket2024m11_issue on ticket2024m11 (date_of_issue);
create index idx_ticket2024m12_issue on ticket2024m12 (date_of_issue);

-- 3.3.3. Напишите правило, которое перенаправляет строки в соответствующую таблицу
create or replace rule ticket_insert_2024m1 as
on insert to ticket
where (new.date_of_issue >= date '2024-01-01' and new.date_of_issue < date '2024-02-01')
do instead insert into ticket2024m1 values (new.*);

create or replace rule ticket_insert_2024m2 as
on insert to ticket
where (new.date_of_issue >= date '2024-02-01' and new.date_of_issue < date '2024-03-01')
do instead insert into ticket2024m2 values (new.*);

create or replace rule ticket_insert_2024m3 as
on insert to ticket
where (new.date_of_issue >= date '2024-03-01' and new.date_of_issue < date '2024-04-01')
do instead insert into ticket2024m3 values (new.*);

create or replace rule ticket_insert_2024m4 as
on insert to ticket
where (new.date_of_issue >= date '2024-04-01' and new.date_of_issue < date '2024-05-01')
do instead insert into ticket2024m4 values (new.*);

create or replace rule ticket_insert_2024m5 as
on insert to ticket
where (new.date_of_issue >= date '2024-05-01' and new.date_of_issue < date '2024-06-01')
do instead insert into ticket2024m5 values (new.*);

create or replace rule ticket_insert_2024m6 as
on insert to ticket
where (new.date_of_issue >= date '2024-06-01' and new.date_of_issue < date '2024-07-01')
do instead insert into ticket2024m6 values (new.*);

create or replace rule ticket_insert_2024m7 as
on insert to ticket
where (new.date_of_issue >= date '2024-07-01' and new.date_of_issue < date '2024-08-01')
do instead insert into ticket2024m7 values (new.*);

create or replace rule ticket_insert_2024m8 as
on insert to ticket
where (new.date_of_issue >= date '2024-08-01' and new.date_of_issue < date '2024-09-01')
do instead insert into ticket2024m8 values (new.*);

create or replace rule ticket_insert_2024m9 as
on insert to ticket
where (new.date_of_issue >= date '2024-09-01' and new.date_of_issue < date '2024-10-01')
do instead insert into ticket2024m9 values (new.*);

create or replace rule ticket_insert_2024m10 as
on insert to ticket
where (new.date_of_issue >= date '2024-10-01' and new.date_of_issue < date '2024-11-01')
do instead insert into ticket2024m10 values (new.*);

create or replace rule ticket_insert_2024m11 as
on insert to ticket
where (new.date_of_issue >= date '2024-11-01' and new.date_of_issue < date '2024-12-01')
do instead insert into ticket2024m11 values (new.*);

create or replace rule ticket_insert_2024m12 as
on insert to ticket
where (new.date_of_issue >= date '2024-12-01' and new.date_of_issue < date '2025-01-01')
do instead insert into ticket2024m12 values (new.*);

-- 3.3.4. Заполните некоторыми данными ваши таблицы.

insert into ticket (user_id, book_id, date_of_issue, date_of_return, arrears, kdays)
values
	(1, 1, '2024-01-15', '2024-01-25', 0, 10),
	(2, 2, '2024-02-10', '2024-02-18', 0, 8),
	(3, 3, '2024-03-05', '2024-03-14', 1, 9),
	(4, 4, '2024-04-12', '2024-04-20', 0, 8),
	(5, 5, '2024-05-22', '2024-05-30', 0, 8),
	(6, 6, '2024-06-17', '2024-06-25', 2, 8),
	(7, 7, '2024-07-02', '2024-07-10', 0, 8),
	(8, 8, '2024-08-19', '2024-08-26', 0, 7),
	(9, 9, '2024-09-11', '2024-09-20', 0, 9),
	(10, 10, '2024-10-03', '2024-10-12', 1, 9),
	(11, 11, '2024-11-08', '2024-11-17', 0, 9),
	(12, 12, '2024-12-25', '2025-01-05', 0, 11);

-- 3.3.5. Постройте план запроса на для обращения к конкретной секции, нарисуйте дерево плана запроса.
explain (verbose, costs off)
select count(*)
from ticket
where date_of_issue >= date '2024-05-01'
  and date_of_issue <  date '2024-06-01';

-- 3.4.2. Создайте домен chN, в котором добавьте проверку, что имя и фамилия пользователя не содержит пробелов и пустых значений
create domain chn as varchar not null
check (value !~ '\s');

select 'Иванов'::chn;
select 'Петр'::chn;
select 'Иван Иванов'::chn;
select ''::chn;

-- 3.4.3. Измените тип данных фамилии и имени пользователя на указанных домен. Проверьте работу домена
select id, lastname, name
from "user"
where lastname is null or name is null
   or lastname ~ '\s' or name ~ '\s'
   or lastname = '' or name = '';

alter table "user"
  alter column lastname type chn using lastname::chn,
  alter column name type chn using name::chn;

-- 3.4.4. Создайте тип данных, включающий два текстовых поля для хранения названия компании и название должности работника. Примените тип данных для таблицы Пользователь, добавив поле – работа.
create type work_info as (
    company text,
    position text
);

alter table "user"
add column work work_info;

update "user"
set work = row('ООО БиблиоСфера', 'Менеджер')
where id = 1;

select id, lastname, name, work from "user";

-- 3.4.5. Создайте запрос, который по id пользователя возвращает данные о его работе.
select
    id,
    (work).company  as company,
    (work).position as position
from "user"
where id = 1;

-- 3.5.1. Добавьте в таблицу "user" поле contact_number имеющим тип данных ARRAY строки
alter table "user"
add column contact_number text[];

-- 3.5.2. Добавьте данные в данное поле по примеру
update "user"
set contact_number = array['+7-900-123-45-67', '+7-911-222-33-44']
where id = 1;

select id, lastname, name, contact_number
from "user"
where id = 1;

-- 3.5.3. Напишите запрос для нахождения фио пользователя и первого телефона из списка у пользователя
select concat(lastname, ' ', name) as fio, contact_number[1] as first_phone
from "user"
where contact_number is not null;

-- 3.5.4.	Выведите записи о пользователях, которые имеют номер, начинающийся на 911, и содержит две цифры 2 – с применением регулярного выражения
select id, lastname, name, contact_number
from "user"
where exists (select *
from unnest(contact_number) as num
where regexp_replace(num, '\D', '', 'g') ~ '^(7|8)?911'
and regexp_replace(num, '\D', '', 'g') ~ '2.*2');

-- 3.5.5.	Примените функцию ANY() для нахождения пользователей, которые имеют конкретный телефон
select id, lastname, name
from "user"
where '+7-900-123-45-67' = any(contact_number);

-- 3.5.6.	Напишите запросы с применением операторов @>,<@, &&, ||

-- @>  массив пользователя СОДЕРЖИТ указанные элементы
select id, lastname, name
from "user"
where contact_number @> array['+7-900-123-45-67'];

-- <@  массив пользователя ПОДМНОЖЕСТВО заданного набора
select id, lastname, name
from "user"
where contact_number <@ array['+7-900-123-45-67', '+7-911-222-33-44'];

-- &&  массив пользователя ПЕРЕСЕКАЕТСЯ с набором хотя бы по одному элементу
select id, lastname, name
from "user"
where contact_number && array['+7-900-123-45-67', '+7 900 000-00-00'];

-- ||  КОНКАТЕНАЦИЯ массивов (добавить номер в конец)
update "user"
set contact_number = coalesce(contact_number, '{}') || array['+7-900-123-45-67']
where id = 2;

select id, lastname, name, contact_number
from "user"
where id = 2;

-- 3.5.7.	Напишите запросы с применением функций array_append, array_cat, array_dims, unnest
update "user"
set contact_number = array_append(coalesce(contact_number,'{}'::text[]), '+7 960 111-22-33')
where id = 4;

update "user"
set contact_number = array_cat(
coalesce(contact_number,'{}'::text[]),
array['+7 999 000-00-01','+7 999 000-00-02']
)
where id = 5;

select id, lastname, name, array_dims(contact_number) as dims
from "user"
where contact_number is not null;

select u.id, concat(u.lastname,' ',u.name) as fio, p.phone
from "user" u
cross join lateral unnest(u.contact_number) as p(phone)
order by u.id, p.phone;

-- 3.6.	Работа с данными в форматах json, xml
-- 3.6.1.	Добавим в таблицу Студент поле about формата json для хранения данных о пользователе, а именно – work место учёбы/работы, interests – интересы – набор нескольких данных, по примеру. Заполните записями. Выведите данные только о тех пользователях, в интересы которых входит только спорт, спорт или чтение, спорт и компьютер
--{
--  "work": "Университет НовГУ",
-- "interests": "путешествия", "чтение", "спорт"
--}
--	Добавим в таблицу Преподаватель поле schedule формата xml для хранения расписания педагога, по примеру. Заполните записями. Выведите данные только о расписании, о расписании определённой группы.
alter table student add column about jsonb;

update student
set about = jsonb_build_object(
	'work','университет новгу',
	'interests', jsonb_build_array('спорт')
)
where id in (select id from student order by id limit 2);

select * from student;

create table teacher (
    id serial primary key,
    lastname varchar(20) not null,
    name varchar(15) not null,
    year_b integer,
    age integer,
    category text default 'преподаватель',
    position varchar(40),
    work_place varchar(50),
    schedule xml,
    contact_number text[]
);

alter table teacher add column if not exists schedule xml;
select * from teacher;

update teacher
set schedule = $$
<schedule>
  <dayWeek day="monday">
    <lesson>базы данных</lesson>
    <group>1091</group>
    <time>09-00—12-00</time>
  </dayWeek>
  <dayWeek day="wednesday">
    <lesson>sql</lesson>
    <group>1092</group>
    <time>10-00—13-00</time>
  </dayWeek>
</schedule>
$$
where id = (select id from teacher order by id limit 1);

select id, lastname, name, schedule
from teacher
where schedule is not null;

select t.id, t.lastname, t.name, xmlserialize(content x as text) as расписание_для_группы
from teacher t, lateral unnest(xpath('//dayWeek[group="1091"]', t.schedule)) as x
where t.schedule is not null;

-- 3.7.1. Создайте таблицу для авторизации пользователя в системе с полями id (uuid первичный ключ, login (логин), email (электронная почта), password (зашифрованный пароль), dt_create (дата и время записи).


-- 3.7.2. Напишите запрос для создания 100 записей в таблице, при этом генерируйте данные по логину и почты по своему усмотрению, для пароля примените хэширование, дату создания берем из системной информации.


-- 3.7.3. Напишите запрос для получения списка пользователей


-- 3.7.4. Напишите запрос для получения данных о конкретном пользователе, эмитируйте ситуацию пользовательского входа.


-- 3.7.5. Напишите правило проверки для добавления нового пользователя с проверкой существования записи.

