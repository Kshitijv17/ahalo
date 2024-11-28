class User < ApplicationRecord

has_secure_password

has_many :otp_verifications
has_many :sms_messages


# def self.create_user_for_google(data)
#     where(uid: data["email"]).first_or_initialize.tap do |user|
#       user.provider="google_oauth2"
#       user.uid=data["email"]
#       user.email=data["email"]
#       user.save!
#     end
#   end  


end
