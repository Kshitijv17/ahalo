class RegistrationsController < ApplicationController
    skip_before_action :authenticate_user , only: [:new, :create]
    before_action :redirect_if_authenticated , only: [:new, :create] 
  
    def new
      @user = User.new
    end
  
    def create
      @user = User.new(user_params)
      if @user.save
        otp = OtpController.new.send(:generate_otp)
        OtpVerification.create(user: @user, otp_code: otp)
        UserMailer.with(user: @user, otp_code: otp).send_otp(@user, otp).deliver_now

        redirect_to verify_path(email: @user.email), flash: { success: 'Registration successful! Please verify your email.' }
        # return render  json: { message: 'User created successfully.' }

      else
        render :new
      end
    end
  
    private
  
    def user_params
      params.require(:user).permit(:name, :email, :password)
    end
end