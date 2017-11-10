require 'rest-client'
require 'openssl'
require 'addressable/uri'
require 'base64'
require 'json'

module Bittrex
  class Client
    HOST = 'https://bittrex.com/api/v1.1'.freeze

    attr_reader :key, :secret

    def initialize(attrs = {})
      @key    = attrs[:key]
      @secret = attrs[:secret]
    end

    def get(command, params)
      params['apikey'] = key
      params['nonce'] = Time.now.to_i
      full_url = make_full_url command, params
      sig = signature full_url
      response = RestClient.get full_url, apisign: sig
      puts response
      parsed_response = JSON.parse(response)
      if parsed_response['success'] == false
        puts parsed_response['message']
        return nil
      end
      parsed_response['result']
    end

    private

    def make_full_url(path, params)
      url = "#{HOST}/#{path}"
      query = params.map { |k, v| "#{k}=#{v}" }.join '&'
      "#{url}?#{query}"
    end

    def signature(url)
      OpenSSL::HMAC.hexdigest('sha512', secret.encode('ASCII'),
                              url.encode('ASCII'))
    end
  end
end
