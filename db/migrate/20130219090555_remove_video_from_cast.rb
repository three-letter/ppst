class RemoveVideoFromCast < ActiveRecord::Migration
  def up
    drop_attached_file :casts, :video
  end

  def down
    change_table :casts do |t|
      t.attachment :video
    end
  end
end
