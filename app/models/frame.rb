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

  private

  def check_strike_or_spare
    self.strike = true and return if first_roll == 10
    self.spare = true if first_roll + second_roll == 10
  end
end
