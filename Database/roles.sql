-- This file defines the roles

-- permissive roles
create role full_access
;
create role limited_access
;


-- login roles
create role full_user with login encrypted password 'full_user'
;
grant full_access to full_user
;

create role limited_user with login encrypted password 'limited_user'
;
grant limited_access to limited_user
;
