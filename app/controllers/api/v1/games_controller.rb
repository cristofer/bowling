module Api
  module V1
    class GamesController < Base
      # POST /api/v1/games/:game_id/scores/create  params: name
      def create
        render json: serializer.new(create_game), status: :created
      rescue ActiveRecord::RecordInvalid => e
        logger.fatal "ERROR: Games#create RecordInvalid: #{e}"
        render json: json_record_invalid_error, status: :bad_request
      rescue StandardError => e
        logger.fatal "ERROR: Games#create: StandardError: #{e}"
        render json: json_error, status: :internal_server_error
      end

      # GET /api/v1/games/:game_id/status
      def status
        render json: json_finished, status: :ok
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
