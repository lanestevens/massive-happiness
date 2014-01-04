-- This file defines the types for the massive-happiness project.

create type mood_summary
       as ( mood_type_id                int
          , mood_type                   varchar(24)
          , count                       bigint
          , early_created               timestamp with time zone
          , late_created                timestamp with time zone
          )
;
