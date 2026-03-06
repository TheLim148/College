-- 1.1.	Создайте запрос на добавление в таблицу Books поля About типа данных text, для хранения данных краткого содержания книги. Напишите запрос Update для добавления данных в поле.
alter table book add column if not exists about text;

update book
set about = concat('Краткое содержание: ', title, '(раздел: ', section, ')')
where about is null;

-- 1.3. Напишите запрос для обновления таблицы – заполнение поля категория. Заполните записями данное поле значениями студент, преподаватель, методист, применяя конструкцию:
update "user" u
set category = case (floor(random()*3))::int
  when 0 then 'студент'
  when 1 then 'преподаватель'
  else 'методист'
end;

-- 1.4.	Создайте запрос для добавления поля arrears (Задолженность – если поля нет, то добавить) в таблицу ticket числового типа, а также поле Kdays со значением по умолчанию, равным 14 дням – для хранения количества дней, на которые выдается книга.
alter table ticket
	add column if not exists arrears integer default 0,
	add column if not exists kdays integer default 14;

-- 2.1.	Создайте следующее представление: "Create view viewbook AS select название, цена from book;"
create view viewbook as
select title as "Название", price as "Цена"
from book;

select * from viewbook;

-- 2.2.	Создайте представление Razdel, содержащее поля: название раздел, название книги, год издания между 2007 и 2017. Создайте запрос на выборку всех записей созданного представления.
create view Razdel as
select section as "Раздел", title as "Книга", year_publ as "Год"
from book
where year_publ between 2007 and 2017;

select * from Razdel;

-- 2.3.	Создайте представление ST, которое выбирает данные из таблицы Book: Название, Стоимость, Налог 18%; создайте запрос на выборку всех записей созданного представления.
create view ST as
select title as "Название", price as "Стоимость", round((price * 0.18)::numeric, 2) as "Налог"
from book;

select * from ST;

-- 3.1.	Создайте таблицу book_author, которое бы показывало фамилию +имя_автора (как поле Автор) и название книги, как поле Book и поле цена книги - Цена. 
create view book_author as
seelct
    concat(a.lastname, ' ', a.name) as "Автор",
    b.title as "Книга",
    b.price as "Цена"
from book b
join author a on a.id = b.id_author;

-- 3.2.	Напишите правило select для таблицы book_author.
create rule "_RETURN" as
on select to book_author
do instead
select
    concat(a.lastname, ' ', a.name) as "Автор",
    b.title as "Книга",
    b.price as "Цена"
from book b
join author a on a.id = b.id_author;

-- 3.3.	Создайте представление Kol_book, на основании представления book_author, для нахождения общего количества книг по каждому автору.
create view Kol_book as
select "Автор", count(*) as "Количество книг"
from book_author
group by "Автор";

select * from Kol_book;

-- 3.4.	Создайте представление St_book, на основании представления book_author, для нахождения минимальной, максимальной, средней цены книг по каждому автору.
create view St_book as
select "Автор",
	min("Цена") as min_price,
	max("Цена") as max_price,
	round(avg("Цена")) as avg_price
from book_author
group by "Автор";

select * from St_book;

-- 4.1.	Напишите правило insert для представления book_author.
create rule book_author_insert as
on insert to book_author
do instead
insert into book (bshifr, section, id_author, title, publishing, year_publ, price)
values (
	(select coalesce(max(bshifr) + 1, 1) from book),
	null,
	(select id from author where concat(lastname, ' ', name) = new."Автор"),
	new."Книга",
	null,
	null,
	new."Цена"
);

select * from book_author;

insert into book_author("Автор", "Книга", "Цена")
values ('Чуковский Корней Иванович', 'Книга 1', 299);

-- 4.2.	Напишите правило update для представления book_author


-- 4.3.	Напишите правило delete для представления book_author
create rule book_author_delete as
on delete to book_author
do instead
delete from book b
using author a
where a.id = b.id_author
	and concat(a.lastname, ' ', a.name) = old."Автор"
	and b.title = old."Книга";

select * from book;

delete from book_author
where "Книга" = 'Книга 1';

-- 4.4.	Создайте представление Tek_z для выборки записей из таблицы tiket, в которых поле data_vozv меньше текущей даты. Напишите правило update для представления Tek_z – заполнения поля Задолженность для пользователей, сумма задолженности определяется как количество дней задолженности *1.5 от стоимости книги.


-- 4.5.1. Создайте таблицу logticket, включающую поля код, книга, читатель, пользователь, текущая дата, операция


-- 4.5.2. Напишите правило, которое при вставке/изменении/удалении данных в таблице book будет добавлять запись в таблицу логов


-- 4.5.3. Выполните операции вставки/изменения/удаления записей в таблицу ticket


-- 4.5.4. Проверьте записи в таблице logticket


-- 5.1.	Создайте представление About на основании запроса, который бы в зависимости от шифра книги в таблице Books выдавал бы для какого возраста данная книга, например Айболит – от 0 до 7 лет и т.д.


-- 5.2.	Создайте представление BoolZ, которое в зависимости от наличия задолженности выдачи книги (количество дней между датой возврата и датой выдачи не больше допустимого количества дней выдачи книги), выдавал бы текста «Есть задолженность», иначе «Нет задолженности». 


-- 6.1.	Создайте представление Min_g, которое содержит список (название книги, ФИО автора, год_издания), имеющих минимальный год выпуска.


-- 6.2.	Создайте представление Max_z, которое содержит список пользователей, которые имели самую высокую задолженность за последние 3 года.


-- 7.1.	Создайте представление BOOKS_USERS для получения данных о выдачи книг пользователям библиотеки (ФИО пользователя, Книга, Дата выдачи, Дата возврата)


-- 7.2.	Добавьте по одной записи в таблицы Book, Users, и две записи в таблицу ticket. Просмотрите результат выборки данных из материализованного представления.


-- 7.3.	Обновите созданное представление.


-- 7.4.	Найдите записи, отсортированные по названию книги – постройте план запроса. Создайте индекс по полю – название книги, постройте план запроса – результаты сравните.


-- 7.5.	Создайте таблицы логов - журналов материализованного представления для каждой из таблиц, входящих в определение представления BOOKS_USERS, при создании необходимо перечислить все столбцы, упоминаемые в материализованном представлении


-- 7.6.	Добавьте по одной записи в таблицы Book, Users, и две записи в таблицу ticket. Просмотрите результат выборки созданных материализованных представлений.

