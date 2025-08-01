Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

    # API routes
  namespace :api do
    namespace :v1 do
      resources :posts, only: [:index, :show, :create, :update, :destroy]

      # Users routes
      resources :users, only: [:show, :update] do
        collection do
          get :me  # 現在のユーザー情報取得
        end
        # ユーザー投稿一覧用
        resources :posts, only: [:index]
      end
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
