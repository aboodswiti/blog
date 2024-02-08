class Comment < ApplicationRecord
  belongs_to :post, counter_cache: true
  belongs_to :user
  has_rich_text :body

  has_many :noticed_events, as: :record, dependent: :destroy, class_name: "Noticed::Event"

  after_create_commit :notify_recipient
  # before_detroy :cleanup_notifications
  # has_noticed_notifications modal_name: "Notification"

  private

  def notify_recipient

    CommentNotifier.with(record: self,comment:self, post: post).deliver(post.user)

  end

  # def cleanup_notifications
  #   notifications_as_comment.destroy_all
  # end
end
