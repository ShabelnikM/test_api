Rails.application.routes.draw do
  apipie

  root to: redirect('/apipie')
end
