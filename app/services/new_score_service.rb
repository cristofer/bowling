# frozen_string_literal: true

class NewScoreService
  def initialize(game:, score:)
    @game = game
    @score = score
  end

  def call
    setup_score
  end

  private

  def setup_score
    current_frame = Frame.find(@game.current_frame_id)

    if current_frame.first_roll.negative?
      current_frame.first_roll = @score
    else
      current_frame.second_roll = @score
    end

    raise GreaterThanTenError if current_frame.first_roll + current_frame.second_roll > 10

    current_frame.save!
    current_frame
  end
end

class GreaterThanTenError < StandardError
  def message
    'Both rolls can not add more than 10'
  end
end
