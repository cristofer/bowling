# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #
  namespace :api do
    namespace :v1 do
      namespace :game do
        post 'create', to: 'game#create'
        get ':id/status', to: 'game#status'

        post ':game_id/score/create', to: 'score#create'
        get ':game_id/score/show', to: 'score#show'
      end
    end
  end
  
  get '*page', to: 'welcome#index', constraints: -> (req) do
    !req.xhr? && req.format.html?
  end

  root 'welcome#index'
end
