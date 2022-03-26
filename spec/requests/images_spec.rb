# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Images', type: :request do
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
      let!(:user) { User.create(user_id: 'user_id', password: 'password')}

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
    pending "add some examples (or delete) #{__FILE__}"
  end

  describe 'POST /images' do
    pending "add some examples (or delete) #{__FILE__}"
  end

  describe 'GET /image/:id' do
    pending "add some examples (or delete) #{__FILE__}"
  end
end
