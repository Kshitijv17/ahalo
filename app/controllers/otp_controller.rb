class OtpController < ApplicationController
    skip_before_action :ensure_user_activated
    skip_before_action :authenticate_user

    def send_otp
      @user = User.new(user_params)
      if @user.save
        otp = generate_otp
        OtpVerification.create(user: @user, otp_code: otp)
        UserMailer.with(user: @user, otp_code: otp).send_otp(@user, otp).deliver_now
        redirect_to verify_path(email: @user.email)
      else
        redirect_to new_registration_path, flash: { error: @user.errors.full_messages.join(", ") }
      end
    end
  
    def resend_otp
      @user = User.find_by(email: params[:email])
      if @user
        otp = generate_otp
        OtpVerification.create(user: @user, otp_code: otp)
        UserMailer.with(user: @user, otp_code: otp).send_otp(@user, otp).deliver_now
      end
      redirect_to verify_path(email: params[:email])
    end
  
    def verify
      @email = params[:email]
    end

    def verify_otp
      @user = User.where(email: params[:email]).last
      @otp = OtpVerification.where(user: @user).find_by(otp_code: params[:otp])

      if @otp && !@otp.expired?
        @user.update(user_activated: true)
        token = JsonWebToken.encode(user_id: @user.id)
        time = Time.now + 24.hours.to_i
        render json: { 
          token: token, 
          exp: time.strftime("%m-%d-%Y %H:%M"), 
          username: @user.name,
          message: 'Email verified successfully!'
        }, status: :ok
      else
        render json: { error: 'Invalid or expired OTP' }, status: :unauthorized
      end
    end
  
    private
  
    def user_params
      params.require(:user).permit(:name, :email, :password)
    end
  
    def generate_otp
      rand(1000..9999)
    end
end