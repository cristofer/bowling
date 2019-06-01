module Api
  module V1
    class ScoresController < Base
      # POST /api/v1/games/:game_id/scores/create  params: name
      def create
        # TODO: to check if the game is finished

        new_score = NewScoreService.new(game: game, score: params[:score]).call

        render json: { data: new_score }, status: :created
      rescue ActiveRecord::RecordInvalid => e
        logger.fatal "ERROR: Scores#create RecordInvalid: #{e}"
        render json: json_record_invalid_error, status: :bad_request
      rescue StandardError => e
        logger.fatal "ERROR: Scores#create: StandardError: #{e}"
        render json: json_standard_error, status: :internal_server_error
      end

      private

      def create_game
        Game.create!(name: name_param)
      end

      def name_param
        params[:name]
      end

      def game
        Game.find(params[:game_id])
      end

      def json_record_invalid_error
        { data: { error: 'Score can not be empty' } }
      end

      def json_standard_error
        { data: { error: 'There was an internal error, we could not create the Score' } }
      end
    end
  end
end
