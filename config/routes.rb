Rails.application.routes.draw do
  root to: "books#index"

  resources :books do
    resources :images do
      collection do
        post :check_existence
        post :upload
      end
      resources :texts, only: [:index, :new, :create, :show]
    end
  end
end
