# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users::Sessions', type: :request do
  let(:correct_user_id) { 'correct_user_id' }
  let(:correct_password) { 'correct_password' }

  describe 'GET /login' do
    let(:url) { '/login' }
    let(:subject) { get url }

    before(:each) do
      subject
    end

    context 'access top page' do
      it { expect(response).to have_http_status(:ok) }
      it { expect(response.body).to include 'ログイン' }
    end
  end

  describe 'POST /login' do
    let(:wrong_password) { 'wrong_password' }
    let(:wrong_user_id) { 'wrong_user_id' }
    let!(:user) { User.create(user_id: correct_user_id, password: correct_password)}
    let(:params) {
      {
        session: {
          user_id: correct_user_id,
          password: correct_password
        }
      }
    }
    let(:url) { '/login' }
    let(:subject) { post url, params: params }
    let(:user_error_msg) { I18n.t('errors.messages.blank', attribute: 'ユーザーID') }
    let(:password_error_msg) { I18n.t('errors.messages.blank', attribute: 'パスワード') }
    let(:auth_error_msg) { I18n.t('errors.messages.confirmation', attributes: ['ユーザーID', 'パスワード'].join('と')) }

    before(:each) do
      subject
    end

    it 'is successful' do
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(root_url)
    end

    context 'when user_id is blank' do
      let(:params) {
        {
          session: {
            user_id: '',
            password: correct_password
          }
        }
      }

      it do
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(login_url)
        expect(flash[:alert]).to eq([user_error_msg])
      end
    end

    context 'when password is blank' do
      let(:params) {
        {
          session: {
            user_id: correct_user_id,
            password: ''
          }
        }
      }

      it do
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(login_url)
        expect(flash[:alert]).to eq([password_error_msg])
      end
    end

    context 'when neither user_id nor password is present' do
      let(:params) {
        {
          session: {
            user_id: '',
            password: ''
          }
        }
      }

      it do
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(login_url)
        expect(flash[:alert]).to eq([user_error_msg, password_error_msg])
      end
    end

    context 'when user_id or password is not auth' do
      let(:params) {
        {
          session: {
            user_id: wrong_user_id,
            password: wrong_password
          }
        }
      }

      it do
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(login_url)
        expect(flash[:alert]).to eq([auth_error_msg])
      end
    end
  end

  describe 'DELETE /logout' do
    let!(:user) { User.create(user_id: correct_user_id, password: correct_password)}
    let(:url) { '/logout' }
    let(:parmas) {
      {
        session: { user_id: user.id }
      }
    }
    let(:subject) { delete url, params: parmas }

    before(:each) do
      subject
    end

    it 'is successful' do
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(login_url)
      expect(session[:user_id]).to be_nil
    end
  end
end
