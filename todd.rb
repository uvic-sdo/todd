require 'todd_model'

class Todd
  def initialize(config)
    @todd_hash = config[:list_hash]
  end

  # COMMANDS
  
  def init
  end

  def add_remote
    p "Not Implemented"
  end

  def sync
    p "Not Implemented"
  end

  def add
  end

  def rm
  end

  def list
  end

  def find
  end

  def start
  end

  # stop <id>
  def stop id
    p id
  end
end

# Parse the .todd file if it exists
# Adds the Conf hash to the global namespace for now
begin
  eval file.new(".todd").read
rescue ScriptError=>e
  warn("An error occured while reading ./.todd",e)
end

return if Conf.nil?

todd = Todd.new(Conf)

ARGV.each do |a|
  puts "Argument: #{a}"
  todd.method(a.intern).call()
end
