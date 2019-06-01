module Api
  module V1
    SCORE_NOT_VALID = "Score can not be greater than 10, or negative"
    THE_GAME_HAS_FINISHED = "The Game has finished, you can not score anymore"

    class ScoresController < Base
      swagger_path '/api/v1/games/{game_id}/scores/create' do
        operation :post do
          key :summary, 'It creates a new Score'
          key :description, 'Adds a score to the current Game'
          key :operationId, 'createScore'
          parameter do
            key :name, :game_id
            key :in, :path
            key :description, 'ID of the Game where the score will go'
            key :required, true
            key :type, :uuid
          end
          parameter do
            key :name, :score
            key :in, :query
            key :description, 'Score to be added in the Game'
            key :required, true
            key :type, :int32
          end
          response 200 do
            key :description, 'score response'
            schema do
              key :'$ref', :Frame
            end
          end
          response :default do
            key :description, 'standard error'
          end
        end
      end

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
      rescue GreaterThanTenError => e
        logger.fatal "ERROR: Scores#create: GreaterThanTenError: #{e}"
        render json: json_wrong_total_score, status: :bad_request
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
        raise ScoreError if param_score > 10 ||  param_score.negative?
        param_score
      end

      def param_score
        params[:score].to_i
      end

      def json_record_invalid_error
        { data: { error: SCORE_NOT_VALID } }
      end

      def json_score_can_not_be_empty
        { data: { error: SCORE_NOT_VALID } }
      end

      def json_game_has_finished
        { data: { error: THE_GAME_HAS_FINISHED } }
      end

      def json_wrong_total_score
        { data: { error: 'Both rolls can not add more than 10' } }
      end

      def json_standard_error
        { data: { error: 'There was an internal error, we could not create the Score' } }
      end
    end

    class ScoreError < StandardError
      def message
        SCORE_NOT_VALID
      end
    end

    class GameFinishedError < StandardError
      def message
        THE_GAME_HAS_FINISHED
      end
    end
  end
end
