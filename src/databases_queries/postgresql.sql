/*
 * Чтобы использовать функцию "uuid_generate_v4()", необходимо выполнить SQL команду.
 */
create extension if not exists "uuid-ossp";

/*
 * Данный sql запрос создает таблицу 'channel_types'.
 * В таблице хранится информация касательно типов каналов.
 */
create table channel_types (
	entry_created_date_time timestamp not null default now(),
	entry_updated_date_time timestamp not null default now(),
	entry_deleted_date_time timestamp null,
	channel_type_id uuid not null default uuid_generate_v4() primary key,
	channel_type_name varchar not null,
	channel_type_description text null
);

/*
 * Данный sql запрос создает таблицу 'channels'.
 * В таблице хранится информация касательно каналов.
 * У канала есть лишь единственный доступный тип.
 */
create table channels (
	entry_created_date_time timestamp not null default now(),
	entry_updated_date_time timestamp not null default now(),
	entry_deleted_date_time timestamp null,
	channel_id uuid not null default uuid_generate_v4() primary key,
	channel_name varchar not null,
	channel_description text null,
	channel_type_id uuid not null,
	foreign key (channel_type_id) references channel_types (channel_type_id)
);

/*
 * Данный sql запрос добавляет столбец 'technical_id' в таблицу 'channels'.
 */
alter table channels add column channel_technical_id text not null;

/*
 * Данный sql запрос добавляет в таблицу unique constraint для уникальности технического идентификатора в рамках определенного канала.
 */
alter table channels add unique (channel_type_id, channel_technical_id);

/*
 * Данный sql запрос создает таблицу 'organizations'.
 * В таблице хранится информация касательно организаций, компаний, служб, дирекций, отделов.
 */
create table organizations (
	entry_created_date_time timestamp not null default now(),
	entry_updated_date_time timestamp not null default now(),
	entry_deleted_date_time timestamp null,
	organization_id uuid not null default uuid_generate_v4() primary key,
	organization_name varchar not null,
	organization_description text null,
	parent_organization_id uuid null,
	foreign key (parent_organization_id) references organizations (organization_id),
	parent_organization_name varchar null,
	parent_organization_description text null,
	root_organization_id uuid null,
	foreign key (root_organization_id) references organizations (organization_id),
	root_organization_name varchar null,
	root_organization_description text null
);

/*
 * Данный sql запрос создает таблицу связей между каналами и организациями.
 * Один канал может принадлежать нескольким организациям и одна организация может иметь несколько каналов.
 */
create table channels_organizations_relationship (
	entry_created_date_time timestamp not null default now(),
	entry_updated_date_time timestamp not null default now(),
	entry_deleted_date_time timestamp null,
 	channel_id uuid not null,
 	foreign key (channel_id) references channels (channel_id),
 	organization_id uuid not null,
 	foreign key (organization_id) references organizations (organization_id)
);

/*
 * Данный sql запрос создает столбец "default_organization" в таблице "channels_organizations_relationship".
 * К примеру, владелец бизнеса может указать на какие отделы по умолчанию должны приходить сообщения из канала.
 * Для этого нужен этот столбец.
 */
alter table channels_organizations_relationship add default_organization boolean not null default false;

/*
 * Данный sql запрос создает таблицу 'roles'.
 * В таблице хранится информация касательно ролей.
 */
create table roles (
	entry_created_date_time timestamp not null default now(),
	entry_updated_date_time timestamp not null default now(),
	entry_deleted_date_time timestamp null,
	role_id uuid not null default uuid_generate_v4() primary key,
	role_technical_name varchar not null,
	role_public_name varchar not null,
	role_description text null
);

/*
 * Данный sql запрос создает таблицу 'permissions'.
 * В таблице хранится информация касательно прав доступов.
 */
create table permissions (
	entry_created_date_time timestamp not null default now(),
	entry_updated_date_time timestamp not null default now(),
	entry_deleted_date_time timestamp null,
	permission_id uuid not null default uuid_generate_v4() primary key,
	permission_technical_name varchar not null,
	permission_public_name varchar not null,
	permission_description text null
);

/*
 * Данный sql запрос создает таблицу связей между ролями и правами доступов.
 * Одна роль может иметь несколько прав доступа и определенное права доступа может быть у нескольких ролей.
 */
create table roles_permissions_relationship (
	entry_created_date_time timestamp not null default now(),
	entry_updated_date_time timestamp not null default now(),
	entry_deleted_date_time timestamp null,
 	role_id uuid not null,
 	foreign key (role_id) references roles (role_id),
 	permission_id uuid not null,
 	foreign key (permission_id) references permissions (permission_id)
);

/*
 * Данный sql запрос создает таблицу 'tariffs'.
 * В таблице хранится информация касательно тарифов.
 */
create table tariffs (
	entry_created_date_time timestamp not null default now(),
	entry_updated_date_time timestamp not null default now(),
	entry_deleted_date_time timestamp null,
	tariff_id uuid not null default uuid_generate_v4() primary key,
	tariff_technical_name varchar not null,
	tariff_public_name varchar not null,
	tariff_description text null
);

/*
 * Данный sql запрос создает таблицу 'modules'.
 * В таблице хранится информация касательно модулей.
 */
create table modules (
	entry_created_date_time timestamp not null default now(),
	entry_updated_date_time timestamp not null default now(),
	entry_deleted_date_time timestamp null,
	module_id uuid not null default uuid_generate_v4() primary key,
	module_technical_name varchar not null,
	module_public_name varchar not null,
	module_description text null
);

/*
 * Данный sql запрос создает таблицу 'functions'.
 * В таблице хранится информация касательно функций.
 */
create table functions (
	entry_created_date_time timestamp not null default now(),
	entry_updated_date_time timestamp not null default now(),
	entry_deleted_date_time timestamp null,
	function_id uuid not null default uuid_generate_v4() primary key,
	function_technical_name varchar not null,
	function_public_name varchar not null,
	function_description text null
);

/*
 * Данный sql запрос создает таблицу связей между модулями и функциями.
 * Одна функция может быть во многих модулях и один модуль может иметь множество функций.
 */
create table modules_functions_relationship (
	entry_created_date_time timestamp not null default now(),
	entry_updated_date_time timestamp not null default now(),
	entry_deleted_date_time timestamp null,
	module_id uuid not null,
	foreign key (module_id) references modules (module_id),
	function_id uuid not null,
	foreign key (function_id) references functions (function_id)
);

/*
 * Данный sql запрос создает таблицу связей между тарифами и модулями.
 * Один модуль может быть во многих тарифах и один тариф может иметь множество модулей.
 */
create table tariffs_modules_relationship (
	entry_created_date_time timestamp not null default now(),
	entry_updated_date_time timestamp not null default now(),
	entry_deleted_date_time timestamp null,
	tariff_id uuid not null,
	foreign key (tariff_id) references tariffs (tariff_id),
	module_id uuid not null,
	foreign key (module_id) references modules (module_id)
);

/*
 * Данный sql запрос создает таблицу 'currencies'.
 * В таблице хранится информация касательно валют.
 * Информацию о кодах разных валют можно посмотреть в ISO-4217 на сайтах:
 * - https://www.iso.org/iso-4217-currency-codes.html
 * - https://en.wikipedia.org/wiki/ISO_4217
 */
create table currencies (
	entry_created_date_time timestamp not null default now(),
	entry_updated_date_time timestamp not null default now(),
	entry_deleted_date_time timestamp null,
	currency_id uuid not null default uuid_generate_v4() primary key,
	currency_official_name varchar not null,
	currency_alphabetic_code char(3) not null,
	currency_numeric_code numeric(3) not null
);

/*
 * Данный sql запрос создает таблицу 'countries'.
 * В таблице хранится информация касательно стран.
 * Информацию о кодах разных стран можно посмотреть в ISO-3166 на сайтах:
 * - https://www.iso.org/iso-3166-country-codes.html
 * - https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes
 */
create table countries (
	entry_created_date_time timestamp not null default now(),
	entry_updated_date_time timestamp not null default now(),
	entry_deleted_date_time timestamp null,
	country_id uuid not null default uuid_generate_v4() primary key,
	country_short_name varchar not null,
	country_official_name varchar not null,
	country_alpha_2_code char(2) not null,
	country_alpha_3_code char(3) not null,
	country_numeric_code numeric(3) not null,
	country_code_top_level_domain char(3) not null
);

/*
 * Данный sql запрос создает таблицу 'prices'.
 * В таблице хранится информация касательно цен.
 */
create table prices (
	entry_created_date_time timestamp not null default now(),
	entry_updated_date_time timestamp not null default now(),
	entry_deleted_date_time timestamp null,
	price_id uuid not null default uuid_generate_v4() primary key,
	price_value float not null,
	currency_id uuid not null,
	foreign key (currency_id) references currencies (currency_id)
);

/*
 * Данный sql запрос создает таблицу в которой хранится информация касательно цен разных тарифов.
 * У каждого тарифа в определенной стране есть своя цена.
 * Цена тарифа будет разниться в зависимости от подписки (1 месяц, 3 месяца, 6 месяцев и т.п.)
 */
create table tariffs_prices (
	entry_created_date_time timestamp not null default now(),
	entry_updated_date_time timestamp not null default now(),
	entry_deleted_date_time timestamp null,
	tariff_id uuid not null,
	foreign key (tariff_id) references tariffs (tariff_id),
	country_id uuid not null,
	foreign key (country_id) references countries (country_id),
	price_id uuid not null,
	foreign key (price_id) references prices (price_id),
	days int not null
);

/*
 * Данный sql запрос создает таблицу в которой хранится информация касательно цен разных модулей.
 * У каждого модуля в определенной стране есть своя цена.
 * Цена модуля будет разниться в зависимости от подписки (1 месяц, 3 месяца, 6 месяцев и т.п.)
 */
create table modules_prices (
	entry_created_date_time timestamp not null default now(),
	entry_updated_date_time timestamp not null default now(),
	entry_deleted_date_time timestamp null,
	module_id uuid not null,
	foreign key (module_id) references modules (module_id),
	country_id uuid not null,
	foreign key (country_id) references countries (country_id),
	price_id uuid not null,
	foreign key (price_id) references prices (price_id),
	days int not null
);

/*
 * Для валидации электронной почти на уровне базы данных был создан кастомный тип данных.
 */
create extension citext;
create domain email as citext check (value ~ '^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$');

/*
 * Данный sql запрос создает таблицу 'internal_users'.
 * В таблице хранится информация касательно внутренних пользователей (операторы, супервайзеры и администраторы).
 */
create table internal_users (
	entry_created_date_time timestamp not null default now(),
	entry_updated_date_time timestamp not null default now(),
	entry_deleted_date_time timestamp null,
	internal_user_id uuid not null default uuid_generate_v4() primary key,
	internal_user_first_name varchar null,
	internal_user_last_name varchar null,
	internal_user_middle_name varchar null,
	internal_user_primary_email email null unique,
	internal_user_secondary_email email null unique,
	internal_user_primary_phone_number varchar null unique,
	internal_user_secondary_phone_number varchar null unique,
	internal_user_profile_photo_url text null,
	internal_user_position_name varchar null,
	gender_id uuid null,
	foreign key (gender_id) references genders (gender_id),
	country_id uuid null,
	foreign key (country_id) references countries (country_id),
	role_id uuid null,
	foreign key (role_id) references roles (role_id),
	organization_id uuid null,
	foreign key (organization_id) references organizations (organization_id),
	auth0_user_id varchar not null unique,
	auth0_metadata json null
);

/*
 * Данный sql запрос создает таблицу таблицу 'identified_users'.
 * В таблице хранится информация касательно идентифицированных пользователей.
 */
create table identified_users (
	entry_created_date_time timestamp not null default now(),
	entry_updated_date_time timestamp not null default now(),
	entry_deleted_date_time timestamp null,
	identified_user_id uuid not null default uuid_generate_v4() primary key,
	identified_user_first_name varchar null,
	identified_user_last_name varchar null,
	identified_user_middle_name varchar null,
	identified_user_primary_email email null unique,
	identified_user_secondary_email email null unique,
	identified_user_primary_phone_number varchar null unique,
	identified_user_secondary_phone_number varchar null unique,
	identified_user_profile_photo_url text null,
	gender_id uuid null,
	foreign key (gender_id) references genders (gender_id),
	country_id uuid null,
	foreign key (country_id) references countries (country_id),
	metadata json not null
);

/*
 * Данный sql запрос создает таблицу таблицу 'genders'.
 * В таблице хранится информация касательно пола.
 */
create table genders (
	entry_created_date_time timestamp not null default now(),
	entry_updated_date_time timestamp not null default now(),
	entry_deleted_date_time timestamp null,
	gender_id uuid not null default uuid_generate_v4() primary key,
	gender_technical_name varchar not null,
	gender_public_name varchar not null
);

/*
 * Данный sql запрос создает таблицу таблицу 'unidentified_users'.
 * В таблице хранится информация касательно неидентифицированных пользователей.
 */
create table unidentified_users (
	entry_created_date_time timestamp not null default now(),
	entry_updated_date_time timestamp not null default now(),
	entry_deleted_date_time timestamp null,
	unidentified_user_id uuid not null default uuid_generate_v4() primary key,
	metadata json not null
);

/*
 * В системе у нас есть три типа пользователей: 1) внутренние пользователи; 2) идентифицированные пользователи; 3) неидентифицированные пользователи;
 * Идентификаторы пользователей используются в базе данных Cassandra.
 * К примеру, в чат комнатах диалог может вестись между оператором (внутренний пользователь) и идентифицированным пользователем;
 * Данная таблица объединяет пользовательский пул пользователей с разными типами в одной таблице, чтобы по идентификатору пользователя мы смогли в Cassandra найти информацию по пользователю.
 */
create table users (
	entry_created_date_time timestamp not null default now(),
	entry_updated_date_time timestamp not null default now(),
	entry_deleted_date_time timestamp null,
	user_id uuid not null default uuid_generate_v4() primary key,
	internal_user_id uuid null,
	foreign key (internal_user_id) references internal_users (internal_user_id),
	identified_user_id uuid null,
	foreign key (identified_user_id) references identified_users (identified_user_id),
	unidentified_user_id uuid null,
	foreign key (unidentified_user_id) references unidentified_users (unidentified_user_id)
);

/*
 * Данный запрос добавляет новую запись в таблицу  'unidentified_users'.
 * Данные касаются неидентифицированного пользователя.
 */
insert into unidentified_users (
	unidentified_user_id,
	metadata
) values (
	'ade7dc8d-f754-4436-b2bc-a6433cdc3ded',
	'{"@context": "http://schema.org","@type": "Article","mainEntityOfPage":{"@type": "WebPage","@id": "Каноническая ссылка на статью"},"headline": "Заголовок H1"}'
);

/*
 * Данный запрос добавляет новую запись в таблицу 'internal_users'.
 * Данные касаются внутреннего пользователя.
 */
insert into internal_users (
	internal_user_id,
	internal_user_first_name,
	internal_user_last_name,
	internal_user_middle_name,
	internal_user_primary_email,
	internal_user_secondary_email,
	internal_user_primary_phone_number,
	internal_user_secondary_phone_number,
	internal_user_profile_photo_url
) values (
	'51723324-ae2f-4d30-aaa7-37e6891df474',
	'Екатерина',
	'Климова',
	null,
	'ekaterinaklimova@gmail.com',
	null,
	'+77776573353',
	null,
	'https://klike.net/uploads/posts/2019-03/1551511784_4.jpg'
);

/*
 * Данный запрос возвращает информацию определенных каналов.
 */
select
	channels.channel_id::varchar,
	channels.channel_name,
	channels.channel_description,
	channel_types.channel_type_id::varchar,
	channel_types.channel_type_name,
	channel_types.channel_type_description
from
	channels
left outer join channel_types on
	channels.channel_type_id = channel_types.channel_type_id
where
	channel_id in ('cef46c46-834e-4289-8bcb-c6e3a4c1c213');

/*
 * Данный запрос возвращает информацию определенного человека.
 */
select
	users.user_id::varchar as message_author_id,
	case
		when users.internal_user_id is not null then internal_users.internal_user_first_name
		else identified_users.identified_user_first_name
	end as message_author_first_name,
	case
		when users.internal_user_id is not null then internal_users.internal_user_last_name
		else identified_users.identified_user_last_name
	end as message_author_last_name,
	case
		when users.internal_user_id is not null then internal_users.internal_user_middle_name
		else identified_users.identified_user_middle_name
	end as message_author_middle_name,
	case
		when users.internal_user_id is not null then internal_users.internal_user_primary_email
		else identified_users.identified_user_primary_email
	end as message_author_primary_email,
	case
		when users.internal_user_id is not null then internal_users.internal_user_secondary_email
		else identified_users.identified_user_secondary_email
	end as message_author_secondary_email,
	case
		when users.internal_user_id is not null then internal_users.internal_user_primary_phone_number
		else identified_users.identified_user_primary_phone_number
	end as message_author_primary_phone_number,
	case
		when users.internal_user_id is not null then internal_users.internal_user_secondary_phone_number
		else identified_users.identified_user_secondary_phone_number
	end as message_author_secondary_phone_number,
	case
		when users.internal_user_id is not null then internal_users.internal_user_secondary_phone_number
		else identified_users.identified_user_secondary_phone_number
	end as message_author_secondary_phone_number,
	case
		when users.internal_user_id is not null then internal_users.internal_user_profile_photo_url
		else identified_users.identified_user_profile_photo_url
	end as message_author_profile_photo_url,
	case
		when users.internal_user_id is not null then internal_users.internal_user_profile_photo_url
		else identified_users.identified_user_profile_photo_url
	end as message_author_profile_photo_url
from
	users
left join internal_users on
	users.internal_user_id = internal_users.internal_user_id
left join identified_users on
	users.identified_user_id = identified_users.identified_user_id;

/*
 * Данный запрос возвращает информацию о всех каналах определенной организации.
 */
select
	channels.channel_id::varchar,
	channels.channel_name,
	channels.channel_description,
	channel_types.channel_type_id::varchar,
	channel_types.channel_type_name,
	channel_types.channel_type_description
from
	channels
left join channel_types on
	channels.channel_type_id = channel_types.channel_type_id
where
	channel_id in (
		select
			channel_id
		from
			channels_organizations_relationship
		where
			organization_id = '41c88fbc-3697-47a0-a79b-b838d2348d65'
	);

/*
 * Данный запрос позволяет получить 'organization_id' по значению 'technical_id'.
 * У любого канала есть свой технический идентификатор, который генерирует платформы.
 */
select
	channels_organizations_relationship.organization_id
from
	channels_organizations_relationship
left join channels on
	channels_organizations_relationship.channel_id =channels.channel_id
left join channel_types on
	channels.channel_type_id = channel_types.channel_type_id
where
	channels.technical_id = 'HkfMN@ZRXL'
and
	channel_type_name = 'widget';

/*
 * Данный sql запрос создает таблицу в которой хранится информация касательно чат комнаты.
 */
create table chat_rooms (
	entry_created_date_time timestamp not null default now(),
	entry_updated_date_time timestamp not null default now(),
	entry_deleted_date_time timestamp null,
	chat_room_id uuid not null primary key,
	channel_id uuid not null,
	foreign key (channel_id) references channels (channel_id),
	chat_room_status varchar not null
);

/*
 * Данный sql запрос создает таблицу в которой хранится информация касательно участников чат комнат.
 */
create table chat_rooms_users_relationship (
	entry_created_date_time timestamp not null default now(),
	entry_updated_date_time timestamp not null default now(),
	entry_deleted_date_time timestamp null,
	chat_room_id uuid not null,
	foreign key (chat_room_id) references chat_rooms (chat_room_id),
	user_id uuid not null,
	foreign key (user_id) references users (user_id)
);

/*
 * Данный sql запрос создает новую запись (новую чат комнату) в таблице 'chat_rooms'.
 */
insert into chat_rooms (
	chat_room_id,
	channel_id,
	chat_room_status
) values (
	'f1abe670-0f7d-11eb-adc1-0242ac120002',
	'cef46c46-834e-4289-8bcb-c6e3a4c1c213',
	'non_accepted'
);

/*
 * Данный sql запрос возвращает информацию определенной чат комнаты.
 */
select
	chat_rooms.chat_room_id,
	chat_rooms.chat_room_status,
	channels.channel_id,
	channels.channel_name,
	channels.channel_description,
	channels.channel_technical_id,
	channel_types.channel_type_id,
	channel_types.channel_type_name,
	channel_types.channel_type_description
from
	chat_rooms
left join channels on
	chat_rooms.channel_id = channels.channel_id
left join channel_types on
	channels.channel_type_id = channel_types.channel_type_id
where
	chat_room_id = 'f1abe670-0f7d-11eb-adc1-0242ac120002'
limit 1;

/*
 * Данный sql запрос позволяет получить информацию касательно всех участников чат комнаты.
 */
select
	users.user_id,
	case
		when users.internal_user_id is not null then internal_users.internal_user_first_name
		else identified_users.identified_user_first_name
	end as user_first_name,
	case
		when users.internal_user_id is not null then internal_users.internal_user_last_name
		else identified_users.identified_user_last_name
	end as user_last_name,
	case
		when users.internal_user_id is not null then internal_users.internal_user_middle_name
		else identified_users.identified_user_middle_name
	end as user_middle_name,
	case
		when users.internal_user_id is not null then internal_users.internal_user_primary_email
		else identified_users.identified_user_primary_email
	end as user_primary_email,
	case
		when users.internal_user_id is not null then internal_users.internal_user_secondary_email
		else identified_users.identified_user_secondary_email
	end as user_secondary_email,
	case
		when users.internal_user_id is not null then internal_users.internal_user_primary_phone_number
		else identified_users.identified_user_primary_phone_number
	end as user_primary_phone_number,
	case
		when users.internal_user_id is not null then internal_users.internal_user_secondary_phone_number
		else identified_users.identified_user_secondary_phone_number
	end as user_secondary_phone_number,
	case
		when users.internal_user_id is not null then internal_users.internal_user_profile_photo_url
		else identified_users.identified_user_profile_photo_url
	end as user_profile_photo_url
from
	users
left join internal_users on
	users.internal_user_id = internal_users.internal_user_id
left join identified_users on
	users.identified_user_id = identified_users.identified_user_id
where
	users.user_id in (
		select
			user_id
		from
			chat_rooms_users_relationship
		where
			chat_room_id = 'f1abe670-0f7d-11eb-adc1-0242ac120002'
	);

/*
 * Данный sql запрос позволяет получить список чат комнат в которых участвиет клиент в рамках определенного канала.
 */
select
	chat_rooms.chat_room_id,
	chat_rooms.chat_room_status,
	chat_rooms.entry_updated_date_time as chat_room_updated_date_time
from
	chat_rooms_users_relationship
left join chat_rooms on
	chat_rooms_users_relationship.chat_room_id = chat_rooms.chat_room_id
where
	chat_rooms_users_relationship.user_id = '51723324-ae2f-4d30-aaa7-37e6891df474'
and
	chat_rooms.channel_id = 'cef46c46-834e-4289-8bcb-c6e3a4c1c213'
order by
	chat_rooms.entry_updated_date_time desc;

/*
 * Данный sql запрос позволяет получить информацию по определенному каналу и список отделов, которые обслуживают этот канал.
 */
select
	channels.channel_id,
	channels.channel_name,
	channels.channel_description,
	channels.channel_technical_id,
	channel_types.channel_type_id,
	channel_types.channel_type_name,
	channel_types.channel_type_description,
	array_agg (distinct organization_id) as organizations_ids
from
	channels
left join channel_types on
	channels.channel_type_id = channel_types.channel_type_id
left join channels_organizations_relationship on
	channels.channel_id = channels_organizations_relationship.channel_id
where
	channels.channel_technical_id = 'aHe6ZHJgnots2fUXQFVBtX'
and
	lower(channel_types.channel_type_name) = lower('widget')
group by
    channels.channel_id,
    channel_types.channel_type_id
limit 1;

/*
 * Данный sql запрос позволяет получить список отделов, которые могут обслужить определенную чат комнату.
 */
select
	chat_rooms.channel_id,
	array_agg(distinct channels_organizations_relationship.organization_id)::varchar[] as organizations_ids
from
	channels_organizations_relationship
left join chat_rooms on
	channels_organizations_relationship.channel_id = chat_rooms.channel_id
where
	chat_rooms.chat_room_id = '77b42575-14f4-11eb-8f63-797378ee6f77'
group by
	chat_rooms.channel_id;

/*
 * Данный sql запрос позволяет получить список операторов определенной чат комнаты.
 */
select
	chat_rooms_users_relationship.entry_created_date_time as chat_room_member_since_data_time,
	internal_users.auth0_user_id,
	internal_users.auth0_metadata::text,
	users.user_id,
	internal_users.internal_user_first_name as user_first_name,
	internal_users.internal_user_last_name as user_last_name,
	internal_users.internal_user_middle_name as user_middle_name,
	internal_users.internal_user_primary_email as user_primary_email,
	internal_users.internal_user_secondary_email as user_secondary_email,
	internal_users.internal_user_primary_phone_number as user_primary_phone_number,
	internal_users.internal_user_secondary_phone_number as user_secondary_phone_number,
	internal_users.internal_user_profile_photo_url as user_profile_photo_url,
	internal_users.internal_user_position_name as user_position_name,
	genders.gender_id,
	genders.gender_technical_name,
	genders.gender_public_name,
	countries.country_id,
	countries.country_short_name,
	countries.country_official_name,
	countries.country_alpha_2_code,
	countries.country_alpha_3_code,
	countries.country_numeric_code,
	countries.country_code_top_level_domain,
	roles.role_id,
	roles.role_technical_name,
	roles.role_public_name,
	roles.role_description,
	organizations.organization_id,
	organizations.organization_name,
	organizations.organization_description,
	organizations.parent_organization_id,
	organizations.parent_organization_name,
	organizations.parent_organization_description,
	organizations.root_organization_id,
	organizations.root_organization_name,
	organizations.root_organization_description
from
	chat_rooms_users_relationship
left join users on
	chat_rooms_users_relationship.user_id = users.user_id
left join internal_users on
	users.internal_user_id = internal_users.internal_user_id
left join genders on
	internal_users.gender_id = genders.gender_id
left join countries on
	internal_users.country_id = countries.country_id
left join roles on
	internal_users.role_id = roles.role_id
left join organizations on
	internal_users.organization_id = organizations.organization_id
where
	chat_rooms_users_relationship.chat_room_id = '77b42575-14f4-11eb-8f63-797378ee6f77'
and
	users.internal_user_id is not null
and
	users.identified_user_id is null
and
	users.unidentified_user_id is null
order by
	chat_rooms_users_relationship.entry_created_date_time desc;


/*
 * Данный sql запрос позволяет получить информацию о клиенте определенной чат комнаты.
 */
select
	chat_rooms_users_relationship.entry_created_date_time as chat_room_member_since_data_time,
	users.user_id,
	case
		when users.identified_user_id is not null
		and users.unidentified_user_id is null then identified_users.identified_user_first_name
		else null
	end as user_first_name,
	case
		when users.identified_user_id is not null
		and users.unidentified_user_id is null then identified_users.identified_user_last_name
		else null
	end as user_last_name,
	case
		when users.identified_user_id is not null
		and users.unidentified_user_id is null then identified_users.identified_user_middle_name
		else null
	end as user_middle_name,
	case
		when users.identified_user_id is not null
		and users.unidentified_user_id is null then identified_users.identified_user_primary_email
		else null
	end as user_primary_email,
	case
		when users.identified_user_id is not null
		and users.unidentified_user_id is null then identified_users.identified_user_secondary_email
		else null
	end as user_secondary_email,
	case
		when users.identified_user_id is not null
		and users.unidentified_user_id is null then identified_users.identified_user_primary_phone_number
		else null
	end as user_primary_phone_number,
	case
		when users.identified_user_id is not null
		and users.unidentified_user_id is null then identified_users.identified_user_secondary_phone_number
		else null
	end as user_secondary_phone_number,
	case
		when users.identified_user_id is not null
		and users.unidentified_user_id is null then identified_users.identified_user_profile_photo_url
		else null
	end as user_profile_photo_url,
	case
		when users.identified_user_id is not null
		and users.unidentified_user_id is null then 'identified_user'
		else 'unidentified_user'
	end as user_type,
	case
		when users.identified_user_id is not null
		and users.unidentified_user_id is null then identified_users.metadata::text
		else unidentified_users.metadata::text
	end as metadata,
	genders.gender_id,
	genders.gender_technical_name,
	genders.gender_public_name,
	countries.country_id,
	countries.country_short_name,
	countries.country_official_name,
	countries.country_alpha_2_code,
	countries.country_alpha_3_code,
	countries.country_numeric_code,
	countries.country_code_top_level_domain
from
	chat_rooms_users_relationship
left join users on
	chat_rooms_users_relationship.user_id = users.user_id
left join identified_users on
	users.identified_user_id = identified_users.identified_user_id
left join unidentified_users on
	users.unidentified_user_id = unidentified_users.unidentified_user_id
left join genders on
	identified_users.gender_id = genders.gender_id
left join countries on
	identified_users.country_id = countries.country_id
where
	chat_rooms_users_relationship.chat_room_id = '77b42575-14f4-11eb-8f63-797378ee6f77'
and
	(
		users.internal_user_id is null and users.identified_user_id is not null
		or
		users.internal_user_id is null and users.unidentified_user_id is not null
	)
limit 1;

/*
 * Данный sql запрос позволяет получить id последнего оператора в чат комнате и минимальную информацию о канале опеределенной чат комнаты.
 */
select
	users.user_id as operator_id,
	chat_rooms.channel_id,
	chat_rooms.chat_room_status
from
	chat_rooms_users_relationship
left join users on
	chat_rooms_users_relationship.user_id = users.user_id
left join chat_rooms on
	chat_rooms_users_relationship.chat_room_id = chat_rooms.chat_room_id
where
	chat_rooms_users_relationship.chat_room_id = 'efe6bc6e-14f6-11eb-b198-67b78680c89d'
and
	users.internal_user_id is not null
and
	users.identified_user_id is null
and
	users.unidentified_user_id is null
order by
	chat_rooms_users_relationship.entry_created_date_time desc
limit 1;

/*
 * Получить список отделов, которые могут обслужить определенную чат комнату.
 */
select
	array_agg (distinct organization_id)::varchar[] as organizations_ids
from
	channels_organizations_relationship
left join chat_rooms on
	channels_organizations_relationship.channel_id = chat_rooms.channel_id
where
	chat_rooms.chat_room_id = '6dda662a-1509-11eb-93a5-f5b7f0860418';

/*
 * Данный sql запрос, позволяет получить список операторов, которые могут обслужить опеределенный канал.
 */
select
	internal_users.auth0_user_id,
	internal_users.auth0_metadata::text,
	users.user_id,
	internal_users.internal_user_first_name as user_first_name,
	internal_users.internal_user_last_name as user_last_name,
	internal_users.internal_user_middle_name as user_middle_name,
	internal_users.internal_user_primary_email as user_primary_email,
	internal_users.internal_user_secondary_email as user_secondary_email,
	internal_users.internal_user_primary_phone_number as user_primary_phone_number,
	internal_users.internal_user_secondary_phone_number as user_secondary_phone_number,
	internal_users.internal_user_profile_photo_url as user_profile_photo_url,
	internal_users.internal_user_position_name as user_position_name,
	genders.gender_id,
	genders.gender_technical_name,
	genders.gender_public_name,
	countries.country_id,
	countries.country_short_name,
	countries.country_official_name,
	countries.country_alpha_2_code,
	countries.country_alpha_3_code,
	countries.country_numeric_code,
	countries.country_code_top_level_domain,
	roles.role_id,
	roles.role_technical_name,
	roles.role_public_name,
	roles.role_description,
	organizations.organization_id,
	organizations.organization_name,
	organizations.organization_description,
	organizations.parent_organization_id,
	organizations.parent_organization_name,
	organizations.parent_organization_description,
	organizations.root_organization_id,
	organizations.root_organization_name,
	organizations.root_organization_description
from
	channels_organizations_relationship
left join channels on
	channels_organizations_relationship.channel_id = channels.channel_id
left join channel_types on
	channels.channel_type_id = channel_types.channel_type_id
left join organizations on
	channels_organizations_relationship.organization_id = organizations.organization_id
left join internal_users on
	organizations.organization_id = internal_users.organization_id
left join users on
	internal_users.internal_user_id = users.internal_user_id
left join genders on
	internal_users.gender_id = genders.gender_id
left join countries on
	internal_users.country_id = countries.country_id
left join roles on
	internal_users.role_id = roles.role_id
where
	channels.channel_technical_id = 'aHe6ZHJgnots2fUXQFVBtX'
and
	channel_types.channel_type_name = 'widget'
and
	users.internal_user_id is not null
and
	users.identified_user_id is null
and
	users.unidentified_user_id is null
offset 0 limit 10;

/*
 * Данный sql запрос позволяет получить n количество чат комната в которых участвовал клиент.
 */
select
	chat_rooms_users_relationship.entry_created_date_time as chat_room_member_since_date_time,
	chat_rooms.chat_room_id,
	chat_rooms.chat_room_status
from
	chat_rooms_users_relationship
left join chat_rooms on
	chat_rooms_users_relationship.chat_room_id = chat_rooms.chat_room_id
left join channels on
	chat_rooms.channel_id = channels.channel_id
left join channel_types on
	channels.channel_type_id = channel_types.channel_type_id
where
	chat_rooms_users_relationship.user_id = 'ac606654-6934-40e9-a758-a6c01b9bcfb7'
and
	channels.channel_technical_id = 'aHe6ZHJgnots2fUXQFVBtX'
and
	lower(channel_types.channel_type_name) = lower('widget')
order by
	chat_rooms_users_relationship.entry_created_date_time desc
offset 0 limit 10;

/*
 * Получить список последних операторов определенных чат комнат.
 */
select
	distinct on (chat_rooms_users_relationship.chat_room_id) chat_room_id,
	internal_users.auth0_user_id,
	internal_users.auth0_metadata::text,
	users.user_id,
	internal_users.internal_user_first_name as user_first_name,
	internal_users.internal_user_last_name as user_last_name,
	internal_users.internal_user_middle_name as user_middle_name,
	internal_users.internal_user_primary_email as user_primary_email,
	internal_users.internal_user_secondary_email as user_secondary_email,
	internal_users.internal_user_primary_phone_number as user_primary_phone_number,
	internal_users.internal_user_secondary_phone_number as user_secondary_phone_number,
	internal_users.internal_user_profile_photo_url as user_profile_photo_url,
	internal_users.internal_user_position_name as user_position_name,
	genders.gender_id,
	genders.gender_technical_name,
	genders.gender_public_name,
	countries.country_id,
	countries.country_short_name,
	countries.country_official_name,
	countries.country_alpha_2_code,
	countries.country_alpha_3_code,
	countries.country_numeric_code,
	countries.country_code_top_level_domain,
	roles.role_id,
	roles.role_technical_name,
	roles.role_public_name,
	roles.role_description,
	organizations.organization_id,
	organizations.organization_name,
	organizations.organization_description,
	organizations.parent_organization_id,
	organizations.parent_organization_name,
	organizations.parent_organization_description,
	organizations.root_organization_id,
	organizations.root_organization_name,
	organizations.root_organization_description
from
	chat_rooms_users_relationship
left join users on
	chat_rooms_users_relationship.user_id = users.user_id
left join internal_users on
	users.internal_user_id = internal_users.internal_user_id
left join genders on
	internal_users.gender_id = genders.gender_id
left join countries on
	internal_users.country_id = countries.country_id
left join roles on
	internal_users.role_id = roles.role_id
left join organizations on
	internal_users.organization_id = organizations.organization_id
where
	chat_rooms_users_relationship.chat_room_id in (
		'6630133d-1539-11eb-8b54-ff6e377b3d0e',
		'60eadc2c-1539-11eb-8c4d-ff6e377b3d0e',
		'5ebe0c11-1539-11eb-b821-ff6e377b3d0e',
		'14dceaf9-1539-11eb-9b78-ff6e377b3d0e',
		'954bf8f9-1538-11eb-ac39-ff6e377b3d0e',
		'93c3767d-1538-11eb-a9ee-ff6e377b3d0e',
		'7717823a-1538-11eb-852e-ff6e377b3d0e',
		'6ce1ef07-1538-11eb-8055-ff6e377b3d0e',
		'6acc6175-1538-11eb-bf35-ff6e377b3d0e',
		'5c395d7a-1538-11eb-97b8-ff6e377b3d0e'
	)
and
	users.internal_user_id is not null
and
	users.unidentified_user_id is null
and
	users.identified_user_id is null
order by
	chat_rooms_users_relationship.chat_room_id,
	chat_rooms_users_relationship.entry_created_date_time desc;

/*
 * Данный sql запрос позволяет получить список клиентов определенной организации.
 */
select
	distinct users.user_id,
	case
		when users.identified_user_id is not null
		and users.unidentified_user_id is null then identified_users.identified_user_first_name
		else null
	end as user_first_name,
	case
		when users.identified_user_id is not null
		and users.unidentified_user_id is null then identified_users.identified_user_last_name
		else null
	end as user_last_name,
	case
		when users.identified_user_id is not null
		and users.unidentified_user_id is null then identified_users.identified_user_middle_name
		else null
	end as user_middle_name,
	case
		when users.identified_user_id is not null
		and users.unidentified_user_id is null then identified_users.identified_user_primary_email
		else null
	end as user_primary_email,
	case
		when users.identified_user_id is not null
		and users.unidentified_user_id is null then identified_users.identified_user_secondary_email
		else null
	end as user_secondary_email,
	case
		when users.identified_user_id is not null
		and users.unidentified_user_id is null then identified_users.identified_user_primary_phone_number
		else null
	end as user_primary_phone_number,
	case
		when users.identified_user_id is not null
		and users.unidentified_user_id is null then identified_users.identified_user_secondary_phone_number
		else null
	end as user_secondary_phone_number,
	case
		when users.identified_user_id is not null
		and users.unidentified_user_id is null then identified_users.identified_user_profile_photo_url
		else null
	end as user_profile_photo_url,
	case
		when users.identified_user_id is not null
		and users.unidentified_user_id is null then 'identified_user'
		else 'unidentified_user'
	end as user_type,
	case
		when users.identified_user_id is not null
		and users.unidentified_user_id is null then identified_users.metadata::text
		else unidentified_users.metadata::text
	end as metadata,
	genders.gender_id,
	genders.gender_technical_name,
	genders.gender_public_name,
	countries.country_id,
	countries.country_short_name,
	countries.country_official_name,
	countries.country_alpha_2_code,
	countries.country_alpha_3_code,
	countries.country_numeric_code,
	countries.country_code_top_level_domain
from
	chat_rooms_users_relationship
left join users on
	chat_rooms_users_relationship.user_id = users.user_id
left join identified_users on
	users.identified_user_id = identified_users.identified_user_id
left join unidentified_users on
	users.unidentified_user_id = unidentified_users.unidentified_user_id
left join genders on
	identified_users.gender_id = genders.gender_id
left join countries on
	identified_users.country_id = countries.country_id
where
	users.internal_user_id is null
and
	(users.unidentified_user_id is not null or users.identified_user_id is not null)
and
	chat_rooms_users_relationship.chat_room_id in (
		select
			chat_rooms.chat_room_id
		from
			chat_rooms
		where
			chat_rooms.channel_id in (
			select
				channels_organizations_relationship.channel_id
			from
				channels_organizations_relationship
			left join organizations on
				channels_organizations_relationship.organization_id = organizations.organization_id
			where
				organizations.organization_id = '41c88fbc-3697-47a0-a79b-b838d2348d65'
				or organizations.root_organization_id = '41c88fbc-3697-47a0-a79b-b838d2348d65'
		)
	)
order by
	users.user_id
offset 0 limit 10;

/*
 * Добавить столбец, который хранит информацию по username клиента из Telegram канала.
 */
alter table identified_users add telegram_username varchar null;
alter table identified_users add unique (telegram_username);


/*
 * Данный sql запрос создает нового пользователя из Telegram канала в случае необходимости.
 */
insert into identified_users(
	identified_user_first_name,
	identified_user_last_name,
	metadata,
	telegram_username
) values(
	'Nurzhan',
	'Nogerbek',
	"{'id': 168258901, \'is_bot\': false, 'first_name': 'Nurzhan', 'last_name': 'Nogerbek', 'username': 'nurzhannogerbek', 'language_code': 'ru'}",
	'nurzhannogerbek'
)
on conflict on constraint identified_users_telegram_username_key
do nothing
returning
	identified_user_id;

/*
 * В данной таблице идет сопоставление наших технических идентификаторов с идентификаторами из telegram.
 */
create table telegram_chat_rooms (
	entry_created_date_time timestamp not null default now(),
	entry_updated_date_time timestamp not null default now(),
	entry_deleted_date_time timestamp null,
	chat_room_id uuid not null,
	foreign key (chat_room_id) references chat_rooms (chat_room_id),
	telegram_chat_id varchar not null
);

/*
 * Данный sql запрос добавляет в таблицу unique constraint для уникальности технического идентификатора в рамках определенного канала.
 */
alter table telegram_chat_rooms add unique (chat_room_id, telegram_chat_id);

/*
 * Добавить возможность автогенерации идентификатора в таблице "chat_rooms".
 */
alter table chat_rooms
alter column chat_room_id set default uuid_generate_v4();

/*
 * Создать чат комнату для telegram беседы.
 */
insert into chat_rooms (
	channel_id,
	chat_room_status
)
select
	channel_id,
	'non_accepted' as chat_room_status
from
	channels
where
	channel_technical_id = '1481754199:AAGlv9XTRaFLfDVgRTnx5ZTXRNE6a1UgesI'
	limit 1
returning
	chat_room_id,
	channel_id;

/*
 * Привязать ранее созданную чат комнату с техническим идентификатором из telegram.
 */
insert into telegram_chat_rooms (
	chat_room_id,
	telegram_chat_id
) values (
	'41c88fbc-3697-47a0-a79b-b838d2348d65',
	'168258901'
);

/*
 * Добавить столбецы, который хранит информацию по клиенту из WhatsApp канала.
 */
alter table identified_users add whatsapp_profile varchar null;
alter table identified_users add whatsapp_username varchar null;
alter table identified_users add unique (whatsapp_username);

/*
 * В данной таблице идет сопоставление наших технических идентификаторов с идентификаторами из whatsapp.
 */
create table whatsapp_chat_rooms (
	entry_created_date_time timestamp not null default now(),
	entry_updated_date_time timestamp not null default now(),
	entry_deleted_date_time timestamp null,
	chat_room_id uuid not null,
	foreign key (chat_room_id) references chat_rooms (chat_room_id),
	whatsapp_chat_id varchar not null
);

/*
 * Данный sql запрос добавляет в таблицу unique constraint для уникальности технического идентификатора в рамках определенного канала.
 */
alter table whatsapp_chat_rooms add unique (chat_room_id, whatsapp_chat_id);

/*
 * Данный sql запрос позволяет переквалифицировать неидентифицированного пользователя в идентифицированного.
 */
update
	users x
set
	identified_user_id = '7207690e-676a-4279-a74b-36b1a5543ba9',
	unidentified_user_id = null
from (
		select
			*
		from
			users
		where
			user_id = '7350fb90-135f-4023-947d-7c18814a686b'
		for update
) y
where
	x.user_id = y.user_id
returning
	y.unidentified_user_id;


/*
 * Данный sql запрос позволяет поставить метку на удаление у неидентифицированного пользователя.
 */
update
	unidentified_users
set
	entry_deleted_date_time = now()
where
	unidentified_user_id = '7350fb90-135f-4023-947d-7c18814a686b';

/*
 * Данный sql запрос позволяет получить агрегированный список идентификаторов по типу пользователей.
 */
select
    array_remove(array_agg(distinct identified_user_id), null)::text[] as identified_users_ids,
    array_remove(array_agg(distinct unidentified_user_id), null)::text[] as unidentified_users_ids
from
    users
where user_id in (
	'0c77072d-2462-430a-a9cd-d7162cd16b42'
)
limit 1;

/*
 * Данный sql запрос создает таблицу в которой хранится бизнес аккаунты из WhatsApp.
 */
create table whatsapp_business_accounts (
	entry_created_date_time timestamp not null default now(),
	entry_updated_date_time timestamp not null default now(),
	entry_deleted_date_time timestamp null,
	business_account varchar not null unique,
	channel_id uuid not null,
	foreign key (channel_id) references channels (channel_id)
);

/*
 * Данный sql запрос позволяет получить технический token (api key) определенного бизнес аккаунта WhatsApp.
 */
select
	channels.channel_technical_id as whatsapp_bot_token
from
	whatsapp_business_accounts
left join channels on
	whatsapp_business_accounts.channel_id = channels.channel_id
where
	whatsapp_business_accounts.business_account = '+491606232334'
limit 1;

/*
 * Получить агрегированные данные касательно чат комнаты созданной в рамках WhatsApp.
 */
select
	whatsapp_chat_rooms.whatsapp_chat_id,
	channels.channel_technical_id as whatsapp_bot_token
from
	chat_rooms
left join whatsapp_chat_rooms on
	chat_rooms.chat_room_id = whatsapp_chat_rooms.chat_room_id
left join channels on
	chat_rooms.channel_id = channels.channel_id
where
	chat_rooms.chat_room_id = '5cc13f81-2b19-11eb-8970-3f20b721eacb'
limit 1;