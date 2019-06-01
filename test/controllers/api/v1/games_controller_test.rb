require 'test_helper'

class Api::V1::GamesControllerTest < ActionDispatch::IntegrationTest
  test 'it creates a new Game with a valid name' do
    name = 'New Name'

    post api_v1_games_create_path, params: { name: name }

    assert_response :created

    body = JSON.parse(response.body)

    assert_equal body['data']['attributes']['name'], name
  end

  test 'it does not create a new Game when name is empty' do
    post api_v1_games_create_path, params: { name: '' }

    assert_response :bad_request

    body = JSON.parse(response.body)

    assert_equal body['data']['error'], 'Name can not be empty'
  end

  test 'it gets the correct status when Game has not finished' do
    game = Game.create(name: 'New')

    get api_v1_game_status_path(game_id: game.id)

    assert_response :success

    body = JSON.parse(response.body).with_indifferent_access

    assert_equal body['data']['finished'], false
  end

  test 'it gets the correct status when Game has finished' do
    game = Game.create(name: 'New')

    last_frame = game.frames.last
    prev_last_frame = last_frame.previous_frame
    game.current_frame_id = last_frame.id

    prev_last_frame.first_roll = 3
    prev_last_frame.second_roll = 3
    prev_last_frame.save!
    game.save!

    get api_v1_game_status_path(game_id: game.id)

    assert_response :success

    body = JSON.parse(response.body).with_indifferent_access

    assert_equal body['data']['finished'], true
  end
end