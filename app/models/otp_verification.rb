class OtpVerification < ApplicationRecord
    belongs_to :user
    validates :otp_code, presence: true, numericality: { only_integer: true }
    
    # OTP expires after 10 minutes
    def expired?
        created_at < 10.minutes.ago
    end
end
