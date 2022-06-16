class ApplicationMailer < ActionMailer::Base
  default from: ENV['LS_MAILER_SENDER_EMAIL']
  layout "mailer"
end
