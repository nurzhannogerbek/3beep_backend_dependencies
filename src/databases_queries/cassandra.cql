/*
 * Таблица была спроектирована, чтобы получить список чат комнат, которые не были приняты в работу.
 * Чат комнаты формируются из разных каналов.
 * Оператор должен получить список чат комнат связанных лишь с его организацией.
 * В качестве partition key были указаны столбцы 'organization_id' и 'channel_id'.
 * Это позволяет очень быстро получить список чат комнат определенной организации из определенного канала.
 * В качестве clustering key был указан столбец 'chat_room_id' c типом данных 'timeuuid'.
 * Это позволит искать данные за определенный период.
 */
create table non_accepted_chat_rooms (
	organization_id uuid,
	channel_id uuid,
	chat_room_id timeuuid,
	client_id uuid,
	primary key (
		(
			organization_id,
			channel_id
		),
		chat_room_id
	)
) with clustering order by (
	chat_room_id desc
);

/*
 * Данный cql запрос удаляет таблицу под названием 'non_accepted_chat_rooms'.
 */
drop table non_accepted_chat_rooms;

/*
 * Данный cql запрос добавляет запись в таблицу 'non_accepted_chat_rooms'.
 */
insert into non_accepted_chat_rooms (
	organization_id,
	channel_id,
	chat_room_id,
	client_id
) values (
	41c88fbc-3697-47a0-a79b-b838d2348d65,
	3868d4de-d51c-4545-a872-5a8f24aed52e,
	bbc62722-0ea7-11eb-adc1-0242ac120002,
	51723324-ae2f-4d30-aaa7-37e6891df474
);

/*
 * Данный cql запрос удаляет определенную запись из таблицы 'non_accepted_chat_rooms' по primary key.
 */
delete from
	non_accepted_chat_rooms
where
	organization_id = 4a85c9f2-04a5-11eb-adc1-0242ac120002
and
	channel_id = 6fd98405-5058-4fd4-b995-08821e9bd3bc
and
	chat_room_id = 332b9150-04a6-11eb-adc1-0242ac120002;

/*
 * Данный cql запрос обновляет определенную запись в таблице 'non_accepted_chat_rooms' по primary key.
 * Если при обновлении не указать все столбцы, то Cassandra обновит эти столбцы на NULL.
 */
update
	non_accepted_chat_rooms
set
	client_id = 51723324-ae2f-4d30-aaa7-37e6891df474
where
	organization_id = 4a85c9f2-04a5-11eb-adc1-0242ac120002
and
	channel_id = 6fd98405-5058-4fd4-b995-08821e9bd3bc
and
	chat_room_id = 0f723fc0-04a6-11eb-a1a3-a9f81a83bec9;

/*
 * Данный cql запрос возвращает список данных по partition key за определенный период.
 * Операция IN не поддерживается в Amazon Keyspaces.
 * В случае использования оператора 'IN': com.datastax.driver.core.exceptions.InvalidQueryException: IN is not yet supported.
 */
select
	*
from
	non_accepted_chat_rooms
where
	organization_id = 4a85c9f2-04a5-11eb-adc1-0242ac120002
and
	channel_id = 6fd98405-5058-4fd4-b995-08821e9bd3bc
and
	chat_room_id > maxTimeuuid('2020-01-01 00:00:00')
and
	chat_room_id < minTimeuuid('2020-12-31 23:59:59');

/*
 * Таблица была спроектирована, чтобы получить список чат комнат, которые были приняты в работу определенным оператором.
 * Чат комнаты формируются из разных каналов.
 * Оператор должен получить список лишь взятых в работу чат комнат.
 * В качестве partition key были указаны столбцы 'operator_id', 'channel_id'.
 * Это позволяет очень быстро получить список чат комнат взятых в работу определенным оператором из определенного канала.
 * В качестве clustering key был указан столбец 'chat_room_id' c типом данных 'timeuuid'.
 * Это позволит искать данные за определенный период.
 * На сентябрь 2020 года в Amazon Keyspaces отсутствует команда 'CREATE INDEX'.
 * В таблице можно было бы создать столбец 'organization_id' и привязать его к partition key.
 * А столбец 'operator_id' привязать к index.
 * С помощью этой комбинации мы могли бы получать список чат комнат принятых в работу определенной организацией, так и определенным оператором.
 */
create table accepted_chat_rooms (
	operator_id uuid,
	channel_id uuid,
	chat_room_id timeuuid,
	client_id uuid,
	last_message_content text,
	last_message_date_time timestamp,
	unread_messages_number int,
	primary key (
		(
			operator_id,
			channel_id
		),
		chat_room_id
	)
) with clustering order by (
	chat_room_id desc
);

/*
 * Данный cql запрос удаляет таблицу под названием 'accepted_chat_rooms'.
 */
drop table accepted_chat_rooms;


/*
 * Данный cql запрос добавляет запись в таблицу 'accepted_chat_rooms'.
 */
insert into accepted_chat_rooms (
	operator_id,
	channel_id,
	chat_room_id,
	client_id,
	last_message_content,
	last_message_date_time,
	unread_messages_number
) values (
	4a85c9f2-04a5-11eb-adc1-0242ac120002,
	6fd98405-5058-4fd4-b995-08821e9bd3bc,
	now(),
	ca162500-6cd6-4aa3-9e0b-01dd651e541b,
	'Hello!',
	'2020-06-10 18:00:00',
	1
);

/*
 * Данный cql запрос удаляет определенную запись из таблицы 'accepted_chat_rooms' по primary key.
 */
delete from
	accepted_chat_rooms
where
	operator_id = 4a85c9f2-04a5-11eb-adc1-0242ac120002
and
	channel_id = 6fd98405-5058-4fd4-b995-08821e9bd3bc
and
	chat_room_id = 0ae3d5a0-04b4-11eb-904e-1d2bcad05041;

/*
 * Данный cql запрос удаляет определенную запись из таблицы 'accepted_chat_rooms' по primary key.
 * При обновлении записи нужно указывать все столбцы, либо остальные столбцы обнуляться (NULL).
 */
update
	accepted_chat_rooms
set
	last_message_content = 'Почему не поменялось время?'
where
	operator_id = 4a85c9f2-04a5-11eb-adc1-0242ac120002
and
	channel_id = 6fd98405-5058-4fd4-b995-08821e9bd3bc
and
	chat_room_id = 0ae3d5a0-04b4-11eb-904e-1d2bcad05041;


/*
 * Данный cql запрос возвращает список данных по partition key за определенный период.
 * Операция IN не поддерживается в Amazon Keyspaces.
 * В случае использования оператора 'IN': com.datastax.driver.core.exceptions.InvalidQueryException: IN is not yet supported.
 */
select
	*
from
	accepted_chat_rooms
where
	operator_id = 4a85c9f2-04a5-11eb-adc1-0242ac120002
and
	channel_id = 6fd98405-5058-4fd4-b995-08821e9bd3bc
and
	chat_room_id > maxTimeuuid('2020-01-01 00:00:00')
and
	chat_room_id < minTimeuuid('2020-12-31 23:59:59');

/*
 * Таблица была спроектирована, чтобы получить список чат комнат, которые были завершены определенным оператором.
 * Чат комнаты формируются из разных каналов.
 * Оператор должен получить список лишь завершенных им самим чат комнат.
 * В качестве partition key были указаны столбцы 'operator_id', 'channel_id'.
 * Это позволяет очень быстро получить список чат комнат завершенных определенным оператором из определенного канала.
 * В качестве clustering key был указан столбец 'chat_room_id' c типом данных 'timeuuid'.
 * Это позволит искать данные за определенный период.
 * На сентябрь 2020 года в Amazon Keyspaces отсутствует команда 'CREATE INDEX'.
 * В таблице можно было бы создать столбец 'organization_id' и привязать его к partition key.
 * А столбец 'operator_id' привязать к index.
 * С помощью этой комбинации мы могли бы получать список чат комнат завершенной определенной организацией, так и определенным оператором.
 */
create table completed_chat_rooms (
	operator_id uuid,
	channel_id uuid,
	chat_room_id timeuuid,
	client_id uuid,
	last_message_content text,
	last_message_date_time timestamp,
	unread_messages_number int,
	primary key (
		(
			operator_id,
			channel_id
		),
		chat_room_id
	)
) with clustering order by (
	chat_room_id desc
);

/*
 * Данный cql запрос удаляет таблицу под названием 'completed_chat_rooms'.
 */
drop table completed_chat_rooms;


/*
 * Данный cql запрос добавляет запись в таблицу 'completed_chat_rooms'.
 */
insert into completed_chat_rooms (
	operator_id,
	channel_id,
	chat_room_id,
	client_id,
	last_message_content,
	last_message_date_time,
	unread_messages_number
) values (
	4a85c9f2-04a5-11eb-adc1-0242ac120002,
	6fd98405-5058-4fd4-b995-08821e9bd3bc,
	now(),
	ca162500-6cd6-4aa3-9e0b-01dd651e541b,
	'Hello!',
	'2020-06-10 18:00:00',
	1
);

/*
 * Данный cql запрос возвращает список данных по partition key за определенный период.
 * Операция IN не поддерживается в Amazon Keyspaces.
 * В случае использования оператора 'IN': com.datastax.driver.core.exceptions.InvalidQueryException: IN is not yet supported.
 */
select
	*
from
	completed_chat_rooms
where
	operator_id = 4a85c9f2-04a5-11eb-adc1-0242ac120002
and
	channel_id = 6fd98405-5058-4fd4-b995-08821e9bd3bc
and
	chat_room_id > maxTimeuuid('2020-01-01 00:00:00')
and
	chat_room_id < minTimeuuid('2020-12-31 23:59:59');

/*
 * Таблица была спроектирована, чтобы получить список сообщений определенной чат комнаты, где оператор ведет беседу с клиентом.
 * В качестве partition key был указан столбец 'chat_room_id'.
 * Это позволяет очень быстро получить список сообщений определенной чат комнаты.
 * В качестве clustering key был указан столбец 'message_id' c типом данных 'timeuuid'.
 * Это позволит искать данные за определенный период.
 */
create table chat_rooms_messages (
	chat_room_id uuid,
	message_id timeuuid,
	message_author_id uuid,
	message_channel_id uuid,
	message_type varchar,
	message_text text,
	message_content_url text,
	quoted_message_id uuid,
	quoted_message_author_id uuid,
	quoted_message_channel_id uuid,
	quoted_message_type varchar,
	quoted_message_text text,
	quoted_message_content_url text,
	message_is_sent boolean,
	message_is_delivered boolean,
	message_is_read boolean,
	message_created_date_time timestamp,
	message_updated_date_time timestamp,
	message_deleted_date_time timestamp,
	primary key (
		chat_room_id,
		message_id
	)
) with clustering order by (
	message_id desc
);

/*
 * Данный cql запрос удаляет таблицу под названием 'chat_rooms_messages'.
 */
drop table chat_rooms_messages;

/*
 * Данный cql запрос возвращает все сообщения определенной чат комнаты.
 */
select
	*
from
	chat_rooms_messages
where
	chat_room_id = 5d354323-8b47-447e-8bc7-67dae57248b0;

/*
 * Данный cql запрос создает запись в таблице 'chat_rooms_messages'.
 */
insert into chat_rooms_messages (
	chat_room_id,
	message_id,
	message_author_id,
	message_channel_id,
	message_type,
	message_text,
	message_content_url,
	quoted_message_id,
	quoted_message_author_id,
	quoted_message_channel_id,
	quoted_message_type,
	quoted_message_text,
	quoted_message_content_url,
	message_is_sent,
	message_is_delivered,
	message_is_read,
	message_created_date_time,
	message_updated_date_time,
	message_deleted_date_time
) values (
	5d354323-8b47-447e-8bc7-67dae57248b0,
	now(),
	51723324-ae2f-4d30-aaa7-37e6891df474,
	cef46c46-834e-4289-8bcb-c6e3a4c1c213,
	'text',
	'Привет! Ты можешь мне помочь?',
	null,
	2f73bb21-087d-11eb-9b89-b78014c45398,
	ade7dc8d-f754-4436-b2bc-a6433cdc3ded,
	cef46c46-834e-4289-8bcb-c6e3a4c1c213,
	'text',
	'Привет 6!',
	'https://www.imgonline.com.ua/examples/bee-on-daisy.jpg',
	true,
	true,
	true,
	toTimestamp(now()),
	toTimestamp(now()),
	null
);

/*
 * Данный cql запрос возвращает данные по конкретному сообщению.
 */
select
	*
from
	chat_rooms_messages
where
	chat_room_id = 5d354323-8b47-447e-8bc7-67dae57248b0
and
	message_id = 64c6ae42-0a17-11eb-a05a-bf9f3fdc2e73
limit 1;

/*
 * Данные cql запросы позволяет добавить столбцы в таблицу "non_accepted_chat_rooms".
 */
alter table non_accepted_chat_rooms add last_message_content text;
alter table non_accepted_chat_rooms add last_message_date_time timestamp;
alter table non_accepted_chat_rooms add unread_messages_number int;