module Api
  module V1
    class GamesController < Base
      def create
        render json: serializer.new(create_game), status: :created
      rescue ActiveRecord::RecordInvalid => e
        logger.fatal "ERROR: Games#create RecordInvalid: #{e}"
        render json: json_record_invalid_error, status: :bad_request
      rescue StandardError => e
        logger.fatal "ERROR: Games#create: StandardError: #{e}"
        render json: json_error, status: :internal_server_error
      end

      private

      def create_game
        Game.create!(name: name_param)
      end

      def name_param
        params[:name]
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
