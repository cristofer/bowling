class AddIndexesToGameFrame < ActiveRecord::Migration[5.2]
  def change
    add_index :games, :created_at
    add_index :frames, :created_at
  end
end
