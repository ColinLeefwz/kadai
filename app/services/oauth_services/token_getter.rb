# frozen_string_literal: true

module OauthServices
  # Class for Auth url creator
  #
  # @attr_reader request_url [String] url for request
  # @attr_reader params [Hash<String>] params post request
  class TokenGetter < BaseService
    def initialize(code, grant_type = 'authorization_code')
      @request_url = ENV['AUTH_TOKEN_URL']
      @params = {
        client_id: ENV['CLIENT_ID'],
        client_secret: ENV['CLIENT_SECRET'],
        redirect_uri: ENV['REDIRECT_URI'],
        code: code,
        grant_type: grant_type
      }
    end

    # call getter to get the access token
    #
    # @return [String] auth url
    def call
      access_token = get_access_token
      return failed_result('access token is blank') unless access_token.present?

      succeed_result({ access_token: access_token })
    rescue StandardError => e
      failed_result(e.message)
    end

    # Private: response of post reuqest
    #
    # @return [Net::HTTP::Response] response from auth server
    def post_res
      Net::HTTP.post_form(
        get_uri(request_url),
        params
      )
    end

    # Private: get the access token from response
    #
    # @return [String] access token gotten from auth server
    def get_access_token
      body = post_res.body
      JSON.parse(body).dig('access_token') if body.present?
    end
  end
end
