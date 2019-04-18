Rails.application.routes.draw do
  apipie
  root to: redirect('/apipie')

  scope :api do
    namespace :v1 do
      post '/auth/sign_up', to: 'users#create'
      post '/auth/sign_in', to: 'authentication#create'
      delete '/auth/sign_out', to: 'authentication#destroy'

      resources :users, only: %i[show] do
        resources :projects
      end

      resources :projects, only: [] do
        resources :tasks
      end

      resources :tasks, only: [] do
        resources :comments, except: %i[show update]
      end
    end
  end
end
