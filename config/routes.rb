Rails.application.routes.draw do
  get 'itdcons/index'
  get 'homes/index'
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }, path: '', path_names: {sign_in: 'login', sign_out: 'logout', sign_up: 'register'}
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  root "homes#index"
  resources :empresas do 
    resources :itdcons do
      resources :itdinds
    end
    resources :aspiracions
  end
  get "homes/example"
end
