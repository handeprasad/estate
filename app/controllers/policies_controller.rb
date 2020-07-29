class PoliciesController < ApplicationController
  before_action :authenticate_user!

  def show
    filename = Rails.root.join('tmp', 'protection-policy.pdf')
    PolicyCompiler.new.compile! filename unless File.exist? filename
    send_file filename, type: 'application/pdf', disposition: :inline
  end
end
