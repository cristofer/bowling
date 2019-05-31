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
end
