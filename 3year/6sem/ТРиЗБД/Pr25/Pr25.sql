drop table if exists game_users;
create table game_users
(
user_id int
,created date
,country varchar
)
;

drop table if exists game_actions;
create table game_actions
(
user_id int
,action varchar
,action_date date
) 
;

drop table if exists game_purchases;
create table game_purchases
(
user_id int
,purch_date date
,amount decimal
)
;

drop table if exists exp_assignment;
create table exp_assignment
(
exp_name varchar
,user_id int
,exp_date date
,variant varchar
)
;

create index if not exists idx_exp_assignment_exp_user
on exp_assignment(exp_name, user_id, variant, exp_date);

create index if not exists idx_game_actions_user_action_date
on game_actions(user_id, action, action_date);

create index if not exists idx_game_purchases_user_date
on game_purchases(user_id, purch_date);

select * from game_users limit 10;
select * from game_actions limit 10;
select * from game_purchases limit 10;
select * from exp_assignment limit 10;

-- 3.2. эксперименты с бинарными результатами: тест хи-квадрат
-- 3.2.1. найдите сколько пользователей в каждой группе (контрольная группа control и вариантная группа variant_1)
-- успешно завершили процесс обучения (onboarding_complete), а также общее количество пользователей в каждой группе. сделайте выводы.
with onboarding_users as (
    select distinct
        ga.user_id
    from game_actions ga
    where ga.action = 'onboarding complete'
)
select
    ea.variant
    ,count(distinct ea.user_id) as total_users
    ,count(distinct ou.user_id) as completed_users
    ,round(count(distinct ou.user_id)::numeric / count(distinct ea.user_id) * 100, 2) as completion_rate_pct
from exp_assignment ea
left join onboarding_users ou
    on ou.user_id = ea.user_id
where ea.exp_name = 'Onboarding'
group by ea.variant
order by ea.variant;

-- вывод по данным:
-- control: 36 268 из 49 897 пользователей завершили обучение, коэффициент 72.69%.
-- variant 1: 38 280 из 50 275 пользователей завершили обучение, коэффициент 76.14%.
-- новый вариант обучения выше контрольного примерно на 3.46 процентного пункта.

-- 3.2.2. откройте ресурс (3), разберитесь с построением таблицы сопряжённости для данных,
-- постройте таблицу сопряжённости для каждого варианта ('control' или 'variant 1') и для каждого события
-- (был ли завершен процесс обучения или нет).
with experiment_users as (
    select
        ea.variant
        ,ea.user_id
        ,ea.exp_date
    from exp_assignment ea
    where ea.exp_name = 'Onboarding'
),
completion_flags as (
    select
        eu.variant
        ,eu.user_id
        ,count(ga.user_id) > 0 as is_completed
    from experiment_users eu
    left join game_actions ga
        on ga.user_id = eu.user_id
       and ga.action = 'onboarding complete'
       and ga.action_date >= eu.exp_date
    group by
        eu.variant
        ,eu.user_id
)
select
    cf.variant
    ,case
        when cf.is_completed then 'completed'
        else 'not_completed'
    end as onboarding_result
    ,count(*) as users_count
from completion_flags cf
group by
    cf.variant
    ,case
        when cf.is_completed then 'completed'
        else 'not_completed'
    end
order by
    cf.variant
    ,onboarding_result;

-- 3.2.3. постройте запрос (с.308) для нахождения таблицы сопряжённости, в которой отражается частота
-- для каждого варианта и для каждого события (был ли завершен процесс обучения или нет).
select
    ea.variant
    ,count(case when ga.user_id is not null then ea.user_id end) as completed
    ,count(case when ga.user_id is null then ea.user_id end) as not_completed
from exp_assignment ea
left join game_actions ga
    on ea.user_id = ga.user_id
   and ga.action = 'onboarding complete'
where ea.exp_name = 'Onboarding'
group by ea.variant
order by ea.variant;

-- 3.2.4. сделайте вывод, увеличил ли новый процесс обучения в игре коэффициент завершивших обучение.
with experiment_users as (
    select
        ea.variant
        ,ea.user_id
        ,ea.exp_date
    from exp_assignment ea
    where ea.exp_name = 'Onboarding'
),
completion_flags as (
    select
        eu.variant
        ,eu.user_id
        ,count(ga.user_id) > 0 as is_completed
    from experiment_users eu
    left join game_actions ga
        on ga.user_id = eu.user_id
       and ga.action = 'onboarding complete'
       and ga.action_date >= eu.exp_date
    group by
        eu.variant
        ,eu.user_id
),
rates as (
    select
        variant
        ,count(*) as total_users
        ,count(*) filter (where is_completed) as completed_users
        ,count(*) filter (where is_completed)::numeric / count(*) as completion_rate
    from completion_flags
    group by variant
),
pivot_rates as (
    select
        max(completion_rate) filter (where variant = 'control') as control_rate
        ,max(completion_rate) filter (where variant = 'variant 1') as variant_rate
    from rates
)
select
    round(control_rate * 100, 2) as control_rate_pct
    ,round(variant_rate * 100, 2) as variant_1_rate_pct
    ,round((variant_rate - control_rate) * 100, 2) as difference_percentage_points
    ,case
        when variant_rate > control_rate then 'variant 1 увеличил коэффициент завершения обучения'
        when variant_rate < control_rate then 'variant 1 снизил коэффициент завершения обучения'
        else 'коэффициенты завершения обучения равны'
    end as conclusion
from pivot_rates;

-- 3.2.5. добавьте итоговые значения для каждой строки (столбца) и найдите общий итог.
with experiment_users as (
    select
        ea.variant
        ,ea.user_id
        ,exists (
            select 1
            from game_actions ga
            where ga.user_id = ea.user_id
              and ga.action = 'onboarding complete'
              and ga.action_date >= ea.exp_date
        ) as is_completed
    from exp_assignment ea
    where ea.exp_name = 'Onboarding'
)
select
    coalesce(eu.variant, 'итого') as variant
    ,count(*) filter (where eu.is_completed) as completed_users
    ,count(*) filter (where eu.is_completed = false) as not_completed_users
    ,count(*) as total_users
from experiment_users eu
group by rollup(eu.variant)
order by
    case when eu.variant is null then 2 else 1 end
    ,eu.variant;


-- 3.2.6. постройте аналогичную таблицу с помощью сводной таблицы.
with experiment_users as (
    select
        ea.variant
        ,ea.user_id
        ,ea.exp_date
    from exp_assignment ea
    where ea.exp_name = 'Onboarding'
),
completion_flags as (
    select
        eu.variant
        ,eu.user_id
        ,count(ga.user_id) > 0 as is_completed
    from experiment_users eu
    left join game_actions ga
        on ga.user_id = eu.user_id
       and ga.action = 'onboarding complete'
       and ga.action_date >= eu.exp_date
    group by
        eu.variant
        ,eu.user_id
)
select
    cf.variant
    ,count(*) filter (where cf.is_completed) as completed
    ,count(*) filter (where not cf.is_completed) as not_completed
    ,count(*) as total_users
from completion_flags cf
group by cf.variant
order by cf.variant;

-- 3.2.7. дополнительный расчет статистики хи-квадрат по таблице сопряжённости.
-- этот блок не заменяет полноценный статистический вывод, но показывает саму статистику критерия.
with observed as (
    select
        variant
        ,is_completed
        ,count(*)::numeric as observed_count
    from (
        select
            ea.variant
            ,exists (
                select 1
                from game_actions ga
                where ga.user_id = ea.user_id
                  and ga.action = 'onboarding complete'
                  and ga.action_date >= ea.exp_date
            ) as is_completed
        from exp_assignment ea
        where ea.exp_name = 'Onboarding'
    ) s
    group by variant, is_completed
),
row_totals as (
    select
        variant
        ,sum(observed_count) as row_total
    from observed
    group by variant
),
column_totals as (
    select
        is_completed
        ,sum(observed_count) as column_total
    from observed
    group by is_completed
),
grand_total as (
    select sum(observed_count) as total_count
    from observed
),
expected as (
    select
        o.variant
        ,o.is_completed
        ,o.observed_count
        ,rt.row_total * ct.column_total / gt.total_count as expected_count
    from observed o
    join row_totals rt
        on rt.variant = o.variant
    join column_totals ct
        on ct.is_completed = o.is_completed
    cross join grand_total gt
)
select
    round(sum(power(observed_count - expected_count, 2) / expected_count), 4) as chi_square_statistic
from expected;

-- вывод по данным:
-- статистика хи-квадрат получается большой, поэтому различие в долях выглядит не случайным.

-- 3.3. эксперименты с непрерывными результатами: t-тест
-- 3.3.1. напишите запрос для получения ответа на вопрос: увеличил ли новый процесс обучения в игре расходы пользователей
-- на внутриигровую валюту (с.311). сделайте выводы.
select
    variant
    ,count(user_id) as total_cohorted
    ,round(avg(amount), 3) as mean_amount
    ,round(stddev(amount), 3) as stddev_amount
from (
    select
        ea.variant
        ,ea.user_id
        ,sum(coalesce(gp.amount, 0)) as amount
    from exp_assignment ea
    left join game_purchases gp
        on ea.user_id = gp.user_id
    where ea.exp_name = 'Onboarding'
    group by
        ea.variant
        ,ea.user_id
) a
group by variant
order by variant;

-- вывод: средние расходы пользователей в группе variant 1 ниже, чем в группе control.
-- следовательно, по этим агрегированным значениям нельзя сказать, что новый процесс обучения увеличил расходы
-- пользователей на внутриигровую валюту.


-- 3.3.2. напишите запрос для получения ответа на вопрос, повлиял ли вариант 1 на расходы тех пользователей,
-- которые завершили процесс обучения (с.312). сделайте выводы.
select
    variant
    ,count(user_id) as total_cohorted
    ,round(avg(amount), 3) as mean_amount
    ,round(stddev(amount), 3) as stddev_amount
from (
    select
        ea.variant
        ,ea.user_id
        ,sum(coalesce(gp.amount, 0)) as amount
    from exp_assignment ea
    left join game_purchases gp
        on ea.user_id = gp.user_id
    join game_actions ga
        on ea.user_id = ga.user_id
       and ga.action = 'onboarding complete'
    where ea.exp_name = 'Onboarding'
    group by
        ea.variant
        ,ea.user_id
) a
group by variant
order by variant;

-- вывод: среди пользователей, которые завершили обучение, средние расходы в группе variant 1 ниже,
-- чем в группе control. следовательно, по этим агрегированным значениям нельзя сказать,
-- что вариант 1 положительно повлиял на расходы пользователей, завершивших обучение.


-- 3.3.3. найдите среднее значение расходов на внутриигровую валюту, стандартное отклонение
-- и количество наблюдений для каждой группы.
with user_spend as (
    select
        ea.variant
        ,ea.user_id
        ,coalesce(sum(gp.amount), 0) as total_amount
    from exp_assignment ea
    left join game_purchases gp
        on gp.user_id = ea.user_id
       and gp.purch_date >= ea.exp_date
    where ea.exp_name = 'Onboarding'
    group by
        ea.variant
        ,ea.user_id
)
select
    variant
    ,round(avg(total_amount), 4) as avg_spend
    ,round(stddev_samp(total_amount), 4) as stddev_spend
    ,count(*) as observations_count
from user_spend
group by variant
order by variant;

-- вывод по данным:
-- средние расходы у control примерно 3.7812, у variant 1 примерно 3.6876.
-- по среднему расходу variant 1 не выглядит лучше control, несмотря на более высокий коэффициент завершения обучения.

-- 3.4. выбросы
-- 3.4.1. найдём количество пользователей, совершивших покупку внутриигровой валюты (покупатели),
-- и общее количество пользователей в каждой группе.
with buyer_flags as (
    select
        ea.variant
        ,ea.user_id
        ,count(gp.user_id) > 0 as is_buyer
    from exp_assignment ea
    left join game_purchases gp
        on gp.user_id = ea.user_id
       and gp.purch_date >= ea.exp_date
    where ea.exp_name = 'Onboarding'
    group by
        ea.variant
        ,ea.user_id
)
select
    variant
    ,count(*) filter (where is_buyer) as buyers_count
    ,count(*) as total_users
    ,round(count(*) filter (where is_buyer)::numeric / count(*) * 100, 2) as buyer_conversion_pct
from buyer_flags
group by variant
order by variant;

-- вывод по данным:
-- control: 4 988 покупателей из 49 897 пользователей, около 10.00%.
-- variant 1: 4 981 покупателей из 50 275 пользователей, около 9.91%.
-- конверсия в покупателя почти одинаковая, у variant 1 немного ниже.

-- 3.4.2. найдём коэффициент конверсии в покупателя (совершившего покупки внутриигровой валюты)
-- для пользователей, завершивших процесс обучения, для контрольной и вариантной групп из эксперимента 'Onboarding' (с.315).
select
    ea.variant
    ,count(distinct ea.user_id) as total_cohorted
    ,count(distinct gp.user_id) as purchasers
    ,round(count(distinct gp.user_id) * 100.0 / count(distinct ea.user_id), 2) as pct_purchased
from exp_assignment ea
left join game_purchases gp
    on ea.user_id = gp.user_id
join game_actions ga
    on ea.user_id = ga.user_id
   and ga.action = 'onboarding complete'
where ea.exp_name = 'Onboarding'
group by ea.variant
order by ea.variant;

-- вывод: среди пользователей, завершивших обучение, доля покупателей в группе variant 1 немного ниже,
-- чем в группе control. следовательно, по коэффициенту конверсии в покупателя вариант 1 не показал улучшения.


-- 3.5. метод временных рамок
-- 3.5.1. разберитесь с примером (с.317).
select
    variant
    ,count(user_id) as total_cohorted
    ,round(avg(amount), 3) as mean_amount
    ,round(stddev(amount), 3) as stddev_amount
from (
    select
        ea.variant
        ,ea.user_id
        ,sum(coalesce(gp.amount, 0)) as amount
    from exp_assignment ea
    left join game_purchases gp
        on ea.user_id = gp.user_id
        and gp.purch_date <= ea.exp_date + interval '7 days'
    where ea.exp_name = 'Onboarding'
    group by
        ea.variant
        ,ea.user_id
) a
group by variant
order by variant;

-- вывод: метод временных рамок ограничивает анализ фиксированным периодом после попадания пользователя
-- в эксперимент. в данном примере учитываются покупки только в пределах 7 дней от даты назначения
-- пользователя в эксперимент. это делает сравнение групп более корректным, потому что пользователи,
-- попавшие в эксперимент раньше, не получают искусственное преимущество за счёт большего времени
-- на совершение покупок.


-- 3.6. эксперименты с повторным воздействием
-- 3.6.1. изучение воздействия изменений интерфейса на частоту взаимодействия пользователей с продуктом
-- (вариант 1 — новый интерфейс, контрольная группа — старый интерфейс).
-- какой процент пользователей открыло приложение хотя бы один раз в день?
-- в доступных данных нет отдельного события открытия приложения, поэтому любое действие в game_actions используется как приближение активности за день.
with experiment_users as (
    select
        user_id
        ,variant
        ,exp_date
    from exp_assignment
    where exp_name = 'Onboarding'
),
calendar_days as (
    select generate_series(
        (select min(exp_date) from experiment_users)
        ,(select max(action_date) from game_actions)
        ,interval '1 day'
    )::date as activity_date
),
active_days as (
    select distinct
        user_id
        ,action_date
    from game_actions
)
select
    cd.activity_date
    ,eu.variant
    ,count(*) filter (where ad.user_id is not null) as active_users
    ,count(*) as eligible_users
    ,round(count(*) filter (where ad.user_id is not null)::numeric / count(*) * 100, 2) as active_users_pct
from calendar_days cd
join experiment_users eu
    on eu.exp_date <= cd.activity_date
left join active_days ad
    on ad.user_id = eu.user_id
   and ad.action_date = cd.activity_date
group by
    cd.activity_date
    ,eu.variant
order by
    cd.activity_date
    ,eu.variant;

-- 3.6.2. сколько времени в среднем проводит каждый пользователь в приложении?


-- 3.6.3. как изменилась частота выполнения ключевых действий (например, нажатие на кнопку "купить")?
-- в доступных данных нет события нажатия на кнопку "купить", поэтому покупка из game_purchases используется как приближение ключевого действия.
with experiment_users as (
    select
        user_id
        ,variant
        ,exp_date
    from exp_assignment
    where exp_name = 'Onboarding'
),
purchase_stats as (
    select
        eu.variant
        ,count(distinct eu.user_id) as total_users
        ,count(gp.user_id) as purchases_count
        ,count(distinct gp.user_id) as buyers_count
        ,coalesce(sum(gp.amount), 0) as total_revenue
    from experiment_users eu
    left join game_purchases gp
        on gp.user_id = eu.user_id
       and gp.purch_date >= eu.exp_date
    group by eu.variant
)
select
    variant
    ,total_users
    ,purchases_count
    ,buyers_count
    ,round(purchases_count::numeric / total_users, 4) as purchases_per_user
    ,round(buyers_count::numeric / total_users * 100, 2) as buyer_conversion_pct
    ,round(total_revenue, 2) as total_revenue
from purchase_stats
order by variant;

-- 3.7. альтернативные анализы
-- 3.7.1. анализ «до и после». разберитесь с примером (с.320).
select
    case
        when gu.created between '2020-01-13' and '2020-01-26' then 'pre'
        when gu.created between '2020-01-27' and '2020-02-09' then 'post'
    end as variant
    ,count(distinct gu.user_id) as cohorted
    ,count(distinct ga.user_id) as opted_in
    ,round(count(distinct ga.user_id) * 100.0 / count(distinct gu.user_id), 2) as pct_optin
    ,count(distinct gu.created) as days
from game_users gu
left join game_actions ga
    on gu.user_id = ga.user_id
   and ga.action = 'email_optin'
where gu.created between '2020-01-13' and '2020-02-09'
group by 1
order by 1;

-- 3.7.2. анализ естественных экспериментов. разберитесь с примером (с.322).
select
    gu.country
    ,count(distinct gu.user_id) as total_cohorted
    ,count(distinct gp.user_id) as purchasers
    ,round(count(distinct gp.user_id) * 100.0 / count(distinct gu.user_id), 2) as pct_purchased
from game_users gu
left join game_purchases gp
    on gu.user_id = gp.user_id
where gu.country in ('United States', 'Canada')
group by gu.country
order by gu.country;

-- 3.7.3. анализ популяции около порогового значения.
-- придумайте логику анализа, например, определите, как меняется активность игроков
-- (количество игровых сессий, продолжительность сессий, использование бонусов)
-- при приближении к порогу и сразу после его преодоления.
-- выбранная логика: порогом считаем накопленные расходы игрока 10 долларов.
-- сравниваем активность за 7 дней до первого достижения порога и за 7 дней после достижения порога.
-- из-за ограничений данных игровые сессии заменены на количество активных дней, а бонусы не рассчитываются.
with purchase_ordered as (
    select
        gp.user_id
        ,gp.purch_date
        ,gp.amount
        ,sum(gp.amount) over (
            partition by gp.user_id
            order by gp.purch_date, gp.amount
            rows between unbounded preceding and current row
        ) as cumulative_amount
    from game_purchases gp
),
threshold_users as (
    select
        user_id
        ,min(purch_date) as threshold_date
    from purchase_ordered
    where cumulative_amount >= 10
    group by user_id
),
windows as (
    select
        user_id
        ,threshold_date
        ,'before_threshold' as period
        ,threshold_date - 7 as start_date
        ,threshold_date - 1 as end_date
    from threshold_users

    union all

    select
        user_id
        ,threshold_date
        ,'after_threshold' as period
        ,threshold_date as start_date
        ,threshold_date + 6 as end_date
    from threshold_users
),
action_agg as (
    select
        w.user_id
        ,w.period
        ,count(distinct ga.action_date) as active_days
        ,count(*) as action_count
    from windows w
    left join game_actions ga
        on ga.user_id = w.user_id
       and ga.action_date between w.start_date and w.end_date
    group by
        w.user_id
        ,w.period
),
purchase_agg as (
    select
        w.user_id
        ,w.period
        ,count(gp.user_id) as purchase_count
        ,coalesce(sum(gp.amount), 0) as revenue
    from windows w
    left join game_purchases gp
        on gp.user_id = w.user_id
       and gp.purch_date between w.start_date and w.end_date
    group by
        w.user_id
        ,w.period
),
combined as (
    select
        a.user_id
        ,a.period
        ,a.active_days
        ,a.action_count
        ,p.purchase_count
        ,p.revenue
    from action_agg a
    join purchase_agg p
        on p.user_id = a.user_id
       and p.period = a.period
)
select
    period
    ,count(*) as users_count
    ,round(avg(active_days), 2) as avg_active_days
    ,round(avg(action_count), 2) as avg_actions
    ,round(avg(purchase_count), 2) as avg_purchases
    ,round(avg(revenue), 2) as avg_revenue
from combined
group by period
order by period;

-- 3.8. анализ экспериментов на данных, результаты запросов и построенные диаграммы экспортируйте, сделайте выводы.
-- результаты можно экспортировать из pgadmin через export data, а диаграммы построить по результатам запросов.
-- ниже подготовлен отдельный учебный набор данных для анализа системы рекомендаций.

-- 3.8.1. определите ключевые метрики.
-- метрика 1: количество пройденных курсов каждым студентом.
-- метрика 2: средняя оценка студента за курсы.
-- метрика 3: время, затраченное на прохождение курса.
-- метрика 4: уровень удовлетворённости студента по результатам опроса.

-- 3.8.2. подготовьте данные:
-- student — информация о студентах;
-- course_progress — прогресс прохождения курсов;
-- survey_responses — результаты удовлетворённости студентов;
-- recommendation_system — назначение студентов на разные группы.
drop table if exists survey_responses;
drop table if exists course_progress;
drop table if exists recommendation_system;
drop table if exists student;

create table student
(
    student_id int primary key
    ,full_name varchar not null
    ,registered_at date not null
);

create table recommendation_system
(
    student_id int primary key references student(student_id)
    ,group_name varchar not null check (group_name in ('control', 'experimental'))
    ,assigned_at date not null
);

create table course_progress
(
    progress_id int generated always as identity primary key
    ,student_id int not null references student(student_id)
    ,course_id int not null
    ,started_at date not null
    ,completed_at date
    ,completed boolean not null
    ,grade numeric(5, 2)
);

create table survey_responses
(
    response_id int generated always as identity primary key
    ,student_id int not null references student(student_id)
    ,response_date date not null
    ,satisfaction_score int not null check (satisfaction_score between 1 and 5)
);

-- 3.8.3. генерация данных. создайте искусственные данные для заполнения таблиц.
insert into student
(
    student_id
    ,full_name
    ,registered_at
)
select
    gs as student_id
    ,'student ' || gs as full_name
    ,date '2024-01-01' + (gs % 20) as registered_at
from generate_series(1, 60) as gs;

insert into recommendation_system
(
    student_id
    ,group_name
    ,assigned_at
)
select
    student_id
    ,case
        when student_id <= 30 then 'control'
        else 'experimental'
    end as group_name
    ,date '2024-02-01' as assigned_at
from student;

insert into course_progress
(
    student_id
    ,course_id
    ,started_at
    ,completed_at
    ,completed
    ,grade
)
select
    s.student_id
    ,c.course_id
    ,date '2024-02-01' + ((s.student_id + c.course_id) % 10) as started_at
    ,date '2024-02-01' + ((s.student_id + c.course_id) % 10)
        + case
            when rs.group_name = 'experimental' then 12 + ((s.student_id + c.course_id) % 5)
            else 16 + ((s.student_id + c.course_id) % 7)
        end as completed_at
    ,true as completed
    ,case
        when rs.group_name = 'experimental' then 76 + ((s.student_id + c.course_id) % 20)
        else 68 + ((s.student_id + c.course_id) % 18)
    end::numeric(5, 2) as grade
from student s
join recommendation_system rs
    on rs.student_id = s.student_id
join lateral generate_series(
    1
    ,case
        when rs.group_name = 'experimental' then 4 + (s.student_id % 2)
        else 3 + (s.student_id % 2)
    end
) as c(course_id)
    on true;

insert into survey_responses
(
    student_id
    ,response_date
    ,satisfaction_score
)
select
    s.student_id
    ,date '2024-03-15' as response_date
    ,case
        when rs.group_name = 'experimental' then 4 + (s.student_id % 2)
        else 3 + (s.student_id % 2)
    end as satisfaction_score
from student s
join recommendation_system rs
    on rs.student_id = s.student_id;

-- 3.8.4. сколько курсов в среднем проходит студент в каждой группе?
with completed_courses as (
    select
        rs.group_name
        ,s.student_id
        ,count(cp.progress_id) filter (where cp.completed) as completed_courses_count
    from student s
    join recommendation_system rs
        on rs.student_id = s.student_id
    left join course_progress cp
        on cp.student_id = s.student_id
    group by
        rs.group_name
        ,s.student_id
)
select
    group_name
    ,round(avg(completed_courses_count), 2) as avg_completed_courses
from completed_courses
group by group_name
order by group_name;

-- 3.8.5. какова средняя оценка студентов в каждой группе?
select
    rs.group_name
    ,round(avg(cp.grade), 2) as avg_grade
    ,count(cp.grade) as grades_count
from recommendation_system rs
join course_progress cp
    on cp.student_id = rs.student_id
where cp.completed = true
group by rs.group_name
order by rs.group_name;

-- 3.8.6. какое среднее время студенты тратят на прохождение курса в каждой группе?
select
    rs.group_name
    ,round(avg(cp.completed_at - cp.started_at), 2) as avg_days_to_complete
    ,count(*) as completed_courses_count
from recommendation_system rs
join course_progress cp
    on cp.student_id = rs.student_id
where cp.completed = true
  and cp.completed_at is not null
group by rs.group_name
order by rs.group_name;

-- 3.8.7. уровень удовлетворённости студентов.
select
    rs.group_name
    ,round(avg(sr.satisfaction_score), 2) as avg_satisfaction_score
    ,count(*) as responses_count
    ,count(*) filter (where sr.satisfaction_score >= 4) as positive_responses_count
    ,round(count(*) filter (where sr.satisfaction_score >= 4)::numeric / count(*) * 100, 2) as positive_responses_pct
from recommendation_system rs
join survey_responses sr
    on sr.student_id = rs.student_id
group by rs.group_name
order by rs.group_name;

-- 3.8.8. анализ полученных данных.
-- так как искусственные данные сгенерированы с преимуществом experimental-группы,
-- ожидаемый результат: experimental проходит больше курсов, получает более высокие оценки,
-- быстрее завершает курсы и имеет более высокий уровень удовлетворённости.
with courses_by_student as (
    select
        rs.group_name
        ,s.student_id
        ,count(cp.progress_id) filter (where cp.completed) as completed_courses_count
        ,avg(cp.grade) filter (where cp.completed) as avg_grade
        ,avg(cp.completed_at - cp.started_at) filter (where cp.completed and cp.completed_at is not null) as avg_days_to_complete
    from student s
    join recommendation_system rs
        on rs.student_id = s.student_id
    left join course_progress cp
        on cp.student_id = s.student_id
    group by
        rs.group_name
        ,s.student_id
),
survey_by_student as (
    select
        rs.group_name
        ,sr.student_id
        ,avg(sr.satisfaction_score) as avg_satisfaction_score
    from recommendation_system rs
    join survey_responses sr
        on sr.student_id = rs.student_id
    group by
        rs.group_name
        ,sr.student_id
)
select
    c.group_name
    ,round(avg(c.completed_courses_count), 2) as avg_completed_courses
    ,round(avg(c.avg_grade), 2) as avg_grade
    ,round(avg(c.avg_days_to_complete), 2) as avg_days_to_complete
    ,round(avg(s.avg_satisfaction_score), 2) as avg_satisfaction_score
from courses_by_student c
join survey_by_student s
    on s.student_id = c.student_id
group by c.group_name
order by c.group_name;