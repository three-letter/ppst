class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.integer :cast_id
      t.string :content, :limit => 128

      t.timestamps
    end
  end
end
