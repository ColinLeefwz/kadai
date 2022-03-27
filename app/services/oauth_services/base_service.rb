# frozen_string_literal: true

require 'uri'
require 'net/http'

# BaseSerivce Class of OauthServices
#
class OauthServices::BaseService < BaseService
  class BadURIError < StandardError; end

  attr_reader :request_url, :params

  def initialize
    raise NotImplementedError
  end

  private

  # Private: generate uri by url
  #
  # @params url[String] url link
  #
  # @return [URI] URI instance of url
  def get_uri(url)
    URI(url)
  end

  # Private: generate query by reader attributes
  #
  # @params params[Hash<String>] params hash in query
  #
  # @return [String] query string
  def generate_query(params)
    URI.encode_www_form(params)
  end
end
