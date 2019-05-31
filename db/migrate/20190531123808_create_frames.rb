class CreateFrames < ActiveRecord::Migration[5.2]
  def change
    create_table :frames, id: :uuid do |t|
      t.integer :number
      t.boolean :strike
      t.boolean :spare
      t.integer :first_roll
      t.integer :second_roll
      t.integer :total
      t.references :game, type: :uuid, foreign_key: true

      t.timestamps
    end
  end
end
