class InitializeDatabase < ActiveRecord::Migration
  def self.up
    create_table :todo_lists do |t|
      t.string      :md5_id,      :null => false

      t.timestamps
    end

    create_table :categories do |t|
      t.string      :name,        :null => false

      t.references  :todo_list

      t.timestamps
    end

    create_table :tasks do |t|
      t.string      :title,       :null => false
      t.text        :notes,       :default => ""
      t.boolean     :running,     :default => false
      t.datetime    :start_time
      t.datetime    :total_time,  :default => Time.at(0)

      t.references :category

      t.timestamps
    end

    create_table :archived_tasks do |t|
      t.string      :title,       :null => false
      t.text        :notes,       :default => ""
      t.boolean     :running,     :default => false
      t.datetime    :start_time
      t.datetime    :total_time, :default => Time.at(0)

      t.references :category

      t.timestamps
    end
  end

  def self.down
    drop_table :archived_tasks
    drop_table :tasks
    drop_table :categories
    drop_table :todo_lists
  end
end
