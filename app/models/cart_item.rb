class CartItem < ApplicationRecord
    belongs_to :cart
    belongs_to :product
  
    validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
    
    before_validation :set_default_quantity
    
    def total_price
      return 0 if quantity.nil? || product&.price.nil?
      quantity * product.price
    end
    
    private
    
    def set_default_quantity
      self.quantity ||= 1
    end
end
