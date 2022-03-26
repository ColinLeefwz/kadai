# frozen_string_literal: true

# Class for Auth url creator
#
# @attr_reader auth_url [String] url for auth
# @attr_reader params [Hash<String>] auth params
class TwitterAppAuthUrlCreator < BaseService
  class BadURIError < StandardError; end

  attr_reader :auth_url, :params

  def initialize(response_type = 'code', scope = nil, state = nil)
    @auth_url = ENV['AUTH_URL']
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
    url = "#{auth_url}?#{generate_query}"
    raise BadURIError unless url =~ URI::regexp

    succeed_result({ url: url })
  rescue BadURIError
    failed_result('url is invalid')
  rescue StandardError => e
    failed_result(e.message)
  end

  private

  # Private: generate query by reader attributes
  #
  # @return [String] query string
  def generate_query
    URI.encode_www_form(params)
  end
end
