class User < ApplicationRecord

has_secure_password

has_many :otp_verifications


end
