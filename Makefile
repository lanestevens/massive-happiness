# $Id$

BASE_DIR := $(PWD)
export BASE_DIR


ifeq ($(origin PGPORT), undefined)
PGPORT := 55432
endif
export PGPORT

PGDATABASE := happiness
export PGDATABASE
PGDATA := $(BASE_DIR)/pgdata
export PGDATA

SUBDIRS := Database

top: ENV
	set -e;for DD in $(SUBDIRS); do $(MAKE) --directory=$${DD} $@; done

clobber:
	@set -e;\
	REVERSE=""; \
	for DD in $(SUBDIRS); do REVERSE="$${DD} $${REVERSE}"; done; \
	for DD in $${REVERSE}; do $(MAKE) --directory=$${DD} $@; done; \
	$(RM) Sentinels
	$(RM) ENV

ENV:
	@echo "BASE_DIR=$(BASE_DIR)"		>  ENV
	@echo "export BASE_DIR"			>> ENV
	@echo "PGPORT=$(PGPORT)"		>> ENV
	@echo "export PGPORT"			>> ENV
	@echo "PGDATABASE=$(PGDATABASE)"	>> ENV
	@echo "export PGDATABASE"		>> ENV
	@echo "PGDATA=$(PGDATA)"		>> ENV
	@echo "export PGDATA"			>> ENV

UNSETENV:
	@echo "run the following: unset BASE_DIR PGPORT PGDATABASE PGDATA"

