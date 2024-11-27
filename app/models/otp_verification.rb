class OtpVerification < ApplicationRecord
    belongs_to :user
    validates :otp_code, presence: true, numericality: { only_integer: true }
    
end
