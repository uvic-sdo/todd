require 'rubygems'
require 'active_record'
require 'highline/import'

task :migrate => :enviroment do
  ActiveRecord::Migrator.migrate('migrations', nil)
end

task :enviroment do
  ActiveRecord::Base.establish_connection(YAML::load(File.open('database.yml')))
  ActiveRecord::Base.logger = Logger.new(File.open('logs/migrations.log', 'a'))
  ActiveRecord::Base.colorize_logging = false
end

task :migration do
  migration_name = ask("Migration Name (Uppercase+Spaces):  ")
  klass_name = migration_name.gsub(/\s/, '')
  file_name = migration_name.downcase.gsub(/\s/, '_')
  File.open(Time.now.strftime("migrations/%m%d%y%H%M_#{file_name}.rb"), 'w') do |file|
    file.write(<<-eos)
class #{klass_name} < ActiveRecord::Migration
  def self.up
  end

  def self.down
  end
end
    eos
  end
end
