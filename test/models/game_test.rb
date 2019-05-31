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
    assert_equal game.current_frame_id, game.frames.first.id
  end

  test 'it creates 10 Frames after creating a Game' do
    assert_difference 'Frame.count', 10 do
      Game.create!(name: 'With 10 Frames')
    end
  end
end
