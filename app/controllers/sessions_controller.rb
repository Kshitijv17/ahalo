class SessionsController < ApplicationController
    skip_before_action :authenticate_user, only: [:new, :create]
    before_action :redirect_if_authenticated, only: [:new, :create]
  
    def new
      @user = User.new
    end
  
    def create
      @user = User.find_by(email: params[:email])
  
      if @user&.authenticate(params[:password])
        if @user.user_activated?
          token = JsonWebToken.encode(user_id: @user.id)
          time = Time.now + 24.hours.to_i
          render json: { 
            token: token, 
            exp: time.strftime("%m-%d-%Y %H:%M"), 
            username: @user.name,
            message: 'Logged in successfully'
          }, status: :ok
        else
          redirect_to verify_path(email: @user.email), 
            flash: { warning: 'Please verify your email first' }
        end
      else
        render json: { error: 'Invalid email or password' }, status: :unauthorized
      end
    end
  
    def destroy
      session[:user_id] = nil
      redirect_to new_session_path	, flash: { success: 'Logged Out' }
    end


    def omniauth
      @user = User.find_or_create_by(uid: request.env['omniauth.auth']['uid'], provider: request.env['omniauth.auth']['provider']) do |u|
          u.username = request.env['omniauth.auth']['info']['name']
          u.email = request.env['omniauth.auth']['info']['email']
          u.password = SecureRandom.hex(10)
      end
      if @user.valid?
          session[:user_id] = @user.id
          redirect_to root_path
      else
          render :new
      end
end


private
def user_params
  params.require(:user).permit(:password_digest)
end
  end