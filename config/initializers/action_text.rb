ActiveSupport.on_load(:action_text_rich_text) do
    class ActionText::RichText < ActionText::Record
        def self.ransackable_attributes(auth_object = nil)
            ["body", "created_at", "id", "id_value", "name", "record_id", "record_type", "updated_at"]
          end
    end
  end

#   def self.ransackable_attributes(auth_object = nil)
#     ["body", "created_at", "id", "id_value", "name", "record_id", "record_type", "updated_at"]
#   end