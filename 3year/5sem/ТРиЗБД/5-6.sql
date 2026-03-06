alter table performance add column required_equipment text[];

update performance
set required_equipment = '{канат, огни}'
where perf_id = 1;

update performance
set required_equipment = '{платформа, трапеция}'
where perf_id = 2;

select * from performance;


alter table users 
add column favorite_genres text[] not null default '{}';

update users 
set favorite_genres = array['акробатика', 'огненное шоу'] 
where user_id = 1;

select * from users order by user_id;


create table audit_log (
    log_id serial primary key,
    table_name text not null,
    operation text not null check (operation in ('INSERT', 'UPDATE', 'DELETE')),
    user_id integer,
    changed_at timestamptz not null default NOW(),
    old_data jsonb,
    new_data jsonb
);

create or replace function log_tickets_change()
returns trigger as $$
begin
    if (TG_OP = 'DELETE') then
        insert into audit_log (table_name, operation, user_id, old_data)
        values (
            'tickets', 
            'DELETE', 
            (select user_id from users where username = current_user), 
            to_jsonb(old)
        );
        return old;
    elsif (TG_OP = 'UPDATE') then
        insert into audit_log (table_name, operation, user_id, old_data, new_data)
        values (
            'tickets', 
            'UPDATE', 
            (select user_id from users where username = current_user), 
            to_jsonb(old), 
            to_jsonb(new)
        );
        return new;
    elsif (TG_OP = 'INSERT') then
        insert into audit_log (table_name, operation, user_id, new_data)
        values (
            'tickets', 
            'INSERT', 
            (select user_id from users where username = current_user), 
            to_jsonb(new)
        );
        return new;
    end if;
    return null;
end;
$$ language plpgsql;

create trigger tickets_audit
after insert or update or delete on tickets
for each row execute function log_tickets_change();

insert into tickets (user_id, price_id, seat_number) 
values (1, 1, 'P5');

select * from audit_log;


alter table prices 
	alter column seat_category type VARCHAR(50),
	add constraint seat_category_check 
	check (seat_category in ('VIP', 'Parterre', 'Balcony', 'Amphitheater'));

insert into prices (price_id, seat_category, price)
values
(3, 'Balcony', 2000),
(4, 'Amphitheater', 1000);

select * from prices;

create or replace validate_ticket_price()
returns trigger as $$
declare
    expected_category TEXT;
    actual_category TEXT;
begin
    expected_category := 
        case 
            when NEW.seat_number ~ '^VIP' then 'VIP'
            when NEW.seat_number ~ '^P' then 'Parterre'
            when NEW.seat_number ~ '^B' then 'Balcony'
            when NEW.seat_number ~ '^A' then 'Amphitheater'
			else null
        end;

    select seat_category into actual_category
    from prices
    where price_id = NEW.price_id;

    if actual_category is null then
        raise exception 'price_id=% не существует', NEW.price_id;
    elsif actual_category <> expected_category then
		raise exception 'Категория места "%" не соответствует price_id=% (ожидается: %)', 
                        NEW.seat_number, NEW.price_id, expected_category;
    end if;

    return new;
end;
$$ language plpgsql;

create trigger trg_validate_ticket_price
before insert or update on tickets
for each row execute function validate_ticket_price();

insert into tickets (price_id, seat_number, user_id)
values (1, 'VIP-5', 1);

insert into tickets (price_id, seat_number, user_id)
values (3, 'Balcony-40', 1);

select * from tickets;


create or replace function set_purchase_time()
returns trigger as $$
begin
    NEW.purchase_date := coalesce(NEW.purchase_date, NOW());
    return new;
end;
$$ language plpgsql;

create trigger trg_set_purchase_time
before insert on tickets
for each row execute function set_purchase_time();

insert into tickets (user_id, price_id, seat_number)
values (2, 3, 'Balcony-7');

select * from tickets;


create or replace function prevent_past_shows()
returns trigger as $$
begin
    if NEW.date_time < NOW()::TIMESTAMP THEN
        raise exception 'Ошибка: Шоу "%" назначено на прошедшее время (%).', 
                        NEW.show_id, 
                        TO_CHAR(NEW.date_time, 'YYYY-MM-DD HH24:MI:SS');
    end if;
    return new;
end;
$$ language plpgsql;

create trigger trg_prevent_past_shows
before insert or update on shows
for each row execute function prevent_past_shows();

insert into shows (perf_id, arena, date_time)
values (1, 'Big Top', '2025-12-18 20:00:00');