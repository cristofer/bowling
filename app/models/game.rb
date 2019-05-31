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
end
