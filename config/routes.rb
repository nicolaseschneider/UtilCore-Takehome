Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :users
  resources :trips do
    member do
      put :reassign
      patch :check_in
      patch :check_out
    end
  end
end
