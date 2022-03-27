# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Oauth', type: :request do
  describe 'GET /oauth/callback' do
    let(:url) { '/oauth/callback' }
    let(:params) {
      {}
    }
    let(:subject) { get url, params: params }

    context 'when there is no code params revceived' do
      before(:each) do
        subject
      end

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to(images_path) }
    end

    context 'when there is a code params revceived' do
      let(:code) { 'code' }
      let(:params) {
        {
          code: code
        }
      }
      let(:access_token) { 'access token' }
      let(:success_result) { OpenStruct.new(success?: true, payload: { access_token: access_token }) }
      let(:notice) { 'OAuthアクセストークンの取得に成功しました。' }

      context 'when failed in getting access_token' do
        let(:error_msg) { 'error message' }
        let(:failed_result) { OpenStruct.new(success?: false, error: error_msg) }
        let(:alert) { "OAuthアクセストークンの取得に失敗しました。\n#{error_msg}" }

        before(:each) do
          expect(OauthServices::TokenGetter).to receive(:call).with(code).and_return(failed_result)
          subject
        end

        it do
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(images_path)
          expect(flash[:alert]).to eq(alert)
        end
      end

      it 'is successful' do
        expect(OauthServices::TokenGetter).to receive(:call).with(code).and_return(success_result)
        subject
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(images_path)
        expect(flash[:notice]).to eq(notice)
      end
    end
  end
  describe 'GET /tweet' do
    let(:url) { '/tweet' }
    let(:title) { 'title' }
    let(:image_url) { 'image_url' }
    let(:params) {
      {
        title: title,
        url: image_url,
      }
    }
    let(:subject) { get url, params: params }
    let(:success_result) { OpenStruct.new(success?: true, payload: {}) }
    let(:notice) { 'ツイートに成功しました。' }

    context 'when failed in tweeting' do
      let(:error_msg) { 'error message' }
      let(:failed_result) { OpenStruct.new(success?: false, error: error_msg) }
      let(:alert) { "ツイートに失敗しました。\n#{error_msg}" }

      before(:each) do
        expect(OauthServices::Tweeter).to receive(:call).with(nil, title, image_url).and_return(failed_result)
        subject
      end

      it do
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(images_path)
        expect(flash[:alert]).to eq(alert)
      end
    end

    it 'is successful' do
      expect(OauthServices::Tweeter).to receive(:call).with(nil, title, image_url).and_return(success_result)
      subject
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(images_path)
      expect(flash[:notice]).to eq(notice)
    end
  end
end
