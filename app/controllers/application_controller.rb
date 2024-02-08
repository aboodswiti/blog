class ApplicationController < ActionController::Base
    before_action :set_notifications, if: :current_user
    before_action :set_query
    
    ###############
    around_action :skip_bullet # to skip the bullet ( N+1 )

    def skip_bullet
      Bullet.enable = false
      yield
    ensure
      Bullet.enable = true
    end
  
  ###############
    def set_query
        @query = Post.ransack(params[:q])
    end

    private
  
    def set_notifications
        
    #   notifications = Notification.where(recipient: current_user).newest_first.limit(9)
      @read = current_user.notifications.includes(:event).newest_first.read
      @unread = current_user.notifications.includes(:event).newest_first.unread
    end
end
