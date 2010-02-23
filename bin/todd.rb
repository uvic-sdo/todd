#!/usr/bin/env ruby

$:.unshift File.dirname(__FILE__) + '/../lib'
require 'rubygems'
require 'commander/import'
require 'todd'

program :version, Todd::VERSION
program :description, "Todd: Time Tracking
  Todd is a simple todo list manager which has been
  developed with developers in mind.  It allows you
  to track how much time you spend on different tasks
  as well as just acting as a dumb task list.
  
  Query System:
    Todd provides a simple query system which you can
    use with most of its commands.  The system reads
    the following queries for selecting tasks:
  
    n         :  select a single task with id = n
    n..m      :  select all tasks with id > n AND id < m
    all       :  select all tasks
    last      :  select the last task
    active    :  select all active tasks
    inactive  :  select all inactive tasks

    The system currently only supports a single query
    (instead of ANDing multiple queries)
"

default_command :list

list = nil  # todd initialized after commands

global_option('-f', '--format FORMAT', 'Set output formatting for this run') { |format|
  Todd::Base.set_formatting format
}

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
alias_command :ls, :list

command :find do |c|
  c.syntax = 'todd find [query]'
  c.summary = 'Find tasks matching query'
  c.description = 'Find all tasks which match the query in the current Todd List'
  c.action do |args, options|
    puts Todd::Util.format_bundle list.bundle(args.shift)
  end
end
alias_command :f, :find

command :add do |c|
  c.syntax = 'todd add [task]'
  c.summary = 'Add a task'
  c.description = 'Add a task to the current Todd List
  [task] can contain a hash-tagged category anywhere if you want
  to place the task in a different category than default'
  c.example 'Add a simple task', 'todd add "Fix Todd version"'
  c.example 'Add a task in category personal', 'todd add "Playing Videogames #personal"'
  c.example 'Add a task in category clients', 'todd add "Working on google.com #clients"'
  c.action do |args, options|
    list.add args.shift
  end
end
alias_command :a, :add

command :remove do |c|
  c.syntax = 'todd remove [query]'
  c.summary = 'Remove tasks'
  c.description = 'Remove all tasks which match the query.'
  c.action do |args, options|
    list.rm args.shift
  end
end
alias_command :rm, :remove

command :start do |c|
  c.syntax = 'todd start [query]'
  c.summary = 'Start tasks'
  c.description = 'Start all tasks which match the query'
  c.action do |args, options|
    list.start args.shift
  end
end
alias_command :s, :start

command :stop do |c|
  c.syntax = 'todd stop [query]'
  c.summary = 'stop tasks'
  c.description = 'stop all tasks which match the query'
  c.action do |args, options|
    list.stop args.shift
  end
end
alias_command :st, :stop

command :archive do |c|
  c.syntax = 'todd archive [query]'
  c.summary = 'Archive tasks'
  c.description = 'Archive all tasks which match the query'
  c.action do |args, options|
    list.archive args.shift
  end
end
alias_command :ar, :archive

command :restore do |c|
  c.syntax = 'todd restore [query]'
  c.summary = 'Restore tasks'
  c.description = 'Restore all archived tasks matched by query'
  c.action do |args, options|
    list.restore args.shift
  end
end
alias_command :r, :restore

command :archived do |c|
  c.syntax = 'todd archived [query]'
  c.summary = 'List archived tasks'
  c.description = 'List all archived tasks which match the query [optional]'
  c.action do |args, options|
    puts Todd::Util.format_bundle list.bundle(args.shift, true)
  end
end
alias_command :arch, :archived

Todd::Base.setup
Todd::DB.initialize_db
list = Todd::DB.get_current_list
