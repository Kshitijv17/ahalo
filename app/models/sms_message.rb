class SmsMessage < ApplicationRecord
    belongs_to :user



    
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "message", "mobile_number", "updated_at", "user_id"]
  end
  
end
