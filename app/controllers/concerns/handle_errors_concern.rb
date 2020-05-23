module HandleErrorsConcern
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from GameHasFinishedError, with: :game_has_finished_error
    rescue_from TotalScoreGreaterThanTenError, with: :total_score_greater_than_ten_error
    rescue_from ScoreError, with: :score_validation_error
    rescue_from ActiveRecord::RecordInvalid, with: :json_errors
    rescue_from ArgumentError, with: :format_error

    private

    def record_not_found(e)
      render json: { error: e.message }, status: 404
    end

    def json_errors(record)
      render json: { errors: record.errors.full_messages }, status: 500
    end

    def game_has_finished_error
      render json: { error: 'This game has finished, you can not score anymore' }, status: :bad_request
    end

    def total_score_greater_than_ten_error
      render json: { error: 'The sum of both shots can not be more than 10' }, status: :bad_request
    end

    def score_validation_error(score)
      score_value = Integer(score.message)
      message = score_value.negative? ? "The score can not be negative" : "The score can not be bigger than 10"

      render json: { error: message }, status: :bad_request
    end

    def format_error
      render json: { error: 'The score must be a number between 0 and 10' }, status: :bad_request
    end
  end

  class ScoreError < StandardError
  end

  class GameHasFinishedError < StandardError
  end

  class TotalScoreGreaterThanTenError < StandardError
  end
end
