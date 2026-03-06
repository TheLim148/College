-- 4.1.1. Выведите фамилию и имена авторов книг, и название книг, которые он написал;
select a.lastname, a.name, b.title
from author a
join book b on b.id_author = a.id;

-- 4.1.2. Перечислите пользователей книг, которые взяли книги автора Чуковский Корней Иванович;
select distinct u.lastname, u.name
from "user" u
join ticket t on t.user_id = u.id
join book b on b.bshifr = t.book_id
join author a on a.id = b.id_author
where a.lastname = 'Чуковский' and a.name = 'Корней Иванович';

-- 4.1.3. Выведите фамилии авторов, книги которых выпущены издательством ‘Дрофа’;
select distinct a.lastname, a.name
from author a
join book b on b.id_author = a.id
where b.publishing = 'Дрофа';

-- 4.1.4. Выведите фамилию и имя автора, который написал книги, цена которых >100 и <2000;
select distinct a.lastname, a.name
from author a
join book b on b.id_author = a.id
where b.price > 100 and b.price < 2000;

-- 4.1.5. Выберите все книги автора Пушкин;
select b.*
from book b
join author a on a.id = b.id_author
where a.lastname = 'Пушкин';

-- 4.1.6. Найдите фамилии и имена тех пользователей, которые взяли книги автора, фамилия которого начинается на Ч
select distinct u.lastname, u.name
from "user" u
join ticket t on t.user_id = u.id
join book b on b.bshifr = t.book_id
join author a on a.id = b.id_author
where a.lastname like 'Ч%';

-- 4.1.7. Найдите фамилии тех пользователей, которые взяли книги в период от начала года до текущей даты. 
select distinct u.lastname, u.name
from "user" u
join ticket t on t.user_id = u.id
where t.date_of_issue >= date_trunc('year', current_date)
  and t.date_of_issue <= current_date;

-- 4.1.8. Выведите поля автор, книга, стоимость, если у книги нет цены, заменить ее на 'бесплатно' с помощью COALESCE.
select a.lastname,
	   a.name,
	   b.title,
	   coalesce(b.price::text, 'бесплатно')
from author a
join book b on id_author = a.id;

-- 4.2.1. Выполните операцию внешнего соединения таблиц Билет и Пользователь для получения списка пользователях и шифр книг, которые они взяли. 
select u.id, u.lastname, u.name, t.book_id
from "user" u
left join ticket t on t.user_id = u.id
order by u.id, t.book_id;

-- 4.2.2. Получите фамилии пользователей, которые не взяли ни одной книги.
select u.id, u.lastname, u.name
from "user" u
left join ticket t on t.user_id = u.id
where t.id is null;

-- 4.2.3. Получите список книг, которые не взял ни один пользователь.
select b.bshifr as book_id, b.title
from book b
left join ticket t on t.book_id = b.bshifr
where t.id is null;

-- 4.2.4. Получите список книг и количество выдач книг, если выдач книг не было, напишите – книга не выдавалась.
select b.bshifr,
	   b.title,
	   coalesce(cast(count(t.id) as text), 'книга не выдавалась') as issue_count_or_text
from book b
left join ticket t on t.book_id = b.bshifr
group by b.bshifr, b.title
order by b.title;

-- UNION
-- 4.3.1.1. Выбрать все записи о книгах, цена которых больше 250р. или автор Толстой; (оператор UNION)
select b.*
from book b
where b.price > 250
union
select b.*
from book b
join author a on a.id = b.id_author
where a.lastname = 'Чуковский';

-- 4.3.1.2.	Выведите фамилию и имя автора, который написал книги, цена которых >1000 или <2000; (оператор UNION ALL)
select distinct a.lastname, a.name
from author a
join book b on b.id_author = a.id
where b.price > 1000
union all
select distinct a.lastname, a.name
from author a
join book b on b.id_author = a.id
where b.price < 2000;

-- 4.3.1.3.	Выполните объединение результатов левого и правого внешнего соединения таблиц Книга и Билет.
select b.bshifr, t.id
from book b
left join ticket t on t.book_id = b.bshifr
union
select b2.bshifr, t2.id
from book b2
left join ticket t2 on t2.book_id = b2.bshifr;

-- 4.3.1.4.	Сделайте копию таблицы users. Соедините копию и users с помощью UNION без указания ALL и с указанием ALL. Посчитайте количество строк в двух случаях, сравните результат. 
select count(*) as count_union from (
	select * from "user"
	union
	select * from user_copy
) s;

select count(*) as count_union_all from (
	select * from "user"
	union all
	select * from user_copy
) s;

-- INTERSECT / EXCEPT
-- 4.3.2.1.	Выбрать все записи о книгах, цена которых больше 250р. и автор Гоголь;
select b.*
from book b
join author a on a.id = b.id_author
where a.lastname = 'Гоголь'
intersect
select b.*
from book b
where b.price > 250;

-- 4.3.2.2.	Выбрать все записи о книгах, цена которых больше 250р., но автор не Гоголь;
select b.*
from book b
join author a on a.id = b.id_author
where a.lastname = 'Гоголь'
except
select b.*
from book b
where b.price > 250;

-- 4.4.1. Подсчитайте среднюю цену книг каждого автора.
select a.lastname, a.name, round(avg(b.price)) as avg_price
from author a
join book b on b.id_author = a.id
group by a.lastname, a.name
order by a.lastname, a.name;

-- 4.4.2. Найдите по каждому пользователю количество взятых книг.
select u.id, u.lastname, u.name, count(*) as books_taken
from "user" u
left join ticket t on t.user_id = u.id
group by u.id, u.lastname, u.name
order by books_taken desc, u.id;

-- 4.4.3. Найдите количество тех книг авторов, фамилия которых начинается на «Ч».
select a.lastname, a.name, count(b.bshifr) as books_count
from author a
left join book b on b.id_author = a.id
where a.lastname like 'Ч%'
group by a.lastname, a.name;

-- 4.4.4. Вывести количество книг каждого автора и итоговую стоимость всех книг. 
select a.lastname, a.name,
	   count(b.bshifr) as book_count,
	   sum(b.price) as total_price
from author a
left join book b on b.id_author = a.id
group by a.lastname, a.name
order by a.lastname, a.name;

-- 4.5.1. По каждому разделу книги найдите среднюю цену
select section, round(avg(price)) as avg_price
from book
group by section
order by section;

-- 4.5.2. Найти сколько книг каждому издательству у каждого автора
select a.lastname, a.name, b.publishing, count(*) as books_count
from author a
join book b on b.id_author = a.id
group by a.lastname, a.name, b.publishing
order by a.lastname, a.name, b.publishing;

-- 4.5.3. Найти сколько книг написал каждый автор и сколько читателей прочитали книги.
select a.lastname, a.name,
	   count(distinct b.bshifr) as books_count,
	   count(distinct t.user_id) as readers_count
from author a
left join book b on b.id_author = a.id
left join ticket t on t.book_id = b.bshifr
group by a.lastname, a.name
order by readers_count desc nulls last;

-- 4.5.4. Найти сколько книг в каждом разделе у каждого автора.
select a.lastname, a.name, b.section, count(*) as books_count
from author a
join book b on b.id_author = a.id
group by a.lastname, a.name, b.section
order by a.lastname, a.name, b.section;

-- 4.5.5. Найти агрегации по разделу книги и по автору, только раздел, только автор и общее количество.
select 'by_section_author' as level, b.section, a.lastname, a.name, count(*) as cnt
from ryzhov_ka.book b
join ryzhov_ka.author a on a.id = b.id_author
group by b.section, a.lastname, a.name

union all
-- Только раздел
select 'by_section' as level, b.section, null, null, count(*) as cnt
from ryzhov_ka.book b
group by b.section

union all
-- Только автор
select 'by_author' as level, null, a.lastname, a.name, count(*) as cnt
from ryzhov_ka.book b
join ryzhov_ka.author a ON a.id = b.id_author
GROUP BY a.lastname, a.name

union all
-- Общее количество
select 'total' as level, null, null, null, count(*) as cnt
from ryzhov_ka.book
order by level, section nulls first, lastname nulls first, name nulls first;

-- 4.6.2. Напишите запрос, который получит набор чисел от 1 до 10 с шагом 0,5
select gs from generate_series(1, 10, 0.5) as gs;

-- 4.6.3. Напишите запрос, который сгенерирует даты в диапазоне от сегодняшнего числа + 30 дней.
select d::date
from generate_series(current_date, current_date + interval '30 days', interval '1 day') as d;

-- 4.6.4. Построение рекурсивного запроса к набору данных events
create table events (
	id int primary key,
	predid int,
	postid int,
	descr text
);

insert into events(id, predid, postid, descr)
select id*10,
	   (id-1)*10,
	   (id+1)*10,
	   'Event ' || id*10
from generate_series(1, 10) as id;

select * from events;

with recursive chain as (
	 select e.id, e.predid, e.postid, e.descr
	 from events e
	 where e.id = 10
	union all
	 select e2.id, e2.predid, e2.postid, e2.descr
	 from events e2
	 join chain c on e2.id = c.predid
)
select * from chain;

-- 4.6.5. В таблицу users добавьте поле уровень, заполните его значениями (так 0 до 2), найдите список по подчинённым указанного пользователя.
alter table "user" 
add column level integer check (level in (0, 1, 2));

select * from "user";

select u2.*
from ryzhov_ka."user" u0
join ryzhov_ka."user" u2 on u2.user_group = u0.user_group
where u0.id = 2 and u2.level > u0.level;
