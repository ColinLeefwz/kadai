# frozen_string_literal: true

class ApplicationController < ActionController::Base
  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def auth_current_user
    return if current_user.present?

    session[:return_to_url] = request.url
    return redirect_to :login
  end
end
