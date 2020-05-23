# frozen_string_literal: true

class FramesService
  attr_reader :frame

  def initialize(frame)
    @frame = frame
  end

  def call
    check_strike_or_spare
    calculate_total
    calculate_previous_total
    update_current_frame_for_game
  end

  private

  def check_strike_or_spare
    frame.update_columns(strike: true, total: 10, second_roll: 0) && return if strike?
    frame.update_columns(spare: true, total: 10) if spare?
  end

  def calculate_total
    return if frame.number == 11

    return if frame.strike_or_spare?

    return unless frame.both_rolls_played?

    frame.update_columns(total: total)
  end

  # It sets the previous total when corresponding (prev frame strike or sspare)
  def calculate_previous_total
    return unless frame.frame_has_finished?

    return if frame.number == 1 # nothing to calculate if it is the first frame

    return unless previous_frame_was_strike_or_spare?

    if frame.previous_frame.strike
      new_total = frame.first_roll + frame.second_roll + frame.previous_frame.total
      frame.previous_frame.update_columns(total: new_total)
    end

    if frame.previous_frame.spare
      new_total = frame.first_roll + frame.previous_frame.total
      frame.previous_frame.update_columns(total: new_total)
    end
  end

  # It updates the current_frame for the game
  def update_current_frame_for_game
    return unless frame.frame_has_finished?

    frame.game.update_columns(current_frame_id: frame.next_frame.id) if frame.next_frame.present?
  end

  def strike?
    frame.first_roll == 10
  end

  def spare?
    (frame.first_roll + frame.second_roll) == 10
  end

  def total
    frame.first_roll + frame.second_roll
  end

  def previous_frame_was_strike_or_spare?
    frame.previous_frame.strike || frame.previous_frame.spare
  end
end
