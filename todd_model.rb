require 'rubygems'
require 'dm-core'
require 'dm-validations'
require 'dm-timestamps'

# Setup DataMapper

def setup_db path = '/home/carl/dev/todd/test.db', adapter = 'sqlite3'
  DataMapper.setup(:default, adapter + '://' + path)
  begin
    File::Stat.new(path)
  rescue 
    DataMapper.auto_migrate!
  end
end

class Category
  include DataMapper::Resource

  def format_to formatting = :human
    format_str = ""
    case formatting
      when :human
        format_str = "Category: %s"
      else
        puts "ERROR: Cannot format Category to #{formatting}"
    end
    
    format_str % @name

  end

  # SQL Schema
  property :id,           Serial
  property :name,         String,     :required => true
  property :created_at,   DateTime
  property :updated_at,   DateTime

  has n, :tasks

  validates_is_unique :name
end

class Task
  include DataMapper::Resource

  def format_to formatting = :human
    format_str = ""
    case formatting
      when :human
        format_str = "[%2s] [%-60s] [%11s]"
      else
        puts "ERROR: Cannot format Task to #{formatting}"
    end
    
    format_str % [@id, @title, (@running ? DateTime.now - @start_time : 'Not Running')]

  end

  def start
    return false if @running
    @start_time = Time.now
    @running = true

    return self
  end

  def stop
    return false if !@running
    @total_time += (Time.now - @start_time)
    @start_time = nil
    @running = false

    return self
  end

  # SQL Schema
  property :id,           Serial
  property :title,        String,     :required => true
  property :notes,        Text,       :default => ""
  property :running,      Boolean,    :default => false
  property :start_time,   Time
  property :total_time,   Time,       :default => Time.at(0)
  property :created_at,   DateTime
  property :updated_at,   DateTime
  property :deleted,      ParanoidBoolean
  property :deleted_at,   ParanoidDateTime
  
  belongs_to :category
end

