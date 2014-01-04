-- The default data for the massive-happiness project.

insert into mood_types
          ( id
          , type
          )
     select id
          , type
       from (values (1, 'Disappointed')
                  , (2, 'Sad')
                  , (3, 'Sullen')
                  , (4, 'Excited')
                  , (5, 'Overwhelmed')
                  , (6, 'Angry')
                  , (7, 'Anxious')
                  , (8, 'Massive Happiness')
                  ) as t (id, type)
;
select setval('mood_types_id_seq', max(id), true)
  from mood_types
;
