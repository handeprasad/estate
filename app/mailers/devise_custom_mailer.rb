class DeviseCustomMailer < Devise::Mailer
  include Logoable
  layout 'mailer'
end
