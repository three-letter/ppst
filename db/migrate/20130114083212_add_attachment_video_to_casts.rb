class AddAttachmentVideoToCasts < ActiveRecord::Migration
  def self.up
    change_table :casts do |t|
      t.attachment :video
    end
  end

  def self.down
    drop_attached_file :casts, :video
  end
end
