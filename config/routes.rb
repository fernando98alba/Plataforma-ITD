Rails.application.routes.draw do
  root "homes#index"
  post 'empresas/:empresa_id/aspiracions/update_maturity_recomendation', to: 'aspiracions#update_maturity_recomendation', as: 'update_maturity_recomendation'
  post 'empresas/:empresa_id/aspiracions/update_dat_recomendation', to: 'aspiracions#update_dat_recomendation', as: 'update_dat_recomendation'
  post 'empresas/:empresa_id/aspiracions/update_hab_recomendation', to: 'aspiracions#update_hab_recomendation', as: 'update_hab_recomendation'
  post 'empresas/:empresa_id/users/invite_member', to: 'users#invite_member', as: 'invite_member'
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    confirmations: 'users/confirmations',
    invitations: 'users/invitations'
  }, path: '', path_names: {sign_in: 'login', sign_out: 'logout', sign_up: 'register'}
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  get "empresas/:empresa_id/users", to: "users#index", as: "empresa_users"
  get "users/:id", to: "users#show", as: "user"
  resources :empresas do 
    resources :itdcons, only: [:index, :show, :create] do
      resources :itdinds, only: [:show, :edit, :update]
    end
    resources :aspiracions
  end
  resources :itdsins 
  get "homes/example"

  get '/*paths', to: 'unhandled#show'
end
