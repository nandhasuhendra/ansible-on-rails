Rails.application.routes.draw do
  namespace :api, default: { format: :json } do
    namespace :v1 do
      post '/login', to: 'authenticates#login', as: :login
      post '/register', to: 'registrations#signup', as: :register

      get '/dashboard', to: 'dashboards#index', as: :dashboard

      resources :users
      resources :teams
      resources :hosts
      resources :groups
      resources :credentials, only: [:index, :create, :destroy]
      resources :tasks
      resources :jobs

      post '/groups/setup/:id', to: 'groups#setup'

      post '/default', to: 'ssh#default'
      post '/send_key', to: 'ssh#send_key'
      post '/remove_key', to: 'ssh#remove_key'

      post '/ping', to: 'ansibles#ping'
      post '/task', to: 'ansibles#task'

      get '/ssh', to: 'logs#log_ssh'
      get '/rails', to: 'logs#log_rails'
      get '/ansible', to: 'logs#log_ansible'
    end
  end

  root to: 'main#index'
  match "*path", to: "main#index", format: false, via: :get
end
