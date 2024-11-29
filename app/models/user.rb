class User < ApplicationRecord
  has_secure_password validations: false

  has_many :otp_verifications,dependent: :destroy
  has_many :sms_messages,dependent: :destroy

  has_one_attached :avatar

  has_one :profile, dependent: :destroy
  has_one :cart, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :orders, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, if: :password_required?

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

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "id", "id_value", "name", "password_digest", "provider", "uid", "updated_at", "user_activated"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["otp_verifications", "sms_messages"]
  end

end
