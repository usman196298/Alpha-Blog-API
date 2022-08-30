Rails.application.routes.draw do
  root 'pages#home'
  resources :articles, only: [:show, :index, :new, :create, :edit, :update, :destroy]
  # you can also make the above code simple by writing:
  resources :articles
end