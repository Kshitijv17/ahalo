class UserMailer < ApplicationMailer
    default from: 'experimentalv17@gmail.com'
  
    def welcome_email
      mail(to: "kshitijv17@gmail.com", subject: 'Welcome to Our Application!')
    end

    def send_otp(user, otp)
        @user = user
        @otp = otp
        mail(
          from: "experimentalv17@gmail.com",
          to: @user.email,
          subject: "Your OTP"
          )
      end
  end
  