#This requires PGPORT, PGDATA, and PGDATABASE to be defined.

ifeq ($(origin PGPORT), undefined)
$(error PGPORT is not defined)
endif

ifeq ($(origin PGDATA), undefined)
$(error PGDATA is not defined)
endif

ifeq ($(origin PGDATABASE), undefined)
$(error PGDATABASE is not defined)
endif

top: .schema

.schema:  .db
	$(SHELL) database.bash
	touch $@

.db:
	initdb --encoding=UTF8 --locale=C $(PGDATA) > /dev/null 2>&1
	mv $(PGDATA)/postgresql.conf $(PGDATA)/postgresql.conf-original
	sed -e 's/max_connections = 100/max_connections = 300/g' \
	    < $(PGDATA)/postgresql.conf-original \
            > $(PGDATA)/postgresql.conf
	pg_ctl -D $(PGDATA) -l $(PGDATA)/logfile -o "-p $(PGPORT)" -w start
	createdb -p $(PGPORT) $(PGDATABASE)
	psql -c 'create extension plpythonu' $(PGDATABASE)
	touch $@

clobber: 
	-$(RM) .schema
	-$(RM) .db
	-pg_ctl -D $(PGDATA) -m immediate -w stop
	-$(RM) -rf $(PGDATA)
