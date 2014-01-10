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
    sh %(mv #{db_config['data_dir']}/pg_hba.conf #{db_config['data_dir']}/pg_hba.conf-original)
    sh %(sed -e 's/^local/\#local/g' -e 's/^host/\#host/g' \
             < #{db_config['data_dir']}/pg_hba.conf-original \
             > #{db_config['data_dir']}/pg_hba.conf)
    sh %(echo "local   all             $USER                                     trust" >> #{db_config['data_dir']}/pg_hba.conf)
    sh %(echo "host    all             $USER             127.0.0.1/32            trust" >> #{db_config['data_dir']}/pg_hba.conf)
    sh %(echo "local   all             all                                       md5" >> #{db_config['data_dir']}/pg_hba.conf)
    sh %(echo "host    all             all               127.0.0.1/32            md5" >> #{db_config['data_dir']}/pg_hba.conf)
    
    sh %(pg_ctl -D #{db_config['data_dir']} -l #{db_config['data_dir']}/logfile -o "-p #{db_config['port']}" -w start)
    sh %(createdb -p #{db_config['port']} #{db_config['database']})
    sh %(psql -p #{db_config['port']} -c 'create extension plpythonu' #{db_config['database']})

    sh %(set -e)

    sh %(echo 'Creating roles...')
    sh %(psql -p #{db_config['port']} --quiet --set ON_ERROR_STOP= -f Database/roles.sql #{db_config['database']} > /dev/null)
    
    sh %(echo 'Creating types...')
    sh %(psql -p #{db_config['port']} --quiet --set ON_ERROR_STOP= -f Database/types.sql #{db_config['database']} > /dev/null)

    sh %(echo 'Creating tables...')
    sh %(psql -p #{db_config['port']} --quiet --set ON_ERROR_STOP= -f Database/tables.sql #{db_config['database']} > /dev/null)

    sh %(echo 'Creating constraints...')
    sh %(psql -p #{db_config['port']} --quiet --set ON_ERROR_STOP= -f Database/constraints.sql #{db_config['database']} > /dev/null)

    sh %(echo 'Adding views...')
    sh %(psql -p #{db_config['port']} --quiet --set ON_ERROR_STOP= -f Database/views.sql #{db_config['database']} > /dev/null)

    sh %(echo 'Adding functions...')
    sh %(psql -p #{db_config['port']} --quiet --set ON_ERROR_STOP= -f Database/functions.sql #{db_config['database']} > /dev/null)

    sh %(echo 'Granting permissions...')
    sh %(psql -p #{db_config['port']} --quiet --set ON_ERROR_STOP= -f Database/security.sql #{db_config['database']} > /dev/null)

    sh %(echo 'Adding default data...')
    sh %(psql -p #{db_config['port']} --quiet --set ON_ERROR_STOP= -f Database/default_data.sql #{db_config['database']} > /dev/null)

    #Rake::Task['db:schema:dump']
    #Rake::Task['db::seed']
    #Rake::Task['db:fixtures:load']

  end



  task :down => :environment do
    sh %(echo "Bring the database down")
    # sh %(rm .schema .db)
    sh %(pg_ctl -D #{db_config['data_dir']}  -w stop)
    sh %(rm -rf #{db_config['data_dir']})
    puts "exit status: " + $?.exitstatus.to_s
  end

end