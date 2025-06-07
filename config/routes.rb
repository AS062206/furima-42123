Rails.application.routes.draw do
  root to: "item#index"
  resources :items, only: :index
end
