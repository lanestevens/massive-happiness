-- This file defines the views for the massive-happiness project.

create or replace view formatted_mood_readings
                     ( mood_reading_id
                     , mood_type_id
                     , mood_type
                     , created
                     ) as
                select mr.id as mood_reading_id
                     , mt.id as mood_type_id
                     , mt.type as mood_type
                     , mr.created as created
                  from mood_readings mr
                  join mood_types mt on mt.id = mr.mood_type_id
;

                     
