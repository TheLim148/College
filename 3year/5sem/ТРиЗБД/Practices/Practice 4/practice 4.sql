-- 3.1.1. Для каждого месяца 2025 года выведите количество выданных книг 
with months as (
	select 'Январь' month_nm, 1 month_nus union all
	select 'Февраль', 2 union all
	select 'Март', 3 union all
	select 'Апрель', 4 union all
	select 'Май', 5 union all
	select 'Июнь', 6 union all
	select 'Июль', 7 union all
	select 'Август', 8 union all
	select 'Сентябрь', 9 union all
	select 'Октябрь', 10 union all
	select 'Ноябрь', 11 union all
	select 'Декабрь', 12
),
all_issues as (
	select m.month_nus, m.month_nm, t.id from months m
	left join ticket t on m.month_nus = extract(month from t.date_of_issue)
	and extract(year from t.date_of_issue) = 2025
)
select month_nus, month_nm, count(id) over(partition by month_nus) as "Количество выдач" from all_issues order by month_nus;

-- 3.2.1. Расставьте порядковый номер выдачи книг для каждого дня
select id as "Номер выдачи", date_of_issue as "Дата выдачи", row_number() over(
	partition by date_trunc('day', date_of_issue)
	order by id
) as "Порядковый номер в день"
from ticket where date_of_issue is not null
order by date_of_issue, id;

-- 3.2.2. Вывести список книг с их рангом по году издания (самые старые книги получают ранг 1)
select bshifr as "ID Книги", title as "Название книги", id_author as "Автор", year_publ as "Год публикации",
	rank() over(order by year_publ asc) as "Ранг"
from book where year_publ is not null order by year_publ asc, bshifr;

-- 3.2.3. Для каждого раздела литературы показать автора с наибольшим количеством книг и это количество (применить вынесенный подзапрос)
select section_data."Раздел", section_data."Автор", section_data."Количество книг" from (
	select b.section as "Раздел", concat(a.lastname, ' ', a.name) as "Автор",
	count(b.bshifr) as "Количество книг",
	rank() over(
		partition by b.section
		order by count(b.bshifr) desc
	) as author_rank
	from book b
	join author a on b."id_author" = a.id
	group by b.section, a.id, a.lastname, a.name
) as section_data
where section_data.author_rank = 1
order by "Раздел";

-- 3.3.1. Напишите аналогичный запросу из п.3.1 с применением оконной функции
with months as (
	select 'Январь' month_nm, 1 month_nus union all
	select 'Февраль', 2 union all
	select 'Март', 3 union all
	select 'Апрель', 4 union all
	select 'Май', 5 union all
	select 'Июнь', 6 union all
	select 'Июль', 7 union all
	select 'Август', 8 union all
	select 'Сентябрь', 9 union all
	select 'Октябрь', 10 union all
	select 'Ноябрь', 11 union all
	select 'Декабрь', 12
),
all_issues as (
	select m.month_nus, m.month_nm, t.id, t.date_of_issue from months m
	left join ticket t on m.month_nus = extract(month from t.date_of_issue)
	and extract(year from t.date_of_issue) = 2025
)
select month_nus, month_nm, id as ticket_id, date_of_issue, count(id) over(partition by month_nus) as "Количество выдач"
from all_issues
order by month_nus, date_of_issue;

-- 3.3.2. Напишите оконную функцию для присвоения номера каждому пользователю библиотеки (с сортировкой по фамилии и имени).
select id, lastname, name, row_number()
over(order by lastname, name) as user_num
from "user";

-- 3.3.3. Найдем в каждом месяце первый день выдачи книг автора "Пушкин".
select to_char(t.date_of_issue, 'YYYY-MM') as month,
min(t.date_of_issue)::date as first_issue_day
from ticket as t
join book as b on b.bshifr = t.book_id
join author as a on a.id = b.id_author
where a.lastname = 'Пушкин'
group by to_char(t.date_of_issue, 'YYYY-MM')
order by month;

-- 3.3.4. Найдем разницу между ценой книги и средней ценой книг автора.
select bshifr, title, id_author, price,
	round(price - avg(price) over(partition by id_author)) as diff
from book;

-- 3.3.5. Выведем даты выдачи книг вместе с предыдущей и следующей строками.
select id as ticket_id, date_of_issue,
	lag(date_of_issue) over(order by date_of_issue) as prev_issue,
	lead(date_of_issue) over(order by date_of_issue) as next_issue
from ticket
order by date_of_issue;

-- 3.3.6. Упорядочьте книги в порядке убывания/возрастания их стоимости (с применением функции ранжирования). 
select bshifr, title, price,
	dense_rank() over(order by price desc) as price_rank_desc
from book
order by price desc, bshifr;

select bshifr, title, price,
	dense_rank() over(order by price asc) as price_rank_asc
from book
order by price asc, bshifr;

-- 3.3.7. Для каждого года выведите последнюю дату выдачи книги.
select extract(year from date_of_issue)::integer as year,
	max(date_of_issue)::date as last_issue_date
from ticket
group by extract(year from date_of_issue)
order by year;