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

class GameSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name
end
