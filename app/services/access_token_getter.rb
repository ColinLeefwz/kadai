# frozen_string_literal: true

require 'uri'
require 'net/http'

# Class for Auth url creator
#
# @attr_reader auth_token_url [String] url for getting auth token
# @attr_reader params [Hash<String>] params post request
class AccessTokenGetter < BaseService
  attr_reader :auth_token_url, :params

  def initialize(code, grant_type = 'authorization_code')
    @auth_token_url = ENV['AUTH_TOKEN_URL']
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
    succeed_result({ access_token: get_access_token })
  rescue StandardError => e
    failed_result(e.message)
  end

  private

  # Private: generate uri by auth token url
  #
  # @return [URI] URI instance of auth url
  def post_uri
    URI(auth_token_url)
  end

  # Private: response of post reuqest
  #
  # @return [Net::HTTP::Response] response from auth server
  def post_res
    Net::HTTP.post_form(
      post_uri,
      params
    )
  end

  # Private: get the access token from response
  #
  # @return [String] access token gotten from auth server
  def get_access_token
    JSON.parse(get_access_token).dig('access_token') if post_res.is_a?(Net::HTTPSuccess)
  end
end
