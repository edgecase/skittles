require 'oauth2'

module Skittles
  module Connection

    private

    def connection
      options = {:site => endpoint}

      # Pass in :ssl options, etc.
      options.merge(Skittles::RequestOptions) if Skittles::RequestOptions

      client                  = OAuth2::Client.new(client_id, client_secret, options)
      oauth_token             = OAuth2::AccessToken.new(client, access_token)
      oauth_token.token_param = 'oauth_token'
      oauth_token
    end
  end
end
