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
end
