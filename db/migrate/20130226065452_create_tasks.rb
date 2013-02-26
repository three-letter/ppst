class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :user_id
      t.string :info
      t.integer :status

      t.timestamps
    end
  end
end
