Rails.application.routes.draw do
  resources :shorten_urls
  get '/:id', to: 'shorten_urls#show'
  devise_for :users

  root to: 'shorten_urls#index'
  namespace :api do
    namespace :v1 do
      defaults format: :json do
        post 'authenticate', to: 'users#authenticate'
        get 'get_all_links', to: 'shorten_urls#index'
        post 'generate_link', to: 'shorten_urls#create'
        devise_for :users, only: [:sessions]
      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
