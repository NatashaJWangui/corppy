Rails.application.routes.draw do
  namespace :api do
    get "payment_webhooks/mpesa"
    get "payment_webhooks/stripe"
    get "payment_webhooks/paypal"
    get "countries/states"
    get "ai_assistant/chat"
    get "ai_assistant/response"
  end
  namespace :compliance_officer do
    get "reviews/index"
    get "reviews/show"
    get "reviews/update"
    get "dashboard/index"
  end
  namespace :admin do
    get "document_templates/index"
    get "document_templates/show"
    get "document_templates/new"
    get "document_templates/create"
    get "document_templates/edit"
    get "document_templates/update"
    get "users/index"
    get "users/show"
    get "users/edit"
    get "users/update"
    get "business_registrations/index"
    get "business_registrations/show"
    get "business_registrations/edit"
    get "business_registrations/update"
    get "dashboard/index"
  end
  get "payments/new"
  get "payments/create"
  get "payments/show"
  get "payments/callback"
  get "documents/show"
  get "documents/approve"
  get "documents/sign"
  get "documents/download"
  get "registrations/new"
  get "registrations/create"
  get "registrations/show"
  get "registrations/edit"
  get "registrations/update"
  get "registrations/step"
  get "users/new"
  get "users/create"
  get "sessions/new"
  get "sessions/create"
  get "sessions/destroy"
  get "home/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
