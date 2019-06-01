# == Schema Information
#
# Table name: games
#
#  id         :uuid             not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test 'Name can not be blank' do
    assert_raise ActiveRecord::RecordInvalid do
      Game.create!
    end
  end

  test 'The Game is created with the corresponding Name' do
    assert_difference 'Game.count' do
      Game.create!(name: 'Game Test')
    end

    name = 'New One'
    game = Game.create!(name: name)

    assert_equal game.name, name
  end

  test 'it creates 10 Frames after creating a Game' do
    assert_difference 'Frame.count', 11 do
      Game.create!(name: 'With 11 Frames')
    end

    assert_equal Game.last.frames.count, 11
  end

  test 'The Game is created with the correct current_frame_id' do
    game = Game.create!(name: 'Name')

    assert_equal game.current_frame_id, game.frames.first.id
  end

  test 'it gets the finished status true when 10th was strike' do
    game = Game.create!(name: 'Name')

    last_frame = game.frames.last
    game.current_frame_id = last_frame.id
    game.save!

    prev_last_frame = last_frame.previous_frame

    prev_last_frame.first_roll = 10
    prev_last_frame.save!

    last_frame.first_roll = 2
    last_frame.second_roll = 2
    last_frame.save!

    assert_equal game.finished?, true
  end

  test 'it gets the finished status true when 10th was spare' do
    game = Game.create!(name: 'Name')

    last_frame = game.frames.last
    game.current_frame_id = last_frame.id
    game.save!

    prev_last_frame = last_frame.previous_frame

    prev_last_frame.first_roll = 3
    prev_last_frame.second_roll = 7
    prev_last_frame.save!

    last_frame.first_roll = 2
    last_frame.save!

    assert_equal game.finished?, true
  end

  test 'it gets the finished status true when 10th was neither strike nor spare but played' do
    game = Game.create!(name: 'Name')

    last_frame = game.frames.last
    game.current_frame_id = last_frame.id
    game.save!

    prev_last_frame = last_frame.previous_frame

    prev_last_frame.first_roll = 3
    prev_last_frame.second_roll = 3
    prev_last_frame.save!

    assert_equal game.finished?, true
  end

  test 'Game has not finished yet' do
    game = Game.create!(name: 'Name')

    first_frame = game.frames.first

    first_frame.first_roll = 10
    first_frame.save!

    assert_equal game.finished?, false
  end
end
