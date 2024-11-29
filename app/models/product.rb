class Product < ApplicationRecord
    enum stat: { active: 0, inactive: 1, archived: 2 }
    enum cat: { electronics: 0, accessories: 1, fashion: 2, home: 3 }

    has_one_attached :avatar




    
  def self.ransackable_attributes(auth_object = nil)
    ["cat", "created_at", "id", "id_value", "name", "stat", "updated_at"]
  end

    def self.ransackable_associations(auth_object = nil)
        ["avatar_attachment", "avatar_blob"]
      end
    
end
