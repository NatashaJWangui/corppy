# config/routes.rb
Rails.application.routes.draw do
  # Root route
  root "home#index"

  # Authentication routes (using Rails default)
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"

  # Registration wizard routes
  resources :registrations do
    member do
      get "step/:step", to: "registrations#step", as: "step"
      patch "step/:step", to: "registrations#update"
    end
  end

  # Document routes
  resources :documents, only: [ :show ] do
    member do
      get :approve
      post :sign
      get :download
      post :email_preview
      post :resend_approval
    end
  end

  # Payment routes
  resources :payments, only: [ :new, :create, :show ] do
    collection do
      post :callback
    end
  end

  # Admin routes
  namespace :admin do
    get "/", to: "dashboard#index"
    resources :business_registrations, only: [ :index, :show, :edit, :update ]
    resources :users, only: [ :index, :show, :edit, :update ]
    resources :document_templates
    resources :business_categories
    resources :countries do
      resources :states
    end
  end

  # Compliance Officer routes
  namespace :compliance_officer do
    get "/", to: "dashboard#index"
    resources :reviews, only: [ :index, :show, :update ]
  end

  # API routes
  namespace :api do
    # AI Assistant
    post "ai_assistant/chat", to: "ai_assistant#chat"
    get "ai_assistant/response", to: "ai_assistant#response"

    # Location data
    resources :countries, only: [] do
      member do
        get :states
      end
    end

    # Payment webhooks
    namespace :payment_webhooks do
      post :stripe
      post :paypal
      post :mpesa
    end
  end

  # Health check
  get "/health", to: proc { [ 200, {}, [ "OK" ] ] }
end
