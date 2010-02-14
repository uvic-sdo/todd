require 'rubygems'
require 'active_record'

require 'todd_util'

# Setup Active Record

#ActiveRecord::Base.logger = Logger.new(STDERR)
#ActiveRecord::Base.colorize_logging = true

ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => '/home/carl/dev/todd/todd.db'
)

#ActiveRecord::Schema.define do
#  create_table :todo_lists do |t|
#    t.string      :md5_id,      :null => false
#
#    t.timestamps
#  end
#
#  create_table :categories do |t|
#    t.string      :name,        :null => false
#
#    t.references  :todo_list
#
#    t.timestamps
#  end
#
#  create_table :tasks do |t|
#    t.string      :title,       :null => false
#    t.text        :notes,       :default => ""
#    t.boolean     :running,     :default => false
#    t.datetime    :start_time
#    t.datetime    :total_time,  :default => Time.at(0)
#
#    t.references :category
#
#    t.timestamps
#  end
#
#  create_table :archived_tasks do |t|
#    t.string      :title,       :null => false
#    t.text        :notes,       :default => ""
#    t.boolean     :running,     :default => false
#    t.datetime    :start_time
#    t.datetime    :total_time
#
#    t.references :category
#
#    t.timestamps
#  end
#end

class TodoList < ActiveRecord::Base
  has_many :categories, :dependent => :destroy
  validates_uniqueness_of :md5_id
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
    
    format_str % name
  end

  def visible?
    (tasks.count > 0)
  end
end

class Task < ActiveRecord::Base
  belongs_to :category

  def format_to formatting = :human
    format_str = ""
    case formatting
      when :human
        # sample: [id] [title] [session_time] [total_time]
        format_str = "[%2s] [%-40s] [%11s] [%11s]"
      else
        puts "ERROR: Cannot format Task to #{formatting}"
    end

    format_str % [
      id,
      title,
      (running ? time_period_to_s(session_time) : 'Not Running'),
      (total_time ? time_period_to_s(total_time.to_i) : 'Never Run')
    ]

  end

  def start
    return nil if running
    self[:start_time] = Time.now
    toggle(:running)

    self
  end

  def start!
    return nil if !self.start
    self.save
    self
  end

  def stop
    return nil if !running
    self[:total_time] += (Time.now - start_time)
    self[:start_time] = nil
    toggle(:running)

    self
  end

  def stop!
    return nil if !self.stop
    self.save
    self
  end

  def before_destroy
    ArchivedTask.create(self.clone.attributes)
  end

  def session_time
    return Time.now - start_time if running
    0
  end
end

class ArchivedTask < ActiveRecord::Base
  belongs_to :category

  def restore
    # TODO :: Restore category if needed
    # TODO :: Restore task
  end
end
