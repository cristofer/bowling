# == Schema Information
#
# Table name: frames
#
#  id          :uuid             not null, primary key
#  number      :integer
#  strike      :boolean
#  spare       :boolean
#  first_roll  :integer
#  second_roll :integer
#  total       :integer
#  game_id     :uuid
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Frame < ApplicationRecord
  belongs_to :game

  after_update :check_strike_or_spare
  after_update :calculate_total
  after_update :calculate_previous_total, if: :frame_has_finished?
  after_update :update_current_frame_for_game, if: :frame_has_finished?

  # @return Frame: the previous frame if the current_one is not the first one
  def previous_frame
    return nil if self.number == 1

    game.frames.find_by(number: self.number - 1)
  end

  # @return Frame: the next frame if the current_one is not the last one
  def next_frame
    return nil if self.number == 10

    game.frames.find_by(number: self.number + 1)
  end

  # @return Boolean: true either if game was strike or spare, or both rolls are possitive
  def frame_has_finished?
    strike_or_spare? || both_rolls_played?
  end

  private

  # It checks if the current_frame should be marked either as strike or spare
  def check_strike_or_spare
    self.update_columns(strike: true, total: 10, second_roll: 0) and return if first_roll == 10
    self.update_columns(spare: true, total: 10) if first_roll + second_roll == 10
  end

  # It updates the total once both rolls have been played
  def calculate_total
    return if strike_or_spare?

    return unless both_rolls_played?

    self.update_columns(total: first_roll + second_roll)
  end

  # It sets the previous total when corresponding (prev frame strike or sspare)
  def calculate_previous_total
    return if number == 1 # nothing to calculate if it is the first frame

    return unless previous_frame.strike || previous_frame.spare

    if previous_frame.strike
      new_total = first_roll + second_roll + previous_frame.total
      previous_frame.update_columns(total: new_total)
    end

    if previous_frame.spare
      new_total = first_roll + previous_frame.total
      previous_frame.update_columns(total: new_total)
    end
  end

  # @return Boolean: either if the current frame is spare or strike
  def strike_or_spare?
    strike || spare
  end

  # @return Boolean: true when boths rolls has valid points (positive)
  def both_rolls_played?
    first_roll.positive? && second_roll.positive?
  end

  # @return Boolean: when one of the rolls is still negative (not played)
  def still_rolls_unplayed?
    !both_rolls_played?
  end

  # It updates the current_frame for the game
  def update_current_frame_for_game
    game.update_columns(current_frame_id: next_frame.id) if next_frame.present?
  end
end
