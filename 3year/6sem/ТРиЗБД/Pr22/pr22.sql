drop table if exists stop_words;
create table stop_words (stop_word varchar);

insert into stop_words
values
('a'),
('about'),
('above'),
('across'),
('after'),
('again'),
('against'),
('all'),
('almost'),
('alone'),
('along'),
('already'),
('also'),
('although'),
('always'),
('among'),
('an'),
('and'),
('another'),
('any'),
('anybody'),
('anyone'),
('anything'),
('anywhere'),
('are'),
('around'),
('as'),
('ask'),
('asked'),
('asking'),
('asks'),
('at'),
('away'),
('b'),
('back'),
('backed'),
('backing'),
('backs'),
('be'),
('became'),
('because'),
('become'),
('becomes'),
('been'),
('before'),
('began'),
('behind'),
('being'),
('beings'),
('best'),
('better'),
('between'),
('big'),
('both'),
('but'),
('by'),
('c'),
('came'),
('can'),
('cannot'),
('case'),
('cases'),
('certain'),
('certainly'),
('clear'),
('clearly'),
('come'),
('could'),
('d'),
('did'),
('differ'),
('different'),
('differently'),
('do'),
('does'),
('done'),
('down'),
('down'),
('downed'),
('downing'),
('downs'),
('during'),
('e'),
('each'),
('early'),
('either'),
('end'),
('ended'),
('ending'),
('ends'),
('enough'),
('even'),
('evenly'),
('ever'),
('every'),
('everybody'),
('everyone'),
('everything'),
('everywhere'),
('f'),
('face'),
('faces'),
('far'),
('felt'),
('few'),
('find'),
('finds'),
('first'),
('for'),
('four'),
('from'),
('full'),
('fully'),
('further'),
('furthered'),
('furthering'),
('furthers'),
('g'),
('gave'),
('general'),
('generally'),
('get'),
('gets'),
('give'),
('given'),
('gives'),
('go'),
('going'),
('good'),
('goods'),
('got'),
('great'),
('greater'),
('greatest'),
('group'),
('grouped'),
('grouping'),
('groups'),
('h'),
('had'),
('has'),
('have'),
('having'),
('he'),
('her'),
('here'),
('herself'),
('high'),
('higher'),
('highest'),
('him'),
('himself'),
('his'),
('how'),
('however'),
('i'),
('if'),
('important'),
('in'),
('interest'),
('interested'),
('interesting'),
('interests'),
('into'),
('is'),
('it'),
('its'),
('itself'),
('j'),
('just'),
('k'),
('keep'),
('keeps'),
('kind'),
('knew'),
('know'),
('known'),
('knows'),
('l'),
('large'),
('largely'),
('last'),
('later'),
('latest'),
('least'),
('less'),
('let'),
('lets'),
('like'),
('likely'),
('long'),
('longer'),
('longest'),
('m'),
('made'),
('make'),
('making'),
('man'),
('many'),
('may'),
('me'),
('member'),
('members'),
('men'),
('might'),
('more'),
('most'),
('mostly'),
('mr'),
('mrs'),
('much'),
('must'),
('my'),
('myself'),
('n'),
('necessary'),
('need'),
('needed'),
('needing'),
('needs'),
('never'),
('new'),
('new'),
('newer'),
('newest'),
('next'),
('no'),
('nobody'),
('non'),
('noone'),
('not'),
('nothing'),
('now'),
('nowhere'),
('number'),
('numbers'),
('o'),
('of'),
('off'),
('often'),
('old'),
('older'),
('oldest'),
('on'),
('once'),
('one'),
('only'),
('open'),
('opened'),
('opening'),
('opens'),
('or'),
('order'),
('ordered'),
('ordering'),
('orders'),
('other'),
('others'),
('our'),
('out'),
('over'),
('p'),
('part'),
('parted'),
('parting'),
('parts'),
('per'),
('perhaps'),
('place'),
('places'),
('pointing'),
('points'),
('possible'),
('present'),
('presented'),
('presenting'),
('presents'),
('problem'),
('problems'),
('put'),
('puts'),
('q'),
('quite'),
('r'),
('rather'),
('really'),
('right'),
('right'),
('room'),
('rooms'),
('s'),
('said'),
('same'),
('saw'),
('say'),
('says'),
('second'),
('seconds'),
('see'),
('seem'),
('seemed'),
('seeming'),
('seems'),
('sees'),
('several'),
('shall'),
('she'),
('should'),
('show'),
('showed'),
('showing'),
('shows'),
('side'),
('sides'),
('since'),
('small'),
('smaller'),
('smallest'),
('so'),
('some'),
('somebody'),
('someone'),
('something'),
('somewhere'),
('state'),
('states'),
('still'),
('still'),
('such'),
('sure'),
('t'),
('take'),
('taken'),
('than'),
('that'),
('the'),
('their'),
('them'),
('then'),
('there'),
('therefore'),
('these'),
('they'),
('thing'),
('things'),
('think'),
('thinks'),
('this'),
('those'),
('though'),
('thought'),
('thoughts'),
('three'),
('through'),
('thus'),
('to'),
('today'),
('together'),
('too'),
('took'),
('toward'),
('turn'),
('turned'),
('turning'),
('turns'),
('two'),
('u'),
('under'),
('until'),
('up'),
('upon'),
('us'),
('use'),
('used'),
('uses'),
('v'),
('very'),
('w'),
('want'),
('wanted'),
('wanting'),
('wants'),
('was'),
('way'),
('ways'),
('we'),
('well'),
('wells'),
('went'),
('were'),
('what'),
('when'),
('where'),
('whether'),
('which'),
('while'),
('who'),
('whole'),
('whose'),
('why'),
('will'),
('with'),
('within'),
('without'),
('work'),
('worked'),
('working'),
('works'),
('would'),
('x'),
('y'),
('year'),
('years'),
('yet'),
('you'),
('young'),
('younger'),
('youngest'),
('your'),
('yours'),
('z')
;

create table ufo(
	string_report text,
	description text
);

select * from ufo where string_report is null or description is null;
select count(*) from ufo;
select * from ufo limit 50;

-- 3.2.1. Найдём распределение длин строк в поле sighting_report (отчет о наблюдении / репортаж о наблюдении)
-- 3.2.2. Постройте линейную диаграмму для демонстрации распределения длин строк в столбце sighting_report
select
    length(string_report) as string_length,
    count(*) as frequency
from ufo
group by string_length
order by string_length;

-- 3.2.3. Найдите разброс значений длин второго поля таблицы description (описание), постройте диаграмму, сравните значения двух полей
select 
    length(description) as description_length,
    count(*) as frequency
from ufo
group by description_length
order by description_length;

-- 3.3.1. Нахождение фиксированной длины строки с начала (с конца строки) – найдите первые 8 символов, затем количество таких повторений
select 
	left(string_report, 8) as first_eight,
	right(string_report, 8) as last_eight
from ufo limit 10;

select
    left(string_report, 8) as first_eight,
	right(string_report, 8) as last_eight,
    count(*) as cnt
from ufo
group by 1, 2
order by cnt desc;

-- 3.3.2. Найдите символы от 9 до 18 (примените последовательно вырезку слева, затем справа от результата (попробуйте откорректировать цифры для вырезки даты из текста) 
select 
    string_report,
    substring(string_report from 9 for 18) as chars_9_to_25
from ufo
limit 10;

-- 3.3.3. Используя функцию split_part разделите строку по разделителям Occurred : и Entered', 
-- применяя вложенный вариант данной функции найдите значение даты и времени, полученный результат содержит и пустые строки, исключите их при просмотре
select distinct
    nullif(
        trim(
            split_part(
                split_part(string_report, 'Occurred :', 2),
                ' (Entered', 1
            )
        ),
        ''
    ) as occurred_value
from ufo
where string_report ilike '%occurred :%'
  and string_report ilike '%entered%';

-- 3.3.4. Найдите строчки, в который наиболее частно встречаются значения Occurred
select
    nullif(
        trim(
            split_part(
                split_part(string_report, 'Occurred :', 2),
                ' (Entered', 1
            )
        ),
        ''
    ) as occurred_value,
    count(*) as frequency
from ufo
where string_report ilike '%occurred :%'
group by occurred_value
order by frequency desc
limit 20;

-- 3.4. Постройте представление view1, включающие следующие данные:
-- Occurred (Произошло),
-- entered_as (ввведённый как), 
-- reported (дата сообщения), 
-- posted (дата публикации), 
-- location (метоположение), 
-- shape (форма), 
-- duration (продолжительность)
create or replace view view1 as
select
    -- occurred: берём часть после 'occurred :', обрезаем по ' (entered'
    nullif(trim(split_part(split_part(string_report, 'Occurred :', 2), ' (Entered', 1)), '') as occurred,
    
    -- entered_as: берём часть после '(entered as :', обрезаем по ')'
    nullif(trim(split_part(split_part(string_report, '(Entered as :', 2), ')', 1)), '') as entered_as,
    
    -- reported: берём часть после ')reported:', обрезаем по 'posted:'
    nullif(trim(split_part(split_part(string_report, ')Reported:', 2), 'Posted:', 1)), '') as reported,
    
    -- posted: берём часть после 'posted:', обрезаем по 'location:'
    nullif(trim(split_part(split_part(string_report, 'Posted:', 2), 'Location:', 1)), '') as posted,
    
    -- location: берём часть после 'location:', обрезаем по 'shape:'
    nullif(trim(split_part(split_part(string_report, 'Location:', 2), 'Shape:', 1)), '') as location,
    
    -- shape: берём часть после 'shape:', обрезаем по 'duration:'
    nullif(trim(split_part(split_part(string_report, 'Shape:', 2), 'Duration:', 1)), '') as shape,
    
    -- duration: берём часть после 'duration:', обрезаем по табуляции или концу строки (если есть описание)
    -- в примере данные идут плотно, попробуем обрезать по первому пробелу после цифр, но оставим как есть для надежности
    nullif(trim(split_part(split_part(string_report, 'Duration:', 2), e'\t', 1)), '') as duration,
    string_report,
    description
from ufo;

select * from view1 limit 20;


-- 3.5.1. Приведём написание формы из данных view1 в унифицированном виде (первая буква заглавная)
select
    shape,
    initcap(shape) as shape_unified
from view1
where shape is not null
limit 20;

-- 3.5.2. Постройте график, отражающий количество наблюдений объектов разной формой (последних 10 вариантов наблюдений) 
select
    initcap(shape) as shape_normalized,
    count(*) as count
from view1
where shape is not null
group by shape_normalized
order by count desc
limit 10;

-- 3.5.3. Найдите количество наблюдений с наиболее распространёнными продолжительностями (постройте график и сделайте выводы)
select
    duration,
    count(*) as count
from view1
where duration is not null
group by duration
order by count desc
limit 10;

-- 3.5.4. Выполним преобразование типов данных для данных представления view1, получим новое представление view2 в правильными типами данных.
create or replace view view2 as
select
    occurred::timestamp as occurred,
    entered_as::timestamp as entered_as,
    reported::timestamp as reported,
    posted::text as posted,
    location::text as location,
    shape::text as shape,
    duration::text as duration
from view1
where occurred is not null 
  and entered_as is not null 
  and reported is not null;

select * from view2;

-- 3.5.5. Применение функции trim. Уберите лишние пробелы до/после текста
select
    location,
    trim(location) as location_trimmed
from view1
where location is not null
limit 10;

-- 3.5.6. Применение функции replace. Произведите упоминания 'unidentified flying objects' (неопознанные летающие объекты) на более короткое 'UFOs' (НЛО).
select
    description,
    replace(lower(description), 'unidentified flying objects', 'ufos') as description_clean
from ufo
limit 10;

-- 3.5.7. Найдите десять лучших мест наблюдения НЛО, постройте график.
select
    trim(location) as location_clean,
    count(*) as count
from view1
where location is not null
group by location_clean
order by count desc
limit 10;

-- 3.6.1. Подстановочные знаки: LIKE, ILIKE. Найдите количество упоминаний слово wife в описании.
select
    count(*) as wife_count
from ufo
where description ilike '%wife%';

-- 3.6.2. Постройте сводную таблицу для нахождения количества упоминаний husband(муж), жена, mother (мать), отец.
select
    sum(case when description ilike '%husband%' then 1 else 0 end) as husband,
    sum(case when description ilike '%wife%' then 1 else 0 end) as wife,
    sum(case when description ilike '%mother%' then 1 else 0 end) as mother,
    sum(case when description ilike '%father%' then 1 else 0 end) as father
from ufo;

-- 3.6.3. Выполните категоризацию данных – найдите чем занимался наблюдатель до или после наблюдения, постройте сводную таблицу с данными
select
    sum(case when description ilike '%driving%' then 1 else 0 end) as driving,
    sum(case when description ilike '%walking%' then 1 else 0 end) as walking,
    sum(case when description ilike '%sleeping%' then 1 else 0 end) as sleeping,
    sum(case when description ilike '%working%' then 1 else 0 end) as working
from ufo;

-- 3.6.4. Генерация флагов – в наборе данных есть направление south, north, west, east – указывающее в каком направлении обнаружен объект, найдите количество разных вариантов (16) наблюдений со значениями Boolean
select
    description ilike '%south%' as south,
    description ilike '%north%' as north,
    description ilike '%west%' as west,
    description ilike '%east%' as east,
    count(*) as cnt
from ufo
group by 
    description ilike '%south%',
    description ilike '%north%',
    description ilike '%west%',
    description ilike '%east%'
order by 1, 2, 3, 4 asc;

-- 3.6.5. Постройте график по количеству значений
select 'south' as direction, sum(case when description ilike '%south%' then 1 else 0 end) as count from ufo
union all
select 'north', sum(case when description ilike '%north%' then 1 else 0 end) from ufo
union all
select 'west', sum(case when description ilike '%west%' then 1 else 0 end) from ufo
union all
select 'east', sum(case when description ilike '%east%' then 1 else 0 end) from ufo;

-- 3.7.1. Создадим классификацию наблюдений по первому слову в описании (первое слово найдём, применяя split_part. 
-- При анализе текста видно, что многие сообщения начинаются с названия цвета, выведем сообщения, в которых есть упоминания цветов: 
-- 'Red','Orange','Yellow','Green','Blue','Purple','White'
select
    initcap(lower(split_part(description, ' ', 1))) as first_word,
    count(*) as count
from ufo
where split_part(lower(description), ' ', 1) in ('red', 'orange', 'yellow', 'green', 'blue', 'purple', 'white')
group by first_word
order by count desc;

-- 3.7.2. Найдите частоту появления каждого из слов в тексте и постройте гистограмму
select
    word,
    count(*) as frequency
from (
    select regexp_split_to_table(lower(description), '\s+') as word
    from ufo
) t
where word <> ''
group by word
order by frequency desc;

-- 3.8.1. нахождение предложений без учёта регистра, в которых 'car' является первым словом
select
    description
from ufo
where description ~* '^car\s';

-- 3.8.2. вывод первых 50 символов описания, содержащих цифры, за которыми следует слово light
select
    substring(description from 1 for 50) as desc_preview
from ufo
where description ~* '\d+\s*lights?[,\s]';

-- 3.8.3. выведите таблицу с найденными числами
select 
	(regexp_matches(description, '[0-9]+ light[s,.]'))[1], 
	count(*)
from ufo
where description ~ '[0-9]+ light[s,.]'
group by 1
order by 2 desc;

-- 3.8.4. найдите длительность события с помощью регулярного выражения
select 
	duration, 
	(regexp_matches(duration, '\m[Mm][Ii][Nn][A-Za-z]*\y'))[1] as matched_minutes
from
(
	select split_part(string_report, 'Duration:', 2) as duration, 
	count(*) as reports
	from ufo
	group by 1
) a;

-- 3.9.1. Найдите наиболее часто встречающиеся комбинации форм НЛО и их местоположения в одном поле, подсчитайте количество, постройте график (с.253).
select 
	concat(shape, ' - ', location) as shape_location, 
	reports
from
(
	select
	split_part(split_part(string_report, 'Shape', 1), 'Location: ',2) as location, 
	split_part(split_part(string_report, 'Duration', 1), 'Shape: ',2) as shape, 
	count (*) as reports
from ufo
group by 1,2
order by 3 desc
) a;

-- 3.9.2. Найдите часто встречающиеся слова в описании наблюдений НЛО с исключением стоп-слов (с.258)
select word, count(*) as frequency
from 
(
	select regexp_split_to_table(lower(description), '\s+') as word
	from ufo
) a
left join stop_words b  on a.word = b.stop_word
where b.stop_word is null
group by 1
order by 2 desc;



-- 3.10
drop table if exists complaints_raw;
create table complaints_raw (
    col1 text, col2 text, col3 text, col4 text, col5 text,
    col6 text, col7 text, col8 text, col9 text, col10 text,
    col11 text, col12 text, col13 text, col14 text, col15 text,
    col16 text, col17 text, col18 text, col19 text, col20 text,
    col21 text, col22 text, col23 text, col24 text, col25 text,
    col26 text, col27 text, col28 text, col29 text, col30 text,
    col31 text, col32 text, col33 text, col34 text, col35 text,
    col36 text, col37 text, col38 text, col39 text, col40 text,
    col41 text, col42 text
);

select * from complaints_raw limit 20;


drop table if exists complaints;
create table complaints as
select
    col2::bigint as id,
    col3 as incident_number,
    col33 as incident_text,          -- "Текст инцидента" (34-я колонка)
    col7 as first_response,          -- "Общий текст первого ответа"
    col20 as topic_group,            -- "Группа тем"
    col21 as topic,                  -- "Тема"
    col1 as region,                  -- "Регион"
    col18::timestamp as created_at,  -- "Дата создания"
    col26 as incident_type,          -- "Тип инцидента"
    col27 as result                  -- "Итог"
from complaints_raw;


create table stop_words_ru (
    stop_word varchar(100)
);

insert into stop_words_ru (stop_word) values
-- Предлоги
('а'), ('в'), ('во'), ('и'), ('или'), ('же'), ('бы'), ('б'), ('ли'), ('вы'),
('где'), ('да'), ('до'), ('из'), ('им'), ('от'), ('он'), ('на'),
('по'), ('о'), ('об'), ('обо'), ('пред'), ('при'), ('про'), ('с'), ('со'),
('то'), ('у'), ('уже'), ('хотя'),

-- Местоимения
('его'), ('её'), ('ей'), ('ему'), ('им'),
('эти'), ('этим'), ('этих'), ('эта'), ('эту'), ('это'), ('этот'), ('этом'),
('я'), ('ты'), ('мы'), ('вы'), ('он'), ('она'), ('оно'), ('они'), ('меня'),
('тебя'), ('нас'), ('вас'), ('мне'), ('тебе'), ('нам'), ('вам'), ('него'),
('нею'), ('неё'), ('ней'), ('них'), ('моего'), ('моей'), ('моем'), ('моему'),
('моею'), ('твоего'), ('твоей'), ('твоем'), ('твоему'), ('твоею'), ('нашего'),
('нашей'), ('нашем'), ('нашему'), ('нашею'), ('вашего'), ('вашей'), ('вашем'),
('вашему'), ('вашею'), ('их'), ('моём'), ('моим'), ('моими'), ('твоим'),
('твоём'), ('твоими'), ('нашим'), ('нашими'), ('вашим'), ('вашими'),

-- Вопросительные слова
('кем'), ('чем'), ('ком'), ('чём'), ('кому'), ('чему'),
('кого'), ('чего'), ('как'), ('когда'), ('куда'), ('откуда'),
('зачем'), ('почему'), ('разве'), ('неужели'),

-- Сравнения и уточнения
('будто'), ('словно'), ('точно'), ('прямо'), ('совсем'), ('очень'),
('весьма'), ('более'), ('менее'), ('слишком'), ('почти'), ('едва'),
('еле'), ('чуть'), ('немного'), ('немножко'),

-- Количество
('мало'), ('много'), ('столько'), ('сколько'), ('несколько'),

-- Указательные местоимения
('такой'), ('такая'), ('такое'), ('такие'), ('таких'), ('таким'), ('такими'),
('таком'), ('такому'), ('такою'),
('сам'), ('сама'), ('само'), ('сами'), ('самим'), ('самими'), ('самом'),
('самому'), ('самой'), ('самого'),
('другой'), ('другая'), ('другое'), ('другие'), ('других'), ('другим'),
('другими'), ('другом'), ('другому'), ('другою'),
('чужой'), ('чужая'), ('чужое'), ('чужие'), ('чужих'), ('чужим'),
('чужими'), ('чужом'), ('чужому'), ('чужою'),
('этот'), ('эта'), ('это'), ('эти'), ('этого'), ('этой'), ('этом'),
('этому'), ('этим'), ('этими'),
('тот'), ('та'), ('то'), ('те'), ('того'), ('той'), ('том'), ('тому'),
('тем'), ('теми'),

-- Всё/весь
('всё'), ('весь'), ('вся'), ('все'), ('всего'), ('всей'), ('всём'),
('всему'), ('всем'), ('всеми'),

-- Каждый/любой
('каждый'), ('каждая'), ('каждое'), ('каждые'), ('каждого'), ('каждой'),
('каждом'), ('каждому'), ('каждым'), ('каждыми'),
('любой'), ('любая'), ('любое'), ('любые'), ('любого'), ('любом'),
('любому'), ('любым'), ('любыми'),

-- Самый
('самый'), ('самая'), ('самое'), ('самые'), ('самого'), ('самой'),
('самом'), ('самому'), ('самым'), ('самыми'),

-- Глагол "быть" и формы
('быть'), ('был'), ('была'), ('было'), ('были'),
('буду'), ('будешь'), ('будет'), ('будем'), ('будете'), ('будут'),
('будь'), ('будто'), ('кажется'), ('казалось'),

-- Модальные слова
('может'), ('можно'), ('нельзя'), ('надо'), ('нужно'),
('должен'), ('должна'), ('должно'), ('должны'),

-- Хотеть/мочь
('хочу'), ('хочешь'), ('хочет'), ('хотим'), ('хотите'), ('хотят'),
('хотел'), ('хотела'), ('хотело'), ('хотели'),
('могу'), ('можешь'), ('можем'), ('можете'), ('могут'),
('мог'), ('могла'), ('могло'), ('могли'),

-- Отрицания и союзы
('не'), ('ни'), ('нет'), ('ну'), ('но'), ('либо'),

-- Частицы
('ведь'), ('вот'), ('пусть'), ('пускай'), ('давайте'), ('давай'),

-- Вежливые слова
('пожалуйста'), ('спасибо'), ('здравствуйте'),

-- Время суток
('добрый'), ('утро'), ('день'), ('вечер');


-- Представление с очищенным текстом
create or replace view complaints_clean as
select
    id,
    incident_number,
    incident_text,
    -- очистка текста: нижний регистр, удаление спецсимволов, нормализация пробелов
    regexp_replace(
        lower(
            regexp_replace(
                coalesce(incident_text, ''),
                '[^а-яё0-9\s]',  -- оставляем только русские буквы, цифры и пробелы
                ' ',
                'g'
            )
        ),
        '\s+',
        ' ',
        'g'
    ) as text_clean,
    topic_group,
    topic,
    region,
    created_at,
    incident_type,
    result
from complaints
where incident_text is not null 
  and trim(incident_text) <> '';

select * from complaints_clean;

-- Атрибут кластеризации
select
    topic_group as cluster,
    count(*) as incident_count,
    string_agg(
        incident_number || ': ' || left(incident_text, 100) || '...',
        e'\n' order by created_at
    ) as incidents_list
from complaints_clean
group by topic_group
order by incident_count desc;

-- Количество инцидентов по признакам
select
    sum(case when incident_text ilike '%уважаем% администрация%' then 1 else 0 end) as admin_appeal,
    sum(case when incident_text ilike '%крик души%' then 1 else 0 end) as cry_for_help,
    sum(case when incident_text ilike '%примите меры%' then 1 else 0 end) as take_action,
    sum(case when incident_text ilike '%обращаюсь от лица жителей%' then 1 else 0 end) as collective_appeal,
    sum(case when incident_text ilike '%глава региона%' then 1 else 0 end) +
    sum(case when incident_text ilike '%обращаюсь к губернатору%' then 1 else 0 end) as regional_authority,
    sum(case when 
        incident_text ilike '%отсутствует свет%' or
        incident_text ilike '%нет света%' or
        incident_text ilike '%отсутствует вода%' or
        incident_text ilike '%нет воды%' or
        incident_text ilike '%отсутствует электричество%' or
        incident_text ilike '%нет электричества%' or
        incident_text ilike '%отсутствует транспорт%' or
        incident_text ilike '%нет транспорта%' or
        incident_text ilike '%нет автобуса%'
    then 1 else 0 end) as infrastructure_issues,
    sum(case when incident_text ilike '%погибли%' then 1 else 0 end) as fatalities,
    sum(case when 
        incident_text ilike '%получил травму%' or
        incident_text ilike '%травмировался%'
    then 1 else 0 end) as injuries,
    sum(case when 
        incident_text ilike '%бпла%' or
        incident_text ilike '%дрон%'
    then 1 else 0 end) as uav_incidents,
    sum(case when incident_text ilike '%взрыв%' then 1 else 0 end) as explosions,
    sum(case when 
        incident_text ilike '%обвалился%' or
        incident_text ilike '%обвал%'
    then 1 else 0 end) as collapses,
    sum(case when 
        incident_text ilike '%стая собак%' or
        incident_text ilike '%напала собака%' or
        incident_text ilike '%укусила собака%' or
        incident_text ilike '%бродячие собаки%'
    then 1 else 0 end) as dog_issues,
    sum(case when 
        incident_text ilike '%отказали в помощи%' or
        incident_text ilike '%отказали в обращении%'
    then 1 else 0 end) as help_denied,
    sum(case when incident_text ilike '%аварийное состояние%' then 1 else 0 end) as emergency_condition
from complaints_clean;


-- Количество инцидентов для графика
with flags as (
    select
        id,
        incident_text,
        case when incident_text ilike '%уважаем% администрация%' then 1 else 0 end as admin_appeal,
        case when incident_text ilike '%крик души%' then 1 else 0 end as cry_for_help,
        case when incident_text ilike '%примите меры%' then 1 else 0 end as take_action,
        case when incident_text ilike '%обращаюсь от лица жителей%' then 1 else 0 end as collective_appeal,
        case when incident_text ilike '%глава региона%' or incident_text ilike '%обращаюсь к губернатору%' then 1 else 0 end as regional_authority,
        case when incident_text ilike '%отсутствует свет%' or incident_text ilike '%нет света%' or incident_text ilike '%отсутствует вода%' or incident_text ilike '%нет воды%' or incident_text ilike '%отсутствует электричество%' or incident_text ilike '%нет электричества%' or incident_text ilike '%отсутствует транспорт%' or incident_text ilike '%нет транспорта%' or incident_text ilike '%нет автобуса%' then 1 else 0 end as infrastructure_issues,
        case when incident_text ilike '%погибли%' then 1 else 0 end as fatalities,
        case when incident_text ilike '%получил травму%' or incident_text ilike '%травмировался%' then 1 else 0 end as injuries,
        case when incident_text ilike '%бпла%' or incident_text ilike '%дрон%' then 1 else 0 end as uav_incidents,
        case when incident_text ilike '%взрыв%' then 1 else 0 end as explosions,
        case when incident_text ilike '%обвалился%' or incident_text ilike '%обвал%' then 1 else 0 end as collapses,
        case when incident_text ilike '%стая собак%' or incident_text ilike '%напала собака%' or incident_text ilike '%укусила собака%' or incident_text ilike '%бродячие собаки%' then 1 else 0 end as dog_issues,
        case when incident_text ilike '%отказали в помощи%' or incident_text ilike '%отказали в обращении%' then 1 else 0 end as help_denied,
        case when incident_text ilike '%аварийное состояние%' then 1 else 0 end as emergency_condition
    from complaints_clean
)
select 'admin_appeal' as feature, sum(admin_appeal) as count from flags
union all select 'cry_for_help', sum(cry_for_help) from flags
union all select 'take_action', sum(take_action) from flags
union all select 'collective_appeal', sum(collective_appeal) from flags
union all select 'regional_authority', sum(regional_authority) from flags
union all select 'infrastructure_issues', sum(infrastructure_issues) from flags
union all select 'fatalities', sum(fatalities) from flags
union all select 'injuries', sum(injuries) from flags
union all select 'uav_incidents', sum(uav_incidents) from flags
union all select 'explosions', sum(explosions) from flags
union all select 'collapses', sum(collapses) from flags
union all select 'dog_issues', sum(dog_issues) from flags
union all select 'help_denied', sum(help_denied) from flags
union all select 'emergency_condition', sum(emergency_condition) from flags
order by count desc;

-- Частотный анализ слов исключая русские стоп-слова
with words as (
    select 
        id,
        regexp_split_to_table(text_clean, '\s+') as word
    from complaints_clean
),
filtered_words as (
    select 
        w.word,
        count(*) as frequency
    from words w
    where length(w.word) > 2
      and not exists (
          select 1 from stop_words_ru sw 
          where lower(sw.stop_word) = lower(w.word)
      )
    group by w.word
)
select * from filtered_words
order by frequency desc
limit 50;