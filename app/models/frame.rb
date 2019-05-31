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
end
