module Api
  module V1
    class GamesController < Base
      def create
        render json: serializer.new(create_game), status: :created
      rescue StandardError => e
        logger.fatal "ERROR: Games#create: #{e}"
        render json: json_error, status: 500 # conflict
      end

      private

      def create_game
        Game.create!(name: name_param)
      end

      def name_param
        params[:name]
      end

      def json_error
        { data: { error: 'There was an internal error, we could not create the Game' } }
      end

      def serializer
        GameSerializer
      end
    end
  end
end
