require 'uri'
require 'yajl'
require 'hashie'

module Skittles
  module Request

    def method_missing(sym, *args, &block)
      if %w{get post put delete}.include?(sym.to_s)
        path = args.first

        if args.size > 1
          options = args[1]
          headers = args[2]
          raw     = args[3]
        else
          options = {}
          headers = {}
          raw     = false
        end

        request(sym, path, options, headers, raw)
      else
        super
      end
    end

    private

    #Perform an HTTP request
    def request(method, path, options, headers, raw)
      headers.merge!({
        'User-Agent' => user_agent
      })

      options.merge!({
        :client_id     => client_id,
        :client_secret => client_secret,
        :v             => Time.now.strftime('%Y%m%d')
      })

      begin
        response = connection.request(method, paramify(path, options), headers)
      rescue OAuth2::ErrorWithResponse => e
        Skittles::Utils.handle_foursquare_error(e.response)
      else
        Skittles::Error
      end

      unless raw
        result = Skittles::Utils.parse_json(response)
      end

      raw ? response : result.response
    end

    # Encode path and turn params into HTTP query.
    def paramify(path, params)
      URI.encode("#{path}?#{params.map { |k,v| "#{k}=#{v}" }.join('&')}")
    end
  end
end
