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
    assert_difference 'Frame.count', 10 do
      Game.create!(name: 'With 10 Frames')
    end

    assert_equal Game.last.frames.count, 10
  end

  test 'The Game is created with the correct current_frame_id' do
    game = Game.create!(name: 'Name')

    assert_equal game.current_frame_id, game.frames.first.id
  end

  test 'it gets the finished status of the Game' do
    game = Game.create!(name: 'Name')

    last_frame = game.frames.last

    last_frame.first_roll = 10
    last_frame.save!

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
