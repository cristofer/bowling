# frozen_string_literal: true

module Api
  module V1
    class GamesController < Base
      ## Create

      swagger_path '/api/v1/games/create' do
        operation :post do
          key :summary, 'It initialises a new Game'
          key :description, 'Returns the ID of the new Game created'
          key :operationId, 'createGame'
          parameter do
            key :name, :name
            key :in, :query
            key :description, 'Name of the new Game'
            key :required, true
            key :type, :string
          end
          response 200 do
            key :description, 'game response'
            schema do
              key :'$ref', :Game
            end
          end
          response :default do
            key :description, 'standard error'
          end
        end
      end

      # POST /api/v1/games/create  params: name
      def create
        game = Game.new(name: params[:name])

        if game.save
          render json: GameSerializer.new(game), status: :created
        else
          json_errors(game)
        end
      end

      ## Status

      swagger_path '/api/v1/games/{game_id}/status' do
        operation :get do
          key :summary, 'It retrieves the status of the game'
          key :description, 'Returns if the Game has finished or not, the total score, and all the Frames'
          key :operationId, 'statusGame'
          parameter do
            key :name, :game_id
            key :in, :path
            key :description, 'Id of the Game'
            key :required, true
            key :type, :uuid
          end
          response 200 do
            key :description, 'game response'
          end
          response :default do
            key :description, 'standard error'
          end
        end
      end

      # GET /api/v1/games/:game_id/status
      def status
        game = Game.find(params[:game_id])
        get_status_of_the_game = GameStatusService.new(game).call

        render json: get_status_of_the_game, status: :ok
      end
    end
  end
end
