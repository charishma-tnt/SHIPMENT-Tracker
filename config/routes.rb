Rails.application.routes.draw do
  get "/admin", to: "admins#show", as: :admin
  post "/admin/assign_shipment", to: "admins#assign_shipment", as: :assign_shipment
  delete "/admin/destroy_shipment/:id", to: "admins#destroy_shipment", as: :destroy_shipment

  root "shipments#dashboard"
  get "/role_selection", to: "role_selection#index"
  devise_for :users, controllers: { sessions: "users/sessions" }
  resources :shipments do
    collection do
      get :dashboard
      get :track
    end
    member do
      post :accept_delivery
      post :decline_delivery
    end
  end
  resources :delivery_partners, only: [ :index, :show ]
  resources :customers
end
