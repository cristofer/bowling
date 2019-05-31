class AddCurrentFrameIdToGame < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :current_frame_id, :uuid, references: :frames
  end
end
