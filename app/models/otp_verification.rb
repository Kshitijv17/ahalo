class OtpVerification < ApplicationRecord
    belongs_to :user
    validates :otp_code, presence: true, numericality: { only_integer: true }
    
    # OTP expires after 10 minutes
    def expired?
        created_at < 10.minutes.ago
    end


    
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "id", "otp_code", "updated_at", "user_id"]
  end
  
end
