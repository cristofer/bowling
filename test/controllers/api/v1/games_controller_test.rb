# frozen_string_literal: true

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

    assert_response :error

    body = JSON.parse(response.body)

    assert_equal body['errors'].first, "Name can't be blank"
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

  test 'it gets all the Frames when requesting the status' do
    game = Game.create(name: 'New')

    get api_v1_game_status_path(game_id: game.id)

    assert_response :success

    body = JSON.parse(response.body).with_indifferent_access

    assert_equal body['data']['frames'].size, 11
  end

  test 'it gets the correct data in the frames' do
    game = Game.create(name: 'New')
    first_frame = game.frames.first
    first_frame.first_roll = first_frame.second_roll = 4
    first_frame.save!

    get api_v1_game_status_path(game_id: game.id)

    assert_response :success

    body = JSON.parse(response.body).with_indifferent_access
    first_frame_in_data = body['data']['frames'].first[1]

    assert_equal first_frame_in_data['id'], first_frame.id
    assert_equal first_frame_in_data['first_roll'], first_frame.first_roll
    assert_equal first_frame_in_data['second_roll'], first_frame.second_roll
    assert_equal first_frame_in_data['total'], first_frame.total
    assert_equal first_frame_in_data['strike'], first_frame.strike
    assert_equal first_frame_in_data['spare'], first_frame.spare
  end
end
