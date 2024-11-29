class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token


  helper_method :current_user
  helper_method :user_signed_in?
  before_action :authenticate_user
  # before_action :ensure_user_activated

  def current_user
    @current_user ||= session[:user_id] && User.find_by(id: session[:user_id]) 
  end

  def user_signed_in?
    !current_user.nil?
  end

  def authenticate_user
    redirect_to new_session_path, flash: {danger: 'You must be signed in'} if current_user.nil?
  end

  # def ensure_user_activated
  #   if current_user && !current_user.user_activated?
  #     session[:user_id] = nil
  #     redirect_to new_session_path, flash: {warning: 'Please verify your email first'}
  #   end
  # end

  def redirect_if_authenticated
    redirect_to root_path, flash: { info: 'You are already logged in.'} if user_signed_in?
  end





  def not_found 
    render json: {error: 'not_found from app' }
  end
  
  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
 
    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end
end