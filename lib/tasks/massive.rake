namespace :massive do
  require 'yaml'
  desc "Lane DB Tools"

  # tasks setup

  db_config = Rails.application.config.database_configuration[Rails.env]

  # This requires PGPORT, PGDATA, and PGDATABASE to be defined.
  errors = Array.new
  errors.push "Port is not defined" unless db_config['port']
  errors.push "data_dir is not defined" unless db_config['data_dir']
  errors.push "database is not defined" unless db_config['database']

  if errors.length > 0
    errors.each {|error| sh %(echo #{error}) }
    exit 1
  end

  task :up => :environment do
    sh %(echo "Make Database!")

    sh %(initdb --encoding=UTF8 --locale=C #{db_config['data_dir']})
    sh %(mv #{db_config['data_dir']}/postgresql.conf #{db_config['data_dir']}/postgresql.conf-original)
    sh %(sed -e 's/max_connections = 100/max_connections = 300/g' \
            < #{db_config['data_dir']}/postgresql.conf-original \
            > #{db_config['data_dir']}/postgresql.conf)
    sh %(pg_ctl -D #{db_config['data_dir']} -l #{db_config['data_dir']}/logfile -o "-p #{db_config['port']}" -w start)
    sh %(createdb -p #{db_config['port']} #{db_config['database']})
    sh %(psql -c 'create extension plpythonu' #{db_config['database']})

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

    Rake::Task['db:schema:dump']
    Rake::Task['db::seed']
    Rake::Task['db:fixtures:load']

  end



  task :down => :environment do
    sh %(echo "Bring the database down")
    # sh %(rm .schema .db)
    sh %(pg_ctl -D #{db_config['data_dir']}  -w stop)
    sh %(rm -rf #{db_config['data_dir']})
    puts "exit status: " + $?.exitstatus.to_s
  end

end