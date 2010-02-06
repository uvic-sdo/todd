require 'rubygems'
require 'active_record'

# Setup Active Record

ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.colorize_logging = true

ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => '/home/carl/dev/todd/todd.db'
)

ActiveRecord::Schema.define do
  create_table :categories do |t|
    t.string        :name,    :null => false

    t.timestamps
  end

  create_table :tasks do |t|
    t.string      :title,       :null => false
    t.text        :notes,       :default => ""
    t.boolean     :running,     :default => false
    t.datetime    :start_time
    t.datetime    :total_time

    t.references :category

    t.timestamps
  end

  create_table :archived_tasks do |t|
    t.string      :title,       :null => false
    t.text        :notes,       :default => ""
    t.boolean     :running,     :default => false
    t.datetime    :start_time
    t.datetime    :total_time

    t.references :category

    t.timestamps
  end
end

class Category < ActiveRecord::Base
  has_many :tasks, :dependent => :destroy
  has_many :archived_tasks
  validates_uniqueness_of :name

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
end

class Task < ActiveRecord::Base
  belongs_to :category
  validates_uniqueness_of :title

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
    return nil if @running
    @start_time = DateTime.now
    @running = true

    self
  end

  def stop
    return nil if !@running
    @total_time += (DateTime.now - @start_time)
    @start_time = nil
    @running = false

    self
  end

  def before_destroy
    archived_task = ArchivedTask.new do |t|
      t.attributes = @attributes
    end
  end
end

class ArchivedTask < ActiveRecord::Base
  belongs_to :category
  validates_uniqueness_of :title

  def restore
    # TODO :: Restore category if needed
    # TODO :: Restore task
  end
end
