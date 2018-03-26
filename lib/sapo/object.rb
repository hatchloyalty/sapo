# frozen_string_literal: true

module Sapo
  class Object
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

    attr_reader :properties, :type
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
      response.body.dig(:definition_response_msg, :object_definition, :properties)
              .each do |prop_description|
        properties << prop_description.fetch(:name)
      end
      properties
    end
  end
end
