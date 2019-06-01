# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #
  namespace :api do
    namespace :v1 do
      post 'games/create', to: 'games#create'
      get 'games/:game_id/status', to: 'games#status', as: :game_status

      post 'games/:game_id/scores/create', to: 'scores#create', as: :create_score
    end
  end

  resources :apidocs, only: [:index]

  get '/', to: redirect('apidoc/index.html')
end
