# frozen_string_literal: true

class NewScoreService
  attr_reader :game, :new_score, :score

  def initialize(game:, score:)
    @game = game
    @score = score
    @new_score = nil
  end

  def call
    raise HandleErrorsConcern::ScoreError, score if score.negative? || score > 10

    raise HandleErrorsConcern::GameHasFinishedError if game.finished?

    setup_score
    new_score
  end

  private

  def setup_score
    current_frame = Frame.find(game.current_frame_id)

    if current_frame.first_roll.negative?
      current_frame.first_roll = score
    else
      current_frame.second_roll = score
    end

    raise HandleErrorsConcern::TotalScoreGreaterThanTenError if current_frame.first_roll + current_frame.second_roll > 10

    current_frame.save

    @new_score = current_frame
    broadcast_new_score
  end

  def broadcast_new_score
    GamesChannel.broadcast_to(game, new_score: 'true')
  end
end
