class AddArchivedColumnToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :archived, :boolean, :default => false
    
    Todd::Task.reset_column_information
    Todd::Task.find_each do |t|
      t.archived = false
      t.save
    end
  end

  def self.down
    remove_column :tasks, :archived
  end
end
