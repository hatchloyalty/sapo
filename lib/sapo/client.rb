require 'faraday'
require 'json'
require 'savon'

module Sapo
  # Basic client for getting in.
  class Client
    AUTH_TOKEN_HOST = 'https://auth.exacttargetapis.com'.freeze
    AUTH_TOKEN_PATH = '/v1/requestToken'.freeze
    WSDL_URI = 'https://webservice.s4.exacttarget.com/etframework.wsdl'.freeze
    SOAP_ENDPOINT_URI = 'https://webservice.s4.exacttarget.com/Service.asmx'.freeze

    attr_reader :client_id, :client_secret, :client, :access_token
    def initialize(client_id: ENV['CLIENT_ID'],
                   client_secret: ENV['CLIENT_SECRET'])
      @client_id = client_id
      @client_secret = client_secret
    end

    def authorize
      conn = Faraday.new(AUTH_TOKEN_HOST)
      res = conn.post do |req|
        req.url AUTH_TOKEN_PATH
        req.headers['Content-Type'] = 'application/json'
        req.body = JSON.dump(clientId: client_id, clientSecret: client_secret)
      end

      puts "Response Status Code: #{res.status}"
      puts "Response Response Body: #{res.body}"
      @access_token = JSON.parse(res.body).fetch('accessToken')
    end

    def connect
      @client = Savon.client(wsdl: WSDL_URI,
                             endpoint: SOAP_ENDPOINT_URI,
                             soap_header: { fueloauth: access_token },
                             log_level: :debug,
                             log: true) do
        convert_request_keys_to :none
      end
    end
  end
end
