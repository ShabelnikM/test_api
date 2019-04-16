Rails.application.routes.draw do
  apipie
  root to: redirect('/apipie')

  scope :api do
    namespace :v1 do
      resources :users, only: %i[index] #TODO: remove index
      post '/auth/sign_up', to: 'users#create'
      post '/auth/sign_in', to: 'authentication#create'
      post '/auth/sign_out', to: 'authentication#destroy'
    end
  end
end
