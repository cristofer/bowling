# frozen_string_literal: true

# == Schema Information
#
# Table name: frames
#
#  id          :uuid             not null, primary key
#  number      :integer
#  strike      :boolean
#  spare       :boolean
#  first_roll  :integer
#  second_roll :integer
#  total       :integer
#  game_id     :uuid
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class FrameTest < ActiveSupport::TestCase
  test 'it has the correct amount of Frames in the DB' do
    assert_equal Frame.count, 2
  end

  test 'it creates a Frame' do
    assert_difference 'Frame.count' do
      Frame.create!(game: games(:one))
    end
  end

  test 'it has the correct game' do
    assert_equal frames(:one).game, games(:one)
  end

  test 'it creates a Frame with the correct values' do
    frame = Frame.new
    frame.game = games(:two)
    frame.first_roll = frame.second_roll = 5
    frame.strike = frame.spare = false
    frame.total = 10

    frame.save!

    last_frame = Frame.last

    assert_equal frame, last_frame
  end

  test 'it creates a Frame with the correct default values' do
    frame = games(:one).frames.create!

    assert_equal frame.first_roll, -1
    assert_equal frame.second_roll, -1
    assert_equal frame.strike, false
    assert_equal frame.spare, false
    assert_equal frame.total, -1
    assert_nil frame.number
    assert_equal frame.game, games(:one)
  end

  test 'it sets the strike to true when first_roll is 10 (spare should be false)' do
    frame_1 = games(:one).frames.first

    frame_1.first_roll = 10
    frame_1.save!

    assert_equal frame_1.strike, true
    assert_equal frame_1.spare, false
    assert_equal frame_1.total, 10
  end

  test 'it sets the spare to true when total is 10 (strike should be false)' do
    frame_1 = games(:one).frames.first

    frame_1.first_roll = 3
    frame_1.second_roll = 7
    frame_1.save!

    assert_equal frame_1.spare, true
    assert_equal frame_1.strike, false
    assert_equal frame_1.total, 10
  end

  test 'it updates total of a striked frame' do
    new_game = Game.create(name: 'New')

    frame_1 = new_game.frames.first
    frame_2 = new_game.frames.second

    frame_1.first_roll = 10
    frame_1.save!

    frame_2.first_roll = 2
    frame_2.second_roll = 3
    frame_2.save!

    assert_equal frame_1.reload.total, 15
  end

  test 'it updates total of a spared frame' do
    new_game = Game.create(name: 'New')

    frame_1 = new_game.frames.first
    frame_2 = new_game.frames.second

    frame_1.first_roll = 5
    frame_1.second_roll = 5
    frame_1.save!

    frame_2.first_roll = 2
    frame_2.second_roll = 3
    frame_2.save!

    assert_equal frame_1.reload.total, 12
  end

  test 'it doesnt update the total of prev frame when no striked or spared' do
    new_game = Game.create(name: 'New')

    frame_1 = new_game.frames.first
    frame_2 = new_game.frames.second

    frame_1.first_roll = 1
    frame_1.second_roll = 2
    frame_1.save!

    frame_2.first_roll = 2
    frame_2.second_roll = 3
    frame_2.save!

    assert_equal frame_1.reload.total, 3
  end

  test 'it sets the total correctly' do
    frame = games(:one).frames.first

    frame.first_roll = 2
    frame.second_roll = 5
    frame.save!

    assert_equal frame.total, 7
  end

  test 'it retries the correct previous_frame' do
    new_game = Game.create(name: 'New')
    frames = new_game.frames

    assert_nil frames.first.previous_frame
    assert_equal frames.second.previous_frame, frames.first
  end

  test 'it retries the correct next_frame' do
    new_game = Game.create(name: 'New')
    frames = new_game.frames

    assert_nil frames.last.next_frame
    assert_equal frames.first.next_frame, frames.second
  end

  # TODO: update the current_frame_id for the game

  test 'it has the correct current_frame_id when game is created' do
    new_game = Game.create(name: 'New')

    assert_equal new_game.current_frame_id, new_game.frames.first.id
  end

  test 'it has the correct current_frame_id when the current_frame is ended' do
    new_game = Game.create(name: 'New')
    first_frame = new_game.frames.first

    first_frame.first_roll = 10
    first_frame.save!

    assert_equal new_game.current_frame_id, new_game.frames.second.id
  end

  test 'it keeps the current_frame_id of the last fram when game is in the last frame' do
    new_game = Game.create(name: 'New')

    last_frame = new_game.frames.last

    new_game.current_frame_id = last_frame.id

    last_frame.first_roll = 10
    last_frame.save!

    assert_equal new_game.current_frame_id, last_frame.id
  end
end
