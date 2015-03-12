Rails.application.routes.draw do
  root 'dreams#index'
  resources :dreams
end
