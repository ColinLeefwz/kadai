# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Images', type: :request do
  let!(:user) { User.create(user_id: 'user_id', password: 'password')}

  describe 'GET /images' do
    let(:url) { '/images' }
    let(:subject) { get url }

    context 'when there is no signed in user' do
      before(:each) do
        subject
      end

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to(login_url) }
    end

    context 'when there is signed in user' do
      before(:each) do
        allow(User).to receive(:find_by).and_return(user)
        subject
      end

      it do
        expect(response).to have_http_status(:ok)
        expect(response.body).to include '写真一覧'
      end
    end
  end

  describe 'GET /images/new' do
    let(:url) { '/images/new' }
    let(:subject) { get url }

    before(:each) do
      allow(User).to receive(:find_by).and_return(user)
      subject
    end

    it do
      expect(response).to have_http_status(:ok)
      expect(response.body).to include '写真アップロード'
    end
  end

  describe 'POST /images' do
    let(:title) { 'title' }
    let(:avatar) { 'avatar' }
    let(:params) {
      {
        image: {
          title: 'title',
          avatar: fixture_file_upload(file_fixture('test.jpg'), 'image/jpg')
        }
      }
    }
    let(:url) { '/images' }
    let(:subject) { post url, params: params }
    let(:notice_msg) { '作成が成功しました。' }

    before(:each) do
      allow(User).to receive(:find_by).and_return(user)
      subject
    end

    it 'is successful' do
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(images_path)
      expect(flash[:notice]).to eq(notice_msg)
    end

    context 'when the image is invalid' do
      let(:params) {
        {
          image: {
            title: '',
            avatar: fixture_file_upload(file_fixture('test.jpg'), 'image/jpg')
          }
        }
      }
      let(:blank_title_msg) { 'タイトルタイトルを入力してください' }

      it do
        expect(response).to have_http_status(:ok)
        expect(response.body).to include '写真アップロード'
        expect(flash[:alert]).to match_array([blank_title_msg])
      end
    end
  end
end
