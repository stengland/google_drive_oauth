require 'google_drive'
require 'oauth2'

module GoogleDrive
  class OAuth
    REDIRECT_URL = "urn:ietf:wg:oauth:2.0:oob"

    def initialize(options)
      @options = options
    end

    def auth_url
      client.auth_code.authorize_url(
        :redirect_uri => REDIRECT_URL,
        :scope => "https://www.googleapis.com/auth/drive " +
          "https://spreadsheets.google.com/feeds/"
      )
    end

    def get_token(authorization_code)
      client.auth_code.get_token(
        authorization_code,
        :redirect_uri => REDIRECT_URL)
    end

    def drive_session(access_token: nil, refresh_token: options[:refresh_token])
      access_token = load_token(refresh_token) if access_token.nil?
      access_token = access_token.refresh! if access_token.token.empty? or access_token.expired?
      GoogleDrive.login_with_oauth(access_token.token)
    end

    private

    attr_reader :options

    def load_token(refresh_token)
      OAuth2::AccessToken.from_hash(client, {refresh_token: refresh_token})
    end

    def client
      @client ||= OAuth2::Client.new(
        options[:client_id], options[:client_secret],
        :site => "https://accounts.google.com",
        :token_url => "/o/oauth2/token",
        :authorize_url => "/o/oauth2/auth")
    end

  end
end
