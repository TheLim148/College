-- 1.1 Подсчёт количества автомобилей
select count(*) as total_cars
from car;

-- 1.2 Средняя стоимость топлива для путевых листов
select round(avg(fuel_amount_liters)) as avg_fuel
from road_expense;


-- 2.1 Вложенный запрос для получения автомобилей, у которых есть путевой лист с расходами
select make, plate_number
from car where id in (
	select car_id
	from waybill
);

-- 2.2 Вложенный запрос для получения путевых листов с расходами, превышающими 100
select waybill_number, trip_date
from waybill
where id in (
	select waybill_id
	from road_expense
	where other_amount > 100
);


-- 3.1 Использование exists для проверки существования путевых листов с расходами на топливо
select waybill_number
from waybill w
where exists (
	select 1
	from road_expense re
	where re.waybill_id = w.id and re.expense_type = 'Fuel'
);

-- 3.2 Использование all для поиска путевых листов с расходами на топливо, превышающими 50 литров
select waybill_number
from waybill w
where 50 < all (
	select fuel_amount_liters
	from road_expense
	where expense_type = 'Fuel' and waybill_id = w.id
);


-- 4.1 Использование union для вывода автомобилей и путевых листов
select plate_number from car
union
select waybill_number from waybill;

-- 4.2 Использование union all для вывода всех путевых листов и расходов
select waybill_number from waybill
union all
select refuel_receipt_no from road_expense;


-- 5.1 Группировка по автомобилям с подсчётом количества путевых листов
select car_id, count(*) as num_of_waybills
from waybill
group by car_id;

-- 5.2 Группировка по типу расхода и подсчёт суммы
select expense_type, sum(other_amount) as total_expense
from road_expense
group by expense_type;


-- 6.1 Запрос с использованием шаблона для поиска автомобилей с госномерами, начинающимися на "A"
select plate_number
from car
where plate_number like 'A%';

-- 6.2 Запрос для поиска путевых листов с датой в диапазоне
select waybill_number, trip_date
from waybill
where trip_date between '2025-10-01' and '2025-10-31';


-- 7.1 Поиск путевых листов с датой раньше текущей
select waybill_number, trip_date
from waybill
where trip_date < current_date;

-- 7.2 Получение автомобилей, которые использовались в поездках после 1 января 2025 года
select make, plate_number
from car
where id in (
    select car_id
    from waybill
    where trip_date > '2025-01-01'
);