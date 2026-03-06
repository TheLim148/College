-- 3.1.1. Выберите все названия издательств из таблицы book без повторений;
select distinct publishing from book;

-- 3.1.2. Выбор из таблицы book записей, название которой начинается на А;
select * from book where title like 'А%';

-- 3.1.3. Выбор из списка значений – выбор книг, издательства которых 'Эксмо' или 'Дрофа';
select * from book where publishing in ('Дрофа', 'Эксмо');

-- 3.1.4. Использование вычисляемого выражения – найдите цену каждой книги с уценкой 10%;
select bshifr, title, price, round(price * 0.9) as price_with_discount from book;

-- 3.1.5. Выборка записей из таблицы Автор, имя которых содержит букву “в”, год рождения не равен 1960;
select * from author where name like '%в%' and year_b != 1960;

-- 3.1.6. Найдите все книги, которые были выпущены между 1990 и 1995 годами;
select * from book where year_publ between 1990 and 1995;

-- 3.1.7. Найдите книги, в названии которых присутствует буквосочетание ‘ал’.
select * from book where title like '%ал%';

-- 3.1.8. Найдите все записи о книгах, шифр которых содержит цифру 2 в повторении
-- минимум 2 раза или содержит цифру 3 (используйте поиск по регулярному выражению
select * from book where bshifr::text similar to '%2{2,}%' or bshifr::text like '%3%';

----------

-- 3.2.1. Вывод полей таблицы Book отсортированных по полю Год_издания;
select * from book order by year_publ;

-- 3.2.2. Произведите сортировку записей таблицы Автор по убыванию фамилий авторов;
select * from author order by lastname desc;

-- 3.2.3. Произведите сортировку записей любого запроса из предыдущего задания (3.2) по возрастанию (по убыванию)
select * from book order by year_publ asc;
select * from book order by year_publ desc;

----------

-- 3.3.1. Напишите запросы с применением строковых функций (SUBSTRING, INITCAP, REPLACE)
-- substring - первые три символа названия книги
select bshifr, substring(title from 1 for 3) as title_short from book;

-- initcap - первая буква издателя теперь заглавная
select bshifr, initcap(publishing) as publishing_formatted from book;

-- replace буква "а" заменяется на утроенную
select bshifr, replace(publishing, 'а', 'ааа') as publishing_with_tripple_a from book;

-- 3.3.2. Выведите на экран значение полей: Фамилия + Имя автора (с помощью функции CONCAT) из таблицы Автор.
select id, year_b, concat(lastname, ' ', name) as full_name from author;

-- 3.3.3. Найдите длину названий каждой книги
select bshifr, title, length(title) as title_lenght from book;

-- 3.3.4. Напишите запрос на изменение данных, который будет удалять все пробелы в начале каждого названия книги и в конце каждого названия книги.
select bshifr, title,  trim(title) as trimmed_title from book;

----------

-- 3.4.1. Найти средний год рождения всех пользователей библиотеки.
select round(avg(year_b)) as avg_birth_year from "user";

-- 3.4.2. Найдите минимальную цену книги для каждого раздела. 
select section, min(price) as min_price from book group by section;

-- 3.4.3. Найдите среднюю цену тех книг, год выпуска у которых больше 2000. 
select avg(price) as avg_price from book where year_publ > 2000;

-- 3.4.4. Найдите по каждому пользователю количество взятых книг в период от начала года до текущей даты.
select user_id, count(*) as books_taken from ticket
where date_of_issue >= date_trunc('year', current_date)
and date_of_issue <= current_date
group by user_id;

-- 3.4.5. Напишите запрос для нахождения максимальной цены по каждому разделу и максимальной итоговой цены
select section, max(price) as max_section_price, (select max(price) from book) as overall_price from book group by section;

-- 3.4.6.	Напишите запрос, который по каждому автору находит количество книг, если данное количество будет от 0 до 1
select id_author, books_count
from (
	select id_author, count(*) as books_count
	from book
	group by id_author
) as sub
where books_count between 0 and 1;

-- 3.4.7. Найдём количество книг, которые по цене в диапазонах от 100 до 500, от 500 до 1000, от 1000 до 10000.
select case
	when price between 100 and 500 then '100-500'
	when price between 500 and 1000 then '500-1000'
	when price between 1000 and 10000 then '1000-10000'
	else 'other'
	end as price_range, count(*) as book_count
	from book group by price_range;

-- 3.4.8. (grouping) Найти сколько книг каждому издательству у каждого автора. Группируем по издательству и по автору
select publishing, id_author, count(*) as books_count
from book
group by publishing, id_author
order by publishing, id_author;

-- 3.4.9. (group by cube) Найти сколько книг в каждом разделе у каждого автора. Группируем по разделу и по автору
select section, id_author, count(*) as books_count
from book
group by cube(section, id_author)
order by section nulls last, id_author nulls last;

-- 3.4.10. (group by grouping sets) Найти агрегации по разделу книги и по автору, только раздел, только автор и общее количество. Группируем по разделу и по автору, по разделу, по автору, () – общее значение
select section, id_author, count(*) as books_count
from book
group by grouping sets(
	(section, id_author),
	(section),
	(id_author),
	()
)
order by section nulls last, id_author nulls last;

----------

-- 3.5.1. Выведите текущую дату
select current_date;

-- 3.5.2. Преобразуйте строку в число, строку в дату (по своему усмотрению)
select 
	'100'::integer as n1,
	to_number('1 234', 'L9G999') as n2;

select
	'2025-09-18'::date as d1,
	to_date('20250918', 'YYYYMMDD') as d2;

-- 3.5.3. Преобразуйте число, дату в строку в строку в определённому формате (по своему усмотрению)
select
	to_char(12345, '99,999') as num_format,
	to_char(current_date, 'DD.MM.YYYY') as date_format;

-- 3.5.4. Найдите количество месяцев между текущей датой и январём 2024 года
select(extract(year from age(current_date, date '2024-01-01')) * 12
	+ extract(month from age(current_date, date '2024-01-01')))::integer as month_diff;

-- 3.5.5. Найдите количество дней, прошедших от начала года до текущей даты.
select(current_date - date_trunc('year', current_date)::date) as days;

-- 3.5.6. Вывод списка авторов, возраст которых между 40 и 200.
select id, lastname, name, (extract(year from current_date)::integer - year_b) as age_years
from author
where (extract(year from current_date)::integer - year_b) between 40 and 200
order by age_years, lastname, name;

-- 3.5.7. Найдите количество дней между датой выдачи книги и датой возврата книги.
select id, (date_of_return - date_of_issue) as days_borrowed
from ticket
where date_of_return is not null
order by id;

-- 3.5.8. Вычислите возраст (в днях) каждой книги.
select bshifr, title, (current_date - make_date(year_publ, 1, 1)) as age_days
from book
where year_publ is not null
order by age_days desc, title;

-- 3.5.9. Найдите книги, взятые в период от начала года до текущей даты.
select id, user_id, book_id, date_of_issue, date_of_return
from ticket
where date_of_issue >= date_trunc('year', current_date)::date
and date_of_issue <= current_date
order by date_of_issue, id;