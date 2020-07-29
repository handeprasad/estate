module Logoable
  extend ActiveSupport::Concern

  included do
    before_action :attach_logo
  end

  private
  def attach_logo
    attachments.inline['logo.png'] = Rails.root.join('app', 'assets', 'images', 'logo.png').read
  end


end
