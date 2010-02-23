#!/usr/bin/env ruby

$:.unshift File.dirname(__FILE__) + '/../lib'
require 'rubygems'
require 'commander/import'
require 'todd'

program :version, Todd::VERSION
program :description, "Todd: Time Tracking"

Todd::Base.setup
Todd::DB.initialize_db
list = Todd::DB.get_current_list

default_command :help

command :init do |c|
  c.syntax = 'todd init'
  c.summary = 'Initialize Todd'
  c.description = 'Initialize Todd in the current directory'
  c.action do |args, options|
    Todd::Base.init_local_dir
  end
end

command :list do |c|
  c.syntax = 'todd list'
  c.summary = 'List all tasks'
  c.description = 'List all the tasks in the current Todd List'
  c.action do |args, options|
    puts Todd::Util.format_bundle list.bundle
  end
end

command :find do |c|
  c.syntax = 'todd find [query]'
  c.summary = 'Find tasks matching query'
  c.description = 'Find all tasks which match the query in the current Todd List'
  c.action do |args, options|
    puts Todd::Util.format_bundle list.bundle args.shift
  end
end

command :add do |c|
  c.syntax = 'todd add [task]'
  c.summary = 'Add a task'
  c.description = 'Add a task to the current Todd List'
  c.action do |args, options|
    list.add args.shift
  end
end

command :rm do |c|
  c.syntax = 'todd rm [query]'
  c.summary = 'Remove tasks'
  c.description = 'Remove all tasks which match the query'
  c.action do |args, options|
    list.rm args.shift
  end
end

=begin tasks to add
    :init     => ["todd init          ", "Initialize a Todd list in the local directory."],
    :add      => ["todd add <string>  ", "Add an item to the local Todd list."],
    :rm       => ["todd rm <id>       ", "Remove an item from the local todo list."],
    :list     => ["todd list          ", "List all items in all categories."],
    :find     => ["todd find <query>  ", "List all items which match the query."],
    :start    => ["todd start <id>    ", "Start the timer on task with id == <id>."],
    :stop     => ["todd stop <id>     ", "Stop the timer on task with id == <id>."],
    :listd    => ["todd listd         ", "List all deleted tasks."]
=end
