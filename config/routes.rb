Rails.application.routes.draw do
  resources :products
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :sessions, only: %i[new create destroy]

  # Defines the root path route ("/")
  # root "articles#index"
end
