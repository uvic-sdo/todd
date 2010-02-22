#!/usr/bin/env ruby

require 'todd_model'
require 'todd_util'
require 'digest/md5'
require 'pp'

config = {
  :default_db_path  =>  "/home/carl/dev/todd/test.db",
  :config_filename  =>  ".todd",
  :default_category =>  "default",
  :default_config   =>  "todd_hash: %s\n",
  :output_format    =>  "minimal"
}

module Docs
  Short = {
    :init     => ["todd init          ", "Initialize a Todd list in the local directory."],
    :add      => ["todd add <string>  ", "Add an item to the local Todd list."],
    :rm       => ["todd rm <id>       ", "Remove an item from the local todo list."],
    :list     => ["todd list          ", "List all items in all categories."],
    :find     => ["todd find <query>  ", "List all items which match the query."],
    :start    => ["todd start <id>    ", "Start the timer on task with id == <id>."],
    :stop     => ["todd stop <id>     ", "Stop the timer on task with id == <id>."],
    :listd    => ["todd listd         ", "List all deleted tasks."]
  }
end

def docs_for(method)
  puts "%s\t%s" % Docs::Short[method.to_sym]
end

class Todd

  @config = {}

  def initialize(config)
    @config = config
    @todo_list = TodoList.first(:conditions => { :md5_id => @config[:todd_hash] })
  end

  # COMMANDS
  
  def init
    if File.exists?(@config[:config_filename])
      puts "Todd is already initialized in the local directory"
      return
    end

    current_dir = Dir.getwd
    current_dir_md5 = Digest::MD5.hexdigest(current_dir)

    TodoList.create(:md5_id => current_dir_md5)

    File.open(@config[:config_filename], 'w') do |f|
      f.write(sprintf(@config[:default_config],current_dir_md5))
    end

    puts "Initialized Todd in #{current_dir}"
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

    category = @todo_list.categories.find_or_create_by_name(category_name)
    task = category.tasks.create(:title => task_str)
  end

  def rm id
    t = Task.find(id).destroy
  end

  def list
    puts format_bundle @todo_list.bundle, @config[:output_format]
  end

  def find
  end

  def start id
    t = Task.find(id).start!
    puts t ? "Task #{t.id} started" : "Task already running"
  end

  def stop id
    t = Task.find(id).stop!
    puts t ? "Task #{t.id} stopped" : "Task already stopped"
    puts format_bundle t.bundle, @config[:output_format] if t
  end

  def listd
    puts "Not Implemented"
  end

  def restore
    puts "Not Implemented"
  end

  def add_remote
    puts "Not Implemented"
  end

  def sync
    puts "Not Implemented"
  end
end

# Parse the .todd file if it exists

if File.exists? config[:config_filename]
  begin
    conf = YAML.load(File.open(config[:config_filename], 'r').read)
    conf.each { |key, val|
      config[key.to_sym] = val
    } unless conf == nil
  rescue ScriptError=>e
    warn("Error reading #{config[:config_filename]}, you might have an error in your local .todd file")
    puts "Exception Trace:"
    pp e
    exit
  end
else
  unless ARGV.include? "init"
    warn("Error finding #{config[:config_filename]}")
    exit
  end
end

todd = Todd.new(config)

if ARGV.length > 0
  command = ARGV.shift

  break if command == "help"

  begin
    todd.send(command.to_sym, *ARGV)
  rescue ArgumentError => e
    puts e
    pp e.backtrace
    docs_for command
  end

  exit
end

## show help

puts "Usage: todd [OPTION] [ARGS]"

Docs::Short.keys.each do |command|
  docs_for command
end
