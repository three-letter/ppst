class CreateCasts < ActiveRecord::Migration
  def change
    create_table :casts do |t|
      t.integer :user_id
      t.string :title,  :limit => 32
      t.integer :price
      t.integer :free_time

      t.timestamps
    end
  end
end
