# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OauthServices::Authorizer do
  let(:service) { described_class.new }

  describe '#call' do
    context 'BadURIErrorの例外が発生する場合' do
      let(:bad_url) { 'bad url' }
      let(:error_msg) { 'url is invalid' }

      before do
        ENV['AUTH_URL'] = bad_url
      end

      it do
        result = service.call
        expect(result.success?).to be false
        expect(result.error).to eq(error_msg)
      end
    end

    context '例外が発生する場合' do
      let(:standard_error) { 'standard error' }

      before do
        expect(URI).to receive(:encode_www_form).and_raise(StandardError, standard_error)
      end

      it do
        result = service.call
        expect(result.success?).to be false
        expect(result.error).to eq(standard_error)
      end
    end

    it 'is successful' do
      result = service.call
      expect(result.success?).to be true
    end
  end
end
