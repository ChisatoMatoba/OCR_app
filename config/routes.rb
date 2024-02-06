Rails.application.routes.draw do
  root to: "books#index"

  resources :books do
    resources :images do
      collection do
        post :check_existence
        post :upload
      end
    end
  end
end
