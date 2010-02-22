require 'rubygems'
require 'active_record'

require 'todd_util'

# Setup Active Record

ActiveRecord::Base.establish_connection(YAML::load(File.open('database.yml')))
ActiveRecord::Base.logger = Logger.new(File.open('logs/database.log', 'a'))
ActiveRecord::Base.colorize_logging = false

class TodoList < ActiveRecord::Base
  has_many :categories, :dependent => :destroy
  validates_uniqueness_of :md5_id

  def bundle
    bund = {
      :type => :todolist,
      :categories => []
    }
    
    self.categories.each do |cat|
      next unless cat.visible?
      bund[:categories] << cat.bundle
    end

    bund
  end
end

class Category < ActiveRecord::Base
  has_many :tasks, :dependent => :destroy
  has_many :archived_tasks
  validates_uniqueness_of :name

  def bundle
    bund = {
      :type => :category,
      :name => name,
      :tasks => []
    }
    
    self.tasks.each do |task|
      bund[:tasks] << task.bundle
    end

    bund
  end

  def visible?
    (tasks.count > 0)
  end
end

class Task < ActiveRecord::Base
  belongs_to :category

  def bundle
    {
      :type => :task,
      :id => id,
      :title => title,
      :active => running,
      :session_time => session_time,
      :total_time => total_time
    }
  end

  def start!
    return nil if running

    punch = Punch.new
    punch.clock_in!

    self[:current_punch] = punch.id
    toggle(:running)

    self.save

    self
  end

  def stop!
    return nil if !running

    punch = Punch.find(current_punch)
    session_time = punch.clock_out!

    self[:total_time] += session_time if session_time
    toggle(:running)

    self.save

    self
  end

  def before_destroy
    ArchivedTask.create(self.clone.attributes)
  end

  def session_time
    running ? Punch.find(current_punch).session_time : 0
  end
end

class Punch < ActiveRecord::Base
  belongs_to :task

  def clock_in!
    return false if running
    self[:start] = Time.now
    toggle(:running)

    self.save
    
    true
  end

  def clock_out!
    return nil unless running
    self[:stop] = Time.now
    toggle(:running)

    self.save

    session_time
  end

  def session_time
    running ? (Time.now - start) : (stop - start)
  end
end

class ArchivedTask < ActiveRecord::Base
  belongs_to :category

  def restore
    # TODO :: Restore category if needed
    # TODO :: Restore task
  end
end
