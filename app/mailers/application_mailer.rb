class ApplicationMailer < ActionMailer::Base
  include Logoable

  SUPPORT_EMAIL = ENV.fetch('SUPPORT_EMAIL', '"Estatesearch Support" <support@estatesearch.co.uk>')

  default from: SUPPORT_EMAIL
  layout 'mailer'
end
