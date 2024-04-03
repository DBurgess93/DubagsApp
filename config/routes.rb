Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "openai#index"
  get 'openai', to: 'openai#index', as: 'openai'
  post 'openai' => 'openai#create', as: :openai_create
end
