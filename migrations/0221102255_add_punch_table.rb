class AddPunchTable < ActiveRecord::Migration
  def self.up
    create_table :punches do |t|
      t.boolean     :running,   :default => false
      t.datetime    :start
      t.datetime    :stop

      t.references  :task
    end

    remove_column :tasks, :start_time
    add_column    :tasks, :current_punch, :integer

  end

  def self.down
    drop_table :punches

    add_column    :tasks, :start_time, :boolean
    remove_column :tasks, :current_punch

  end
end
