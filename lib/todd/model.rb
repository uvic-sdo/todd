module Todd

  class DB

    def self.initialize_db
      conf_path = File.dirname(__FILE__) + '/../../db/database.yml'
      ActiveRecord::Base.establish_connection(YAML::load(File.open(conf_path)))
      ActiveRecord::Base.logger = Logger.new(File.open('logs/database.log', 'a'))
      ActiveRecord::Base.colorize_logging = false
    end

    def self.get_current_list
      TodoList.first(:conditions => { :md5_id => Base[:todd_hash] })
    end

    def self.find query, category_ids
      found = []
      case query
        when 'all'
          found = Task.all(:conditions => {:category_id => category_ids})
        when 'last'
          found << Task.first(:conditions => {:category_id => category_ids}, :order => "created_at DESC")
        when 'active', 'running', 'started'
          found = Task.all(:conditions => {:category_id => category_ids, :running => true})
        when 'inactive', 'stopped'
          found = Task.all(:conditions => {:category_id => category_ids, :running => false})
        when /(\d+)\.\.(\d+)/
          found = Task.all(:conditions => {:category_id => category_ids, :id => $1.to_i..$2.to_i})
        when /(\d+)/
          found << Task.find($1.to_i, :conditions => {:category_id => category_ids})
        else
          warn "Invalid query: #{query}"
          exit
      end

      if block_given?
        found.each do |f|
          yield f
        end
      end

      found
    rescue ActiveRecord::RecordNotFound => e
      puts "Query not found"
      pp e
      if block_given?
        yield nil
      end

      []
    end
        
  end

  class TodoList < ActiveRecord::Base
    has_many :categories, :dependent => :destroy
    has_many :tasks, :through => :categories
    validates_uniqueness_of :md5_id

    def category_ids
      return @_category_ids if @_category_ids

      @_category_ids = []
      self.categories.find_each do |cat|
        @_category_ids << cat.id
      end

      @_category_ids
    end

    def bundle query = nil
      bund = {
        :type => :todolist,
        :categories => []
      }
      
      self.categories.each do |cat|
        next unless cat.visible?
        sub_bundle = cat.bundle(query)
        bund[:categories] << sub_bundle unless sub_bundle[:tasks] == []
      end

      bund
    end

    def add task_str
      category_name = Base[:default_category]
      task_str = task_str.sub(/#(\S*)/) do |cat|
        puts "Category: #{$1}"
        category_name = $1
        ""    # this kills the category in the task_str
      end
      task_str.strip!

      puts "Task #{task_str}"

      category = self.categories.find_or_create_by_name(category_name)
      task = category.tasks.create(:title => task_str)
    end

    def rm query
      DB.find(query, category_ids) do |t|
        puts "Removed Task #{t.id}"
        t.destroy
      end
    end

    def start query
      DB.find(query, category_ids) do |t|
        t = t.start!
        puts t ? "Task #{t.id} started" : "Task already running"
      end
    end

    def stop query
      DB.find(query, category_ids) do |t|
        t = t.stop!
        puts t ? "Task #{t.id} stopped" : "Task already stopped"
        puts Util.format_bundle t.bundle if t
      end
    end


  end

  class Category < ActiveRecord::Base
    belongs_to :todo_list
    has_many :tasks, :dependent => :destroy
    has_many :archived_tasks
    validates_uniqueness_of :name

    def bundle query = nil
      bund = {
        :type => :category,
        :name => name,
        :tasks => []
      }
      
      found = (query != nil) ? DB.find(query, [id]) : self.tasks
      found.each do |task|
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
end
