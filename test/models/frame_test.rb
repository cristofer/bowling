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
end
