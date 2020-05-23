# frozen_string_literal: true

module Api
  module V1
    class ScoresController < Base
      swagger_path '/api/v1/games/{game_id}/scores/create' do
        operation :post do
          key :summary, 'It creates a new Score'
          key :description, 'Adds a score to the current Game'
          key :operationId, 'createScore'
          parameter do
            key :name, :game_id
            key :in, :path
            key :description, 'ID of the Game where the score will go'
            key :required, true
            key :type, :uuid
          end
          parameter do
            key :name, :score
            key :in, :query
            key :description, 'Score to be added in the Game'
            key :required, true
            key :type, :int32
          end
          response 200 do
            key :description, 'score response'
            schema do
              key :'$ref', :Frame
            end
          end
          response :default do
            key :description, 'standard error'
          end
        end
      end

      # POST /api/v1/games/:game_id/scores/create  params: name
      def create
        game = Game.find(params[:game_id])
        score = Integer(params[:score])

        new_score = NewScoreService.new(game: game, score: score).call

        if new_score.valid?
          render json: { data: new_score }, status: :created
        else
          json_errors(new_score)
        end
      end
    end
  end
end
