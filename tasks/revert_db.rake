desc "Revert the DB to a blank slate"
task :revert_db => :enviroment do
  if agree("Are you sure you want to revert the db?  All data will be lost!")
    rm 'db/todd.db'
    Rake::Task[:migrate].execute
  end
end
