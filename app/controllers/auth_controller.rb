class AuthController < ApplicationController
  include AuthHelper

  def gettoken
    auth_code = params[:code]
    if auth_code
      store_token(auth_code)
      render plain: 'OK'
    else
      if ENV.has_key?('AZURE_CLIENT_ID') && ENV.has_key?('AZURE_CLIENT_SECRET') && ENV.has_key?('AZURE_TENANT')
        render inline: "<a href='#{get_login_url}'>Microsoft Azure Auth</a>"
      else
        render inline: "#{ENV.has_key?('AZURE_CLIENT_ID') ? '' : 'AZURE_CLIENT_ID environment variable must be set.'} #{ENV.has_key?('AZURE_CLIENT_SECRET') ? '' : 'AZURE_CLIENT_ID environment variable must be set.'} #{ENV.has_key?('AZURE_TENANT') ? '' : 'AZURE_TENANT environment variable must be set.'}
        <br/>Visit <a href=\"https://portal.azure.com/#home\">The Azure Portal</a> to register your app.
        <br/>See <a href=\"https://docs.microsoft.com/en-us/graph/\">MS Graph docs</a>
        "
      end
    end
  end
end
