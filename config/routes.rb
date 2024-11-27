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
end
