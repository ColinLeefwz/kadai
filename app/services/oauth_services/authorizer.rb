# frozen_string_literal: true

module OauthServices
  # Class for creating Authorizer link
  #
  # @attr_reader request_url [String] url for request
  # @attr_reader params [Hash<String>] request params
  class Authorizer < BaseService

    def initialize(response_type = 'code', scope = nil, state = nil)
      @request_url = ENV['AUTH_URL']
      @params = {
        client_id: ENV['CLIENT_ID'],
        redirect_uri: ENV['REDIRECT_URI'],
        response_type: response_type,
        scope: scope,
        state: state
      }
    end

    # call link creator to generate auth url
    #
    # @return [String] auth url
    def call
      url = "#{request_url}?#{generate_query(params)}"
      raise BadURIError unless url =~ URI::regexp

      succeed_result({ url: url })
    rescue BadURIError
      failed_result('url is invalid')
    rescue StandardError => e
      failed_result(e.message)
    end
  end
end
