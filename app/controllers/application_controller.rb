class ApplicationController < ActionController::Base
    before_action :set_notifications, if: :current_user
    before_action :set_query
    before_action :set_categories

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
    
    def is_admin!
      redirect_to root_path, alert: 'You are not authorized to do that.' unless current_user&.admin?
    end
  
    private

    def set_categories
      @nav_categories = Category.where(display_in_nav: true).order(:name)
    end
  
    def set_notifications
        
    #   notifications = Notification.where(recipient: current_user).newest_first.limit(9)
      @read = current_user.notifications.includes(:event).newest_first.read
      @unread = current_user.notifications.includes(:event).newest_first.unread
    end
end
