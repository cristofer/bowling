class AddDefaultsToFrame < ActiveRecord::Migration[5.2]
  def change
    change_column_default :frames, :strike, false
    change_column_default :frames, :spare, false
    change_column_default :frames, :first_roll, 0
    change_column_default :frames, :second_roll, 0
    change_column_default :frames, :total, 0
  end
end
