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

  private

  def create_default_frames
    1.upto(10) do |frame_number|
      frames.create!(number: frame_number)
    end

    self.current_frame_id = frames.first.id
  end
end
