# frozen_string_literal: true

class GameStatusService
  def initialize(game:)
    @game = game
  end

  def call
    setup_status
  end

  private

  def setup_status
    total = @game.current_total
    finished = @game.finished?
    frames = @game.frames
    frames_to_return = {}

    frames.each do |frame|
      frames_to_return[frame.number] = frame.as_json
    end

    { data: { total: total, finished: finished, frames: frames_to_return } }
  end
end
