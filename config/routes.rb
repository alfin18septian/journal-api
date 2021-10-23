Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      post 'authenticate', to: 'authentication#create'

      resources :user do
        collection do
          get 'confirm'
        end
      end
      
      resources :journals do
        collection do
          get 'confirm'
        end
      end

      resources :categories
      
      post 'password/forgot', to: 'passwords#forgot'
      post 'password/reset', to: 'passwords#reset'
      put 'password/update', to: 'passwords#update'
    end
  end
end
