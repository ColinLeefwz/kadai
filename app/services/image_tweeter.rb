# frozen_string_literal: true

require 'uri'
require 'net/http'

# Class for Auth url creator
#
# @attr_reader tweet_url [String] url of tweet api
# @attr_reader header [Hash<String>] header for post request auth
class ImageTweeter < BaseService
  ATTRS = %i[
    tweet_url
    access_token
    title
    url
  ].freeze
  attr_reader *ATTRS

  def initialize(access_token, title, url)
    @tweet_url = ENV['TWEET_URL']
    @access_token = access_token
    @title = title
    @url = url
  end

  # call link creator to generate auth url
  #
  # @return [String] auth url
  def call
    return failed_result('failed in tweeting') unless post_res.is_a?(Net::HTTPCreated)

    succeed_result
  rescue StandardError => e
    failed_result(e.message)
  end

  private

  # Private: generate uri by auth token url
  #
  # @return [URI] URI instance of auth url
  def post_uri
    URI(tweet_url)
  end

  # Private: response of post reuqest
  #
  # @return [Net::HTTP::Response] response from auth server
  def post_res
    https = Net::HTTP.new(post_uri.host, post_uri.port)
    https.use_ssl = true
    https.verify_mode = OpenSSL::SSL::VERIFY_NONE
    req = Net::HTTP::Post.new(post_uri.path)
    req['Authorization'] = "bearer #{access_token}"
    req['Content-Type'] = 'application/json'
    body = {
      'text' => title,
      'url' => url
    }.to_json

    req.body = body
    https.request(req)
  end
end
