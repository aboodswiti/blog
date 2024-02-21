class Post < ApplicationRecord
    extend FriendlyId
    validates :title, presence: true, length: { minimum: 5, maximum: 50 }
    validates :body, presence: true
    belongs_to :user
    belongs_to :category


    has_many :comments, dependent: :destroy

    # \single image upload
    # has_one_attached :image
    # Multiple images upload
    has_many_attached :images

    has_rich_text :body
    has_one :content, class_name: 'ActionText::RichText', as: :record, dependent: :destroy
  
    def self.ransackable_attributes(auth_object = nil)
      ["category_id", "comments_count", "created_at", "id", "id_value", "slug", "title", "updated_at", "user_id", "views"]
    end
    def self.ransackable_associations(auth_object = nil)
      ["category", "comments", "content", "notification_mentions", "rich_text_body", "slugs", "user"]
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

    def views_by_day
      daily_events = Ahoy::Event.where("cast(properties ->> 'post_id' as bigint) = ?", id)
      daily_events.group_by_day(:time, range: 1.month.ago..Time.now).count
    end
  
    def self.total_views_by_day
      daily_events = Ahoy::Event.where(name: 'Viewed Post')
      daily_events.group_by_day(:time, range: 1.month.ago..Time.now).count
    end
end
