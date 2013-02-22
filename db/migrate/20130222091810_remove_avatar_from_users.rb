class RemoveAvatarFromUsers < ActiveRecord::Migration
  def up
    drop_attached_file :users, :avatar
  end

  def down
    change_table :users do |t|
      t.attachment :avatar
    end
  end
end
