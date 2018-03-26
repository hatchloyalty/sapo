# frozen_string_literal: true

module Sapo
  class Object
    BLACKLISTED_PROPERTIES = %w[DataRetentionPeriod].freeze
    extend Savon::Model
    client wsdl: Client::WSDL_URI,
           endpoint: Client::SOAP_ENDPOINT_URI,
           log_level: :debug,
           log: true

    operations :create,
               :retrieve,
               :update,
               :delete,
               :query,
               :describe,
               :execute,
               :perform,
               :configure,
               :schedule,
               :version_info,
               :extract,
               :get_system_status

    attr_reader :type
    attr_accessor :properties
    def initialize(type)
      @type = type
      @properties = []
      client.globals[:convert_request_keys_to] = :none
    end

    def authorize
      access_token = Client.new.authorize
      client.globals[:soap_header] = { fueloauth: access_token }
    end

    def get
      fetch_properties if properties.empty?
      retrieve(message: {
                 RetrieveRequest: {
                   ObjectType: type,
                   Properties: properties
                 }
               }).body
    end

    def fetch_properties
      response = describe(message: { DescribeRequests: {
                            ObjectDefinitionRequest: { ObjectType: type }
                          } })
      @properties =
        response.body
                .dig(:definition_response_msg,
                     :object_definition,
                     :properties)
                .map do |prop_description|
                  next unless prop_description.fetch(:is_retrievable)
                  next if BLACKLISTED_PROPERTIES.include?(
                    prop_description.fetch(:name)
                  )
                  prop_description.fetch(:name)
                end.compact
      properties
    end
  end
end
