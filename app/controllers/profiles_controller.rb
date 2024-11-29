class ProfilesController < ApplicationController
  # before_action :checknull, only: :index

  def index
    if Profile.where(user_id:current_user.id).empty?
      @profile = Profile.find(current_user.id) 
    else
       @profile = "datalolound"
    end
    @show = current_user
      @sav = User.new
  end


  def update
    @use=current_user
    if @use.update(photo_params)
     redirect_to profiles_path, notice: "image was successfully added."
    else
      redirect_to profiles_path
    end
  end

    private
    def photo_params
      params.require(:user).permit(:avatar)
    end
         #Kartikey try

#  def checknull
#    if @profile.bio.empty?
#      bio="---Empty---"
#    end
#  end

end
