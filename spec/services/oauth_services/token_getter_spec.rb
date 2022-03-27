# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OauthServices::TokenGetter do
  let(:code) { 'code' }
  let(:service) { described_class.new(code) }
  let(:response) { double('response') }
  let(:access_token) { 'access token' }
  let(:success_body) {
    {
      'access_token': access_token
    }.to_json
  }

  describe '#call' do
    context '例外が発生する場合' do
      let(:standard_error) { 'standard error' }

      before do
        expect(Net::HTTP).to receive(:post_form).and_raise(StandardError, standard_error)
      end

      it do
        result = service.call
        expect(result.success?).to be false
        expect(result.error).to eq(standard_error)
      end
    end

    context 'アクセストークンが取得出来ない場合' do
      let(:error_body) {
        {
          'error' => 'not invalid'
        }.to_json
      }
      let(:error_msg) { 'access token is blank' }

      before do
        expect(Net::HTTP).to receive(:post_form).and_return(response)
        expect(response).to receive(:body).and_return(error_body)
      end

      it do
        result = service.call
        expect(result.success?).to be false
        expect(result.error).to eq(error_msg)
      end
    end

    it 'is successful' do
      expect(Net::HTTP).to receive(:post_form).and_return(response)
      expect(response).to receive(:body).and_return(success_body)
      result = service.call
      expect(result.success?).to be true
      expect(result.payload).to eq({ access_token: access_token })
    end
  end
end
