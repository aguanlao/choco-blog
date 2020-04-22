Rails.application.routes.draw do
  root 'posts#index'
  get 'about', to: 'pages#about'
  resources :posts
  get 'signup', to: 'users#new'
  resources :users, except: [:new]
end
