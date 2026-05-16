create table videogame_sales
(
rank int
,name varchar
,platform varchar
,year int
,genre varchar
,publisher varchar
,na_sales decimal
,eu_sales decimal
,jp_sales decimal
,other_sales decimal
,global_sales decimal
)
;

select * from videogame_sales;

-- 3.2.1. найти суммарные глобальные продажи global_sales по платформе, жанру и издателю
-- по каждому полю отдельное агрегирование, а не по комбинации этих трех полей,
-- и вывести результаты в одном запросе.
select
    'platform' as group_type
    ,platform as group_value
    ,round(sum(global_sales), 2) as total_global_sales
from videogame_sales
group by platform

union all

select
    'genre' as group_type
    ,genre as group_value
    ,round(sum(global_sales), 2) as total_global_sales
from videogame_sales
group by genre

union all

select
    'publisher' as group_type
    ,publisher as group_value
    ,round(sum(global_sales), 2) as total_global_sales
from videogame_sales
group by publisher

order by
    group_type
    ,total_global_sales desc;


-- 3.2.2. напишите данный запрос с group by sets.
select
    case
        when grouping(platform) = 0 then 'platform'
        when grouping(genre) = 0 then 'genre'
        when grouping(publisher) = 0 then 'publisher'
    end as group_type
    ,coalesce(platform, genre, publisher, 'unknown') as group_value
    ,round(sum(global_sales), 2) as total_global_sales
from videogame_sales
group by grouping sets
(
    (platform)
    ,(genre)
    ,(publisher)
)
order by
    group_type
    ,total_global_sales desc;


-- используйте оператор group by sets для группировки игр по годам выпуска и платформам одновременно.
select
    case
        when grouping(year) = 0 and grouping(platform) = 0 then 'year_platform'
        when grouping(year) = 0 then 'year'
        when grouping(platform) = 0 then 'platform'
    end as group_type
    ,year as release_year
    ,platform
    ,count(*) as games_count
    ,round(sum(global_sales), 2) as total_global_sales
from videogame_sales
group by grouping sets
(
    (year)
    ,(platform)
    ,(year, platform)
)
order by
    group_type
    ,release_year nulls last
    ,platform nulls last;


-- 3.3.1. частичная выборка с помощью остатка от деления.
-- выберите все игры, чей рейтинг rank делится на 5 без остатка.
-- такие игры занимают ключевые места в топе продаж.
select
    rank
    ,name
    ,platform
    ,year
    ,genre
    ,publisher
    ,global_sales.2.3. 
from videogame_sales
where rank % 5 = 0
order by rank;

-- 3.3.2. уменьшение размерности.
-- создайте новую таблицу на основе существующей, которая будет содержать только следующие столбцы:
-- name, platform, year и global_sales.
drop table if exists videogame_sales_reduced;

create table videogame_sales_reduced as
select
    name
    ,platform
    ,year
    ,global_sales
from videogame_sales;

select * from videogame_sales_reduced;

-- 3.3.3. персональные данные и конфиденциальность.
-- добавьте таблицу users_game и заполните таблицу рандомными данными.
drop table if exists users_game;

create table users_game
(
    user_id int
    ,buyer_name varchar
    ,address varchar
    ,game_name varchar
    ,platform varchar
    ,purchase_amount decimal
    ,purchase_date date
);

insert into users_game
(
    user_id
    ,buyer_name
    ,address
    ,game_name
    ,platform
    ,purchase_amount
    ,purchase_date
)
select
    g.user_id
    ,(array[
        'иван иванов'
        ,'петр петров'
        ,'анна смирнова'
        ,'мария кузнецова'
        ,'алексей соколов'
        ,'елена попова'
        ,'сергей волков'
        ,'ольга морозова'
    ])[(1 + floor(random() * 8 + g.user_id * 0))::int] || ' ' || g.user_id as buyer_name
    ,'адрес покупателя ' || g.user_id as address
    ,v.name as game_name
    ,v.platform
    ,round((1 + random() * 99 + g.user_id * 0)::numeric, 2) as purchase_amount
    ,current_date - floor(random() * 365 + g.user_id * 0)::int as purchase_date
from generate_series(1, 100) as g(user_id)
cross join lateral (
    select
        name
        ,platform
    from videogame_sales
    order by random() + g.user_id * 0
    limit 1
) v;

select * from users_game;

-- анонимизация.
-- удалить идентифицирующие данные, такие как имя и адрес.
drop table if exists users_game_anonymized;

create table users_game_anonymized as
select
    game_name
    ,platform
    ,purchase_amount
    ,purchase_date
from users_game;

select * from users_game_anonymized;

-- псевдонимизация.
-- используйте функции sql для замены реальных имен покупателей на уникальные идентификаторы,
-- сохранив возможность последующего анализа данных.
drop table if exists users_game_pseudonymized;

create table users_game_pseudonymized as
select
    md5(user_id::text || ':' || buyer_name || ':' || address) as buyer_uid
    ,game_name
    ,platform
    ,purchase_amount
    ,purchase_date
from users_game;

select * from users_game_pseudonymized;

-- 3.4.1. комбинирование методов анализа.
-- анализ воронки продаж.
-- рассчитайте долю продаж в каждой категории na, eu, jp, other относительно глобальных продаж.
with sales_by_category as (
    select
        'na_sales' as sales_category,
        sum(na_sales) as category_sales
    from videogame_sales

    union all

    select
        'eu_sales' as sales_category,
        sum(eu_sales) as category_sales
    from videogame_sales

    union all

    select
        'jp_sales' as sales_category,
        sum(jp_sales) as category_sales
    from videogame_sales

    union all

    select
        'other_sales' as sales_category,
        sum(other_sales) as category_sales
    from videogame_sales
),
global_total as (
    select
        sum(global_sales) as global_sales
    from videogame_sales
)
select
    sales_category,
    round(category_sales, 2) as category_sales,
    round(category_sales * 100.0 / nullif(global_sales, 0), 2) as pct_of_global_sales
from sales_by_category
cross join global_total
order by pct_of_global_sales desc;


-- 3.4.2. отток, отставшие и анализ разрывов.
-- определите игры, которые были выпущены после 2015 года, но имеют низкие продажи в японии.
-- низкими продажами считаем продажи, которые попадают в нижний квартиль по jp_sales среди игр после 2015 года.
with jp_threshold as (
    select
        percentile_cont(0.25) within group (order by jp_sales) as low_jp_sales_threshold
    from videogame_sales
    where year > 2015
      and jp_sales is not null
)
select
    v.rank
    ,v.name
    ,v.platform
    ,v.year
    ,v.genre
    ,v.publisher
    ,v.jp_sales
    ,v.global_sales
    ,jt.low_jp_sales_threshold
from videogame_sales v
cross join jp_threshold jt
where v.year > 2015
  and v.jp_sales <= jt.low_jp_sales_threshold
order by
    v.jp_sales
    ,v.global_sales desc;


-- 3.4.3. анализ потребительской корзины.
-- найдите наиболее часто встречающиеся комбинации жанров игр, которые продаются вместе.
with basket_genres as (
    select distinct
        publisher
        ,platform
        ,year
        ,genre
    from videogame_sales
    where publisher is not null
      and platform is not null
      and year is not null
      and genre is not null
),
genre_pairs as (
    select
        bg1.genre as genre_1
        ,bg2.genre as genre_2
        ,bg1.publisher
        ,bg1.platform
        ,bg1.year
    from basket_genres bg1
    join basket_genres bg2
        on bg1.publisher = bg2.publisher
       and bg1.platform = bg2.platform
       and bg1.year = bg2.year
       and bg1.genre < bg2.genre
)
select
    genre_1
    ,genre_2
    ,count(*) as baskets_count
from genre_pairs
group by
    genre_1
    ,genre_2
order by
    baskets_count desc
    ,genre_1
    ,genre_2;


-- 3.5.1. решение задач.
-- сгенерируйте данные для таблицы clothing_items.
drop table if exists orders;
drop table if exists orders_anonymized;
drop table if exists clothing_items;

create table clothing_items
(
    item_id int primary key
    ,name varchar
    ,category varchar
    ,price decimal
    ,size varchar
    ,color varchar
    ,stock_amount int
);

insert into clothing_items
(
    item_id
    ,name
    ,category
    ,price
    ,size
    ,color
    ,stock_amount
)
select
    g.item_id
    ,(array[
        'базовая модель'
        ,'городская модель'
        ,'спортивная модель'
        ,'зимняя модель'
        ,'летняя модель'
        ,'повседневная модель'
        ,'премиальная модель'
        ,'классическая модель'
    ])[(1 + floor(random() * 8 + g.item_id * 0))::int] || ' ' || g.item_id as name
    ,(array[
        'шапки'
        ,'куртки'
        ,'брюки'
        ,'футболки'
        ,'обувь'
    ])[(1 + floor(random() * 5 + g.item_id * 0))::int] as category
    ,round((500 + random() * 9500 + g.item_id * 0)::numeric, 2) as price
    ,(array[
        's'
        ,'m'
        ,'l'
        ,'xl'
    ])[(1 + floor(random() * 4 + g.item_id * 0))::int] as size
    ,(array[
        'черный'
        ,'белый'
        ,'серый'
        ,'синий'
        ,'красный'
        ,'зеленый'
    ])[(1 + floor(random() * 6 + g.item_id * 0))::int] as color
    ,floor(random() * 40 + g.item_id * 0)::int as stock_amount
from generate_series(1, 80) as g(item_id);

select * from clothing_items;

-- сгенерируйте данные для таблицы orders.
create table orders
(
    order_id int
    ,customer_id varchar
    ,item_id int references clothing_items(item_id)
    ,quantity int
    ,total_price decimal
    ,order_date date
    ,delivery_status varchar
);

with order_meta as (
    select
        g.order_id
        ,'customer_' || lpad((1 + floor(random() * 50 + g.order_id * 0))::int::text, 3, '0') as customer_id
        ,current_date - floor(random() * 90 + g.order_id * 0)::int as order_date
        ,(array[
            'в пути'
            ,'доставлено'
            ,'отменено'
            ,'ожидает отправки'
        ])[(1 + floor(random() * 4 + g.order_id * 0))::int] as delivery_status
        ,(1 + floor(random() * 3 + g.order_id * 0))::int as lines_count
    from generate_series(1, 120) as g(order_id)
),
order_lines as (
    select
        om.order_id
        ,om.customer_id
        ,om.order_date
        ,om.delivery_status
        ,l.line_no
    from order_meta om
    cross join lateral generate_series(1, om.lines_count) as l(line_no)
)
insert into orders
(
    order_id
    ,customer_id
    ,item_id
    ,quantity
    ,total_price
    ,order_date
    ,delivery_status
)
select
    ol.order_id
    ,ol.customer_id
    ,ci.item_id
    ,q.quantity
    ,round((ci.price * q.quantity)::numeric, 2) as total_price
    ,ol.order_date
    ,ol.delivery_status
from order_lines ol
cross join lateral (
    select
        item_id
        ,price
    from clothing_items
    order by random() + ol.order_id * 0 + ol.line_no * 0
    limit 1
) ci
cross join lateral (
    select
        (1 + floor(random() * 4 + ol.order_id * 0 + ol.line_no * 0))::int as quantity
) q;

select * from orders;

-- 3.5.2. анонимизируйте данные.
-- заменяем customer_id на псевдоним и убираем прямой идентификатор клиента.
drop table if exists orders_anonymized;

create table orders_anonymized as
select
    order_id
    ,md5(customer_id) as customer_uid
    ,item_id
    ,quantity
    ,total_price
    ,order_date
    ,delivery_status
from orders;

select * from orders_anonymized;

-- найти товары, которые закончились на складе.
select
    item_id
    ,name
    ,category
    ,price
    ,size
    ,color
    ,stock_amount
from clothing_items
where stock_amount = 0
order by
    category
    ,name;


-- посчитать общую выручку от заказов за последний месяц.
select
    round(sum(total_price), 2) as revenue_last_month
from orders
where order_date >= current_date - interval '1 month';


-- определить самые популярные товары по количеству заказов.
select
    ci.item_id
    ,ci.name
    ,ci.category
    ,count(distinct o.order_id) as orders_count
    ,sum(o.quantity) as total_quantity
    ,round(sum(o.total_price), 2) as total_revenue
from orders o
join clothing_items ci
    on o.item_id = ci.item_id
group by
    ci.item_id
    ,ci.name
    ,ci.category
order by
    orders_count desc
    ,total_quantity desc
    ,total_revenue desc;


-- рассчитайте долю продаж в каждой категории.
with category_sales as (
    select
        ci.category
        ,round(sum(o.total_price), 2) as category_revenue
    from orders o
    join clothing_items ci
        on o.item_id = ci.item_id
    group by ci.category
)
select
    category
    ,category_revenue
    ,round(category_revenue * 100.0 / nullif(sum(category_revenue) over (), 0), 2) as pct_of_total_revenue
from category_sales
order by pct_of_total_revenue desc;


-- найдите количество заказов по клиентам.
select
    customer_id
    ,count(distinct order_id) as orders_count
    ,sum(quantity) as total_items
    ,round(sum(total_price), 2) as total_spent
from orders
group by customer_id
order by
    orders_count desc
    ,total_spent desc;


-- получить список товаров, которые клиенты чаще всего покупают вместе.
select
    least(ci1.name, ci2.name) as item_1
    ,greatest(ci1.name, ci2.name) as item_2
    ,count(distinct o1.order_id) as orders_together
from orders o1
join orders o2
    on o1.order_id = o2.order_id
   and o1.item_id < o2.item_id
join clothing_items ci1
    on o1.item_id = ci1.item_id
join clothing_items ci2
    on o2.item_id = ci2.item_id
group by
    least(ci1.name, ci2.name)
    ,greatest(ci1.name, ci2.name)
order by
    orders_together desc
    ,item_1
    ,item_2;

