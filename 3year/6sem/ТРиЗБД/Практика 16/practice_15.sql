-- 3.1.1. Разработать хранимые процедуры для шифрования и дешифрования данных.
alter table "user"
    add column if not exists email bytea;

alter table "user"
    add column if not exists email_plain text;+

-- функция шифрования
create or replace function encrypt_text(p_text text)
returns bytea
language plpgsql
as $$
begin
    return pgp_sym_encrypt(p_text, 'secret_key_123');
end;
$$;

-- функция дешифрования
create or replace function decrypt_text(p_data bytea)
returns text
language plpgsql
as $$
begin
    return pgp_sym_decrypt(p_data, 'secret_key_123');
end;
$$;

-- триггерная функция: шифруем email_plain -> email
create or replace function encrypt_email_trigger()
returns trigger
language plpgsql
as $$
begin
    if new.email_plain is not null then
        new.email := encrypt_text(new.email_plain);
    end if;

    return new;
end;
$$;

drop trigger if exists trg_encrypt_email on "user";

create trigger trg_encrypt_email
before insert or update on "user"
for each row
execute function encrypt_email_trigger();

-- функция проверки существования пользователя по введённой почте (1/0)
create or replace function user_exists_by_email(p_email text)
returns integer
language plpgsql
as $$
declare
    cnt integer;
begin
    select count(*) into cnt
    from "user"
    where decrypt_text(email) = p_email;

    return case when cnt > 0 then 1 else 0 end;
end;
$$;


insert into "user"(id, lastname, name, email_plain, user_group, year_b, age)
values (1001, 'иванов', 'иван', 'test@mail.com', 5000, 2000, 3);

select
    email_plain,
    email as email_encrypted,
    decrypt_text(email) as email_decrypted
from "user"
where email_plain is not null;

select user_exists_by_email('test@mail.com') as exists_1_or_0;
select user_exists_by_email('nope@mail.com') as exists_1_or_0;

-- 3.1.2. Создайте функцию, которая будет шифровать и дешифровать данные в базе данных,
-- например номера телефонов, номера кредитных карт или личные данные пользователей.
-- Проверьте работу функции

create or replace function crypt_data(p_text text, p_mode text)
returns text
language plpgsql
as $$
begin
    if p_mode = 'encrypt' then
        return encode(encrypt_text(p_text), 'hex');
    elsif p_mode = 'decrypt' then
        return decrypt_text(decode(p_text, 'hex'));
    else
        raise exception 'mode must be encrypt or decrypt';
    end if;
end;
$$;

select crypt_data('79991234567', 'encrypt') as enc_hex;
select crypt_data(crypt_data('79991234567', 'encrypt'), 'decrypt') as dec_text;

-- 3.2.1. В таблице Пользователи добавьте поля логин и пароль
alter table "user"
    add column if not exists login text,
    add column if not exists password_hash text;

select * from "user";

-- 3.2.2. Добавьте записи в таблицу, применяя цикл или рекурсивный подзапрос,
-- создавая пользователей с именами student100...student200 и паролем применив хэширование
do $$
declare
    i integer;
begin
    for i in 100..200 loop
        insert into "user"(id, lastname, name, login, password_hash, user_group, year_b, age)
        values (
			i,
			'lastname' || i,
			'name' || i,
            'student' || i,
            hash_text_sha256('password', 2),
			i,
			2007,
			18
        );
    end loop;
end;
$$;

select * from "user" where id between 100 and 200;

-- 3.2.3. Создайте функцию на языке PL/pgSQL, которая будет вычислять хэш-значение для столбца типа TEXT.
-- Хэширование должно выполняться с использованием алгоритма SHA-256.
-- Также предусмотрите возможность передачи параметра, определяющего количество раз применения хэширования к одному значению.
create or replace function hash_text_sha256(
    p_text text,
    p_rounds integer default 1
)
returns text
language plpgsql
as $$
declare
    result text := p_text;
    i integer;
begin
    if p_rounds is null or p_rounds < 1 then
        p_rounds := 1;
    end if;

    for i in 1..p_rounds loop
        result := encode(digest(result, 'sha256'), 'hex');
    end loop;

    return result;
end;
$$;

-- 3.3.1. Используя тип данных UUID сгенерируйте id произвольной таблицы
create table if not exists audit_log (
    id uuid,
    time_created timestamp
);

-- Триггер
create or replace function set_uuid_and_time()
returns trigger
language plpgsql
as $$
begin
    new.id := gen_random_uuid();
    new.time_created := now();
    return new;
end;
$$;

drop trigger if exists trg_set_uuid on audit_log;

create trigger trg_set_uuid
before insert on audit_log
for each row
execute function set_uuid_and_time();


insert into audit_log default values;
select * from audit_log order by time_created desc;

-- 3.3.2. Создайте функцию для генерации случайных слов из существующего файла
create or replace function load_words()
returns text[]
language plpgsql
as $$
declare
    content text;
begin
    content := pg_read_file('/usr/share/dict/words');
    return string_to_array(content, e'\n');
end;
$$;

create or replace function random_words(p_count integer)
returns texts
language plpgsql
as $$
declare
    words text[];
    result text := '';
    i integer;
    idx integer;
    n integer;
begin
    if p_count is null or p_count < 1 then
        return '';
    end if;

    words := load_words();
    n := array_length(words, 1);

    if n is null or n = 0 then
        return '';
    end if;

    for i in 1..p_count loop
        idx := 1 + floor(random() * n)::int;
        result := result || ' ' || words[idx];
    end loop;

    return btrim(result);
end;
$$;

select random_words(5);


create or replace function generate_sentence(p_length integer)
returns text
language plpgsql
as $$
begin
    return random_words(p_length);
end;
$$;

select generate_sentence(10);

-- 3.4.	Придумайте и реализуйте систему управления пользователями,
-- включающую регистрацию новых пользователей, аутентификацию и управление доступом.
-- Система должна включать защиту данных через шифрование и хэширование с солью,
-- а также предоставлять функционал для генерации текстовых данных на основе списка слов.
