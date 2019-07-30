Rails.application.routes.draw do
  root 'posts#index'

  devise_for :users, :controllers => { omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :posts
  resources :posts do
    resources :comments
  end
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
