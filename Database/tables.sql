-- Tables for the massive-happiness project

-- mr:  mood_readings
-- mt:  mood_types

create sequence mood_types_id_seq start 1
;
create table mood_types
           ( id                 int not null default nextval('mood_types_id_seq')
           , type               varchar(24)
           )
;

create sequence mood_readings_id_seq start 1
;
create table mood_readings
           ( id                 int not null default nextval('mood_readings_id_seq')
           , mood_type_id       int not null
           , created            timestamp with time zone not null default now()
           )
;
