massive-happiness
=================

App to test the viability of engines in the app.


Database
--------

### Overview
The intent of this project is to explore archituctural approaches.
Things that can be explored in this test are:

1. The use of models defined by this gem in other modules/gems.
2. The ability to interact directly with the database via sql
3. The ability to use views
4. The ability to invoke database functions

The initial version of the database defines a type (mood_summary),
two tables (mood_types and mood_readings) including constraints,
foreign key relationships, and sequences, a view
(formatted_mood_readings), and a set-returning function
(summarize_moods).

### Usage
Lane is not familiar with rake, so for round 1, he has created
a Makefile that creates the database and clobbers the database.
This can be migrated to the rake framework.

The database instance is rooted at the sandbox/project root and
is called pgdata.  The database is called happiness, this example
uses the port 55432 per the discussion on Thursday.

To create the database this, the three environment variables
PGDATABASE, PGPORT, and PGDATA are set, and then make is run.
The make command is run from the project root.

```bash
# To create a database instance:
export PGPORT=55432
export PGDATA=$(pwd)/pgdata
export PGDATABASE=happiness
make --directory=Database

# an anternative single command is:
PGPORT=55432 PGDATA=$(pwd)/pgdata PGDATABASE=happiness make --directory Database

# To cleanup/clobber the database instance:
# with the three environment variables set
make --directory Database
# without the three environment variables set:
PGPORT=55432 PGDATA=$(pwd)/pgdata PGDATABASE=happiness make --directory Database clobber
```

# We can now use rake for that:

```
rake massive:up
```
to bring the database up, and
```
rake massive:down
```
to bring the db down.