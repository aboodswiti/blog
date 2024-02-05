class NotificationsController < ApplicationController
    before_action :authenticate_user!

    def index
        @notification = current_user.notifications.includes(event: :record)
    end
end
