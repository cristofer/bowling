require 'test_helper'

class Api::V1::GamesControllerTest < ActionDispatch::IntegrationTest
  test 'it creates a new Game' do
    name = 'New Name'

    post api_v1_games_create_path, params: { name: name }

    assert_response :created

    body = JSON.parse(response.body)

    assert_equal body['data']['attributes']['name'], name
  end
end
