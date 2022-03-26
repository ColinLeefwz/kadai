# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def current_user
    return unless session[:user_id]

    @current_user ||= User.find_by(id: session[:user_id])
  end
end
