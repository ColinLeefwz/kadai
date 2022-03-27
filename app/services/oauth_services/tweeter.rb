# frozen_string_literal: true

module OauthServices
  # Class for Auth url creator
  #
  # @attr_reader request_url [String] url of request
  # @attr_reader params [Hash<String>] request params
  # @attr_reader access_token [String] header bearer token
  class Tweeter < BaseService
    attr_reader :access_token

    def initialize(access_token, title, url)
      @request_url = ENV['TWEET_URL']
      @params = {
        'text' => title,
        'url' => url
      }
      @access_token = access_token
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

    # Private: response of post reuqest
    #
    # @return [Net::HTTP::Response] response from auth server
    def post_res
      request_uri = get_uri(request_url)
      https = Net::HTTP.new(request_uri.host, request_uri.port)
      https.use_ssl = true
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE
      req = Net::HTTP::Post.new(request_uri.path)
      req['Authorization'] = "bearer #{access_token}"
      req['Content-Type'] = 'application/json'
      req.body = params.to_json
      https.request(req)
    end
  end
end
