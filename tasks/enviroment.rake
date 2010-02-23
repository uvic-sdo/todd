task :enviroment do
  ActiveRecord::Base.establish_connection(YAML::load(File.open('db/database.yml')))
  ActiveRecord::Base.logger = Logger.new(File.open('logs/migrations.log', 'a'))
  ActiveRecord::Base.colorize_logging = false
end
