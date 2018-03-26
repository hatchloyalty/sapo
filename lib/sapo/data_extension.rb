# frozen_string_literal: true

module Sapo
  class DataExtension
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

    def authorize
      access_token = Client.new.authorize
      client.globals[:soap_header] = { fueloauth: access_token }
    end

    def all
      query(message: { QueryRequest: { Query: { Object: { ObjectType: 'DataExtension', Properties: ["Name"] }}}}).body
    end
  end
end
