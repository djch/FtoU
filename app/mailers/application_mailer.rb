class ApplicationMailer < ActionMailer::Base
  helper LocalTimeHelper
  helper OrdersHelper
  helper_method :user_signed_in?

  default from: ENV['DEFAULT_MAILER_FROM'] || 'Getbusi <noreply@getbusi.com>'
  layout "mailer"

  private
    def user_signed_in?
      false
    end
end
