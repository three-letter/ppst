class AddUrlToCast < ActiveRecord::Migration
  def change
    add_column :casts, :url, :string
  end
end
