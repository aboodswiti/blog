class Post < ApplicationRecord
    extend FriendlyId
    validates :title, presence: true, length: { minimum: 5, maximum: 50 }
    validates :body, presence: true
    belongs_to :user
    
    has_many :comments, dependent: :destroy

    has_rich_text :body
    has_one :content, class_name: 'ActionText::RichText', as: :record, dependent: :destroy
  

    def self.ransackable_attributes(auth_object = nil)
      ["created_at", "id", "id_value", "title", "updated_at", "user_id", "views"]
    end
    def self.ransackable_associations(auth_object = nil)
      ["comments", "content", "notification_mentions", "rich_text_body", "user"]
    end
    # has_noticed_notification modal_name: "Notification"
    # has_many :notification, through: :user, dependent: :destroy
    has_many :notification_mentions, through: :user, dependent: :destroy, class_name:"Noticed::Event"
    # def self.ransackable_attributes(auth_object = nil)
    #     ["body", "created_at", "id", "id_value", "title", "updated_at", "user_id", "views"]
    #   end
    # def self.ransackable_attributes(auth_object = nil)
    #   ["body", "created_at", "id", "id_value", "name", "record_id", "record_type", "updated_at"]
    # end

    friendly_id :title, use: %i[slugged history finders]

    def should_generate_new_friendly_id?
        title_changed? || slug.blank?
    end
end
