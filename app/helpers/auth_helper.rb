require 'net/http'

module AuthHelper
  SCOPES = [
    'offline_access',
    'openid',
    'profile',
    'User.Read',
    'Mail.Read',
    'Mail.Send'
  ].join(' ')

  def client
    return nil unless ENV.has_key?('AZURE_CLIENT_ID') && ENV.has_key?('AZURE_CLIENT_SECRET')
    @client ||= OAuth2::Client.new(
      ENV.fetch('AZURE_CLIENT_ID'),
      ENV.fetch('AZURE_CLIENT_SECRET'),
      site: 'https://login.microsoftonline.com',
      authorize_url: "/#{ENV.fetch('AZURE_TENANT')}/oauth2/v2.0/authorize",
      token_url: "/#{ENV.fetch('AZURE_TENANT')}/oauth2/v2.0/token"
    )
  end

  def get_login_url
    host = ENV.fetch('SITE_HOST', 'localhost')
    authorize_url = Rails.application.routes.url_helpers.authorize_url(host: host)
    authorize_url = Rails.application.routes.url_helpers.authorize_url(host: host, port: 3000) if host=='localhost'
    client&.auth_code&.authorize_url(
      redirect_uri: authorize_url, 
      scope: SCOPES
    )
  end

  def get_auth_code
    uri = URI(get_login_url)
    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Get.new(uri.path)
    http.request(req)
  end

  def get_token_from_code(auth_code)
    client.auth_code.get_token(
      auth_code,
      redirect_uri: authorize_url,
      scope: SCOPES
    )
  end

  def store_token(auth_code)
    token = get_token_from_code(auth_code)
    admin = Administrator.find_by(email: 'postmaster@risq.co.uk') || Administrator.create!(email: 'postmaster@risq.co.uk', password: SecureRandom.hex)
    admin.microsoft_graph_token = token.to_hash.to_json
    admin.save
  end

  def get_access_token
    client = OAuth2::Client.new(
      ENV.fetch('AZURE_CLIENT_ID'),
      ENV.fetch('AZURE_CLIENT_SECRET'),
      site: 'https://login.microsoftonline.com',
      authorize_url: "/#{ENV.fetch('AZURE_TENANT')}/oauth2/v2.0/authorize",
      token_url: "/#{ENV.fetch('AZURE_TENANT')}/oauth2/v2.0/token"
    )
    admin = Administrator.find_by_email('postmaster@risq.co.uk')
    token = OAuth2::AccessToken.from_hash(client, JSON.parse(admin.microsoft_graph_token))
    if token.expired?
      new_token = token.refresh!
      admin.microsoft_graph_token = new_token.to_hash.to_json
      admin.save
      access_token = new_token.token
    else
      access_token = token.token
    end
  end

  def get_graph(bearer_token)
    callback = Proc.new do |r|
      r.headers['Authorization'] = "Bearer #{bearer_token}"
    end
    MicrosoftGraph.new(
      base_url: 'https://graph.microsoft.com/v1.0',
      cached_metadata_file: File.join(MicrosoftGraph::CACHED_METADATA_DIRECTORY, 'metadata_v1.0.xml'),
      &callback
    )
  end
end
