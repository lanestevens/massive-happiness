-- This file defines the constraints for the massive-happiness project

-- mr:  mood_readings
-- mt:  mood_types

   alter table mood_types
add constraint ht_pk
   primary key (id)
;

   alter table mood_readings
add constraint hr_pk
   primary key (id)
;

   alter table mood_readings
add constraint hr_ht_fk
   foreign key (mood_type_id)
    references mood_types (id)
;
