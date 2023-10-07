class ApplicationMailer < ActionMailer::Base
  default from: ENV['DEFAULT_MAILER_FROM'] || 'Getbusi <noreply@getbusi.com>'
  layout "mailer"
end
