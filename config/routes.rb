Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "claude#index"
  get 'claude', to: 'claude#index', as: 'claude'
  post 'claude', to: 'claude#create', as: 'claude_create'
end
