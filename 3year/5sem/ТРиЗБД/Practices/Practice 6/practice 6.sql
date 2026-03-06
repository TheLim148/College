-- 4.1.1. Выведите информацию об авторах книги под названием «Айболит».
select * from author
where id in (
	select id_author
	from book
	where title = 'Айболит'
);

-- 4.1.2. Подзапрос с DISTINCT: Произведите вывод списка книг, которые были взяты пользователями библиотеки.
select * from book
where bshifr in (
	select distinct book_id
	from ticket
);

-- 4.1.3. Агрегатные функции в подзапросах: Выведите на экран все книги, которые имеют стоимость, большую средней стоимости всех книг.
select * from book
where price > (select avg(price) from book);

-- 4.1.4. Найдите все книги библиотеки, которые имеет стоимость такую же, как книга «Айболит».
select * from book
where price = (
	select price from book
	where title = 'Айболит'
);

-- 4.1.5. Filter: Выведите список и количество книг каждого автора, год рождения которых от 1800 до 1900.
select lastname || ' ' || name as author,
	(select count(*) from book where id_author = id) as cnt
from author
where year_b between 1800 and 1900
	and (select count(*) from book where id_author = id) > 0
order by author;

-- 4.2.1. Выведите список авторов книг, которые написали книги жанра «хоррор».
select * from author
where id in (
	select id_author
	from book
	where lower(section) = 'хоррор'
);

-- 4.2.2. Найти имена авторов, которые принимали участие в написании, по крайней мере, одной книги, выданной пользователям библиотеки категории «студент». (добавьте поле категория в таблице user, и добавить данные в поле)
alter table "user" add column if not exists category text;
update "user" set category = 'студент' where user_group = 1;

select *
from author a
where a.id in (
    select id_author
    from book
    where bshifr in (
        select book_id
        from ticket
        where user_id in (
            select id
            from "user"
            where category = 'студент'
        )
    )
);

-- 4.2.3. Напишите запрос на изменение записей, который удвоит цену всех книг, написанные автором Пушкин.
update book set price = price * 2
where id_author in (
	select id
	from author
	where lastname ilike 'Пушкин%'
);

select * from book;

-- 4.2.4. Напишите запрос на удаление всех данных о выдачи книг автора Чуковский К.И.
delete from ticket
where book_id in (
	select bshifr
	from book
	where id_author in (
		select id
		from author
		where lastname ilike 'Чуковский%'
	)
);

-- 4.2.5. Создайте запрос для нахождения списка пользователей, которые имели самую высокую задолженность за последние 3 года (без сортировки).
select u.id, u.lastname, u.name,
       (
         select sum(
                  greatest(
                    ((coalesce(t.date_of_return, current_date) - t.date_of_issue) * interval '1 day')
                    - interval '14 days',
                    interval '0 days'
                  )
                )
         from ticket t
         where t.user_id = u.id
           and t.date_of_issue >= current_date - interval '3 years'
       ) as overdue
from "user" u
where exists (
    select 1
    from ticket t
    where t.user_id = u.id
      and t.date_of_issue >= current_date - interval '3 years'
)
order by overdue desc nulls last
limit 1;

-- 4.3.1. Распределите всех пользователей библиотеки по группам по возрасту
with age_groups as (select
        u.id as user_id,
        u.age,
        case
            when u.age between 7 and 17 then 'школьники'
            when u.age between 18 and 24 then 'студенты'
            when u.age between 25 and 65 then 'служащие'
            when u.age >= 66 then 'пенсионеры'
            else 'не определено'
        end as age_category,
        (select count(*)
         from ticket t
         where t.user_id = u.id) as books_taken
    from "user" u)
select age_groups.age_category, count(distinct age_groups.user_id) as users_count, sum(age_groups.books_taken) as total_books_taken
from age_groups group by age_groups.age_category;

-- 4.4.2. Напишите запрос, который получит набор чисел от 1 до 10 с шагом 0,5
select gs from generate_series(1, 10, 0.5) as gs;

-- 4.4.3. Напишите запрос, который сгенерирует даты в диапазоне от сегодняшнего числа + 30 дней.
select d::date
from generate_series(current_date, current_date + interval '30 days', interval '1 day') as d;

-- 4.4.4. Построение рекурсивного запроса к набору данных events
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

with recursive chain(id) as (
    select 10
  union all
    select e.id
    from events e, chain c
    where e.predid = c.id
)
select id
from chain;

-- 4.4.5. В таблицу users добавьте поле уровень, заполните его значениями (так 0 до 2), найдите список по подчинённым указанного пользователя.
select u2.*
from ryzhov_ka."user" u0
join ryzhov_ka."user" u2 on u2.user_group = u0.user_group
where u0.id = 2 and u2.level > u0.level;

-- 4.6.1. ANY. Напишите запрос для определения списка книг, которые взяли хотя бы один пользователь.
select * from book
where bshifr = any(select book_id from ticket);

-- 4.6.2. SOME. Напишите запрос для вывода списка пользователей библиотеки, год рождения которых больше года рождения читателей категории Куратор.
select * from "user" u
where u.year_b > some(
	select u2.year_b from "user" u2
	where u2.category='Куратор');

-- 4.6.3. ALL. Найти книги, которые стоят больше, чем самая дорогая книга жанра Детская.
select * from book
where price > all(
	select price from book
	where section='Детская');

-- 4.6.4. Коррелированный подзапрос. Найти книги, стоимость которых выше средней стоимости книг авторов, которые их написали
select * from book b
where b.price > (select avg(price) from book b2 where b2.id_author=b.id_author);

-- 4.6.5. LATERAL. Найти список авторов вместе с их самой популярной книгой (например, по количеству чтений).


-- 4.7.1. Напишите подзапрос для вывода фамилий авторов, которые пишут книги одного или более жанров.
select lastname from author
where id in (
	select id_author
	from book
	where section is not null
);

-- 4.7.2. Напишите запрос, для нахождения списка книг, которые на взяли ни один пользователь.
select title from book
where bshifr not in (
	select book_id
	from ticket
);

-- 4.7.3. Напишите запрос для вывода списка книг, которые были взяты хотя бы одним пользователем.
select title from book
where bshifr in (
	select book_id
	from ticket
);

-- 4.7.4. Перечислите фамилии авторов, которые не написали ни одной книги из раздела ‘учебная’.
select lastname from author
where id not in (
	select id_author
	from book
	where section = 'Учебная'
);

-- 4.7.5. Напишите запрос для вывода фамилий авторов без повторений, которые написали книги каждого жанра.
