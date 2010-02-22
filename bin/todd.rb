#!/usr/bin/env ruby

$:.unshift File.dirname(__FILE__) + '/../lib'
require 'rubygems'
require 'commander/import'
require 'todd'

program :version, Todd::VERSION
program :description, "Todd: Time Tracking"

Todd::initialize_db

default_command :list

command :init do |c|
  c.syntax = 'todd init'
  c.summary = 'Initialize Todd'
  c.description = 'Initialize Todd in the current directory'
  c.action do
    # TODO: Todd init
  end
end

command :add do |c|
  c.syntax = 'todd add [task]'
  c.summary = 'Add a task'
  c.description = 'Add a task to the current Todd List'
  c.action do
    # TODO: Todd add
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
