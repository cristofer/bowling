# frozen_string_literal: true

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

  after_update :call_service_for_frames

  scope :ten_frames, -> { where.not(number: 11) }
  scope :with_possitive_total, -> { where.not(total: -1) }
  scope :ten_frames_and_possitive_total, -> { ten_frames.with_possitive_total }

  # @return Frame: the previous frame if the current_one is not the first one
  def previous_frame
    return nil if number == 1

    game.frames.find_by(number: number - 1)
  end

  # @return Frame: the next frame if the current_one is not the last one
  def next_frame
    return nil if number == 11

    game.frames.find_by(number: number + 1)
  end

  # @return Boolean: true either if game was strike or spare, or both rolls are possitive
  def frame_has_finished?
    strike_or_spare? || both_rolls_played? || last_frame_with_previous_spare
  end

  # @return Boolean: true when boths rolls has valid points (positive)
  def both_rolls_played?
    first_roll >= 0 && second_roll >= 0
  end

  # @return Boolean: when both rolls where played and total < 10
  def was_played_without_strike_or_spare?
    !strike_or_spare? && both_rolls_played?
  end

  # @return Boolean: The very last frame is special, as it could be played or not,
  # depending on the result of the 10th frame (technically the last one).
  # This 11th frame is 'played' only when the 10th was either striked or spared
  def last_frame_played?
    return true if previous_frame.strike && both_rolls_played?

    return true if previous_frame.spare && !first_roll.negative?

    return true if previous_frame.was_played_without_strike_or_spare?

    false
  end

  def strike_or_spare?
    strike || spare
  end

  private

  def call_service_for_frames
    FramesService.new(self).call
  end

  # @return Boolean: when one of the rolls is still negative (not played)
  def still_rolls_unplayed?
    !both_rolls_played?
  end

  # For the special frame (11th) we have to deal with its previous as a Spare
  # in order to recalculate the total of the 10th frame
  def last_frame_with_previous_spare
    return false if number < 11

    previous_frame.spare
  end
end
