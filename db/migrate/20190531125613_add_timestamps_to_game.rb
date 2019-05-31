class AddTimestampsToGame < ActiveRecord::Migration[5.2]
  def change
    add_timestamps :games
  end
end
