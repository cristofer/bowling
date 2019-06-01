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
    
    current_frame.save!
    current_frame
  end
end
