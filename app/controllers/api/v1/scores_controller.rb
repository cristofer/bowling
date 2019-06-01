module Api
  module V1
    SCORE_CAN_NOT_BE_EMPTY = "Score can not be empty"
    THE_GAME_HAS_FINISHED = "The Game has finished, you can not score anymore"

    class ScoresController < Base
      # POST /api/v1/games/:game_id/scores/create  params: name
      def create
        check_game_finished

        new_score = NewScoreService.new(game: game, score: score).call

        render json: { data: new_score }, status: :created
      rescue ScoreError => e
        logger.fatal "ERROR: Scores#create: ScoreError: #{e}"
        render json: json_score_can_not_be_empty, status: :bad_request
      rescue GameFinishedError => e
        logger.fatal "ERROR: Scores#create: GameFinishedError: #{e}"
        render json: json_game_has_finished, status: :bad_request
      rescue StandardError => e
        logger.fatal "ERROR: Scores#create: StandardError: #{e}"
        render json: json_standard_error, status: :internal_server_error
      end

      private

      def check_game_finished
        raise GameFinishedError if game.finished?
      end

      def game
        Game.find(params[:game_id])
      end

      def score
        raise ScoreError if params[:score].blank?
        params[:score]
      end

      def json_record_invalid_error
        { data: { error: SCORE_CAN_NOT_BE_EMPTY } }
      end

      def json_score_can_not_be_empty
        { data: { error: SCORE_CAN_NOT_BE_EMPTY } }
      end

      def json_game_has_finished
        { data: { error: THE_GAME_HAS_FINISHED } }
      end

      def json_standard_error
        { data: { error: 'There was an internal error, we could not create the Score' } }
      end
    end

    class ScoreError < StandardError
      def message
        SCORE_CAN_NOT_BE_EMPTY
      end
    end

    class GameFinishedError < StandardError
      def message
        THE_GAME_HAS_FINISHED
      end
    end
  end
end
