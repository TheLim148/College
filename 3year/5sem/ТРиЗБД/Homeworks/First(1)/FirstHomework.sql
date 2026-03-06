-- Машина
create table car (
	id bigserial primary key,
	make text not null, -- Марка
	plate_number text not null unique, -- Номер
	driver text, 
	class text,
	body_type text -- Тип кузова
);

-- Путевой лист
create table waybill (
	id bigserial primary key,
	waybill_number text not null unique, -- Номер путевого листа
	trip_date date not null,
	time_start time,
	time_end time,
	route text, -- Маршрут
	notes text,
	car_id bigint not null references car(id) -- Внешний ключ на автомобиль
);

-- Дорожные расходы
create table road_expense (
	id bigserial primary key,
	expense_type text not null, -- Тип расхода
	fuel_amount_liters numeric(10,2), -- Количество топлива
	refuel_receipt_no text, -- Номер заправки/чека
	other_amount numeric(12,2), -- Прочие расходы
	details text, -- Подробности
	waybill_id bigint not null references waybill(id) -- Внешний ключ на путевой лист
);

-- Задания водителю
create table driver_task (
	id bigserial primary key,
	description text not null,
	passengers_count integer,
	equipment text, -- Оборудование
	waybill_id bigint not null references waybill(id) -- Внешний ключ на путевой лист
);

-- Двигатель
create table engine (
	id bigserial primary key,
	engine_number text not null unique,
	engine_type text,
	performance_specs text, -- Характеристики
	car_id bigint unique references car(id)-- Внешний ключ на автомобиль
);



-- Добавление поля "год выпуска"
alter table car
add column year_of_issue integer;

-- Удаление поля "Оборудование"
alter table driver_task
drop column equipment;

-- Переименование поля в более короткое
alter table engine
rename column performance_specs to specs;

-- Изменение типа поля
alter table road_expense
alter column other_amount type integer;

-- Добавление проверки на неотрицательных пассажиров
alter table driver_task
add constraint chk_passengers_count check (passengers_count >= 0);



-- Добавляем автомобиль
insert into car (make, plate_number, driver, class, body_type)
values
('Toyota', 'A123BC', 'John Doe', 'Sedan', 'Sedan'),
('Mercedes', 'B456XY', 'Jane Smith', 'SUV', 'SUV'),
('BMW', 'C789ZY', 'Alice Brown', 'Coupe', 'Coupe');

-- Добавляем путевой лист
insert into waybill (waybill_number, trip_date, time_start, time_end, route, notes, car_id)
values
('WB001', '2025-10-01', '08:00', '10:00', 'Route 66', 'Test trip', 1),
('WB002', '2025-10-02', '09:00', '11:00', 'Route 99', 'Another test trip', 2);

-- Добавляем дорожные расходы
insert into road_expense (expense_type, fuel_amount_liters, refuel_receipt_no, other_amount, details, waybill_id)
values
('Fuel', 50.5, 'R001', 0, 'Full tank', 1),
('Maintenance', 0, 'R002', 200, 'Engine check', 2);

-- Добавляем задания водителю
insert into driver_task (description, passengers_count, waybill_id)
values
('Drive to station', 4, 1),
('Drive to airport', 2, 2);

-- Добавляем двигатель
insert into engine (engine_number, engine_type, car_id)
values
('ENG12345', 'V6', 1),
('ENG67890', 'V8', 2);



-- Обновляем информацию о водителе в таблице car
update car
set driver = 'Mark Johnson'
where plate_number = 'A123BC';

-- Изменим количество топлива на 60 литров в записи о расходах
update road_expense
set fuel_amount_liters = 60
where refuel_receipt_no = 'R001';

-- Обновим описание задания водителю
update driver_task
set description = 'Drive to the station for repairs'
where id = 1;



-- Удаляем путевой лист с номером WB001
delete from waybill
where waybill_number = 'WB001';

-- Удаляем задачу водителю по ID
delete from driver_task
where id = 2;

-- Удаляем автомобиль с госномером 'B456XY'
delete from car
where plate_number = 'B456XY';
