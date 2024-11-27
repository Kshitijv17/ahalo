class RegistrationsController < ApplicationController
    skip_before_action :authenticate_user , only: [:new, :create]
    before_action :redirect_if_authenticated , only: [:new, :create] 
  
    def new
      @user = User.new
    end
  
    def create
      @user = User.new(user_params)
      if @user.save
        session[:user_id] = @user.id
        # @user.profile.create(user_params)
        redirect_to root_path, flash: { success: 'Registration successfully' }
      else
        render :new
      end
    end
  
    def verify_otp_and_activate
        user = User.find_by(email: params[:email])
        return render json: { error: "User not found. Please request OTP again." }, status: :not_found unless user
    
        otp_verification = user.otp_verifications.find_by(otp_code: params[:otp])
        if otp_verification && otp_valid?(otp_verification)
          activate_user(user)
        else
          render json: { error: otp_verification.nil? ? "Invalid OTP" : "OTP expired" }, status: :unprocessable_entity
        end
    end
    
      private
    
      def otp_valid?(otp_verification)
        Time.now <= otp_verification.created_at + 180.seconds
      end

    def user_params
      params.require(:user).permit(:name, :email, :password)
    end
    def profile_params
      params.require(:profile).permit( :email, :password)
    end
  end