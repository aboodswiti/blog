class PagesController < ApplicationController
  def home
    return unless current_user
    # You can’t create a portal session in test mode until you save your customer portal settings in test mode at https://dashboard.stripe.com/test/settings/billing/portal.

    # @portal_session = current_user.payment_processor.billing_portal
  end
  def hello
    HelloJob.perform_at(10.seconds.from_now)
  end
  def about
  end
end
