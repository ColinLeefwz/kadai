# frozen_string_literal: true

class OauthController < ApplicationController
  before_action :check_code, only: :callback

  # GET /oauth/callback
  def callback
    token_result = OauthServices::TokenGetter.call(session[:oauth_code])
    return redirect_to images_path, flash: { alert: "OAuthアクセストークンの取得に失敗しました。\n#{token_result.error}" } unless token_result.success?

    session[:app_access_token] = token_result.payload[:access_token]
    redirect_to images_path, flash: { notice: 'OAuthアクセストークンの取得に成功しました。' }
  end

  # GET /tweet
  def tweet
    tweet_result = OauthServices::Tweeter.call(session[:app_access_token], tweet_params[:title], tweet_params[:url])
    return redirect_to images_path, flash: { alert: "ツイートに失敗しました。\n#{tweet_result.error}" } unless tweet_result.success?

    redirect_to images_path, flash: { notice: 'ツイートに成功しました。' }
  end

  private

  def callback_params
    params.permit(:code)
  end

  def tweet_params
    params.permit(:title, :url)
  end

  # Private: check if code has been received
  def check_code
    session[:oauth_code] = callback_params[:code]
    return if session[:oauth_code].present?

    return redirect_to images_path, flash: { alert: 'OAuthアクセストークンの取得に失敗しました。' }
  end
end
