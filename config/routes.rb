Rails.application.routes.draw do
  resources :categories
  authenticate :user, ->(user) { user.admin? } do
    get 'admin', to: 'admin#index'
    get 'admin/posts'
    get 'admin/comments'
    get 'admin/users'
    get 'admin/post/:id', to: 'admin#show_post', as: 'admin_post'
    get 'admin/comment/:id', to: 'admin#show_comment', as: 'admin_comment'

  end
  
  # get 'users/profile'
  get 'search', to: 'search#index'

  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
  }

  get 'u/:id', to: 'users#profile', as: 'user';

  resources :after_signup

  resources :posts do
    resources :comments
  end
  # get 'pages/home'
  get 'about', to: 'pages#about'

  get 'notifications', to: 'notifications#index'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "pages#home"
end
