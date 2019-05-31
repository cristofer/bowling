# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #
  namespace :api do
    namespace :v1 do
      post 'games/create', to: 'games#create'
      get 'games/:id/status', to: 'games#status'

      post 'games/:game_id/scores/create', to: 'scores#create'
      get 'games/:game_id/scores/show', to: 'scores#show'
    end
  end

  get '*page', to: 'welcome#index', constraints: -> (req) do
    !req.xhr? && req.format.html?
  end

  root 'welcome#index'
end
