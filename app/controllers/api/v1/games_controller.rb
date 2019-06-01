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
        render json: serializer.new(create_game), status: :created
      rescue ActiveRecord::RecordInvalid => e
        logger.fatal "ERROR: Games#create RecordInvalid: #{e}"
        render json: json_record_invalid_error, status: :bad_request
      rescue StandardError => e
        logger.fatal "ERROR: Games#create: StandardError: #{e}"
        render json: json_error, status: :internal_server_error
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
        get_status_of_the_game = GameStatusService.new(game: game).call
        render json: get_status_of_the_game, status: :ok
      rescue ActiveRecord::RecordNotFound => e
        logger.fatal "ERROR: Games#status RecordNotFound: #{e}"
        render json: json_record_not_found, status: :not_found
      rescue StandardError => e
        logger.fatal "ERROR: Games#status Internal Error: #{e}"
        render json: { data: { error: e } }, status: 500
      end

      private

      def create_game
        Game.create!(name: name_param)
      end

      def name_param
        params[:name]
      end

      def json_finished
        { data: { finished: game.finished? } }
      end

      def game
        Game.find(params[:game_id])
      end

      def json_record_not_found
        { data: { error: 'The Game was not found' } }
      end

      def json_record_invalid_error
        { data: { error: 'Name can not be empty' } }
      end

      def json_standard_error
        { data: { error: 'There was an internal error, we could not create the Game' } }
      end

      def serializer
        GameSerializer
      end
    end
  end
end
