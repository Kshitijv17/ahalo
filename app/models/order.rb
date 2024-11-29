class Order < ApplicationRecord
    belongs_to :user
  
    validates :total, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :status, presence: true, inclusion: { in: %w[pending processing paid shipped delivered cancelled] }
    
    before_create :set_ordered_at
    
    scope :recent, -> { order(ordered_at: :desc) }
    
    private
    
    def set_ordered_at
      self.ordered_at = Time.current
    end
    
end
