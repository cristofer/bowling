# frozen_string_literal: true

class ApidocsController < ActionController::Base
  include Swagger::Blocks

  swagger_root do
    key :swagger, '2.0'
    info do
      key :version, '1.0.0'
      key :title, 'Bowling!'
      key :description, 'An Api to handle the scores in a Bowling Game'
      contact do
        key :name, 'Cristofer Reyes'
      end
      license do
        key :name, 'MIT'
      end
    end
    key :host, 'free-bowling.herokuapp.com'
    key :basePath, '/api'
    key :consumes, ['application/json']
    key :produces, ['application/json']
  end

  # A list of all classes that have swagger_* declarations.
  SWAGGERED_CLASSES = [
    Api::V1::GamesController,
    Api::V1::ScoresController,
    self
  ].freeze

  def index
    render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
  end
end
