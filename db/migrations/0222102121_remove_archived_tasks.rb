class RemoveArchivedTasks < ActiveRecord::Migration
  def self.up
    drop_table :archived_tasks
  end

  def self.down
    create_table :archived_tasks do |t|
      t.string      :title,       :null => false
      t.text        :notes,       :default => ""
      t.boolean     :running,     :default => false
      t.datetime    :total_time, :default => Time.at(0)
      t.integer     :current_punch

      t.references :category

      t.timestamps
    end
  end
end
