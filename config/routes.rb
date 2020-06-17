Rails.application.routes.draw do
  root 'posts#index'
  # get 'about', to: 'pages#about'
  resources :posts
  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'
  resources :users, except: [:new, :create, :index]
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  resources :categories
end
