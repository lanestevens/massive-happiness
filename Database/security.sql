-- Defines security of dataase objects.

revoke all privileges on sequence mood_types_id_seq from public
;
grant all privileges on sequence mood_types_id_seq to full_access
;
revoke all privileges on table mood_types from public
;
grant all privileges on table mood_types to full_access
;
grant select on table mood_types to limited_access
;
revoke all privileges on sequence mood_readings_id_seq from public
;
grant all privileges on sequence mood_readings_id_seq to full_access
;
revoke all privileges on table mood_readings from public
;
grant all privileges on table mood_readings to full_access
;
grant select on table mood_readings to limited_access
;
revoke all privileges on table formatted_mood_readings from public
;
grant all privileges on table formatted_mood_readings to full_access
;
grant select on table formatted_mood_readings to limited_access
;
revoke all privileges on function summarize_moods() from public
;
grant all privileges on function summarize_moods() to full_access
;
grant execute on function summarize_moods() to limited_access
;
