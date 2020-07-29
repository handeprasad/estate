class DocumentsController < ApplicationController
  before_action :authenticate_user!

  def show
    gid         = GlobalID.parse Base64.urlsafe_decode64(params[:id])
    object      = GlobalID::Locator.locate gid
    destination = object.public_send(gid.params[:attribute]).url

    redirect_to destination
  end
end
