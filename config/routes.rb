Rails.application.routes.draw do
  get 'itdcons/index'
  get 'homes/index'
  post 'empresas/:empresa_id/aspiracions/update_maturity_recomendation', to: 'aspiracions#update_maturity_recomendation', as: 'update_maturity_recomendation'
  post 'empresas/:empresa_id/aspiracions/update_dat_recomendation', to: 'aspiracions#update_dat_recomendation', as: 'update_dat_recomendation'
  post 'empresas/:empresa_id/aspiracions/update_hab_recomendation', to: 'aspiracions#update_hab_recomendation', as: 'update_hab_recomendation'
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }, path: '', path_names: {sign_in: 'login', sign_out: 'logout', sign_up: 'register'}
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  root "homes#index"
  resources :empresas do 
    resources :itdcons do
      resources :itdinds do 
        resources :verificadors
      end
    end
    resources :aspiracions
  end
  resources :itdsins 
  get "homes/example"
end
