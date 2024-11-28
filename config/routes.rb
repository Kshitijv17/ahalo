Rails.application.routes.draw do
  root "home#index"
  resources :registrations
  resources :sessions
  delete "/sessions", to: "sessions#destroy", as: "sign_out"

  get 'otp/send_otp'
  get 'otp/resent_otp'
  
  namespace :otp do
    post :send_otp
    post :resend_otp
  end
  
  post 'send_otp', to: 'otp#send_otp'
  post 'resend_otp', to: 'otp#resend_otp'
  get 'verify', to: 'otp#verify'
  post 'verify_otp', to: 'otp#verify_otp'

  get '/auth/:provider/callback', to: 'sessions#omniauth'
  post '/auth/:provider/callback', to: 'sessions#omniauth'
  get '/auth/failure', to: redirect('/')

  resources :sms_messages, only: [ :create ]

end
