# frozen_string_literal: true

module Api
  module V1
    class Base < ActionController::API
      include Swagger::Blocks
      include HandleErrorsConcern
    end
  end
end
