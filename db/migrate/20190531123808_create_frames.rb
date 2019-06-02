# frozen_string_literal: true

class CreateFrames < ActiveRecord::Migration[5.2]
  def change
    create_table :frames, id: :uuid do |t|
      t.integer :number
      t.boolean :strike, default: false
      t.boolean :spare, default: false
      t.integer :first_roll, default: -1
      t.integer :second_roll, default: -1
      t.integer :total, default: -1
      t.references :game, type: :uuid, foreign_key: true

      t.timestamps
    end
  end
end
