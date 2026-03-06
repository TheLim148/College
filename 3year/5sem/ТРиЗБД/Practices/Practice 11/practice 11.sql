-- 4.1.	PL/pgSQL код без привязки к базе данных
-- 4.1.1. Создайте анонимный блок, в котором объявите переменные. Используя эти переменные выведите:  Наушники JBL T110 899*5=4495
-- v_pr number(8,2) := 899
-- v_qu number(3,0) :=5
-- v_title varchar(20) := ' Наушники JBL T110'
do $$
declare
    v_pr numeric(8,2) := 899;
    v_qu numeric(3,0) := 5;
    v_title varchar(20) := 'Наушники JBL T110';
begin
    raise notice '% %*%=%', v_title, round(v_pr), v_qu, (round(v_pr) * v_qu);
end $$;

-- 4.1.2. Напишите анонимный блок, в котором выведите текущее время n раз, где n – переменная, значение которой задаётся.
do $$
declare
    n int := 5;
    i int := 0;
begin
    if n is null or n < 0 then
        raise exception 'n должно быть неотрицательным';
    end if;

    loop
        exit when i >= n;
        raise notice 'now = %', clock_timestamp();
        i := i + 1;
    end loop;
exception
    when others then
        raise notice 'ошибка: %', sqlerrm;
end $$;

-- 4.1.3. Напишите код, который в зависимости от значения переменной cur вычислит стоимость товара в долларах,
--        если переменная cur=0 и в рублях, если переменная cur=1.
do $$
declare
    cur int := 0;              -- 0 = $, 1 = руб
    usd numeric := 100;
    rub numeric := 95.00;
    result numeric;
begin
    if usd is null or rub is null then
        raise exception 'курс/цена не заданы';
    end if;

    case cur
        when 0 then
            result := usd;
            raise notice 'цена: $%', result;
        when 1 then
            result := usd * rub;
            raise notice 'цена: % руб.', result;
        else
            raise exception 'неизвестная валюта: % (ожидалось 0 или 1)', cur;
    end case;
exception
    when others then
        raise notice 'ошибка: %', sqlerrm;
end $$;

-- 4.2.	Использование блоков <<>>
-- 4.2.1. Создайте анонимный блок, содержащий два блока – внешний и внутренний. Во внешнем блоке объявите и инициализируйте переменные:
-- v_date – текущая дата
-- v_name – имя и фамилия отца
-- v_dt_bt – дата рождения отца

-- Во внутреннем блоке объявите и инициализируйте переменные
-- v_name – имя и фамилия ребёнка
-- v_dt_bt – дата рождения ребёнка

-- Объявите переменные, вычислите их значения и выведите на экран
-- v_age_f – возраст отца
-- v_age_c – возраст ребёнка
-- v_age_v – возраст отца на момент рождения ребёнка
do $$
<<outer_block>>
declare
    v_today date := current_date;
    v_name  text := 'Иван Петров';
    v_dt_bt date := date '1980-05-10';
begin
    <<inner_block>>
    declare
        v_name  text := 'Алексей Петров';
        v_dt_bt date := date '2010-03-15';
        v_age_f int;
        v_age_c int;
        v_age_v int;
    begin
        v_age_f := date_part('year', age(outer_block.v_today, outer_block.v_dt_bt))::int;
        v_age_c := date_part('year', age(outer_block.v_today, v_dt_bt))::int;
        v_age_v := date_part('year', age(v_dt_bt, outer_block.v_dt_bt))::int;

        raise notice 'Отец - %, лет - %', outer_block.v_name, v_age_f;
        raise notice 'Ребёнок - %, лет - %', v_name, v_age_c;
        raise notice 'Возраст Отца на момент рождения ребёнка - % лет', v_age_v;
    exception when others then
        raise notice 'внутренний блок: %', sqlerrm;
    end inner_block;
exception when others then
    raise notice 'внешний блок: %', sqlerrm;
end outer_block $$;

-- 4.3.	PL/pgSQL код с привязкой к базе данных
-- 4.3.1. Объявите переменные для присвоения значения следующим столбцам:
-- Фамилия автора
-- Имя автора
-- Шифр книги
-- Название книги
-- Год издания
-- Цена книги

-- Используя оператор SELECT присвоить заданным переменным значения и вывести на экран с именами полей на русском языке, например 
-- в таком формате: Автор Фамилия Имя, Книга шифр, название, год издания, цена
do $$
declare
    a_last text;
    a_name text;
    b_sh   book.bshifr%type;
    b_ttl  book.title%type;
    b_year book.year_publ%type;
    b_pr   book.price%type;
begin
    begin
        select au.lastname, au.name, b.bshifr, b.title, b.year_publ, b.price
          into a_last, a_name, b_sh, b_ttl, b_year, b_pr
          from author au
          join book   b on b.id_author = au.id
         order by b.bshifr
         limit 1;

        if not found then
            raise notice 'нет данных об авторах/книгах';
            return;
        end if;

        raise notice 'автор % %, книга %: "%", %, % руб.',
            a_last, a_name, b_sh, b_ttl, b_year, b_pr;
    exception
        when too_many_rows then
            raise notice 'ожидалась одна строка';
        when others then
            raise notice 'ошибка: %', sqlerrm;
    end;
end $$;

--4.3.2. Объявить и инициализировать переменные с привязкой к полям
-- b_razd – раздел
-- b_price – цена книги
-- b_pct – величина изменения стоимости книги, процент в год
-- Используя эти переменные, создать запрос, который изменит цену книг заданного раздела.
-- Вывести суммарную стоимость книг до и после изменения, а также количество книг.
do $$
declare
    b_razd book.section%type := 'Детская';
    b_pct  numeric := 10;
    sum_before numeric; 
    sum_after  numeric;
    cnt int;
begin
    select count(*), coalesce(sum(price),0)
      into cnt, sum_before
      from book
     where section = b_razd;

    if cnt = 0 then
        raise notice 'в разделе "%" книг нет — ничего не меняем', b_razd;
        return;
    end if;

    update book
       set price = round((price * (1 + b_pct/100.0))::numeric, 2)
     where section = b_razd;

    select coalesce(sum(price),0)
      into sum_after
      from book
     where section = b_razd;

    raise notice 'раздел "%": книг=%; сумма до=%; сумма после=%; разница=%',
        b_razd, cnt, sum_before, sum_after, (sum_after - sum_before);
exception
    when others then
        raise notice 'ошибка при перерасчёте: %', sqlerrm;
end $$;

-- 4.4.	Управляющие операторы
-- 4.4.1. (IF) Написать программу для изменения для нахождения корней квадратного уравнения, при этом значения переменных a, b, c.
--             Предусмотрите проверку ввода только числовых значений.
do $$
declare
    a_txt text := '1';
    b_txt text := '5';
    c_txt text := '6';
    a numeric; b numeric; c numeric;
    d numeric; x1 numeric; x2 numeric;
begin
    if a_txt !~ '^\s*-?\d+([.,]\d+)?\s*$'
    	or b_txt !~ '^\s*-?\d+([.,]\d+)?\s*$'
    	or c_txt !~ '^\s*-?\d+([.,]\d+)?\s*$' then
        raise exception 'ввод допускает только числа';
    end if;

    -- поддержим запятую как десятичный разделитель
    a := replace(a_txt, ',', '.')::numeric;
    b := replace(b_txt, ',', '.')::numeric;
    c := replace(c_txt, ',', '.')::numeric;

    if a = 0 then
        raise exception 'не квадратное уравнение (a = 0)';
    end if;

    d :=b * b - 4 * a * c;

    if d < 0 then
        raise notice 'корней нет (d=%)', d;
    elsif d = 0 then
        x1 := -b / (2 * a);
        raise notice 'один корень: x=%', round(x1, 2);
    else
        x1 := (-b - sqrt(d)) / (2 * a);
        x2 := (-b + sqrt(d)) / (2 * a);
        raise notice 'два корня: x1=%, x2=%', round(x1, 2), round(x2, 2);
    end if;
exception
    when others then
        raise notice 'ошибка: %', sqlerrm;
end $$;

-- 4.4.2. (CASE) Напишите программу, которая будет формировать значение переменной bonus, в зависимости от значения переменной summa_pr,
--               если данная переменная больше 10000, то переменная bonus = 50% от суммы, если от 1000 до 10000 25% от суммы,
--               иначе переменная д.б. равна 0.
do $$
declare
    summa_pr numeric := 12000;
    bonus numeric := 0;
begin
    bonus := case
               when summa_pr > 10000 then summa_pr*0.50
               when summa_pr >= 1000  then summa_pr*0.25
               else 0
             end;
    raise notice 'сумма=%, бонус=%', summa_pr, bonus;
exception
    when others then
        raise notice 'ошибка: %', sqlerrm;
end $$;

-- 4.4.3. (LOOP) Вычислите значение суммы ряда P = 1 + x + x2/2! + x3/3!+… Вычисление завершить, если ai < 0.0001
do $$
declare
    x numeric := 1.0;
    i int := 0;
    sum numeric := 0.0;
    term numeric;
begin
    loop
		term := power(x, i) / factorial(i);
        exit when term < 0.0001;
        sum := sum + term;
        i := i + 1;
    end loop;

    raise notice 'p(x=%) ≈ % (i=%)', x, sum, i;
end $$;

-- 4.4.4. (WHILE) Вычислите значение суммы ряда с применением оператора while
do $$
declare
    x numeric := 1.0;
    i int := 1;
    term numeric := 1.0;
    sum numeric := 1.0;
begin
    if x is null then
        raise exception 'x не задан';
    end if;

    term := x; i := 1;
    while term >= 0.0001 loop
        sum := sum + term;
        i := i + 1;
        term := power(x, i) / factorial(i);
    end loop;
    raise notice 'p(x=%) ≈ % (i=%)', x, sum, i;
exception when others then
    raise notice 'ошибка: %', sqlerrm;
end $$;

-- 4.4.5. (FOR) Определите последовательность из трёх дат с максимальным количеством выданных книг в течение 10000 дней,
--              начиная с даты 01.10.2020
do $$
declare
    d1 date := '2020-10-01';
    d2 date := d1 + 10000;   -- [d1; d2)
    total int;
    r record;
begin
    select count(*) into total
    from ticket
    where date_of_issue::date >= d1
      and date_of_issue::date <  d2;

    if total = 0 then
        raise notice 'в период %..% выдач нет', d1, (d2 - 1);
        return;
    end if;

    for r in
        select date_of_issue::date as d, count(*) as k
        from ticket
        where date_of_issue::date >= d1
          and date_of_issue::date <  d2
        group by date_of_issue::date
        order by k desc, d
        limit 3
    loop
        raise notice '%: % выдач', r.d, r.k;
    end loop;
exception when others then
    raise notice 'ошибка: %', sqlerrm;
end $$;

-- 4.4.6. (Вложенные циклы) Выведите количество выданных книг за каждый месяц 2024-2025 годов.
do $$
declare
    y int;
    m int;
    first_day date;
    next_month date;
    cnt int;
begin
    for y in 2024..2025 loop
        for m in 1..12 loop
            first_day := make_date(y,m,1);
            next_month := (first_day + interval '1 month')::date;
            select count(*) into cnt
              from ticket
             where date_of_issue >= first_day and date_of_issue < next_month;
            raise notice '%-%: % выдач', y, lpad(m::text,2,'0'), cnt;
        end loop;
    end loop;
exception when others then
    raise notice 'ошибка: %', sqlerrm;
end $$;

-- 4.5.	Обработка ошибок
-- 4.5.1. Напишите программу, в которой произведите удаление автора книги, при этом предусмотрите,
--        если есть ссылка на данного автора выведите текстовое сообщение 
--        "Удаление невозможно, удалите сначала записи о книгах автора."
insert into author(id, lastname, name, year_b, gender) values(5, 'Реддл', 'Том', 1800, 'м');

select * from author;

do $$
declare
    v_author_id int := 5;
begin
    begin
        delete from author where id = v_author_id;

        if not found then
            raise notice 'автор % не найден', v_author_id;
            return;
        end if;

        raise notice 'автор % удалён', v_author_id;

    exception
        when foreign_key_violation then
            raise exception 'удаление невозможно: у автора % есть связанные книги', v_author_id;
        when others then
            raise notice 'ошибка: %', sqlerrm;
    end;
end $$;

-- 4.5.2. Напишите программу, в которой введите данные о книге, предусмотрите проверку,
--        что ввода данных не нарушит ссылочную целостность.
do $$
begin
    insert into book(bshifr, section, id_author, title, publishing, year_publ, price, about, shifr)
    values (6001, 'Детская', 1, 'фиктивная', 'нет', 2025, 100.00, 'демо', 'AB0002');

    raise notice 'книга добавлена';

exception
    when foreign_key_violation then
        raise exception 'нарушена ссылочная целостность: проверь id автора или раздел';
    when check_violation then
        raise exception 'нарушено ограничение CHECK (например, формат shifr)';
    when unique_violation then
        raise exception 'дублирование ключа/шифра книги';
    when others then
        raise notice 'ошибка: %', sqlerrm;
end $$;

-- 4.5.3. Напишите код, вызывающий любую ошибку по вашему усмотрению.
--        Выведите информацию об ошибке с помощью GET STACKED DIAGNOSTICS
do $$
declare
    code text; msg text; ctx text;
begin
    begin
        perform 1/0;
    exception when others then
        get stacked diagnostics
            code = returned_sqlstate,
            msg  = message_text,
            ctx  = pg_exception_context;
        raise notice 'sqlstate: %', code;
        raise notice 'msg     : %', msg;
        raise notice 'context : %', ctx;
    end;
end $$;