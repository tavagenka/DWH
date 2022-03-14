

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

drop table  dwh.Fact_Flights

-- справочник дат
CREATE TABLE  dwh.Dim_Calendar
AS
    SELECT dd::date AS dt
    FROM generate_series
            ('2010-01-01'::timestamp
            , '2030-01-01'::timestamp
            , '1 day'::interval) dd


--ALTER TABLE  dwh.Dim_Calendar ADD PRIMARY KEY (id);



create table dwh.Dim_Passengers -- справочник пассажиров
(id int not null primary key,
passenger varchar(100) not null)

create table dwh.Dim_Aircrafts -- справочник самолетов
(id int not null primary key,
aircrafts varchar(100) not null)

create table dwh.Dim_Airports -- справочник аэропортов
(id int not null primary key,
arrival_airport varchar(100) not null)

create table dwh.Dim_Tariff -- справочник тарифов (Эконом/бизнес и тд)
(id int not null primary key,
fare_conditions varchar(50) not null)


create table dwh.Fact_Flights (
id_passenger int not null references dwh.Dim_Passengers(id),
--passenger varchar(50) NOT null,
departure_datetime timestamptz NOT null,
arrival_datetime timestamptz NOT null,
departure_delay interval,
arrival_delay interval,
--aircraft_code bpchar(3) NOT null,
id_aircrafts int not null references dwh.Dim_Aircrafts(id),
--arrival_airport bpchar(3) NOT null,
id_arrival_airport int not null references dwh.Dim_Airports(id),
--fare_conditions varchar(10) NOT null,
id_fare_conditions int not null references dwh.Dim_Tariff(id),
ticket_price float8
);


insert into dwh.Fact_Flights 
(passenger, departure_datetime, arrival_datetime, departure_delay, arrival_delay,
aircraft_code,arrival_airport,fare_conditions,ticket_price)
select 
	passenger_name,
	scheduled_departure, --fact
	scheduled_arrival,
	(scheduled_departure-actual_departure) as delay1,
	(actual_arrival-scheduled_arrival) as delay2,
	aircraft_code,
	arrival_airport,
	fare_conditions,
	amount
from flights f
join ticket_flights tf on tf.flight_id =f.flight_id 
join tickets t on t.ticket_no=tf.ticket_no 

select * from dwh.Fact_Flights 




