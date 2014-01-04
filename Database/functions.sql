-- This file defines the functions for the massive-happiness project

create or replace function summarize_moods()
returns setof mood_summary
language sql
immutable
as $$
   select mood_type_id
        , mood_type
        , count(*) as count
        , min(created) as early_created
        , max(created) as late_created
     from formatted_mood_readings
 group by mood_type_id, mood_type
$$
;
