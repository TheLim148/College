-- 3.1.1. Поиск с помощью регулярных выражений
-- Выполните поиск с применением функции regexp_match
select id, category, regexp_match(category, '([A-Za-zА-Яа-я]+)') as first_token
from "user"
where category is not null;

select regexp_match('Книга издана в 2019 году', '(\d{4})') as year_match;

-- Выполните поиск с применением функции regexp_matches
select b.id_author, b.title, (regexp_matches(coalesce(b.about,''), '([A-Za-zА-Яа-я]+)', 'g')) as token
from book b
where b.about is not null
order by id_author asc;

-- Выполните поиск с применением regexp_replace
select id,
	lastname as raw,
	regexp_replace(lastname, '\s+', ' ', 'g') as cleaned
from "user";

select regexp_replace('a__b__c', '_', '–', 'g');

-- Разберитесь с функцией regexp_split_to_table
select b.id_author, b.title,
	trim(x) as tag
from book b,
	regexp_split_to_table(coalesce(b.about,''), '[,:;]') as x
where b.about is not null;

-- Разберитесь с функцией split_part
select id,
	lastname || ' ' || name as fio,
	split_part(name, ' ', 1) as name_first_token,
	left(name, 1) || '.' || left(lastname, 1) || '.' as initials
from "user";

-- Разберитесь с функцией substring
select id, lastname, substring(lastname from 1 for 3) as last3
from "user";

select substring('Год: 2001' from '(\d{4})')::int as y;

select substring('Год: 2001' from '([A-Za-zА-Яа-я]+:)')::varchar as y;

-- 3.1.2. Работа с неструктурированными данными
create temp table tmp_raw_people(txt text);

insert into tmp_raw_people(txt) values
	('Иванов Иван 1999 студент'),
	('Петров-Павлов Сергей 2001 преподаватель'),
	('Сидорова Анна 2000 аспирант'),
	('Орлов Алексей 2002');

select regexp_match(txt, '^[А-Яа-я-]+') as last_name from tmp_raw_people;
select regexp_match(txt, '\s([А-ЯA-Z][а-яa-z-]+)\s') as first_name from tmp_raw_people;
select regexp_match(txt, '\d{4}') as year_b from tmp_raw_people;
select coalesce((regexp_match(txt, '(студент|преподаватель|аспирант)'))[1], 'не указано') as category from tmp_raw_people;

create temp table users_parsed as select
	split_part(txt, ' ', 1) as lastname,
	split_part(txt, ' ', 2) as name,
	split_part(txt, ' ', 3) as year_b,
	coalesce(nullif(split_part(txt, ' ', 4), ''), 'не указано') as category
from tmp_raw_people;
select * from users_parsed;

-- 3.1.3. Добавьте в таблицу книги поле shifr, заполните его значениями, при этом используйте check проверку с применением регулярного выражения (первые две буквы латинские, потом четыре цифры) 
-- добавляем поле (text подходит; можно varchar(6), если хочешь жёсткую длину)
alter table book
  add column shifr varchar(6);

-- check-ограничение: две латинские буквы (без учёта регистра) + 4 цифры
alter table book
  add constraint book_shifr_chk
  check (shifr ~ '^[A-Za-z]{2}\d{4}$');

update book
set shifr = 'AB0001'
where bshifr = 1;

select * from book;

update book
set shifr = 'A1234'
where bshifr = 2;

--3.2.1. Напишите инструкцию для просмотра статистики таблицы Билет (по примеру)
select * from pg_stat_all_tables where relname = 'ticket';

--3.2.2. Выведите значение поля   из предыдущего запроса
select seq_scan from pg_stat_all_tables where relname = 'ticket';

--3.2.3. Выполните чтение таблицы
select * from ticket;

--3.2.4. Проверьте значение поля   после чтения таблицы
select seq_scan from pg_stat_all_tables where relname = 'ticket';

--3.2.5. Создайте таблицу statbilet на основании запроса на нахождения количества вставленных строк, удалённых строк (из статистики)
create table statbilet as
select relname, n_tup_ins, n_tup_del
from pg_stat_all_tables
where relname = 'ticket';

select * from statbilet;

--3.2.6. Создайте индекс в таблице author – включающий поля Имя и Отчество
create index index_last_first_name on author(lastname, name);

--3.2.7. Создайте индекс в таблице users, включающий поле категория пользователя (по убыванию значения).
create index index_users on "user" (category desc);

--3.2.8.	Напишите запрос к таблице users с применением индекса по категории.
begin;
set local enable_seqscan = off;
set local enable_indexscan = on;
select id, lastname, name, category
from "user"
where category = 'студент';
commit;

--3.2.9. Найдите количество сканирований по индексу, количество строк, отобранных при сканированиях по индексу.
select relname as table_name, idx_scan as index_scans, idx_tup_fetch as fetched_by_index
from pg_stat_all_tables
where relname = 'user';
