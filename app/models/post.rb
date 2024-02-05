class Post < ApplicationRecord
    validates :title, presence: true, length: { minimum: 5, maximum: 50 }
    validates :body, presence: true, length: { minimum: 10, maximum: 1000 }
    belongs_to :user
    has_many :comments, dependent: :destroy

    # has_noticed_notification modal_name: "Notification"
    # has_many :notification, through: :user, dependent: :destroy
    has_many :notification_mentions, through: :user, dependent: :destroy, class_name:"Noticed::Event"

end
