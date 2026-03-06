-- 3.2.1 Пользователю stud2 дайте все права на все ваши таблицы
grant all privileges on all tables in schema ryzhov_ka to stud2;
grant all privileges on all sequences in schema ryzhov_ka to stud2;

-- 3.2.2 Пользователю stud1 дайте разрешение:
-- на чтение таблицы Книга.
-- Таблица Пользователи:
-- изменение данных в таблице Пользователи;
-- может видеть только базовые данные пользователей (id и данные о фамилии и имени);
-- не может видеть данные о номере телефона; 
-- разрешение на добавление и удаление данных в таблице Автор;
-- разрешение на добавление записей в таблицу Билет.

grant select on ryzhov_ka."user" to stud1;
grant update on ryzhov_ka."user" to stud1;

grant insert, delete on author to stud1;

grant usage, select on all sequences in schema ryzhov_ka to stud1;

grant insert on ticket to stud1;

grant usage on schema ryzhov_ka to stud1;
grant select on ryzhov_ka.book to stud1;

grant usage on schema ryzhov_ka to stud2;

-- 3.3.2 Проверьте привилегии данного пользователя. Для этого:
-- Выполните запрос для выборки всех записей таблицы book: select * from book;
-- Выполните запрос для добавления поля в таблицу book. Какой результат запроса?
-- Проверьте привилегию, данную на таблицу Билет, для этого добавьте по одной записи в таблицу под каждым из пользователей БД. Проверьте, что записи добавлены в таблицу.

-- stud1
select * from ryzhov_ka.book;

-- stud1 err
alter table ryzhov_ka.book add column tmp_col integer;

-- stud1 insert
insert into ryzhov_ka.ticket (user_id, book_id, date_of_issue)
values (5, 5, current_date);
select * from ryzhov_ka.ticket order by date_of_issue desc;


-- stud2
select * from ryzhov_ka.book;
alter table ryzhov_ka.book add column tmp2 integer;

-- stud2 insert
insert into ryzhov_ka.ticket (user_id, book_id, date_of_issue)
values (6, 6, current_date);
select * from ryzhov_ka.ticket order by date_of_issue desc;


-- 3.3.3 Вернитесь к своему пользователю
-- Проверьте привилегии пользователя к схеме 
-- SELECT has_schema_privilege('stud1', 'public', 'USAGE');
-- Выполните проверку привилегий к бд – параметры имя базы данных и привилегии connect и create с помощью функции has_database_privilege()

select
  has_schema_privilege('stud1', 'ryzhov_ka', 'usage') as stud1_schema_usage,
  has_schema_privilege('stud2', 'ryzhov_ka', 'usage') as stud2_schema_usage;

select
  has_database_privilege('stud1', 'dbstudy', 'connect') as stud1_can_connect,
  has_database_privilege('stud1', 'dbstudy', 'create')  as stud1_can_create,
  has_database_privilege('stud2', 'dbstudy', 'connect') as stud2_can_connect,
  has_database_privilege('stud2', 'dbstudy', 'create')  as stud2_can_create;

select 'book' as tbl,
       has_table_privilege('stud1','ryzhov_ka.book','select') as s1_sel,
       has_table_privilege('stud1','ryzhov_ka.book','insert') as s1_ins,
       has_table_privilege('stud1','ryzhov_ka.book','update') as s1_upd,
       has_table_privilege('stud1','ryzhov_ka.book','delete') as s1_del
union all
select 'author',
       has_table_privilege('stud1','ryzhov_ka.author','select'),
       has_table_privilege('stud1','ryzhov_ka.author','insert'),
       has_table_privilege('stud1','ryzhov_ka.author','update'),
       has_table_privilege('stud1','ryzhov_ka.author','delete')
union all
select 'ticket',
       has_table_privilege('stud1','ryzhov_ka.ticket','select'),
       has_table_privilege('stud1','ryzhov_ka.ticket','insert'),
       has_table_privilege('stud1','ryzhov_ka.ticket','update'),
       has_table_privilege('stud1','ryzhov_ka.ticket','delete');

-- 3.3.4 Напишите запрос для проверки привилегий пользователей stud1 и stud2 в вашим объектам базы данных:
-- Выберите поля grantee, table_schema, table_name, privilege_type из таблицы information_schema.table_privileges
-- Добавьте фильтрацию для указания пользователей
-- Добавьте группировку по полям grantee, table_schema, table_name  и добавьте агрегацию привилегий пользователей с помощью функции STRING_AGG(поле, разделитель)
-- Проверьте результат запроса, примерно он должен быть следующим:
select
  grantee,
  table_schema,
  table_name,
  string_agg(privilege_type, ', ' order by privilege_type) as all_privileges
from information_schema.table_privileges
where grantee in ('stud1', 'stud2')
  and table_schema = 'ryzhov_ka'
group by grantee, table_schema, table_name
order by grantee, table_name;

-- 3.3.5 Аналогично агрегируем данные о доступных столбцах таблицы Пользователи для пользователей stud1 и stud2, примеряя функцию STRING_AGG(column_name, ', ') с агрегацией по полям grantee, table_name из таблицы information_schema.column_privileges.
select
  grantee,
  table_name,
  string_agg(column_name || ' (' || privilege_type || ')', ', ' order by column_name) as columns_with_privs
from information_schema.column_privileges
where grantee in ('stud1', 'stud2')
  and table_schema = 'ryzhov_ka'
  and table_name = 'user'
group by grantee, table_name
order by grantee;

-- 3.4.1 Подготовка таблицы и включение RLS:
-- В таблице users выберите поле для идентификации пользователя (можно использовать поле lastname или name);
-- Обновите существующие записи, добавьте записи или обновите любую запись с изменением его значения на пользователей (stud1, stud2);
-- Включите защиту на уровне строк для таблицы users: ALTER TABLE users ENABLE ROW LEVEL SECURITY;
select * from "user";

insert into "user" (id, lastname, name, user_group, year_b, age, level, category)
values 
	(7, 'stud1', 'foo', 3, 2000, 25, 1, 'студент'),
	(8, 'stud2', 'foo', 3, 2000, 25, 1, 'студент');


select id, lastname, name
from ryzhov_ka."user"
where lastname in ('stud1','stud2');

alter table ryzhov_ka."user" enable row level security;

-- 3.4.2 Создайте политику для таблицы users, позволяющую пользователям видеть и изменять только свою запись (в таблице users должна быть запись о пользователе).
create policy user_select_self
on ryzhov_ka."user"
for select
to stud1, stud2
using (lastname = current_user);

create policy user_update_self
on ryzhov_ka."user"
for update
to stud1, stud2
using (lastname = current_user);

select id, lastname, name from ryzhov_ka."user";

-- 3.4.3 Создайте политику, чтобы администратор stud2 мог видеть и добавлять любые строки.
create policy admin_select_all
on ryzhov_ka."user"
for select
to stud2
using (true);

create policy admin_insert_all
on ryzhov_ka."user"
for insert
to stud2
with check (true);

select id, lastname, name from ryzhov_ka."user";
insert into ryzhov_ka."user"(id, lastname, name, user_group, year_b, age) values (9, 'someone', 'test', 3, 2000, 25);

-- 3.4.4 Напишите запрос на создание политики, которая позволит всем пользователям видеть все строки в таблице users, но менять только свою собственную (две политики – одна для чтения всех строк, вторая для изменения только своей записи).
create policy select_all_users
on ryzhov_ka."user"
for select
to stud1, stud2
using (true);

create policy update_self_only
on ryzhov_ka."user"
for update
to stud1, stud2
using (lastname = current_user)
with check (lastname = current_user);

-- stud1
select id, lastname, name from ryzhov_ka."user";

update ryzhov_ka."user" set name = 'x' where lastname = 'stud2';

update ryzhov_ka."user" set name = 'ok' where lastname = current_user;

-- 3.4.5 Проверьте созданные права (напишем запрос по примеру п.3.3.4 для агрегации политик по tablename с обращением к таблице pg_policies).
select
  tablename,
  string_agg(policyname, '; ' order by policyname) as policies,
  string_agg(cmd, ', ' order by cmd) as operations
from pg_policies
where schemaname = 'ryzhov_ka'
  and tablename  = 'user'
group by tablename
order by tablename;

-- 