namespace :massive do
  desc "This is a test rake task"
  task :top do
    sh %(echo "Make Database!")

    #This requires PGPORT, PGDATA, and PGDATABASE to be defined.
    errors = Array.new
    errors.push "ENV['PGPORT'] is not defined" unless ENV['PGPORT']
    errors.push "ENV['PGDATA'] is not defined" unless ENV['PGDATA']
    errors.push "ENV['PGDATABASE'] is not defined" unless ENV['PGDATABASE']

    if errors.length > 0
      errors.each {|error| sh %(echo #{error}) }
      exit 1
    end

    sh %(echo #{ENV['PGPORT']})
    # exit

    #sh %(Database/database.bash)

    cmd = "initdb --encoding=UTF8 --locale=C #{ENV['PGDATA']} > /dev/null 2>&1"

    # puts cmd
    # exit

    # sh %(initdb --encoding=UTF8 --locale=C #{ENV['PGDATA']} > /dev/null 2>&1)
    sh %(initdb --encoding=UTF8 --locale=C #{ENV['PGDATA']})

    sh %(mv #{ENV['PGDATA']}/postgresql.conf #{ENV['PGDATA']}/postgresql.conf-original)
    sh %(sed -e 's/max_connections = 100/max_connections = 300/g' \
            < #{ENV['PGDATA']}/postgresql.conf-original \
            > #{ENV['PGDATA']}/postgresql.conf)
    sh %(pg_ctl -D #{ENV['PGDATA']} -l #{ENV['PGDATA']}/logfile -o "-p #{ENV['PGPORT']}" -w start)
    sh %(createdb -p #{ENV['PGPORT']} #{ENV['PGDATABASE']})
    sh %(psql -c 'create extension plpythonu' #{ENV['PGDATABASE']})
    # sh %(rm -rf .schema .db pgdata)

    sh %(set -e)

    sh %(echo 'Creating types...')
    sh %(psql --quiet --set ON_ERROR_STOP= -f Database/types.sql > /dev/null)

    sh %(echo 'Creating tables...')
    sh %(psql --quiet --set ON_ERROR_STOP= -f Database/tables.sql > /dev/null)

    sh %(echo 'Creating constraints...')
    sh %(psql --quiet --set ON_ERROR_STOP= -f Database/constraints.sql > /dev/null)

    sh %(echo 'Adding views...')
    sh %(psql --quiet --set ON_ERROR_STOP= -f Database/views.sql > /dev/null)

    sh %(echo 'Adding functions...')
    sh %(psql --quiet --set ON_ERROR_STOP= -f Database/functions.sql > /dev/null)

    sh %(echo 'Adding default data...')
    sh %(psql --quiet --set ON_ERROR_STOP= -f Database/default_data.sql > /dev/null)


  end

  task :clobber do
    sh %(echo "Bring the database down")
    # sh %(rm .schema .db)
    sh %(pg_ctl -D #{ENV['PGDATA']}  -w stop)
    sh %(rm -rf #{ENV['PGDATA']})
    puts "exit status: " + $?.exitstatus.to_s
  end

end