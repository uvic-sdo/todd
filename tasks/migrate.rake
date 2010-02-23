desc "Migrate the DB file to the latest migration.  Will create the DB file if it does not exist."
task :migrate => :enviroment do
  ActiveRecord::Migrator.migrate('db/migrations',nil)
end
