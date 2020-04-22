Rails.application.routes.draw do
  root 'posts#index'
  get 'about', to: 'pages#about'
  resources :posts
  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'
  resources :users, except: [:new, :create]
end
