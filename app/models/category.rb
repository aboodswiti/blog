class Category < ApplicationRecord
    has_many :posts, dependent: :destroy

    
    def self.ransackable_attributes(auth_object = nil)
        ["created_at", "display_in_nav", "id", "id_value", "name", "updated_at"]
      end
end
