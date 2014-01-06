namespace :massive do
  desc "This is a test rake task"
  task :top do
    %x(echo "Make Database!")

    #This requires PGPORT, PGDATA, and PGDATABASE to be defined.
    errors = Array.new
    errors.push "ENV['PGPORT'] is not defined" unless ENV['PGPORT']
    errors.push "ENV['PGDATA'] is not defined" unless ENV['PGDATA']
    errors.push "ENV['PGDATABASE'] is not defined" unless ENV['PGDATABASE']

    if errors.length > 0
      errors.each {|error| %x(echo #{error}) }
      exit 1
    end

    %x(bash Database/database.bash)
    %x(initdb --encoding=UTF8 --locale=C $PGDATA > /dev/null 2>&1)
    %x(mv $PGDATA/postgresql.conf $PGDATA/postgresql.conf-original)
    %x(sed -e 's/max_connections = 100/max_connections = 300/g' \
            < $PGDATA/postgresql.conf-original \
            > $PGDATA/postgresql.conf)
    %x(pg_ctl -D $PGDATA -l $PGDATA/logfile -o "-p $PGPORT" -w start)
    %x(createdb -p $PGPORT $PGDATABASE)
    %x(psql -c 'create extension plpythonu' $PGDATABASE)
    %x(rm -rf .schema .db pgdata)

    puts "exit status: " + $?.exitstatus.to_s

  end

  task :clobber do
    %x(echo "Bring the database down")
    %x(rm .schema .db)
    %x(pg_ctl -D $PGDATA -m immediate -w stop)
    %x(rm -rf $PGDATA)
    puts "exit status: " + $?.exitstatus.to_s
  end

end