require 'test_helper'

class Api::V1::ScoresControllerTest < ActionDispatch::IntegrationTest
  test 'The First Score goes to first_roll' do
    game = Game.create(name: 'New')

    score = 2

    post api_v1_create_score_path(game_id: game.id), params: { score: score }

    assert_response :created

    body = JSON.parse(response.body).with_indifferent_access
    data = body['data']

    assert_equal data['first_roll'], score
  end

  test 'Two Scores set the total (no Spare)' do
    game = Game.create(name: 'New')

    first_roll = 2
    post api_v1_create_score_path(game_id: game.id), params: { score: first_roll }

    assert_response :created

    second_roll = 3
    post api_v1_create_score_path(game_id: game.id), params: { score: second_roll }

    assert_response :created

    body = JSON.parse(response.body).with_indifferent_access
    data = body['data']

    game.reload

    assert_equal data['first_roll'], first_roll
    assert_equal data['second_roll'], second_roll
    assert_equal data['total'], first_roll + second_roll
    assert_equal game.current_frame_id, game.frames.second.id
  end

  test 'First Score with 10 set the Strike and moves the current_frame' do
    game = Game.create(name: 'New')

    first_roll = 10
    post api_v1_create_score_path(game_id: game.id), params: { score: first_roll }

    assert_response :created

    body = JSON.parse(response.body).with_indifferent_access
    data = body['data']

    game.reload

    assert_equal data['first_roll'], first_roll
    assert_equal data['second_roll'], 0
    assert_equal data['strike'], true
    assert_equal data['spare'], false
    assert_equal data['total'], 10
    assert_equal game.current_frame_id, game.frames.second.id
  end

  test 'Second Score gets a Spare and moves the current_frame' do
    game = Game.create(name: 'New')

    first_roll = 9
    post api_v1_create_score_path(game_id: game.id), params: { score: first_roll }

    assert_response :created

    second_roll = 1
    post api_v1_create_score_path(game_id: game.id), params: { score: second_roll }

    assert_response :created

    body = JSON.parse(response.body).with_indifferent_access
    data = body['data']

    game.reload

    assert_equal data['first_roll'], first_roll
    assert_equal data['second_roll'], second_roll
    assert_equal data['strike'], false
    assert_equal data['spare'], true
    assert_equal data['total'], 10
    assert_equal game.current_frame_id, game.frames.second.id
  end

  test 'The two rolls after a Strike goes to the total of the previous Frame' do
    game = Game.create(name: 'New')

    first_roll = 10
    post api_v1_create_score_path(game_id: game.id), params: { score: first_roll }

    assert_response :created

    game.reload

    first_roll = 3
    post api_v1_create_score_path(game_id: game.id), params: { score: first_roll }

    assert_response :created

    second_roll = 5
    post api_v1_create_score_path(game_id: game.id), params: { score: second_roll }

    assert_response :created

    game.reload

    body = JSON.parse(response.body).with_indifferent_access
    data = body['data']

    assert_equal data['first_roll'], first_roll
    assert_equal data['second_roll'], second_roll
    assert_equal data['strike'], false
    assert_equal data['spare'], false
    assert_equal data['total'], 8
    assert_equal game.current_frame_id, game.frames.third.id
    assert_equal game.frames.first.total, 18
  end

  test 'The next roll after a Spare goes to the total of the previous Frame' do
    game = Game.create(name: 'New')

    first_frame_first_roll = 5
    post api_v1_create_score_path(game_id: game.id), params: { score: first_frame_first_roll }

    assert_response :created

    first_frame_second_roll = 5
    post api_v1_create_score_path(game_id: game.id), params: { score: first_frame_second_roll }

    assert_response :created

    game.reload

    first_frame_second_roll = 5
    post api_v1_create_score_path(game_id: game.id), params: { score: first_frame_second_roll }

    assert_response :created

    second_frame_second_roll = 3
    post api_v1_create_score_path(game_id: game.id), params: { score: second_frame_second_roll }

    assert_response :created

    game.reload

    body = JSON.parse(response.body).with_indifferent_access
    data = body['data']

    assert_equal data['first_roll'], first_frame_second_roll
    assert_equal data['second_roll'], second_frame_second_roll
    assert_equal data['strike'], false
    assert_equal data['spare'], false
    assert_equal data['total'], 8
    assert_equal game.current_frame_id, game.frames.third.id
    assert_equal game.frames.first.total, 15
  end
end