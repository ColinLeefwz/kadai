# frozen_string_literal: true

class OauthController < ApplicationController
  before_action :check_code, only: :callback

  def callback
    token_result = AccessTokenGetter.call(session[:oauth_code])
    return redirect_to images_path, flash: { alert: 'OAuthアクセストークンの取得に失敗しました。' } unless token_result.success?

    session[:app_access_token] = token_result.payload[:access_token]
    redirect_to images_path, flash: { notice: 'OAuthアクセストークンの取得に成功しました。' }
  end

  private

  def callback_params
    params.permit(:code)
  end

  def check_code
    session[:oauth_code] = callback_params[:code]
    return if session[:oauth_code].present?

    return redirect_to images_path, flash: { alert: 'OAuthアクセストークンの取得に失敗しました。' }
  end
end
