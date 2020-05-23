# frozen_string_literal: true

# == Schema Information
#
# Table name: games
#
#  id         :uuid             not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Game < ApplicationRecord
  validates :name, presence: true

  has_many :frames

  after_create :create_default_frames

  # @return Boolean: when the game is in the last frame and the 10th was totally finished
  def finished?
    current_frame_is_the_last_one? && frames.last.was_played?
  end

  # @return Integer: the current total, it doesnt count the frames that have not been finished yet
  def current_total
    frames.ten_frames_and_possitive_total.sum(:total)
  end

  private

  # It sets the 11 frames (11th the special case only when the 10th is either strike or spare)
  def create_default_frames
    1.upto(11) do |frame_number|
      frames.create(number: frame_number)
    end

    update_columns(current_frame_id: frames.first.id)
  end

  # @return Boolean: When the game is in the last position
  def current_frame_is_the_last_one?
    current_frame_id == frames.last.id
  end
end
