-- 1. Простые запросы с условием (операторы сравнения, and, or, like, ilke, similar to, between, in и др.)                                                                                                     
select *
from performance
where status = 'active';

select *
from tickets
where status = 'purchased'
	and price_id in (
		select price_id
		from ryzhov_ka.prices
		where price > 1500
);

-- 2. Подзапросы скалярные (после where, select, having)                                                                                                 
select *
from prices
where price > (
    select avg(price)
    from prices
);

select u.login,
  (select count(*)
   from tickets t
   where t.user_id = u.user_id) as tickets_count
from users u;

-- 3 .Подзапросы табличные (после from, where, having)                                                                                                     
select *
from (
    select *
    from shows
    where status = 'open'
) shows;

select *
from users
where user_id in (
    select distinct user_id
    from tickets
);

-- 4. Подзапросы с кванторами (существования для соединения exists, всеобщности all для деления)                                                                                              
select *
from shows s
where exists (
    select 1
    from tickets t
    where t.show_id = s.show_id
);

select *
from ryzhov_ka.prices
where price >= all (
    select price
    from ryzhov_ka.prices
);

-- 5. Запросы с множественными операциями (объединение, пересечение, разность)                                                                                               
select name from actors
union
select login from users;

select actor_id
from actors
intersect
select actor_id
from participation;

-- 6. Вынесенные подзапросы with                                                                                         
with ticket_counts as (
    select show_id, count(*) as cnt
    from tickets
    group by show_id
)
select *
from ticket_counts;

with avg_price as (
    select round(avg(price), 2) as value
    from prices
)
select *
from avg_price;

-- 7. Запросы с  агрегатными функциями, с группировкой данных, с условием для отбора групп                                                                                              
select user_id, count(*) as total
from tickets
group by user_id;

select user_id, count(*) as total
from tickets
group by user_id
having count(*) > 2;

-- 8. Многотабличные запросы                                                                                                 
select t.ticket_id, u.login
from tickets t
join users u on u.user_id = t.user_id;

select p.title, s.date_time
from performance p
join shows s on s.perf_id = p.perf_id;

-- 9. Запросы с применением функций для работы со строками, датами, функциями преобразования и др.                                                                                                    
select upper(login)
from users;

select show_id, extract(year from date_time) as year
from shows;

-- 10.Рекурсивные подзапросы                                                                                                
-- Написал ещё две оконные функции вместо рекурсии

-- 11.Запросы на построение сводных таблиц (перекрёстные запросы)                                                    
select status, count(*) 
from tickets
group by status;

select u.role, count(t.ticket_id)
from users u
left join tickets t on t.user_id = u.user_id
group by u.role;

-- 12.Запросы с применением оконных функций
select
  ticket_id,
  user_id,
  row_number() over (partition by user_id)
from tickets;

select
  price,
  round(avg(price) over (), 2) as avg_price
from prices;

select
  price,
  rank() over (order by price desc) as price_rank
from prices;

select
  price,
  round(avg(price) over (order by price rows between 2 preceding and current row), 2) as moving_avg
from prices;
