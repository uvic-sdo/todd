desc "Create a new migration file in db/migrations"
task :migration do
  migration_name = ask("Migration Name (Uppercase+Spaces):  ")
  klass_name = migration_name.gsub(/\s/, '')
  file_name = migration_name.downcase.gsub(/\s/, '_')
  File.open(Time.now.strftime("db/migrations/%m%d%y%H%M_#{file_name}.rb"), 'w') do |file|
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
