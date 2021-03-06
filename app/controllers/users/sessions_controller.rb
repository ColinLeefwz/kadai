# frozen_string_literal: true

class Users::SessionsController < ApplicationController
  before_action :check_current_user, only: :new
  before_action :check_session_params, only: :create
  before_action :auth_user, only: :create

  # GET /login
  def new; end

  # POST /login
  def create
    session[:user_id] = @user.id

    session[:return_to_url] ||= request.referrer
    redirect_to session.delete(:return_to_url) || root_path
  end

  # DELETE /logout
  def destroy
    session[:user_id] = nil

    redirect_to :login
  end

  private

  def session_params
    params.require(:session).permit(:user_id, :password)
  end

  def check_current_user
    return redirect_to root_url if current_user.present?
  end

  def check_session_params
    error_mgs = []
    error_mgs << I18n.t('errors.messages.blank', attribute: 'ユーザーID') unless session_params[:user_id].present?
    error_mgs << I18n.t('errors.messages.blank', attribute: 'パスワード') unless session_params[:password].present?
    return unless error_mgs.present?

    flash[:alert] = error_mgs
    return render :new
  end

  def auth_user
    error_mgs = []
    @user = User.find_by(user_id: session_params[:user_id])
    error_mgs << I18n.t('errors.messages.confirmation', attributes: ['ユーザーID', 'パスワード'].join('と')) unless @user.present? && @user.authenticate(session_params[:password])
    return unless error_mgs.present?

    flash.now[:alert] = error_mgs
    return render :new
  end
end
