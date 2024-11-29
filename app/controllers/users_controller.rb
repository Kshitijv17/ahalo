class UsersController < InheritedResources::Base

  private

    def user_params
      params.require(:user).permit(:name, :email, :password_digest)
    end

  def create
    @user = User.new(user_params)
    if @user.save
      if request.format.json?
        # Respond with JSON if the request format is JSON (e.g., from Postman)
        render json: { message: 'User created successfully.' }
      else
        redirect_to verify_path(email: @user.email), 
                    flash: { success: 'Registration successful! Please verify your email.' }
      end
    else
      render :new
    end
  end

end
