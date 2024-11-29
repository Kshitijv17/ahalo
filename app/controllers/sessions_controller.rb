class SessionsController < ApplicationController
    skip_before_action :authenticate_user, only: [:new, :create]
    before_action :redirect_if_authenticated, only: [:new, :create]
  
    def new
      @user = User.new
    end

    def create
      @user = User.find_by(email: params[:user][:email])
      if @user.present? #&& @user.authenticate(params[:user][:password])
        session[:user_id] = @user.id

        # UserMailer.welcome_email(@user).deliver_later
        redirect_to root_path, flash: { success: 'Logged in successfully' }
      else
        render :new
      end
    end
  
    # def create
    #   @user = User.find_by(email: params[:email])
  
    #   if @user&.authenticate(params[:password])
    #     if @user.user_activated?
    #       token = JsonWebToken.encode(user_id: @user.id)
    #       time = Time.now + 24.hours.to_i
    #       render json: { 
    #         token: token, 
    #         exp: time.strftime("%m-%d-%Y %H:%M"), 
    #         username: @user.name,
    #         message: 'Logged in successfully'
    #       }, status: :ok
    #     else
    #       redirect_to verify_path(email: @user.email), 
    #         flash: { warning: 'Please verify your email first' }
    #     end
    #   else
    #     render json: { error: 'Invalid email or password' }, status: :unauthorized
    #   end
    # end
  
    def destroy
      session[:user_id] = nil
      redirect_to new_session_path	, flash: { success: 'Logged Out' }
    end


    def omniauth
      ActiveRecord::Base.transaction do
        @user = User.from_omniauth(request.env['omniauth.auth'])

        if @user.persisted?
          # Create or update profile
          @profile = Profile.find_or_create_by(user_id: @user.id) do |p|
            p.name = request.env['omniauth.auth']['info']['name']
            p.email = request.env['omniauth.auth']['info']['email']
          end

          if @profile.valid?
            session[:user_id] = @user.id
            redirect_to root_path, flash: { success: 'Successfully signed in with Google!' }
          else
            raise ActiveRecord::Rollback
            flash[:error] = 'Error creating profile'
            redirect_to new_session_path
          end
        else
          flash[:error] = 'Error creating user'
          redirect_to new_session_path
        end
      end
    rescue StandardError => e
      flash[:error] = "Authentication error: #{e.message}"
      redirect_to new_session_path
    end


    private
    def user_params
      params.require(:user).permit(:password_digest)
    end
  end