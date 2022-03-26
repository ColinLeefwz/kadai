# frozen_string_literal: true

class ApplicationController < ActionController::Base
  private

  # Private: get the instance of logged in user
  #
  # @return [User] logged in user instance
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  # Private: check current user
  #
  # @return [nil] if current user is available
  # @redirect login page, if current user is not available
  def auth_current_user
    return if current_user.present?

    session[:return_to_url] = request.url
    return redirect_to :login
  end
end
