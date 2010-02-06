require 'todd_model'
require 'todd_util'
require 'digest/md5'

config = {
  :default_db_path  =>  "/home/carl/dev/todd/test.db",
  :config_filename  =>  ".todd",
  :default_category =>  "default",
  :default_config   =>  "conf = {\n  :todd_hash      =>  '%s'\n}",
  :output_format    =>  :human      #:human -> human readable output
}

module Docs
  Short = {
    :init  => ["todd init        ", "Initialize a Todd list in the local directory."],
    :add   => ["todd add <string>", "Add an item to the local Todd list."],
    :rm    => ["todd rm <id>     ", "Remove an item from the local todo list."],
    :list  => ["todd list        ", "List all items in all categories."],
    :find  => ["todd find <query>", "List all items which match the query."],
    :start => ["todd start <id>  ", "Start the timer on task with id == <id>."],
    :stop  => ["todd stop <id>   ", "Stop the timer on task with id == <id>."]
  }
end

def docs_for(method)
  puts "%s\t%s" % Docs::Short[method.to_sym]
end

class Todd

  @config = {}

  def initialize(config)
    @config = config
  end

  # COMMANDS
  
  def init
    current_dir = Dir.getwd
    current_dir_md5 = Digest::MD5.hexdigest(current_dir)

    File.open(@config[:config_filename], 'w') do |f|
      f.write(sprintf(@config[:default_config],current_dir_md5))
    end

    p "Initialized Todd in #{current_dir}"
  end

  def add task_str
    category_name = @config[:default_category]
    task_str = task_str.sub(/#(\S*)/) do |cat|
      puts "Cat name: #{$1}"
      category_name = $1
      ""
    end
    task_str.strip!

    puts "Task: #{task_str}"

    begin
      category = Category.get!(:name => category_name)
      category.save
    rescue DataMapper::ObjectNotFoundError => e
      category = Category.new(:name => category_name)
      category.save
    end

    task = category.tasks.new(:title => task_str)
    task.save
  end

  def rm
  end

  def list
    Category.all.each do |cat|
      if cat.name != @config[:default_category]
        puts cat.format_to @config[:output_format]
      end

      cat.tasks.all.each do |task|
        puts task.format_to @config[:output_format]
      end

      print "\n"
    end
  end

  def find
  end

  def start id
    t = Task.get(id).start
    puts t ? "Task #{t.id} started" : "Task already running"
  end

  def stop id
    t = Task.get(id).stop
    puts t ? "Task #{t.id} stopped" : "Task already stopped"
    puts time_period_to_s t.total_time if t
  end

  def add_remote
    p "Not Implemented"
  end

  def sync
    p "Not Implemented"
  end
end

# Parse the .todd file if it exists
conf = nil
begin
  eval File.open(config[:config_filename], 'r').read
  config = conf.merge(config) unless conf == nil
rescue ScriptError=>e
  warn("Error reading #{config_filename}, you must run todd init to use todd")
end

todd = Todd.new(config)

setup_db config[:default_db_path]

if ARGV.length > 0
  command = ARGV.shift

  break if command == "help"

  begin
    todd.send(command.to_sym, *ARGV)
  rescue ArgumentError => e
    docs_for command
  end

  exit
end

## show help

puts "Usage: todd [OPTION] [ARGS]"

Docs::Short.keys.each do |command|
  docs_for key
end
