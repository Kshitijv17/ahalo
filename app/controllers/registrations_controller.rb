class RegistrationsController < ApplicationController
    skip_before_action :authenticate_user , only: [:new, :create]
    before_action :redirect_if_authenticated , only: [:new, :create] 
  
    def new
      @user = User.new
    end


  
    def create
      @user = User.new(user_params)
      @profile = Profile.new(profile_params)

        if @user.save
          @profile.user_id = @user.id
          if @profile.save
            session[:user_id] = @user.id
            redirect_to root_path, flash: { success: 'Registration successful!' }
          else
            render :new
          end
        else
          render :new
        end
    end 
    


    def self.from_omniauth(auth)
      where(provider: auth['provider'], uid: auth['uid']).first_or_initialize.tap do |user|
        user.email = auth['info']['email']
        user.name = auth['info']['name']
        user.password = SecureRandom.hex(16) if user.new_record?
        user.save!
      end
    end
  
    def password_required?
      provider.blank?
    end



    # def create
    #   @user = User.new(user_params)
    #   if @user.present?
    #     if request.format.json?
    #       # Respond with JSON if the request format is JSON (e.g., from Postman)
    #       render json: { message: 'User created successfully.' }
    #     else
    #          # redirect_to verify_path(email: @user.email), 
    #       #             flash: { success: 'Registration successful! Please verify your email.' }
    #     end
    #   else
    #     render :new
    #   end
    # end
  
    # def create
    #   @user = User.new(user_params)
    #   if @user.save
    #   #   if request.format.json?
    #   #   # Respond with JSON if the request format is JSON (e.g., from Postman)
    #   #    render  json: { message: 'User created successfully.' }

    #   #   # otp = OtpController.new.send(:generate_otp)
    #   #   # OtpVerification.create(user: @user, otp_code: otp)
    #   #   # # UserMailer.with(user: @user, otp_code: otp).send_otp(@user, otp).deliver_now
    #   # else
    #     redirect_to verify_path(email: @user.email), flash: { success: 'Registration successful! Please verify your email.' }
    #   # end
    #   else
    #     render :new
    #   end
    # end 
    
    private
  
    def user_params
      params.require(:user).permit(:name, :email, :password)
    end

    def profile_params
      params.require(:user).permit(:name, :email)
    end
end