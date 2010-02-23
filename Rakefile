$:.unshift 'lib'

require 'todd'
require 'rubygems'
require 'rake'
require 'highline/import'
require 'echoe'

Echoe.new 'todd', Todd::VERSION do |p|
  p.author = "Carl Sverre"
  p.email = "carl@carlsverre.com"
  p.summary = "A simple time-tracking todo-list for the command line."
  p.url = "http://github.com/carlsverre/todd"
  p.runtime_dependencies << 'commander >=4.0.2'
  p.runtime_dependencies << 'active_record >=2.3.5'
  p.runtime_dependencies << 'terminal_table >=1.4.2'
  p.runtime_dependencies << 'json >=1.2.0'
end 

Dir['tasks/**/*.rake'].sort.each { |f| load f }
