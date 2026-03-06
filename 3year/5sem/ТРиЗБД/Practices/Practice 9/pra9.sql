-- 3.1.	Управление данными. Наследование
-- 3.1.1.	Создайте таблицы Студент, Преподаватель, которые наследуются от таблицы users и каждая из таблиц имеет своё собственное поле
create table student (
    course int not null
) inherits (users);

create table teacher (
    salary numeric(10,2) not null
) inherits (users);

-- 3.1.2.	Создайте операции вставки, обновления, удаления данных из таблиц
-- вставка
insert into student (lastname, name, groupa, year_b, age, category, course)
values ('иванов','пётр','п-11',2004,20,'студент',1),
('смирнова','оля','п-12',2005,19,'студент',2);

insert into teacher (lastname, name, groupa, year_b, age, category, salary)
values ('павлов','сергей',null,1985,39,'преподаватель',85000.00),
('кудрявцева','анна',null,1990,34,'преподаватель',92000.00);

select * from student;
select * from teacher;

update only student
set course = course + 1
where lastname = 'иванов';

update only teacher
set salary = salary * 1.05
where lastname = 'кудрявцева';

select * from student;
select * from teacher;

delete from only student
where lastname = 'смирнова';
delete from only teacher
where lastname = 'павлов';

select * from student;
select * from teacher;

-- 3.1.3.	Напишите операции выборки данных с применением оператора only и без
select id, lastname, name from users;
select id, lastname, name from only users;
select id, lastname, name, course from only student;

-- 3.2.	Секционирование 
-- 3.2.1.	Создание таблицы с разбиением по значению поля даты
-- 	Создайте секционированную таблицу Sec_Book, содержащую данные о шифрах книги и даты ее выдачи, 
-- создайте три секции, в зависимости от даты выдачи (распределите по годам или по месяцам, в зависимости от данных вашей таблицы)
create table sec_book ( id serial, book_code int not null, issue_date date not null, primary key (id, issue_date)
) partition by range (issue_date);

create table sec_book_2023 partition of sec_book for values from ('2023-01-01') to ('2024-01-01');
create table sec_book_2024 partition of sec_book for values from ('2024-01-01') to ('2025-01-01');
create table sec_book_2025 partition of sec_book for values from ('2025-01-01') to ('2026-01-01');
-- 	Напишите запрос на вставку записей в созданную таблицу из таблицы Билет
insert into sec_book (book_code, issue_date)
select t.book_bshifr, t.book_issuance
from tiket t;

-- 	Напишите запрос на выборку данных из каждой созданной секции, например, select * from Sec_Book partition_part1;
select * from sec_book_2023;
select * from sec_book_2024;
select * from sec_book_2025;
select * from book;
-- 3.2.2.	Создайте таблицу Book_razd, которая будет содержать список книг по разделам
create table book_razd (
    section text not null,
    bshifr  integer not null references book(bshifr),
    primary key (section, bshifr)
);
insert into book_razd(section, bshifr)
select section, bshifr from book where section is not null;
-- 3.2.3.	Создайте таблицу Users, которая будет содержать список пользователей в зависимости по годам рождения (диапазонам годов).
create table Users_by_year_b (
    id integer,
    lastname text,
    name text,
    year_b integer not null
) partition by range (year_b);
select * from Users_by_year_b;

-- 3.3.	Секционирование с использованием наследования
-- 3.3.1.	Создайте таблицы ticket2024m1, ticket2024m2, … ticket2024m12 как таблицы наследование данных таблицы ticket. При создании таблиц добавим неперекрывающиеся ограничения, определяющие допустимые значения ключей каждой таблицы, с указанием определённых дат, по примеру
create table tiket2024m01 (check (book_issuance >= date '2024-01-01' and book_issuance < date '2024-02-01')
) inherits (tiket);

create table tiket2024m02 (check (book_issuance >= date '2024-02-01' and book_issuance < date '2024-03-01')
) inherits (tiket);

create table tiket2024m03 (
    check (book_issuance >= date '2024-03-01' and book_issuance < date '2024-04-01')
) inherits (tiket);

create table tiket2024m04 (check (book_issuance >= date '2024-04-01' and book_issuance < date '2024-05-01')
) inherits (tiket);

create table tiket2024m05 (check (book_issuance >= date '2024-05-01' and book_issuance < date '2024-06-01')
) inherits (tiket);

create table tiket2024m06 (check (book_issuance >= date '2024-06-01' and book_issuance < date '2024-07-01')
) inherits (tiket);

create table tiket2024m07 (check (book_issuance >= date '2024-07-01' and book_issuance < date '2024-08-01')
) inherits (tiket);

create table tiket2024m08 (check (book_issuance >= date '2024-08-01' and book_issuance < date '2024-09-01')
) inherits (tiket);

create table tiket2024m09 (
    check (book_issuance >= date '2024-09-01' and book_issuance < date '2024-10-01')
) inherits (tiket);

create table tiket2024m10 (check (book_issuance >= date '2024-10-01' and book_issuance < date '2024-11-01')
) inherits (tiket);

create table tiket2024m11 (check (book_issuance >= date '2024-11-01' and book_issuance < date '2024-12-01')
) inherits (tiket);

create table tiket2024m12 (check (book_issuance >= date '2024-12-01' and book_issuance < date '2025-01-01')
) inherits (tiket);
-- 3.3.2.	Создайте индексы для каждой таблицы по полю дата выдачи книги.
create index tik24m01_book_issuance_idx on tiket2024m01 (book_issuance);
create index tik24m02_book_issuance_idx on tiket2024m02 (book_issuance);
create index tik24m03_book_issuance_idx on tiket2024m03 (book_issuance);
create index tik24m04_book_issuance_idx on tiket2024m04 (book_issuance);
create index tik24m05_book_issuance_idx on tiket2024m05 (book_issuance);
create index tik24m06_book_issuance_idx on tiket2024m06 (book_issuance);
create index tik24m07_book_issuance_idx on tiket2024m07 (book_issuance);
create index tik24m08_book_issuance_idx on tiket2024m08 (book_issuance);
create index tik24m09_book_issuance_idx on tiket2024m09 (book_issuance);
create index tik24m10_book_issuance_idx on tiket2024m10 (book_issuance);
create index tik24m11_book_issuance_idx on tiket2024m11 (book_issuance);
create index tik24m12_book_issuance_idx on tiket2024m12 (book_issuance);
-- 3.3.3.	Напишите правило, которое перенаправляет строки в соответствующую таблицу
create rule tiket_insert_2024m01 as
on insert to tiket
where (new.book_issuance >= date '2024-01-01' and new.book_issuance < date '2024-02-01')
do instead insert into tiket2024m01 values (new.*);

create rule tiket_insert_2024m02 as
on insert to tiket
where (new.book_issuance >= date '2024-02-01' and new.book_issuance < date '2024-03-01')
do instead insert into tiket2024m02 values (new.*);

create rule tiket_insert_2024m03 as
on insert to tiket
where (new.book_issuance >= date '2024-03-01' and new.book_issuance < date '2024-04-01')
do instead insert into tiket2024m03 values (new.*);

create rule tiket_insert_2024m04 as
on insert to tiket
where (new.book_issuance >= date '2024-04-01' and new.book_issuance < date '2024-05-01')
do instead insert into tiket2024m04 values (new.*);

create rule tiket_insert_2024m05 as
on insert to tiket
where (new.book_issuance >= date '2024-05-01' and new.book_issuance < date '2024-06-01')
do instead insert into tiket2024m05 values (new.*);

create rule tiket_insert_2024m06 as
on insert to tiket
where (new.book_issuance >= date '2024-06-01' and new.book_issuance < date '2024-07-01')
do instead insert into tiket2024m06 values (new.*);

create rule tiket_insert_2024m07 as
on insert to tiket
where (new.book_issuance >= date '2024-07-01' and new.book_issuance < date '2024-08-01')
do instead insert into tiket2024m07 values (new.*);

create rule tiket_insert_2024m08 as
on insert to tiket
where (new.book_issuance >= date '2024-08-01' and new.book_issuance < date '2024-09-01')
do instead insert into tiket2024m08 values (new.*);

create rule tiket_insert_2024m09 as
on insert to tiket
where (new.book_issuance >= date '2024-09-01' and new.book_issuance < date '2024-10-01')
do instead insert into tiket2024m09 values (new.*);

create rule tiket_insert_2024m10 as
on insert to tiket
where (new.book_issuance >= date '2024-10-01' and new.book_issuance < date '2024-11-01')
do instead insert into tiket2024m10 values (new.*);

create rule tiket_insert_2024m11 as
on insert to tiket
where (new.book_issuance >= date '2024-11-01' and new.book_issuance < date '2024-12-01')
do instead insert into tiket2024m11 values (new.*);

create rule tiket_insert_2024m12 as
on insert to tiket
where (new.book_issuance >= date '2024-12-01' and new.book_issuance < date '2025-01-01')
do instead insert into tiket2024m12 values (new.*);

create rule tiket_insert_out_of_2024 as
on insert to tiket
where not (new.book_issuance >= date '2024-01-01'
and new.book_issuance < date '2025-01-01'
)
do instead nothing;

-- 3.3.4.	Заполните некоторыми данными ваши таблицы.
insert into tiket (user_id, book_bshifr, book_issuance)
values (1, 101, date '2024-01-10'),
(2, 102, date '2024-02-05'),
(3, 103, date '2024-03-15'),
(4, 104, date '2024-04-20'),
(5, 105, date '2024-05-25'),
(6, 106, date '2024-06-03'),
(7, 107, date '2024-07-11'),
(8, 108, date '2024-08-22'),
(9, 109, date '2024-09-09'),
(10, 110, date '2024-10-18'),
(11, 111, date '2024-11-27'),
(12, 112, date '2024-12-06');

-- 3.3.5.	Постройте план запроса на для обращения к конкретной секции, нарисуйте дерево плана запроса.
explain analyze
select count(*)
from tiket
where book_issuance >= date '2024-03-01'
and book_issuance <  date '2024-04-01';

-- 3.4.	Домен и тип данных
-- 3.4.1.	Создание домена и применение
-- 3.4.2.	Создайте домен chN, в котором добавьте проверку, что имя и фамилия пользователя не содержит пробелов и пустых значений
create domain chN as varchar not null check (value !~ '\s');

-- 3.4.3.	Измените тип данных фамилии и имени пользователя на указанных домен. Проверьте работу домена
alter table users alter column lastname type chn using lastname::chn,
alter column name type chn using name::chn;
select * from users;

insert into users (lastname, name, groupa, year_b, age, category)
values ('Иванов','Петр','П-11',2004,20,'student');

insert into users (lastname, name, groupa, year_b, age, category)
values ('Иван ов','Петр','П-11',2004,20,'student');

-- 3.4.4.	Создайте тип данных, включающий два текстовых поля для хранения названия компании и название должности работника.
-- Примените тип данных для таблицы Пользователь, добавив поле – работа.
create type work_info as (company  varchar(50), position varchar(30));

alter table users add column work work_info;
update users
set work = row('НовГУ', 'преподаватель')
where category = 'преподаватель';

update users
set work = row('НовГУ', 'методист')
where category = 'методист';

-- 3.4.5.	Создайте запрос, который по id пользователя возвращает данные о его работе.
select id, lastname, name, work
from users
where id = 5;


-- 3.5.	Массивы
-- 3.5.1.	Добавьте в таблицу users поле contact_number имеющим тип данных ARRAY строки
alter table users
add column contact_number text[];

-- 3.5.2.	Добавьте данные в данное поле по примеру
update users set contact_number = array['(+7) 911-111-10-36','(+7) 961-222-10-36'] where id = 2;
update users set contact_number = array['+7 911 222-33-44'] where id = 4;
update users set contact_number = array['+7 900 000-00-00','+7 911 222-22-22','+7 911 123-45-67'] where id = 5;
update users set contact_number = array['+7 921 555-55-55', '+7 911 726-22-18'] where id = 38;

-- 3.5.3.	Напишите запрос для нахождения фио пользователя и первого телефона из списка у пользователя
select concat(lastname, ' ', name) as fio, contact_number[1] as first_phone
from users
where contact_number is not null;

-- 3.5.4.	Выведите записи о пользователях, которые имеют номер, начинающийся на 911, и содержит две цифры 2 – с применением регулярного выражения
select id, lastname, name, contact_number
from users
where exists (select *
from unnest(contact_number) as num
where regexp_replace(num, '\D', '', 'g') ~ '^(7|8)?911'
and regexp_replace(num, '\D', '', 'g') ~ '2.*2');

-- 3.5.5.	Примените функцию ANY() для нахождения пользователей, которые имеют конкретный телефон
select id, lastname, name
from users
where '+7 911 222-33-44' = any(contact_number);

-- 3.5.6.	Напишите запросы с применением операторов @>,<@, &&, ||

-- @>  массив пользователя СОДЕРЖИТ указанные элементы
select id, lastname, name
from users
where contact_number @> array['+7 911 222-33-44'];

-- <@  массив пользователя ПОДМНОЖЕСТВО заданного набора
select id, lastname, name
from users
where contact_number <@ array['+7 911 222-33-44', '+7 921 555-55-55'];

-- &&  массив пользователя ПЕРЕСЕКАЕТСЯ с набором хотя бы по одному элементу
select id, lastname, name
from users
where contact_number && array['+7 911 222-33-44', '+7 900 000-00-00'];

-- ||  КОНКАТЕНАЦИЯ массивов (добавить номер в конец)
update users
set contact_number = coalesce(contact_number, '{}') || array['+7 950 777-77-77']
where id = 2;

select id, lastname, name, contact_number
from users
where id = 2;
-- 3.5.7.	Напишите запросы с применением функций array_append, array_cat, array_dims, unnest
update users
set contact_number = array_append(coalesce(contact_number,'{}'::text[]), '+7 960 111-22-33')
where id = 4;

update users
set contact_number = array_cat(
coalesce(contact_number,'{}'::text[]),
array['+7 999 000-00-01','+7 999 000-00-02']
)
where id = 5;

select id, lastname, name, array_dims(contact_number) as dims
from users
where contact_number is not null;

select u.id, concat(u.lastname,' ',u.name) as fio, p.phone
from users u
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
  'work','Университет НовГУ',
  'interests', jsonb_build_array('спорт')
)
where id in (35,40);

select * from student;


update student
set about = jsonb_build_object(
  'work','Колледж ИТ',
  'interests', jsonb_build_array('спорт','чтение')
)
where id in (36,37,35);

update student
set about = jsonb_build_object(
  'work','ПГУ',
  'interests', jsonb_build_array('спорт','компьютер')
)
where id in (39);


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
  <dayWeek day="Monday">
    <lesson>Базы данных</lesson>
    <group>1091</group>
    <time>09-00—12-00</time>
  </dayWeek>
  <dayWeek day="Wednesday">
    <lesson>SQL</lesson>
    <group>1092</group>
    <time>10-00—13-00</time>
  </dayWeek>
  <dayWeek day="Saturday">
    <lesson>Проектирование ИС</lesson>
    <group>1095</group>
    <time>11-00—14-00</time>
  </dayWeek>
</schedule>
$$
where id = 38;

select id, lastname, name, schedule
from teacher
where schedule is not null;

insert into teacher (lastname, name, year_b, age, category, salary, work, contact_number, schedule)
values ('Смирнов', 'Игорь', 1988, 36, 'преподаватель', 85000.00, row('НовГУ', 'преподаватель'), array['+7 911 555-44-77', '+7 911 444-22-33'],
  $$
  <schedule>
    <dayWeek day="Tuesday">
      <lesson>Python</lesson>
      <group>1093</group>
      <time>09-00—11-00</time>
    </dayWeek>
    <dayWeek day="Thursday">
      <lesson>Веб-разработка</lesson>
      <group>1094</group>
      <time>12-00—15-00</time>
    </dayWeek>
  </schedule>
  $$
);

insert into teacher (lastname, name, year_b, age, category, salary, work, contact_number, schedule)
values ('Кузнецов', 'Михаил', 1984, 40, 'преподаватель', 91000.00, row('НовГУ', 'преподаватель'), array['+7 950 111-11-11'],
  $$
  <schedule>
    <dayWeek day="Monday">
      <lesson>Компьютерные сети</lesson>
      <group>1091</group>
      <time>13-00—15-00</time>
    </dayWeek>
    <dayWeek day="Friday">
      <lesson>Кибербезопасность</lesson>
      <group>1095</group>
      <time>09-00—12-00</time>
    </dayWeek>
  </schedule>
  $$
);

insert into teacher (lastname, name, year_b, age, category, salary, work, contact_number, schedule)
values ('Орлова', 'Марина', 1990, 34, 'преподаватель', 97500.00, row('НовГУ', 'преподаватель'), array['+7 901 555-66-99'],
  $$
  <schedule>
    <dayWeek day="Wednesday">
      <lesson>Анализ данных</lesson>
      <group>1092</group>
      <time>11-00—14-00</time>
    </dayWeek>
    <dayWeek day="Saturday">
      <lesson>Математика</lesson>
      <group>1093</group>
      <time>09-00—11-00</time>
    </dayWeek>
  </schedule>
  $$
);

select id, lastname, name, schedule
from teacher
where schedule is not null;


select t.id, t.lastname, t.name, xmlserialize(content x as text) as расписание_для_группы
from teacher t, lateral unnest(xpath('//dayWeek[group="1091"]', t.schedule)) as x
where t.schedule is not null;

-- 3.7.	Использование UUID, RAND() и NEWID().
-- 3.7.1.	Создайте таблицу для авторизации пользователя в системе с полями id (uuid первичный ключ, login (логин), 
-- email (электронная почта), password (зашифрованный пароль), dt_create (дата и время записи).

-- 3.7.2.	Напишите запрос для создания 100 записей в таблице, при этом генерируйте данные по логину 
-- и почты по своему усмотрению, для пароля примените хэширование, дату создания берем из системной информации.
-- 3.7.3.	Напишите запрос для получения списка пользователей
-- 3.7.4.	Напишите запрос для получения данных о конкретном пользователе, эмитируйте ситуацию пользовательского входа.
-- 3.7.5.	Напишите правило проверки для добавления нового пользователя с проверкой существования записи.
