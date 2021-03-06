Rails.application.routes.draw do
  devise_for :users

  get 'home/index'
  root to: 'home#index'

  resources :workouts
  resource :profile, only: [:edit, :update]

  mount SwaggerUiEngine::Engine, at: '/api-docs'

  namespace :api do
    namespace :v1 do
      post 'users/sign_in'
      resources :workouts, only: [:index, :create, :update, :destroy]
      resources :performances, only: [:index]
      resources :trainees, only: [:index] do
        member do
          post :assign_workouts
        end
      end
      resources :trainers, only: [:index] do
        collection do
          post :choose
        end
      end
    end
  end
end
