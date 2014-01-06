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
    %x(initdb --encoding=UTF8 --locale=C #{ENV['PGDATA']} > /dev/null 2>&1)
    %x(mv #{ENV['PGDATA']}/postgresql.conf #{ENV['PGDATA']}/postgresql.conf-original)
    %x(sed -e 's/max_connections = 100/max_connections = 300/g' \
            < #{ENV['PGDATA']}/postgresql.conf-original \
            > #{ENV['PGDATA']}/postgresql.conf)
    %x(pg_ctl -D #{ENV['PGDATA']} -l #{ENV['PGDATA']}/logfile -o "-p #{ENV['PGPORT']}" -w start)
    %x(createdb -p #{ENV['PGPORT']} #{ENV['PGDATABASE']})
    %x(psql -c 'create extension plpythonu' #{ENV['PGDATABASE']})
    # %x(rm -rf .schema .db pgdata)

    puts "exit status: " + $?.exitstatus.to_s

  end

  task :clobber do
    %x(echo "Bring the database down")
    %x(rm .schema .db)
    %x(pg_ctl -D #{ENV['PGDATA']} -m immediate -w stop)
    %x(rm -rf #{ENV['PGDATA']})
    puts "exit status: " + $?.exitstatus.to_s
  end

end